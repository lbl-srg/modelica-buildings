within Buildings.Fluid.Actuators.Examples;
model TwoWayValves
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.ConstantPropertyLiquidWater;

  Buildings.Fluid.Actuators.Valves.TwoWayLinear valLin(
    redeclare package Medium = Medium,
    l=0.05,
    m_flow_nominal=2) "Valve model, linear opening characteristics"
         annotation (Placement(transformation(extent={{0,10},{20,30}}, rotation=
           0)));
    Modelica.Blocks.Sources.Ramp y(
    height=1,
    duration=1,
    offset=0) "Control signal"
                 annotation (Placement(transformation(extent={{-60,60},{-40,80}},
          rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sou(             redeclare package Medium
      = Medium,
    use_p_in=true,
    nPorts=3,
    T=293.15)                                       annotation (Placement(
        transformation(extent={{-70,-20},{-50,0}}, rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sin(             redeclare package Medium
      = Medium,
    use_p_in=true,
    nPorts=3,
    T=293.15)                                       annotation (Placement(
        transformation(extent={{72,-20},{52,0}}, rotation=0)));
    Modelica.Blocks.Sources.Constant PSin(k=3E5)
      annotation (Placement(transformation(extent={{60,60},{80,80}}, rotation=0)));
    Modelica.Blocks.Sources.Constant PSou(k=306000)
      annotation (Placement(transformation(extent={{-100,16},{-80,36}},
          rotation=0)));
  Buildings.Fluid.Actuators.Valves.TwoWayQuickOpening valQui(
    redeclare package Medium = Medium,
    l=0.05,
    m_flow_nominal=2) "Valve model, quick opening characteristics"
         annotation (Placement(transformation(extent={{0,-20},{20,0}}, rotation=
           0)));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valEqu(
    redeclare package Medium = Medium,
    l=0.05,
    R=10,
    delta0=0.1,
    m_flow_nominal=2) "Valve model, equal percentage opening characteristics"
         annotation (Placement(transformation(extent={{0,-50},{20,-30}},
          rotation=0)));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
equation
  connect(y.y, valLin.y) annotation (Line(
      points={{-39,70},{-12,70},{-12,32},{10,32},{10,28}},
      color={0,0,127},
      pattern=LinePattern.None));
  connect(PSin.y, sin.p_in) annotation (Line(points={{81,70},{86,70},{86,-2},{
          74,-2}}, color={0,0,127}));
  connect(PSou.y, sou.p_in)
    annotation (Line(points={{-79,26},{-74.5,26},{-74.5,-2},{-72,-2}},
                                                 color={0,0,127}));
  connect(y.y, valQui.y) annotation (Line(
      points={{-39,70},{-12,70},{-12,2},{10,2},{10,-2}},
      color={0,0,127},
      pattern=LinePattern.None));
  connect(y.y, valEqu.y) annotation (Line(
      points={{-39,70},{-12,70},{-12,-28},{10,-28},{10,-32}},
      color={0,0,127},
      pattern=LinePattern.None));
  connect(sou.ports[1], valLin.port_a) annotation (Line(
      points={{-50,-7.33333},{-27,-7.33333},{-27,20},{-5.55112e-16,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valQui.port_a, sou.ports[2]) annotation (Line(
      points={{-5.55112e-16,-10},{-50,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valEqu.port_a, sou.ports[3]) annotation (Line(
      points={{-5.55112e-16,-40},{-26,-40},{-26,-12.6667},{-50,-12.6667}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valLin.port_b, sin.ports[1]) annotation (Line(
      points={{20,20},{37,20},{37,-7.33333},{52,-7.33333}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valQui.port_b, sin.ports[2]) annotation (Line(
      points={{20,-10},{52,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valEqu.port_b, sin.ports[3]) annotation (Line(
      points={{20,-40},{36,-40},{36,-12.6667},{52,-12.6667}},
      color={0,127,255},
      smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                        graphics),
             __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Actuators/Examples/TwoWayValves.mos" "Simulate and plot"),
    Documentation(info="<html>
<p>
Test model for two way valves. Note that the 
leakage flow rate has been set to a large value
and the rangeability to a small value
for better visualization of the valve characteristics.
To use common values, use the default values.
</p>
</html>", revisions="<html>
<ul>
<li>
June 16, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end TwoWayValves;
