within Buildings.Fluid.CHPs.OrganicRankine.Validation.BaseClasses;
partial model PartialVariable
  "Partial class for the validation models"
  parameter Buildings.Fluid.CHPs.OrganicRankine.Data.WorkingFluids.R245fa pro
    "Property record of the working fluid"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  package MediumHot = Buildings.Media.Air "Medium in the evaporator";
  package MediumCol = Buildings.Media.Water "Medium in the condenser";
  parameter Modelica.Units.SI.MassFlowRate mHot_flow_nominal = 1
    "Medium flow rate in the evaporator";
  parameter Modelica.Units.SI.MassFlowRate mCol_flow_nominal = 2
    "Medium flow rate in the condenser";

  Buildings.Fluid.CHPs.OrganicRankine.Cycle orc(
    redeclare package Medium1 = MediumHot,
    redeclare package Medium2 = MediumCol,
    pro=pro,
    tau1=0,
    tau2=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T1_start(displayUnit="K") = 350,
    T2_start(displayUnit="K") = 290,
    QEva_flow_nominal=1E5,
    mHot_flow_nominal=mHot_flow_nominal,
    mCol_flow_nominal=mCol_flow_nominal,
    TWorEva=350,
    etaExp=0.7)                       "Organic Rankine cycle"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Sources.MassFlowSource_T souHot(
    redeclare final package Medium = MediumHot,
    m_flow=mHot_flow_nominal,
    T=orc.TWorEva + 20,
    nPorts=1) "Source on the evaporator side"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Fluid.Sources.Boundary_pT sinHot(
    redeclare final package Medium = MediumHot,
    nPorts=1) "Sink on the evaporator side"
    annotation (Placement(transformation(extent={{80,20},{60,40}})));
  Buildings.Fluid.Sources.MassFlowSource_T souCol(
    redeclare final package Medium = MediumCol,
    m_flow=mCol_flow_nominal,
    nPorts=1) "Source on the condenser side"
    annotation (Placement(transformation(extent={{40,-40},{20,-20}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort THotOut(
    redeclare final package Medium = MediumHot,
    final m_flow_nominal=mHot_flow_nominal,
    tau=0) "Outgoing temperature of evaporator hot fluid"
    annotation (Placement(transformation(extent={{30,20},{50,40}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TColOut(
    redeclare final package Medium = MediumCol,
    final m_flow_nominal=mCol_flow_nominal,
    tau=0) "Outgoing temperature of condenser cold fluid"
    annotation (Placement(transformation(extent={{-30,-40},{-50,-20}})));
  Buildings.Fluid.Sources.Boundary_pT sinCol(
    redeclare final package Medium = MediumCol,
    nPorts=1) "Sink on the condenser side"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));

  Modelica.Blocks.Sources.BooleanConstant tru(k=true) "Constant true"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
equation
  connect(souHot.ports[1],orc. port_a1) annotation (Line(points={{-20,30},{-16,30},
          {-16,6},{-10,6}}, color={0,127,255}));
  connect(souCol.ports[1],orc. port_a2) annotation (Line(points={{20,-30},{16,-30},
          {16,-6},{10,-6}}, color={0,127,255}));
  connect(sinHot.ports[1],THotOut. port_b)
    annotation (Line(points={{60,30},{50,30}}, color={0,127,255}));
  connect(THotOut.port_a,orc. port_b1) annotation (Line(points={{30,30},{16,30},
          {16,6},{10,6}}, color={0,127,255}));
  connect(TColOut.port_a,orc. port_b2) annotation (Line(points={{-30,-30},{-16,-30},
          {-16,-6},{-10,-6}}, color={0,127,255}));
  connect(sinCol.ports[1], TColOut.port_b)
    annotation (Line(points={{-60,-30},{-50,-30}}, color={0,127,255}));
  connect(tru.y, orc.ena)
    annotation (Line(points={{-19,0},{-8,0}}, color={255,0,255}));
    annotation (
    Documentation(info="<html>
<p>
This is the base class for the validation models.
</p>
</html>",revisions="<html>
<ul>
<li>
February 16, 2024, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3433\">#3433</a>.
</li>
</ul>
</html>"));
end PartialVariable;
