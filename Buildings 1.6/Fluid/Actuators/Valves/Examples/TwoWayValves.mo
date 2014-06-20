within Buildings.Fluid.Actuators.Valves.Examples;
model TwoWayValves "Two way valves with different opening characteristics"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.ConstantPropertyLiquidWater;

  Buildings.Fluid.Actuators.Valves.TwoWayLinear valLin(
    redeclare package Medium = Medium,
    l=0.05,
    m_flow_nominal=2,
    filteredOpening=false,
    dpValve_nominal=6000) "Valve model, linear opening characteristics"
         annotation (Placement(transformation(extent={{0,20},{20,40}}, rotation=
           0)));
    Modelica.Blocks.Sources.Ramp y(
    height=1,
    duration=1,
    offset=0) "Control signal"
                 annotation (Placement(transformation(extent={{-60,60},{-40,80}},
          rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sou(             redeclare package Medium
      = Medium,
    nPorts=3,
    use_p_in=false,
    p(displayUnit="Pa") = 306000,
    T=293.15)                                       annotation (Placement(
        transformation(extent={{-70,-20},{-50,0}}, rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sin(             redeclare package Medium
      = Medium,
    nPorts=3,
    p(displayUnit="Pa") = 3E5,
    T=293.15)                                       annotation (Placement(
        transformation(extent={{72,-20},{52,0}}, rotation=0)));
  Buildings.Fluid.Actuators.Valves.TwoWayQuickOpening valQui(
    redeclare package Medium = Medium,
    l=0.05,
    m_flow_nominal=2,
    filteredOpening=false,
    dpValve_nominal=6000) "Valve model, quick opening characteristics"
         annotation (Placement(transformation(extent={{0,-20},{20,0}}, rotation=
           0)));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valEqu(
    redeclare package Medium = Medium,
    l=0.05,
    R=10,
    delta0=0.1,
    m_flow_nominal=2,
    filteredOpening=false,
    dpValve_nominal=6000)
    "Valve model, equal percentage opening characteristics"
         annotation (Placement(transformation(extent={{0,-60},{20,-40}},
          rotation=0)));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
equation
  connect(y.y, valLin.y) annotation (Line(
      points={{-39,70},{-12,70},{-12,50},{10,50},{10,42}},
      color={0,0,127},
      pattern=LinePattern.None));
  connect(y.y, valQui.y) annotation (Line(
      points={{-39,70},{-12,70},{-12,8},{10,8},{10,2}},
      color={0,0,127},
      pattern=LinePattern.None));
  connect(y.y, valEqu.y) annotation (Line(
      points={{-39,70},{-12,70},{-12,-30},{10,-30},{10,-38}},
      color={0,0,127},
      pattern=LinePattern.None));
  connect(sou.ports[1], valLin.port_a) annotation (Line(
      points={{-50,-7.33333},{-27,-7.33333},{-27,30},{-5.55112e-16,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valQui.port_a, sou.ports[2]) annotation (Line(
      points={{-5.55112e-16,-10},{-50,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valEqu.port_a, sou.ports[3]) annotation (Line(
      points={{-5.55112e-16,-50},{-26,-50},{-26,-12.6667},{-50,-12.6667}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valLin.port_b, sin.ports[1]) annotation (Line(
      points={{20,30},{37,30},{37,-7.33333},{52,-7.33333}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valQui.port_b, sin.ports[2]) annotation (Line(
      points={{20,-10},{52,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valEqu.port_b, sin.ports[3]) annotation (Line(
      points={{20,-50},{36,-50},{36,-12.6667},{52,-12.6667}},
      color={0,127,255},
      smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                        graphics),
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Actuators/Valves/Examples/TwoWayValves.mos"
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
February 28, 2013, by Michael Wetter:<br/>
Added default value for <code>dpValve_nominal</code>.
</li>
<li>
June 16, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end TwoWayValves;
