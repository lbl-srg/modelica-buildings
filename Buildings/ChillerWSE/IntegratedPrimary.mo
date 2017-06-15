within Buildings.ChillerWSE;
model IntegratedPrimary "Integrated WSE for Primary Chilled Water System"
  extends Buildings.ChillerWSE.BaseClasses.PartialIntegratedPrimary(
    final nVal=8,
    final m_flow_nominal={mChiller1_flow_nominal,mChiller2_flow_nominal,mWSE1_flow_nominal,
      mWSE2_flow_nominal,mWSE2_flow_nominal,mChiller2_flow_nominal,mWSE2_flow_nominal,mChiller2_flow_nominal},
    rhoStd = {Medium1.density_pTX(101325, 273.15+4, Medium1.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default),
            Medium1.density_pTX(101325, 273.15+4, Medium1.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default)},
    val2(final y_start=yValve_start[1]),
    val1(final y_start=1 - yValve_start[1]));

  parameter Integer numPum=nChi "Number of pumps";
  parameter Real lValve3(min=1e-10,max=1) = 0.0001
    "Valve leakage, l=Kv(y=0)/Kv(y=1)"
    annotation(Dialog(group="Valve"));
  parameter Modelica.SIunits.Time riseTimePum=120
    "Rise time of the filter (time to reach 99.6 % of an opening step)"
    annotation(Dialog(tab="Dynamics", group="Filtered opening in pumps",enable=use_inputFilter));
  parameter Modelica.Blocks.Types.Init initPum=initValve
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Filtered opening in pumps",enable=use_inputFilter));
  parameter Real[numPum] yPum_start=fill(0,numPum) "Initial value of output:0-closed, 1-fully opened"
    annotation(Dialog(tab="Dynamics", group="Filtered opening in pumps",enable=use_inputFilter));

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
    each addPowerToMedium=false,
    each final energyDynamics=energyDynamics,
    each final massDynamics=massDynamics,
    each final inputType=Buildings.Fluid.Types.InputType.Continuous,
    each final use_inputFilter=use_inputFilter,
    each final riseTime=riseTimePum,
    each final init=initPum,
    final y_start=yPum_start)                   "Pumps"
    annotation (Placement(transformation(extent={{10,-50},{-10,-30}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val3(
    redeclare final package Medium = Medium2,
    final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    final m_flow_nominal=mChiller2_flow_nominal,
    final dpFixed_nominal=0,
    final l=lValve3,
    final kFixed=0,
    final deltaM=deltaM2,
    final rhoStd=rhoStd[8],
    final dpValve_nominal=dpValve_nominal[8],
    final allowFlowReversal=allowFlowReversal2,
    final show_T=show_T,
    final from_dp=from_dp2,
    final homotopyInitialization=homotopyInitialization,
    final linearized=linearizeFlowResistance2,
    final use_inputFilter=use_inputFilter)
    annotation (Placement(transformation(extent={{10,-90},{-10,-70}})));

  replaceable parameter Buildings.Fluid.Movers.Data.Generic perPum[nChi]
    annotation (Placement(transformation(extent={{10,74},{30,94}})));
  Modelica.Blocks.Interfaces.RealInput yPum[nChi]
    "Constant normalized rotational speed"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput yVal3
    "Actuator position (0: closed, 1: open)" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-28,-120})));
  Modelica.Blocks.Interfaces.BooleanInput wseMod
    "=true, activate fully wse mode"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
equation
  for i in 1:nChi loop
  connect(val1.port_b, pum[i].port_a) annotation (Line(points={{40,-20},{14,-20},{14,
          -40},{10,-40}}, color={0,127,255}));
  connect(pum[i].port_b, val2.port_a) annotation (Line(points={{-10,-40},{-16,-40},
          {-16,-20},{-40,-20}}, color={0,127,255}));
  end for;
  connect(val1.port_b, val3.port_a) annotation (Line(points={{40,-20},{30,-20},{
          30,-80},{10,-80}}, color={0,127,255}));
  connect(val3.port_b, port_b2) annotation (Line(points={{-10,-80},{-40,-80},{-40,
          -60},{-100,-60}}, color={0,127,255}));
  connect(inv.y,val1.y)  annotation (Line(points={{-2.6,94},{4,94},{4,0},{50,0},
          {50,-8}},    color={0,0,127}));
  connect(pum.y, yPum) annotation (Line(points={{0.2,-28},{0.2,-10},{-26,-10},{-26,
          -40},{-120,-40}}, color={0,0,127}));
  connect(val3.y, yVal3) annotation (Line(points={{0,-68},{0,-68},{0,-60},{-28,-60},
          {-28,-120}}, color={0,0,127}));

  connect(y_actual[1], inv.u2)
    annotation (Line(points={{-20,74},{-8,74},{-8,89.2}}, color={0,0,127}));
  connect(y_actual[1], val2.y) annotation (Line(points={{-20,74},{-14,74},{-14,0},
          {-50,0},{-50,-8}}, color={0,0,127}));
  connect(booToRea.u, wseMod) annotation (Line(points={{-81.2,74},{-120,74},{-120,
          80}}, color={255,0,255}));
end IntegratedPrimary;
