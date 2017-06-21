within Buildings.ChillerWSE;
model IntegratedPrimaryLoadSide
  "Integrated WSE on the load side in a primary-only chilled water System"
  extends Buildings.ChillerWSE.BaseClasses.PartialIntegratedPrimary(
    final nVal=7,
    final m_flow_nominal={mChiller1_flow_nominal,mChiller2_flow_nominal,mWSE1_flow_nominal,
      mWSE2_flow_nominal,nChi*mChiller2_flow_nominal,mWSE2_flow_nominal,mChiller2_flow_nominal},
    rhoStd = {Medium1.density_pTX(101325, 273.15+4, Medium1.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default),
            Medium1.density_pTX(101325, 273.15+4, Medium1.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default)});
  extends Buildings.ChillerWSE.BaseClasses.PartialOperationSequenceInterface;

 //Dynamics
 parameter Modelica.SIunits.Time tauPump = 30
    "Time constant of fluid volume for nominal flow in pumps, used if energy or mass balance is dynamic"
     annotation (Dialog(tab = "Dynamics", group="Pump",
     enable=not energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState));

  //Pump
  parameter Integer numPum=nChi "Number of pumps"
    annotation(Dialog(group="Pump"));
  replaceable parameter Buildings.Fluid.Movers.Data.Generic perPum[nChi]
    annotation (Dialog(group="Pump"),
          Placement(transformation(extent={{38,78},{58,98}})));
  parameter Boolean addPowerToMedium=true
    "Set to false to avoid any power (=heat and flow work) being added to medium (may give simpler equations)"
    annotation (Dialog(group="Pump"));
  parameter Modelica.SIunits.Time riseTimePum=120
    "Rise time of the filter (time to reach 99.6 % of an opening step)"
    annotation(Dialog(tab="Dynamics", group="Filtered speed",enable=use_inputFilter));
  parameter Modelica.Blocks.Types.Init initPum=initValve
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Filtered speed",enable=use_inputFilter));
  parameter Real[numPum] yPum_start=fill(0,numPum) "Initial value of output:0-closed, 1-fully opened"
    annotation(Dialog(tab="Dynamics", group="Filtered speed",enable=use_inputFilter));

 //Valve
  parameter Real lValve7(min=1e-10,max=1) = 0.0001
    "Valve leakage, l=Kv(y=0)/Kv(y=1)"
    annotation(Dialog(group="On/Off valve"));
  parameter Real yValve7_start = 0 "Initial value of output:0-closed, 1-fully opened"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter));

  Buildings.Fluid.Movers.SpeedControlled_y pum[nChi](
    redeclare each final package Medium = Medium2,
    each final p_start=p2_start,
    each final T_start=T2_start,
    each final X_start=X2_start,
    each final C_start=C2_start,
    each final C_nominal=C2_nominal,
    each final allowFlowReversal=allowFlowReversal2,
    each final m_flow_small=m2_flow_small,
    each final show_T=show_T,
    final per=perPum,
    each addPowerToMedium=addPowerToMedium,
    each final energyDynamics=energyDynamics,
    each final massDynamics=massDynamics,
    each final inputType=Buildings.Fluid.Types.InputType.Continuous,
    each final use_inputFilter=use_inputFilter,
    each final riseTime=riseTimePum,
    each final init=initPum,
    final y_start=yPum_start,
    each final tau=tauPump) "Pumps"
    annotation (Placement(transformation(extent={{10,-50},{-10,-30}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val7(
    redeclare final package Medium = Medium2,
    final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    final m_flow_nominal=mChiller2_flow_nominal,
    final dpFixed_nominal=0,
    final l=lValve7,
    final kFixed=0,
    final deltaM=deltaM2,
    final rhoStd=rhoStd[7],
    final dpValve_nominal=dpValve_nominal[7],
    final allowFlowReversal=allowFlowReversal2,
    final show_T=show_T,
    final from_dp=from_dp2,
    final homotopyInitialization=homotopyInitialization,
    final linearized=linearizeFlowResistance2,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTimeValve,
    final init=initValve,
    final y_start=yValve7_start)
    "Adjustable valve: the valve position is manipulated to maintain the minimum flow requirement through chillers"
    annotation (Placement(transformation(extent={{10,-90},{-10,-70}})));

  Modelica.Blocks.Interfaces.RealInput yPum[nChi]
    "Constant normalized rotational speed"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput yVal7
    "Position signal for valve 7 (0: closed, 1: open) " annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-28,-120})));
  Modelica.Blocks.Sources.BooleanExpression wseMod(y=if Modelica.Math.BooleanVectors.anyTrue(on[1:nChi]) then false else true)
   "If any chiller is on then the plant is not in free cooling mode"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
equation
  for i in 1:nChi loop
  connect(val5.port_b, pum[i].port_a) annotation (Line(points={{40,-20},{14,-20},{14,
          -40},{10,-40}}, color={0,127,255}));
  connect(pum[i].port_b,val6.port_a)  annotation (Line(points={{-10,-40},{-16,-40},
          {-16,-20},{-40,-20}}, color={0,127,255}));
  end for;
  connect(val5.port_b,val7. port_a) annotation (Line(points={{40,-20},{30,-20},{
          30,-80},{10,-80}}, color={0,127,255}));
  connect(val7.port_b, port_b2) annotation (Line(points={{-10,-80},{-40,-80},{-40,
          -60},{-100,-60}}, color={0,127,255}));
 connect(pum.y, yPum) annotation (Line(points={{0.2,-28},{0.2,-10},{-26,-10},{-26,
          -40},{-120,-40}}, color={0,0,127}));
  connect(val7.y, yVal7) annotation (Line(points={{0,-68},{0,-68},{0,-60},{-28,-60},
          {-28,-120}}, color={0,0,127}));

  connect(booToRea.y,val6.y)  annotation (Line(points={{-47.4,74},{-28,74},{-28,
          0},{-50,0},{-50,-8}}, color={0,0,127}));
  connect(booToRea.y, inv.u2)
    annotation (Line(points={{-47.4,74},{-8,74},{-8,89.2}}, color={0,0,127}));
  connect(inv.y,val5.y)  annotation (Line(points={{-2.6,94},{8,94},{8,0},{50,0},
          {50,-8}}, color={0,0,127}));
  connect(wseMod.y, booToRea.u) annotation (Line(points={{-79,80},{-70,80},{-70,
          74},{-61.2,74}}, color={255,0,255}));
end IntegratedPrimaryLoadSide;
