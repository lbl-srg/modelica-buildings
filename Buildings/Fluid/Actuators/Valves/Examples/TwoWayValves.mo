within Buildings.Fluid.Actuators.Valves.Examples;
model TwoWayValves "Two way valves with different opening characteristics"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;

  Buildings.Fluid.Actuators.Valves.TwoWayLinear valLin(
    redeclare package Medium = Medium,
    l=0.05,
    m_flow_nominal=2,
    use_inputFilter=false,
    dpValve_nominal=6000) "Valve model, linear opening characteristics"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
    Modelica.Blocks.Sources.Ramp y(
    height=1,
    duration=1,
    offset=0) "Control signal"
                 annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    nPorts=5,
    use_p_in=false,
    p(displayUnit="Pa") = 306000,
    T=293.15) "Boundary condition for flow source"  annotation (Placement(
        transformation(extent={{-70,-10},{-50,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=5,
    p(displayUnit="Pa") = 3E5,
    T=293.15) "Boundary condition for flow sink"    annotation (Placement(
        transformation(extent={{72,-10},{52,10}})));
  Buildings.Fluid.Actuators.Valves.TwoWayQuickOpening valQui(
    redeclare package Medium = Medium,
    l=0.05,
    m_flow_nominal=2,
    use_inputFilter=false,
    dpValve_nominal=6000) "Valve model, quick opening characteristics"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valEqu(
    redeclare package Medium = Medium,
    l=0.05,
    R=10,
    delta0=0.1,
    m_flow_nominal=2,
    use_inputFilter=false,
    dpValve_nominal=6000)
    "Valve model, equal percentage opening characteristics"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  TwoWayPressureIndependent valInd(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    dpValve_nominal=10000,
    use_inputFilter=false,
    l=0.05,
    l2=0.01) annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  TwoWayPolynomial valPol(
    c={0,0.5304,-0.7698,1.2278},
    l=0.05,
    m_flow_nominal=1,
    dpValve_nominal=10000,
    use_inputFilter=false,
    redeclare package Medium = Medium,
    CvData=Buildings.Fluid.Types.CvTypes.OpPoint)
    "Valve with polynomial opening characteristic"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
equation
  connect(y.y, valLin.y) annotation (Line(
      points={{-39,100},{10,100},{10,92}},
      color={0,0,127}));
  connect(y.y, valQui.y) annotation (Line(
      points={{-39,100},{-12,100},{-12,60},{10,60},{10,52}},
      color={0,0,127}));
  connect(y.y, valEqu.y) annotation (Line(
      points={{-39,100},{-12,100},{-12,20},{10,20},{10,12}},
      color={0,0,127}));
  connect(sou.ports[1], valLin.port_a) annotation (Line(
      points={{-50,3.2},{-27,3.2},{-27,80},{0,80}},
      color={0,127,255}));
  connect(valQui.port_a, sou.ports[2]) annotation (Line(
      points={{0,40},{-26,40},{-26,1.6},{-50,1.6}},
      color={0,127,255}));
  connect(valEqu.port_a, sou.ports[3]) annotation (Line(
      points={{0,0},{-50,0}},
      color={0,127,255}));
  connect(valLin.port_b, sin.ports[1]) annotation (Line(
      points={{20,80},{37,80},{37,3.2},{52,3.2}},
      color={0,127,255}));
  connect(valQui.port_b, sin.ports[2]) annotation (Line(
      points={{20,40},{36,40},{36,1.6},{52,1.6}},
      color={0,127,255}));
  connect(valEqu.port_b, sin.ports[3]) annotation (Line(
      points={{20,0},{52,0}},
      color={0,127,255}));
  connect(valInd.y, y.y) annotation (Line(
      points={{10,-28},{10,-20},{-12,-20},{-12,100},{-39,100}},
      color={0,0,127}));
  connect(valInd.port_b, sin.ports[4]) annotation (Line(
      points={{20,-40},{36,-40},{36,-1.6},{52,-1.6}},
      color={0,127,255}));
  connect(valInd.port_a, sou.ports[4]) annotation (Line(
      points={{0,-40},{-26,-40},{-26,-1.6},{-50,-1.6}},
      color={0,127,255}));
  connect(valPol.port_b, sin.ports[5]) annotation (Line(points={{20,-80},{38,
          -80},{38,-3.2},{52,-3.2}}, color={0,127,255}));
  connect(valPol.port_a, sou.ports[5]) annotation (Line(points={{0,-80},{-28,
          -80},{-28,-3.2},{-50,-3.2}}, color={0,127,255}));
  connect(valPol.y, y.y) annotation (Line(points={{10,-68},{10,-60},{-12,-60},{-12,
          100},{-39,100}},   color={0,0,127}));
    annotation (experiment(Tolerance=1e-6, StopTime=1.0),
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
</html>"),
    Diagram(coordinateSystem(extent={{-100,-100},{100,120}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,120}})));
end TwoWayValves;
