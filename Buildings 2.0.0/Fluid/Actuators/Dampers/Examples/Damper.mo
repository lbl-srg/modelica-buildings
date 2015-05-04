within Buildings.Fluid.Actuators.Dampers.Examples;
model Damper
  "Damper with constant pressure difference and varying control signal"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air;

  Buildings.Fluid.Actuators.Dampers.Exponential res(
    A=1,
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    filteredOpening=false)
         annotation (Placement(transformation(extent={{0,10},{20,30}})));
    Modelica.Blocks.Sources.Ramp yRam(
    duration=0.3,
    offset=0,
    startTime=0.2,
    height=1)    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.Fluid.Sources.Boundary_pT sou(             redeclare package Medium
      = Medium,
    nPorts=1,
    p(displayUnit="Pa") = 101335,
    T=293.15)                                       annotation (Placement(
        transformation(extent={{-68,10},{-48,30}})));
  Buildings.Fluid.Sources.Boundary_pT sin(             redeclare package Medium
      = Medium,
    nPorts=1,
    p(displayUnit="Pa") = 101325,
    T=293.15)                                       annotation (Placement(
        transformation(extent={{74,10},{54,30}})));

equation
  connect(yRam.y, res.y) annotation (Line(
      points={{1,50},{10,50},{10,32}},
      color={0,0,127}));
  connect(sou.ports[1], res.port_a) annotation (Line(
      points={{-48,20},{-5.55112e-16,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin.ports[1], res.port_b) annotation (Line(
      points={{54,20},{20,20}},
      color={0,127,255},
      smooth=Smooth.None));
    annotation (experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Actuators/Dampers/Examples/Damper.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
Test model for the air damper.
The air damper is connected to models for constant inlet and outlet
pressures. The control signal of the damper is a ramp.
</p>
</html>", revisions="<html>
<ul>
<li>
July 20, 2007 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Damper;
