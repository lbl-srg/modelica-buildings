within Buildings.Fluid.Actuators.Valves.Examples;
model TwoWayValvesTable "Two way valve with linear opening characteristics"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Medium";

    Modelica.Blocks.Sources.Ramp y(
    height=1,
    duration=1,
    offset=0) "Control signal"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    nPorts=2,
    use_p_in=false,
    p(displayUnit="Pa") = 306000,
    T=293.15) "Boundary condition for flow source"
    annotation (Placement(
        transformation(extent={{-80,8},{-60,28}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=2,
    p(displayUnit="Pa") = 3E5,
    T=293.15) "Boundary condition for flow sink"
    annotation (Placement(
        transformation(extent={{60,8},{40,28}})));
  Valves.TwoWayTable valTab(
    redeclare package Medium = Medium,
    m_flow_nominal=2,
    use_strokeTime=false,
    dpValve_nominal=6000,
    flowCharacteristics=Buildings.Fluid.Actuators.Valves.Data.Linear(),
    from_dp=true) "Valve model with opening characteristics based on a table"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  TwoWayLinear valLin(
    use_strokeTime=false,
    redeclare package Medium = Medium,
    l=0.0001,
    m_flow_nominal=2,
    dpValve_nominal=6000,
    from_dp=true) "Valve model with linear opening characteristics"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));

equation
  connect(y.y,valTab. y) annotation (Line(
      points={{-39,50},{-39,50},{0,50},{0,50},{0,32}},
      color={0,0,127}));
  connect(valTab.port_a, sou.ports[1]) annotation (Line(
      points={{-10,20},{-60,20}},
      color={0,127,255}));
  connect(valTab.port_b, sin.ports[1]) annotation (Line(
      points={{10,20},{40,20}},
      color={0,127,255}));
  connect(valLin.y, y.y) annotation (Line(
      points={{8.88178e-16,-8},{8.88178e-16,-2},{-28,-2},{-28,50},{-39,50}},
      color={0,0,127}));
  connect(sou.ports[2], valLin.port_a) annotation (Line(
      points={{-60,16},{-34,16},{-34,-20},{-10,-20}},
      color={0,127,255}));
  connect(valLin.port_b, sin.ports[2]) annotation (Line(
      points={{10,-20},{28,-20},{28,16},{40,16}},
      color={0,127,255}));
    annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Actuators/Valves/Examples/TwoWayValvesTable.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Test model for two way valves.
The instance <code>valTab</code> has a linear opening characteristics
based on a table, while <code>valLin</code> also has a linear opening
characteristics that is directly implemented in the model.
For practical applications in which valves with linear opening characteristics
are used, one should use <code>valLin</code> rather
than <code>valTab</code> as <code>valLin</code> is a more efficient
implementation.
</p>
<p>
This test demonstrates that both valves have, as expected, the same
mass flow rate for the whole range of the opening signal.
</p>
<p>
The parameter <code>filterOpening</code> is set to <code>false</code>,
as this model is used to plot the flow at different opening signals
without taking into account the travel time of the actuator.
</p>
</html>", revisions="<html>
<ul>
<li>
March 26, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end TwoWayValvesTable;
