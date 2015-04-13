within Buildings.Fluid.Actuators.Valves.Examples;
model TwoWayValves "Two way valves with different opening characteristics"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;

  Buildings.Fluid.Actuators.Valves.TwoWayLinear valLin(
    redeclare package Medium = Medium,
    l=0.05,
    m_flow_nominal=2,
    filteredOpening=false,
    dpValve_nominal=6000) "Valve model, linear opening characteristics"
         annotation (Placement(transformation(extent={{0,50},{20,70}})));
    Modelica.Blocks.Sources.Ramp y(
    height=1,
    duration=1,
    offset=0) "Control signal"
                 annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Fluid.Sources.Boundary_pT sou(             redeclare package Medium
      = Medium,
    nPorts=4,
    use_p_in=false,
    p(displayUnit="Pa") = 306000,
    T=293.15) "Boundary condition for flow source"  annotation (Placement(
        transformation(extent={{-70,-10},{-50,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(             redeclare package Medium
      = Medium,
    nPorts=4,
    p(displayUnit="Pa") = 3E5,
    T=293.15) "Boundary condition for flow sink"    annotation (Placement(
        transformation(extent={{72,-10},{52,10}})));
  Buildings.Fluid.Actuators.Valves.TwoWayQuickOpening valQui(
    redeclare package Medium = Medium,
    l=0.05,
    m_flow_nominal=2,
    filteredOpening=false,
    dpValve_nominal=6000) "Valve model, quick opening characteristics"
         annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valEqu(
    redeclare package Medium = Medium,
    l=0.05,
    R=10,
    delta0=0.1,
    m_flow_nominal=2,
    filteredOpening=false,
    dpValve_nominal=6000)
    "Valve model, equal percentage opening characteristics"
         annotation (Placement(transformation(extent={{0,-30},{20,-10}})));

  TwoWayPressureIndependent valInd(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    dpValve_nominal=10000,
    filteredOpening=false,
    l=0.05,
    l2=0.01) annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
equation
  connect(y.y, valLin.y) annotation (Line(
      points={{-39,80},{-12,80},{10,80},{10,72}},
      color={0,0,127}));
  connect(y.y, valQui.y) annotation (Line(
      points={{-39,80},{-12,80},{-12,40},{10,40},{10,32}},
      color={0,0,127}));
  connect(y.y, valEqu.y) annotation (Line(
      points={{-39,80},{-12,80},{-12,0},{10,0},{10,-8}},
      color={0,0,127}));
  connect(sou.ports[1], valLin.port_a) annotation (Line(
      points={{-50,3},{-27,3},{-27,60},{0,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valQui.port_a, sou.ports[2]) annotation (Line(
      points={{0,20},{-26,20},{-26,1},{-50,1}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valEqu.port_a, sou.ports[3]) annotation (Line(
      points={{0,-20},{-26,-20},{-26,-1},{-50,-1}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valLin.port_b, sin.ports[1]) annotation (Line(
      points={{20,60},{37,60},{37,3},{52,3}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valQui.port_b, sin.ports[2]) annotation (Line(
      points={{20,20},{36,20},{36,1},{52,1}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valEqu.port_b, sin.ports[3]) annotation (Line(
      points={{20,-20},{36,-20},{36,-1},{52,-1}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valInd.y, y.y) annotation (Line(
      points={{10,-48},{10,-40},{-12,-40},{-12,80},{-39,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(valInd.port_b, sin.ports[4]) annotation (Line(
      points={{20,-60},{38,-60},{38,-3},{52,-3}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valInd.port_a, sou.ports[4]) annotation (Line(
      points={{0,-60},{-28,-60},{-28,-3},{-50,-3}},
      color={0,127,255},
      smooth=Smooth.None));
    annotation (experiment(StopTime=1.0),
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
January 29, 2015, by Filip Jorissen:<br/>
Added pressure-independent valve.
</li>
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
