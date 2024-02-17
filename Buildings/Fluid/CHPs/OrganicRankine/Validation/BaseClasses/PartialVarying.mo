within Buildings.Fluid.CHPs.OrganicRankine.Validation.BaseClasses;
partial model PartialVarying
  "Partial class for the validation models"
  parameter Buildings.Fluid.CHPs.OrganicRankine.Data.WorkingFluids.Toluene pro
    "Property record of the working fluid"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  package MediumEva = Buildings.Media.Air "Medium in the evaporator";
  package MediumCon = Buildings.Media.Water "Medium in the condenser";
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
    nPorts=1) "Source on the evaporator side"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Fluid.Sources.Boundary_pT sinEva(
    redeclare final package Medium = MediumEva,
    nPorts=1) "Sink on the evaporator side"
    annotation (Placement(transformation(extent={{80,20},{60,40}})));
  Buildings.Fluid.Sources.MassFlowSource_T souCon(
    redeclare final package Medium = MediumCon,
    m_flow=mCon_flow_nominal,
    nPorts=1) "Source on the condenser side"
    annotation (Placement(transformation(extent={{40,-40},{20,-20}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TEvaOut(
    redeclare final package Medium = MediumEva,
    final m_flow_nominal=mEva_flow_nominal,
    tau=0) "Outgoing temperature of evaporator hot fluid"
    annotation (Placement(transformation(extent={{30,20},{50,40}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TConOut(
    redeclare final package Medium = MediumCon,
    final m_flow_nominal=mCon_flow_nominal,
    tau=0) "Outgoing temperature of condenser cold fluid"
    annotation (Placement(transformation(extent={{-30,-40},{-50,-20}})));
  Buildings.Fluid.Sources.Boundary_pT sinCon(
    redeclare final package Medium = MediumCon,
    nPorts=1) "Sink on the condenser side"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));

equation
  connect(souEva.ports[1],ORC. port_a1) annotation (Line(points={{-20,30},{-16,30},
          {-16,6},{-10,6}}, color={0,127,255}));
  connect(souCon.ports[1],ORC. port_a2) annotation (Line(points={{20,-30},{16,-30},
          {16,-6},{10,-6}}, color={0,127,255}));
  connect(sinEva.ports[1],TEvaOut. port_b)
    annotation (Line(points={{60,30},{50,30}}, color={0,127,255}));
  connect(TEvaOut.port_a,ORC. port_b1) annotation (Line(points={{30,30},{16,30},
          {16,6},{10,6}}, color={0,127,255}));
  connect(TConOut.port_a,ORC. port_b2) annotation (Line(points={{-30,-30},{-16,-30},
          {-16,-6},{-10,-6}}, color={0,127,255}));
  connect(sinCon.ports[1], TConOut.port_b)
    annotation (Line(points={{-60,-30},{-50,-30}}, color={0,127,255}));
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
end PartialVarying;
