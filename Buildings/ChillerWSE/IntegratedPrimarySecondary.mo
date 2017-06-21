within Buildings.ChillerWSE;
model IntegratedPrimarySecondary
  "Integrated chiller and WSE for primary-secondary chilled water system"
  extends Buildings.ChillerWSE.BaseClasses.PartialChillerWSE(
  final nVal=5);

  parameter Integer numPum=nChi "Number of pumps";

  parameter Real lValve1(min=1e-10,max=1) = 0.0001
    "Valve leakage, l=Kv(y=0)/Kv(y=1)"
    annotation(Dialog(group="Valve"));
   parameter Real yValve1_start = 0 "Initial value of output:0-closed, 1-fully opened"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter));
  replaceable parameter Buildings.Fluid.Movers.Data.Generic perPum[nChi]
    annotation (Dialog(group="Pump"),
          Placement(transformation(extent={{38,78},{58,98}})));

  parameter Boolean addPowerToMedium=true
    "Set to false to avoid any power (=heat and flow work) being added to medium (may give simpler equations)"
    annotation (Dialog(group="Pump"));

  parameter Modelica.SIunits.Time riseTimePum=120
    "Rise time of the filter (time to reach 99.6 % of an opening step)"
    annotation(Dialog(tab="Dynamics", group="Filtered flowrate",enable=use_inputFilter));
  parameter Modelica.Blocks.Types.Init initPum=initValve
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Filtered flowrate",enable=use_inputFilter));
  parameter Real[numPum] yPum_start(each min=0)=fill(0,numPum) "Initial value of output:0-closed, 1-fully opened"
    annotation(Dialog(tab="Dynamics", group="Filtered flowrate",enable=use_inputFilter));
  parameter Real[numPum] m_flow_start(each min=0)=fill(0,numPum) "Initial value of output:0-closed, 1-fully opened"
    annotation(Dialog(tab="Dynamics", group="Filtered flowrate"));
  parameter Modelica.SIunits.MassFlowRate mPump_flow_nominal(min=0)=mChiller2_flow_nominal
   annotation (Dialog(group="Pump"));
    // Dynamics
 parameter Modelica.SIunits.Time tauPump = 30
  "Time constant of fluid volume for nominal flow in pumps, used if energy or mass balance is dynamic"
   annotation (Dialog(tab = "Dynamics", group="Pump",
     enable=not energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState));

  Fluid.Actuators.Valves.TwoWayLinear           val1(
    redeclare final package Medium = Medium2,
    final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    final allowFlowReversal=allowFlowReversal2,
    final m_flow_nominal=nChi*mChiller2_flow_nominal,
    final show_T=show_T,
    final from_dp=from_dp2,
    final homotopyInitialization=homotopyInitialization,
    final linearized=linearizeFlowResistance2,
    final deltaM=deltaM2,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTimeValve,
    final init=initValve,
    final dpFixed_nominal=0,
    final dpValve_nominal=dpValve_nominal[5],
    final l=lValve1,
    final kFixed=0,
    final rhoStd=rhoStd[5],
    final y_start=yValve1_start)
    annotation (Placement(transformation(extent={{60,-30},{40,-10}})));
  Fluid.Movers.FlowControlled_m_flow       pum[nChi](
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
    final m_flow_start=m_flow_start,
    each final tau=tauPump,
    each final m_flow_nominal=mPump_flow_nominal)
                              "Constant speed pumps"
    annotation (Placement(transformation(extent={{10,-30},{-10,-10}})));
  Modelica.Blocks.Math.BooleanToReal booToRea(final realTrue=0, final realFalse=
       1)                "Boolean to real (if true then 1 else 0)"
    annotation (Placement(transformation(extent={{-60,80},{-48,92}})));
  Modelica.Blocks.Sources.BooleanExpression wseMod(y=if Modelica.Math.BooleanVectors.anyTrue(on[1:nChi]) then false else true)
   "If any chiller is on then the plant is not in WSE Mode"
    annotation (Placement(transformation(extent={{-96,76},{-76,96}})));
  Modelica.Blocks.Interfaces.RealInput m_flow_in[numPum]
    "Prescribed mass flow rate for primary pumps"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
equation
  connect(wse.port_a2, port_a2) annotation (Line(points={{60,24},{80,24},{80,-60},
          {100,-60}}, color={0,127,255}));
  connect(port_a2, val1.port_a) annotation (Line(points={{100,-60},{100,-60},{80,
          -60},{80,-20},{60,-20}}, color={0,127,255}));
  connect(wse.port_b2, val1.port_b) annotation (Line(points={{40,24},{20,24},{20,
          -20},{40,-20}}, color={0,127,255}));

  connect(val1.port_b, port_b2) annotation (Line(points={{40,-20},{30,-20},{30,-60},
          {-100,-60}}, color={0,127,255}));
  connect(chiPar.port_b2, port_b2) annotation (Line(points={{-60,24},{-60,24},{-74,
          24},{-74,-60},{-100,-60}}, color={0,127,255}));
  connect(booToRea.y, val1.y) annotation (Line(points={{-47.4,86},{-47.4,86},{8,
          86},{8,0},{50,0},{50,-8}},
                                  color={0,0,127}));
  for i in 1:numPum loop
    connect(pum[i].port_a, val1.port_b)
    annotation (Line(points={{10,-20},{40,-20}}, color={0,127,255}));
    connect(pum[i].port_b, chiPar.port_a2) annotation (Line(points={{-10,-20},{-20,
          -20},{-20,24},{-40,24}}, color={0,127,255}));
  end for;
  connect(wseMod.y, booToRea.u)
    annotation (Line(points={{-75,86},{-75,86},{-61.2,86}},
                                                   color={255,0,255}));
  connect(m_flow_in, pum.m_flow_in) annotation (Line(points={{-120,-40},{-60,-40},
          {-60,0},{0.2,0},{0.2,-8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end IntegratedPrimarySecondary;
