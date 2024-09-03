within Buildings.Fluid.Sources.Examples;
model PropertySource_h "Model that illustrates the use of PropertySource_h"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air(extraPropertiesNames={"CO2"});

  Buildings.Fluid.Sources.PropertySource_h proSouXi(
    redeclare package Medium = Medium,
    use_Xi_in=true)
    "Property source that prescribes Xi"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Sources.MassFlowSource_h bouXi(
    redeclare package Medium = Medium,
    nPorts=1,
    use_m_flow_in=true)
    "Boundary for Xi test"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Buildings.Fluid.Sources.Boundary_ph sin(
    redeclare package Medium = Medium,
    nPorts=3)
    "Sink model"
          annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Buildings.Fluid.Sources.PropertySource_h proSouH(
    redeclare package Medium = Medium,
    use_h_in=true)
    "Property source that prescribes the specific enthalpy"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Buildings.Fluid.Sources.PropertySource_h proSouC(
    redeclare package Medium = Medium,
    use_C_in=true)   "Property source that prescribes C"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Buildings.Fluid.Sources.MassFlowSource_h bouH(
    redeclare package Medium = Medium,
    nPorts=1,
    use_m_flow_in=true)
    "Boundary for specific enthalpy test"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Fluid.Sources.MassFlowSource_h bouC(
    redeclare package Medium = Medium,
    nPorts=1,
    use_m_flow_in=true)
    "Boundary for C test"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Modelica.Blocks.Sources.Constant h(
    k=Medium.h_default + 1e3)
    "Fixed specific enthalpy value"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Modelica.Blocks.Sources.Constant Xi(k=0.0123)
    "Fixed Xi value"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Modelica.Blocks.Sources.Constant C(k=0.1)
    "Fixed C value"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-2,
    duration=1,
    offset=1)
    "Ramp for mass flow rate"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
equation
  connect(bouXi.ports[1], proSouXi.port_a)
    annotation (Line(points={{-40,0},{-10,0}}, color={0,127,255}));
  connect(bouC.ports[1], proSouC.port_a)
    annotation (Line(points={{-40,-40},{-10,-40}}, color={0,127,255}));
  connect(bouH.ports[1], proSouH.port_a)
    annotation (Line(points={{-40,40},{-10,40}}, color={0,127,255}));
  connect(proSouH.port_b, sin.ports[1]) annotation (Line(points={{10,40},{60,40},
          {60,2.66667}}, color={0,127,255}));
  connect(proSouXi.port_b, sin.ports[2]) annotation (Line(points={{10,0},{36,0},
          {36,-2.22045e-16},{60,-2.22045e-16}}, color={0,127,255}));
  connect(proSouC.port_b, sin.ports[3]) annotation (Line(points={{10,-40},{60,-40},
          {60,-2.66667}}, color={0,127,255}));
  connect(h.y, proSouH.h_in)
    annotation (Line(points={{-19,60},{-4,60},{-4,52}}, color={0,0,127}));
  connect(Xi.y, proSouXi.Xi_in[1])
    annotation (Line(points={{-19,20},{0,20},{0,12}}, color={0,0,127}));
  connect(C.y, proSouC.C_in[1])
    annotation (Line(points={{-19,-20},{4,-20},{4,-28}}, color={0,0,127}));
  connect(bouH.m_flow_in, ramp.y) annotation (Line(points={{-62,48},{-72,48},{-72,
          70},{-79,70}}, color={0,0,127}));
  connect(ramp.y, bouXi.m_flow_in) annotation (Line(points={{-79,70},{-72,70},{-72,
          8},{-62,8}}, color={0,0,127}));
  connect(ramp.y, bouC.m_flow_in) annotation (Line(points={{-79,70},{-72,70},{-72,
          -32},{-62,-32}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Example model that illustrates the use of
the <a href=\"modelica://Buildings.Fluid.Sources.PropertySource_h\">
Buildings.Fluid.Sources.PropertySource_h</a> model.
</p>
</html>", revisions="<html>
<ul>
<li>
April 30, 2018, by Filip Jorissen:<br/>
First implementation.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/881\">#881</a>.
</li>
</ul>
</html>"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Sources/Examples/PropertySource_h.mos"
        "Simulate and plot"),
    experiment(
      StopTime=1,
      Tolerance=1e-06));
end PropertySource_h;
