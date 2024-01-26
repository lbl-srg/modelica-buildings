within Buildings.Fluid.CHPs.OrganicRankine.Validation;
model Cycle
  extends Modelica.Icons.Example;

  parameter Buildings.Fluid.CHPs.OrganicRankine.Data.WorkingFluids.Toluene pro
    "Property record of the working fluid"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  package MediumEva = Buildings.Media.Air "Medium in the evaporator";
  package MediumCon = Buildings.Media.Air "Medium in the condenser";
  parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal = 1
    "Medium flow rate in the evaporator";
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal = 2
    "Medium flow rate in the condenser";

  Buildings.Fluid.CHPs.OrganicRankine.Cycle ORC(
    redeclare package Medium1 = MediumEva,
    redeclare package Medium2 = MediumCon,
    pro=pro,
    tau1=0,
    tau2=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T1_start(displayUnit="K") = 500,
    T2_start(displayUnit="K") = 290,
    QEva_flow_nominal=1E5,
    mEva_flow_nominal=mEva_flow_nominal,
    mCon_flow_nominal=mCon_flow_nominal,
    TEvaWor=473.15)                      "Organic Rankine cycle"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Sources.MassFlowSource_T souEva(
    redeclare final package Medium = MediumEva,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) "Source on the evaporator side"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Fluid.Sources.Boundary_pT sinEva(
    redeclare final package Medium = MediumEva,
    nPorts=1) "Sink on the evaporator side"
    annotation (Placement(transformation(extent={{40,20},{20,40}})));
  Buildings.Fluid.Sources.MassFlowSource_T souCon(
    redeclare final package Medium = MediumCon,
    m_flow=mCon_flow_nominal,
    nPorts=1) "Source on the condenser side"
    annotation (Placement(transformation(extent={{40,-40},{20,-20}})));
  Buildings.Fluid.Sources.Boundary_pT sinCon(
    redeclare final package Medium = MediumCon,
    nPorts=1) "Sink on the condenser side"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Modelica.Blocks.Sources.RealExpression expTEvaIn(y=500)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  Modelica.Blocks.Sources.Sine sine(
    amplitude=mEva_flow_nominal*2,
    f=1/200,
    offset=mEva_flow_nominal)
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
equation
  connect(souEva.ports[1], ORC.port_a1) annotation (Line(points={{-20,30},{-16,30},
          {-16,6},{-10,6}}, color={0,127,255}));
  connect(sinEva.ports[1], ORC.port_b1) annotation (Line(points={{20,30},{16,30},
          {16,6},{10,6}}, color={0,127,255}));
  connect(sinCon.ports[1], ORC.port_b2) annotation (Line(points={{-20,-30},{-16,
          -30},{-16,-6},{-10,-6}}, color={0,127,255}));
  connect(expTEvaIn.y, souEva.T_in) annotation (Line(points={{-59,30},{-50,30},{
          -50,34},{-42,34}}, color={0,0,127}));
  connect(souCon.ports[1], ORC.port_a2) annotation (Line(points={{20,-30},{16,-30},
          {16,-6},{10,-6}}, color={0,127,255}));
  connect(sine.y, souEva.m_flow_in) annotation (Line(points={{-59,60},{-50,60},{
          -50,38},{-42,38}}, color={0,0,127}));
  annotation(experiment(StopTime=100));
end Cycle;
