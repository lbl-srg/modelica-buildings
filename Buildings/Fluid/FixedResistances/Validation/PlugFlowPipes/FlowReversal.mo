within Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes;
model FlowReversal
  "Simple example of plug flow pipe with flow reversal"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Medium in the pipe";
  Modelica.Blocks.Sources.Step m_flow(
    height=-4,
    offset=2,
    startTime=50)  "Mass flow rate signal"
    annotation (Placement(transformation(extent={{-92,-2},{-72,18}})));
  Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=1,
    p(displayUnit="Pa") = 101325,
    T=313.15) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{82,-10},{62,10}})));
  Buildings.Fluid.FixedResistances.PlugFlowPipe pip(
    redeclare package Medium = Medium,
    nPorts=1,
    dIns=0.05,
    kIns=0.028,
    cPip=500,
    thickness=0.0032,
    rhoPip=8000,
    m_flow_nominal=2,
    initDelay=true,
    length=200,
    v_nominal=2,
    T_start_in=293.15,
    T_start_out=293.15) "Pipe"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou(
    nPorts=1,
    redeclare package Medium = Medium,
    m_flow=0,
    use_m_flow_in=true,
    T=303.15) "Flow source"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTemOut(
    redeclare package Medium = Medium,
    tau=0,
    T_start=323.15,
    m_flow_nominal=2)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemIn(
    redeclare package Medium = Medium,
    tau=0,
    T_start=323.15,
    m_flow_nominal=2)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
equation
  connect(pip.ports_b[1], senTemOut.port_a)
    annotation (Line(points={{20,0},{30,0}}, color={0,127,255}));
  connect(senTemOut.port_b, sin.ports[1])
    annotation (Line(points={{50,0},{62,0}}, color={0,127,255}));
  connect(sou.ports[1], senTemIn.port_a)
    annotation (Line(points={{-40,0},{-30,0}}, color={0,127,255}));
  connect(senTemIn.port_b, pip.port_a)
    annotation (Line(points={{-10,0},{0,0}}, color={0,127,255}));
  connect(m_flow.y, sou.m_flow_in)
    annotation (Line(points={{-71,8},{-62,8}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/FixedResistances/Validation/PlugFlowPipes/FlowReversal.mos"
        "Simulate and Plot"),
    experiment(StopTime=150, Tolerance=1e-006),
    Documentation(info="<html>
<p>
Validation model in which water flows into the pipe and then the flow is reversed.
</p>
</html>", revisions="<html>
<ul>
<li>
October 25, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end FlowReversal;
