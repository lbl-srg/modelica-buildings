within Buildings.Fluid.FixedResistances.Examples;
model PlugFlowPipe "Simple example of plug flow pipe"
  extends Modelica.Icons.Example;
  replaceable package Medium = Buildings.Media.Water "Medium in the pipe" annotation (
      choicesAllMatching=true);

  final parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=3
    "Mass flow rate";

  Modelica.Blocks.Sources.Ramp Tin(
    height=20,
    duration=0,
    offset=273.15 + 50,
    startTime=100) "Ramp pressure signal"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    T=273.15 + 10,
    nPorts=2,
    p(displayUnit="Pa") = 101325) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{100,-10},{80,10}})));
  Buildings.Fluid.FixedResistances.PlugFlowPipe pip(
    redeclare package Medium = Medium,
    dh=0.1,
    length=100,
    dIns=0.05,
    kIns=0.028,
    m_flow_nominal=m_flow_nominal,
    cPip=500,
    thickness=0.0032,
    initDelay=true,
    m_flow_start=m_flow_nominal,
    rhoPip=8000,
    T_start_in=323.15,
    T_start_out=323.15) "Pipe"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.HeatTransfer.Sources.FixedTemperature bou[2](each T=283.15)
    "Boundary temperature"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    use_T_in=true,
    m_flow=m_flow_nominal,
    nPorts=1) "Flow source"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTemOut(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=0,
    T_start=323.15) "Temperature sensor"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemIn(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=0,
    T_start=323.15) "Temperature sensor"
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
  Sensors.TemperatureTwoPort senTemInNoMix(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=0,
    T_start=323.15) "Temperature sensor"
    annotation (Placement(transformation(extent={{-30,-30},{-10,-10}})));
  Buildings.Fluid.FixedResistances.PlugFlowPipe pipNoMix(
    have_pipCap=false,
    redeclare package Medium = Medium,
    dh=0.1,
    length=100,
    dIns=0.05,
    kIns=0.028,
    m_flow_nominal=m_flow_nominal,
    cPip=500,
    thickness=0.0032,
    initDelay=true,
    m_flow_start=m_flow_nominal,
    rhoPip=8000,
    T_start_in=323.15,
    T_start_out=323.15) "Pipe"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Sensors.TemperatureTwoPort senTemOutNoMix(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=0,
    T_start=323.15) "Temperature sensor"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Sources.MassFlowSource_T souNoMix(
    redeclare package Medium = Medium,
    use_T_in=true,
    m_flow=m_flow_nominal,
    nPorts=1) "Flow source"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
equation
  connect(Tin.y, sou.T_in)
    annotation (Line(points={{-79,0},{-68,0},{-68,24},{-62,24}},
                                               color={0,0,127}));
  connect(pip.port_b, senTemOut.port_a)
    annotation (Line(points={{20,20},{40,20}},
                                             color={0,127,255}));
  connect(senTemOut.port_b, sin.ports[1])
    annotation (Line(points={{60,20},{76,20},{76,-1},{80,-1}},
                                             color={0,127,255}));
  connect(senTemIn.port_b, pip.port_a)
    annotation (Line(points={{-10,20},{0,20}},
                                             color={0,127,255}));
  connect(senTemInNoMix.port_b, pipNoMix.port_a)
    annotation (Line(points={{-10,-20},{0,-20}}, color={0,127,255}));
  connect(pipNoMix.port_b, senTemOutNoMix.port_a)
    annotation (Line(points={{20,-20},{40,-20}}, color={0,127,255}));
  connect(senTemOutNoMix.port_b, sin.ports[2]) annotation (Line(points={{60,-20},
          {76,-20},{76,1},{80,1}},   color={0,127,255}));
  connect(bou[1].port, pip.heatPort)
    annotation (Line(points={{-20,70},{-4,70},{-4,40},{10,40},{10,30}},
                                                        color={191,0,0}));
  connect(bou[2].port, pipNoMix.heatPort) annotation (Line(points={{-20,70},{-4,
          70},{-4,0},{10,0},{10,-10}},     color={191,0,0}));
  connect(sou.ports[1], senTemIn.port_a) annotation (Line(points={{-40,20},{-30,
          20}},               color={0,127,255}));
  connect(souNoMix.ports[1], senTemInNoMix.port_a)
    annotation (Line(points={{-40,-20},{-30,-20}}, color={0,127,255}));
  connect(Tin.y, souNoMix.T_in) annotation (Line(points={{-79,0},{-68,0},{-68,
          -16},{-62,-16}},
                      color={0,0,127}));
  annotation (
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FixedResistances/Examples/PlugFlowPipe.mos"
        "Simulate and Plot"),
    experiment(StopTime=1000, Tolerance=1e-006),
    Documentation(info="<html>
<p>Basic test of model
<a href=\"modelica://Buildings.Fluid.FixedResistances.PlugFlowPipe\">
Buildings.Fluid.FixedResistances.PlugFlowPipe</a> with and without outlet mixing volume.
This test includes an inlet temperature step under a constant mass flow rate.
</p>
</html>", revisions="<html>
<ul>
<li>July 27, 2021 by Baptiste Ravache<br/>Add case without mixing volume</li>
</ul>
<ul>
<li>September 8, 2017 by Bram van der Heijde<br/>First implementation</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-120,-100},{120,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end PlugFlowPipe;
