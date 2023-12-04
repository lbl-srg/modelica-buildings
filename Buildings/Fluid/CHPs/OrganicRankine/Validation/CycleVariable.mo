within Buildings.Fluid.CHPs.OrganicRankine.Validation;
model CycleVariable
  extends Modelica.Icons.Example;

  parameter Buildings.Fluid.CHPs.OrganicRankine.Data.WorkingFluids.Toluene pro
    "Property record of the working fluid"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  package MediumEva = Buildings.Media.Air "Medium in the evaporator";
  package MediumCon = Buildings.Media.Air "Medium in the condenser";
  parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal = 0.4
    "Medium flow rate in the evaporator";
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal = 1
    "Medium flow rate in the condenser";

  Buildings.Fluid.CHPs.OrganicRankine.CycleVariable ORC(
    redeclare package Medium1 = MediumEva,
    redeclare package Medium2 = MediumCon,
    pro=pro,
    tau1=0,
    tau2=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T1_start(displayUnit="K") = 500,
    T2_start(displayUnit="K") = 290,
    mEva_flow_nominal=mEva_flow_nominal,
    mCon_flow_nominal=mCon_flow_nominal) "Organic Rankine cycle"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    //UAEva=1000,
    //UACon=1000,
  Buildings.Fluid.Sources.MassFlowSource_T souEva(
    redeclare final package Medium = MediumEva,
    m_flow=mEva_flow_nominal,
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
    use_T_in=true,
    T=288.15,
    nPorts=1) "Source on the condenser side"
    annotation (Placement(transformation(extent={{40,-40},{20,-20}})));
  Buildings.Fluid.Sources.Boundary_pT sinCon(
    redeclare final package Medium = MediumCon,
    nPorts=1)  "Sink on the condenser side"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Modelica.Blocks.Sources.RealExpression expTEvaIn(y=500)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.RealExpression expTConIn(y=290)
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Modelica.Blocks.Sources.RealExpression expTEvaWor(y=450)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
equation
  connect(souEva.ports[1], ORC.port_a1) annotation (Line(points={{-20,30},{-16,30},
          {-16,6},{-10,6}}, color={0,127,255}));
  connect(sinEva.ports[1], ORC.port_b1) annotation (Line(points={{20,30},{16,30},
          {16,6},{10,6}}, color={0,127,255}));
  connect(souCon.ports[1], ORC.port_a2) annotation (Line(points={{20,-30},{16,-30},
          {16,-6},{10,-6}}, color={0,127,255}));
  connect(sinCon.ports[1], ORC.port_b2) annotation (Line(points={{-20,-30},{-16,
          -30},{-16,-6},{-10,-6}}, color={0,127,255}));
  connect(expTEvaIn.y, souEva.T_in) annotation (Line(points={{-59,30},{-50,30},{
          -50,34},{-42,34}}, color={0,0,127}));
  connect(expTConIn.y, souCon.T_in) annotation (Line(points={{61,-50},{66,-50},
          {66,-26},{42,-26}}, color={0,0,127}));
  connect(expTEvaWor.y, ORC.TEvaWor) annotation (Line(points={{-59,10},{-40,10},
          {-40,2},{-11,2}}, color={0,0,127}));
end CycleVariable;
