within Buildings.Fluid.BaseClasses.Validation;
model MassFlowRateMultiplier "Example use of MassFlowRateMultiplier"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;

  Buildings.Fluid.BaseClasses.MassFlowRateMultiplier
    massFlowRateMultiplier(
      redeclare package Medium = Medium,
      k=5)
      "Mass flow rate multiplier"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Modelica.Blocks.Sources.Ramp ram_m_flow(
    height=10,
    duration=10,
    offset=0) "Mass flow rate ramp"
    annotation (Placement(transformation(extent={{-80,-2},{-60,18}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) "Mass flow source"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=2)
    "Mass flow sink"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,0})));
  Buildings.Fluid.BaseClasses.MassFlowRateMultiplier
    massFlowRateMultiplier1(
    redeclare package Medium = Medium,
    use_input=true,
    k=5)
      "Mass flow rate multiplier"
    annotation (Placement(transformation(extent={{10,-70},{30,-50}})));
  Modelica.Blocks.Sources.Ramp gaiMasFlo(
    height=4.9,
    duration=10,
    offset=0.1) "Mass flow rate multiplier factor"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou1(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) "Mass flow source"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
equation
  connect(ram_m_flow.y, sou.m_flow_in)
    annotation (Line(points={{-59,8},{-42,8}}, color={0,0,127}));
  connect(sou.ports[1], massFlowRateMultiplier.port_a)
    annotation (Line(points={{-20,0},{10,0}},          color={0,127,255}));
  connect(massFlowRateMultiplier.port_b, sin.ports[1])
    annotation (Line(points={{30,0},{60,0},{60,1}}, color={0,127,255}));
  connect(sou1.ports[1], massFlowRateMultiplier1.port_a)
    annotation (Line(points={{-20,-60},{10,-60}}, color={0,127,255}));
  connect(massFlowRateMultiplier1.port_b, sin.ports[2])
    annotation (Line(points={{30,-60},{60,-60},{60,-1}}, color={0,127,255}));
  connect(gaiMasFlo.y, massFlowRateMultiplier1.u) annotation (Line(points={{-59,
          -40},{0,-40},{0,-54},{8,-54}}, color={0,0,127}));
  connect(ram_m_flow.y, sou1.m_flow_in) annotation (Line(points={{-59,8},{-50,8},
          {-50,-52},{-42,-52}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/BaseClasses/Validation/MassFlowRateMultiplier.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StartTime=0.0, StopTime=10.0),
    Documentation(info="<html>
<p>
This example demonstrates the use of
<a href=\"modelica://Buildings.Fluid.BaseClasses.MassFlowRateMultiplier\">
Buildings.Fluid.BaseClasses.MassFlowRateMultiplier</a>,
using either a parameter to specify the multiplier factor
(see the instance <code>massFlowRateMultiplier</code>) or
an input signal (see the instance <code>massFlowRateMultiplier1</code>).
</p>
</html>", revisions="<html>
<ul>
<li>
July 19, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end MassFlowRateMultiplier;
