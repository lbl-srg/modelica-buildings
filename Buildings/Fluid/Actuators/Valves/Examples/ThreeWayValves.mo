within Buildings.Fluid.Actuators.Valves.Examples;
model ThreeWayValves "Three way valves with different opening characteristics"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium in the component";

  Buildings.Fluid.Actuators.Valves.ThreeWayLinear valLin(
    redeclare package Medium = Medium,
    l={0.05,0.05},
    m_flow_nominal=2,
    filteredOpening=false,
    dpValve_nominal=6000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Valve model, linear opening characteristics"
    annotation (Placement(transformation(extent={{0,-8},{20,12}})));
  Modelica.Blocks.Sources.Ramp y(
    height=1,
    duration=1,
    offset=0) "Control signal"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    nPorts=2,
    use_p_in=true,
    T=313.15) "Boundary condition for flow source"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=2,
    use_p_in=true,
    T=313.15) "Boundary condition for flow sink"
    annotation (Placement(transformation(extent={{70,-10},{50,10}})));
  Modelica.Blocks.Sources.Constant PSin(k=3E5)
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Sources.Constant PSou(k=306000)
    annotation (Placement(transformation(extent={{-88,-2},{-68,18}})));
  Actuators.Valves.ThreeWayEqualPercentageLinear valEquPerLin(
    l={0.05,0.05},
    redeclare package Medium = Medium,
    R=10,
    m_flow_nominal=2,
    filteredOpening=false,
    dpValve_nominal=6000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Buildings.Fluid.Sources.Boundary_pT ret(
    redeclare package Medium = Medium,
    nPorts=2,
    use_p_in=true,
    T=303.15) "Boundary condition for flow sink" annotation (Placement(
        transformation(extent={{10,-10},{-10,10}}, origin={64,-70})));

equation
  connect(y.y, valLin.y) annotation (Line(
      points={{-19,40},{10,40},{10,14}},
      color={0,0,127}));
  connect(PSin.y, sin.p_in)
    annotation (Line(points={{81,70},{86,70},{86,8},{72,8}}, color={0,0,127}));
  connect(y.y, valEquPerLin.y) annotation (Line(points={{-19,40},{-12,40},{-12,-28},
          {10,-28},{10,-38}}, color={0,0,127}));
  connect(sou.ports[1], valLin.port_1) annotation (Line(
      points={{-30,2},{-5.55112e-16,2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[2], valEquPerLin.port_1) annotation (Line(
      points={{-30,-2},{-24,-2},{-24,-50},{-5.55112e-16,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valLin.port_2, sin.ports[1]) annotation (Line(
      points={{20,2},{50,2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valEquPerLin.port_2, sin.ports[2]) annotation (Line(
      points={{20,-50},{37,-50},{37,-2},{50,-2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(PSou.y, ret.p_in) annotation (Line(
      points={{-67,8},{-60,8},{-60,-88},{90,-88},{90,-62},{76,-62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ret.ports[1], valLin.port_3) annotation (Line(
      points={{54,-68},{40,-68},{40,-20},{10,-20},{10,-8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ret.ports[2], valEquPerLin.port_3) annotation (Line(
      points={{54,-72},{10,-72},{10,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(PSou.y, sou.p_in) annotation (Line(
      points={{-67,8},{-52,8}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    experiment(StopTime=1.0),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Actuators/Valves/Examples/ThreeWayValves.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Test model for three way valves. Note that the
leakage flow rate has been set to a large value
and the rangeability to a small value
for better visualization of the valve characteristics.
To use common values, use the default values.
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
end ThreeWayValves;
