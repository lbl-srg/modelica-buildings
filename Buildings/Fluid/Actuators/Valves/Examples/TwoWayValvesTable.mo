within Buildings.Fluid.Actuators.Valves.Examples;
model TwoWayValvesTable
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.ConstantPropertyLiquidWater;

    Modelica.Blocks.Sources.Ramp y(
    height=1,
    duration=1,
    offset=0) "Control signal"
                 annotation (Placement(transformation(extent={{-60,60},{-40,80}},
          rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    nPorts=1,
    use_p_in=false,
    p(displayUnit="Pa") = 306000,
    T=293.15)                                       annotation (Placement(
        transformation(extent={{-70,-20},{-50,0}}, rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=1,
    p(displayUnit="Pa") = 3E5,
    T=293.15)                                       annotation (Placement(
        transformation(extent={{72,-20},{52,0}}, rotation=0)));
  Valves.TwoWayTable valTab(
    redeclare package Medium = Medium,
    m_flow_nominal=2,
    filteredOpening=false,
    dpValve_nominal=6000,
    flowCharacteristics=Buildings.Fluid.Actuators.Valves.Data.Linear())
    "Valve model with opening characteristics based on a table"
         annotation (Placement(transformation(extent={{-2,-20},{18,0}},
          rotation=0)));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
equation
  connect(y.y,valTab. y) annotation (Line(
      points={{-39,70},{-12,70},{8,70},{8,2}},
      color={0,0,127},
      pattern=LinePattern.None));
  connect(valTab.port_a, sou.ports[1]) annotation (Line(
      points={{-2,-10},{-50,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valTab.port_b, sin.ports[1]) annotation (Line(
      points={{18,-10},{52,-10}},
      color={0,127,255},
      smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                        graphics),
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Actuators/Valves/Examples/TwoWayValvesTable.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Test model for two way valves. Note that the 
leakage flow rate has been set to a large value
and the rangeability to a small value
for better visualization of the valve characteristics.
To use common values, use the default values.
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
