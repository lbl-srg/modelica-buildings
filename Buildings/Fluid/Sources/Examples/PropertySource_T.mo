within Buildings.Fluid.Sources.Examples;
model PropertySource_T "Model that illustrates the use of PropertySource_T"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air(extraPropertiesNames={"CO2"});

  Buildings.Fluid.Sources.PropertySource_T proSouXi(
    redeclare package Medium = Medium,
    use_Xi_in=true)
    "Property source that prescribes Xi"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Sources.MassFlowSource_T bouXi(
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
  Buildings.Fluid.Sources.PropertySource_T proSouT(
    redeclare package Medium = Medium,
    use_T_in=true)
    "Property source that prescribes the temperature"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Buildings.Fluid.Sources.PropertySource_T proSouC(
    redeclare package Medium = Medium,
    use_C_in=true)
    "Property source that prescribes C"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Buildings.Fluid.Sources.MassFlowSource_T bouT(
    redeclare package Medium = Medium,
    nPorts=1,
    use_m_flow_in=true)
    "Boundary for temperature test"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Fluid.Sources.MassFlowSource_T bouC(
    redeclare package Medium = Medium,
    nPorts=1,
    use_m_flow_in=true)
    "Boundary for C test"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Modelica.Blocks.Sources.Constant T(k=Medium.T_default + 1)
    "Fixed temperature value"
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
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemT(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    tau=0)
    "Temperature sensor for when using temperature input"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemXi(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    tau=0)
    "Temperature sensor for when using Xi input"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemC(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    tau=0)
    "Temperature sensor for when using C input"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
equation
  connect(bouXi.ports[1], proSouXi.port_a)
    annotation (Line(points={{-40,0},{-10,0}}, color={0,127,255}));
  connect(bouC.ports[1], proSouC.port_a)
    annotation (Line(points={{-40,-40},{-10,-40}}, color={0,127,255}));
  connect(bouT.ports[1], proSouT.port_a)
    annotation (Line(points={{-40,40},{-10,40}}, color={0,127,255}));
  connect(Xi.y, proSouXi.Xi_in[1])
    annotation (Line(points={{-19,20},{0,20},{0,12}}, color={0,0,127}));
  connect(C.y, proSouC.C_in[1])
    annotation (Line(points={{-19,-20},{4,-20},{4,-28}}, color={0,0,127}));
  connect(bouT.m_flow_in, ramp.y) annotation (Line(points={{-62,48},{-72,48},{-72,
          70},{-79,70}}, color={0,0,127}));
  connect(ramp.y, bouXi.m_flow_in) annotation (Line(points={{-79,70},{-72,70},{-72,
          8},{-62,8}}, color={0,0,127}));
  connect(ramp.y, bouC.m_flow_in) annotation (Line(points={{-79,70},{-72,70},{-72,
          -32},{-62,-32}}, color={0,0,127}));
  connect(T.y, proSouT.T_in)
    annotation (Line(points={{-19,60},{-4,60},{-4,52}}, color={0,0,127}));
  connect(proSouC.port_b, senTemC.port_a)
    annotation (Line(points={{10,-40},{20,-40}}, color={0,127,255}));
  connect(senTemC.port_b, sin.ports[1]) annotation (Line(points={{40,-40},{60,
          -40},{60,2.66667}}, color={0,127,255}));
  connect(senTemXi.port_b, sin.ports[2]) annotation (Line(points={{40,0},{50,0},
          {50,-2.22045e-16},{60,-2.22045e-16}}, color={0,127,255}));
  connect(senTemT.port_b, sin.ports[3]) annotation (Line(points={{40,40},{60,40},
          {60,-2.66667}}, color={0,127,255}));
  connect(proSouT.port_b, senTemT.port_a)
    annotation (Line(points={{10,40},{20,40}}, color={0,127,255}));
  connect(proSouXi.port_b, senTemXi.port_a)
    annotation (Line(points={{10,0},{20,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Example model that illustrates the use of
the <a href=\"modelica://Buildings.Fluid.Sources.PropertySource_T\">
Buildings.Fluid.Sources.PropertySource_T</a> model.
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
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Sources/Examples/PropertySource_T.mos"
        "Simulate and plot"),
    experiment(
      StopTime=1,
      Tolerance=1e-06));
end PropertySource_T;
