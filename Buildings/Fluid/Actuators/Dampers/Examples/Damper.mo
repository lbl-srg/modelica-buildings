within Buildings.Fluid.Actuators.Dampers.Examples;
model Damper
  "Dampers with constant pressure difference and varying control signal."
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air;

  Buildings.Fluid.Actuators.Dampers.Exponential res(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    use_input_filter=false)
    annotation (Placement(transformation(extent={{0,10},{20,30}})));

    Modelica.Blocks.Sources.Ramp yRam(
    duration=0.3,
    offset=0,
    startTime=0.2,
    height=1)    annotation (Placement(transformation(extent={{-20,40},{0,60}})));


  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    nPorts=2,
    p(displayUnit="Pa") = 101335,
    T=293.15)                                       annotation (Placement(
        transformation(extent={{-68,10},{-48,30}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
   redeclare package Medium = Medium,
    nPorts=2,
    p(displayUnit="Pa") = 101325,
    T=293.15)                                       annotation (Placement(
        transformation(extent={{74,10},{54,30}})));

  Exponential resLinear(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    filteredOpening=false,
    linearized=true)
    "A damper with linear relationship between m_flow and dp (linearized = true)"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
equation
  connect(yRam.y, res.y) annotation (Line(
      points={{1,50},{10,50},{10,34}},
      color={0,0,127}));
  connect(sou.ports[1], res.port_a) annotation (Line(
      points={{-48,22},{0,22}},
      color={0,127,255}));
  connect(sin.ports[1], res.port_b) annotation (Line(
      points={{54,22},{20,22}},
      color={0,127,255}));
  connect(resLinear.port_b, sin.ports[2]) annotation (Line(points={{20,-20},{32,
          -20},{32,18},{54,18}}, color={0,127,255}));
  connect(resLinear.port_a, sou.ports[2]) annotation (Line(points={{0,-20},{-20,
          -20},{-20,18},{-48,18}}, color={0,127,255}));
  connect(yRam.y, resLinear.y) annotation (Line(points={{1,50},{26,50},{26,-2},{
          10,-2},{10,-8}}, color={0,0,127}));
    annotation (experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Actuators/Dampers/Examples/Damper.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
Test model for the air damper with and without linearization of the pressure-flow relationship.
The air dampers are connected to models for constant inlet and outlet
pressures. The control signal of the damper is a ramp.
The pressure versus mass flow rate relation of the two models
intersect when <code>m_flow = m_flow_nominal = 1</code> kg/s.
</p>
</html>", revisions="<html>
<ul>
<li>
October 12, 2016 by David Blum:<br/>
Added damper <code>resLinear</code> with <code>linearized=true</code>.
</li>
<li>
July 20, 2007 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Damper;
