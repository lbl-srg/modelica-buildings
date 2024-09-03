within Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes;
model TransportWaterAir
  "Validation model, one having water and the other air"
  extends Modelica.Icons.Example;
  package MediumW = Buildings.Media.Water "Medium in the pipe";
  package MediumA = Buildings.Media.Air(extraPropertiesNames={"CO2"})
   "Medium in the duct";

  parameter Modelica.Units.SI.Length length=20 "Pipe length";

  Modelica.Blocks.Sources.Step Tin(
    startTime=100,
    height=10,
    offset=273.15 + 20)
                   "Step input"
    annotation (Placement(transformation(extent={{-92,20},{-72,40}})));
  Sources.Boundary_pT sin(
    redeclare package Medium = MediumW,
    T=273.15 + 10,
    nPorts=1,
    p(displayUnit="Pa") = 101325) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{82,16},{62,36}})));
  Buildings.Fluid.FixedResistances.PlugFlowPipe pip(
    redeclare package Medium = MediumW,
    dIns=0.05,
    kIns=0.028,
    m_flow_nominal=1,
    cPip=500,
    thickness=0.0032,
    initDelay=true,
    m_flow_start=1,
    rhoPip=8000,
    length=length,
    T_start_in=293.15,
    T_start_out=293.15) "Pipe"
    annotation (Placement(transformation(extent={{0,16},{20,36}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou(
    nPorts=1,
    redeclare package Medium = MediumW,
    use_T_in=true,
    m_flow=1) "Flow source"
    annotation (Placement(transformation(extent={{-60,16},{-40,36}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTemOutW(
    redeclare package Medium = MediumW,
    m_flow_nominal=1,
    tau=0,
    T_start=323.15) "Temperature sensor"
    annotation (Placement(transformation(extent={{30,16},{50,36}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemIn(
    redeclare package Medium = MediumW,
    m_flow_nominal=1,
    tau=0,
    T_start=323.15) "Temperature sensor"
    annotation (Placement(transformation(extent={{-30,16},{-10,36}})));
  Sources.Boundary_pT sin1(
    T=273.15 + 10,
    nPorts=1,
    p(displayUnit="Pa") = 101325,
    redeclare package Medium = MediumA)
    "Pressure boundary condition"
    annotation (Placement(transformation(extent={{80,-80},{60,-60}})));
  PlugFlowPipe duc(
    dIns=0.05,
    kIns=0.028,
    m_flow_nominal=1,
    cPip=500,
    thickness=0.0032,
    initDelay=true,
    m_flow_start=1,
    rhoPip=8000,
    redeclare package Medium = MediumA,
    length=length,
    T_start_in=293.15,
    T_start_out=293.15) "Duct"
    annotation (Placement(transformation(extent={{-2,-80},{18,-60}})));
  Sources.MassFlowSource_T sou1(
    nPorts=1,
    use_T_in=true,
    redeclare package Medium = MediumA,
    use_X_in=true,
    use_C_in=true,
    m_flow=1)      "Flow source"
    annotation (Placement(transformation(extent={{-62,-80},{-42,-60}})));
  Sensors.TemperatureTwoPort senTemOutA(
    m_flow_nominal=1,
    tau=0,
    redeclare package Medium = MediumA,
    T_start=323.15)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{28,-80},{48,-60}})));
  Sensors.TemperatureTwoPort senTemIn1(
    m_flow_nominal=1,
    tau=0,
    T_start=323.15,
    redeclare package Medium = MediumA)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{-32,-80},{-12,-60}})));
  Modelica.Blocks.Sources.Step XiIn[2](
    each startTime=100,
    height={0.01, -0.01},
    offset={0.01,0.99}) "Step input"
    annotation (Placement(transformation(extent={{-96,-84},{-76,-64}})));
  Modelica.Blocks.Sources.Step CIn[1](
    each startTime=100,
    each height=0.01,
    each offset=1E-3) "Step input"
    annotation (Placement(transformation(extent={{-96,-116},{-76,-96}})));
equation
  connect(Tin.y, sou.T_in)
    annotation (Line(points={{-71,30},{-62,30}},
                                               color={0,0,127}));
  connect(pip.port_b, senTemOutW.port_a)
    annotation (Line(points={{20,26},{30,26}}, color={0,127,255}));
  connect(senTemOutW.port_b, sin.ports[1])
    annotation (Line(points={{50,26},{62,26}}, color={0,127,255}));
  connect(sou.ports[1], senTemIn.port_a)
    annotation (Line(points={{-40,26},{-30,26}},
                                               color={0,127,255}));
  connect(senTemIn.port_b, pip.port_a)
    annotation (Line(points={{-10,26},{0,26}},
                                             color={0,127,255}));
  connect(duc.port_b,senTemOutA. port_a)
    annotation (Line(points={{18,-70},{28,-70}}, color={0,127,255}));
  connect(senTemOutA.port_b, sin1.ports[1])
    annotation (Line(points={{48,-70},{60,-70}}, color={0,127,255}));
  connect(sou1.ports[1], senTemIn1.port_a)
    annotation (Line(points={{-42,-70},{-32,-70}}, color={0,127,255}));
  connect(senTemIn1.port_b, duc.port_a)
    annotation (Line(points={{-12,-70},{-2,-70}},color={0,127,255}));
  connect(sou1.X_in, XiIn.y) annotation (Line(points={{-64,-74},{-75,-74}},
                      color={0,0,127}));
  connect(sou1.C_in, CIn.y) annotation (Line(points={{-64,-78},{-70,-78},{-70,
          -106},{-75,-106}},
                      color={0,0,127}));
  connect(Tin.y, sou1.T_in) annotation (Line(points={{-71,30},{-68,30},{-68,-66},
          {-64,-66}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FixedResistances/Validation/PlugFlowPipes/TransportWaterAir.mos"
        "Simulate and Plot"),
    experiment(StopTime=1000, Tolerance=1e-006),
    Documentation(info="<html>
<p>
Validation model in which a step input is applied to
the transport of air and water with a species concentration.
</p>
</html>", revisions="<html>
<ul>
<li>
October 25, 2017 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-140},{100,100}})));
end TransportWaterAir;
