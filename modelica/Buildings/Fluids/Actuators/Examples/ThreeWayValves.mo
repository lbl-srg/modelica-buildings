within Buildings.Fluids.Actuators.Examples;
model ThreeWayValves

    annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                        graphics),
                         Commands(file=
            "ThreeWayValves.mos" "run"),
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
June 16, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

 package Medium = Buildings.Media.ConstantPropertyLiquidWater
    "Medium in the component";

  Buildings.Fluids.Actuators.Valves.ThreeWayLinear valLin(
    redeclare package Medium = Medium,
    l={0.05,0.05},
    m_flow_nominal=2) "Valve model, linear opening characteristics" 
         annotation (Placement(transformation(extent={{0,-26},{20,-6}},
          rotation=0)));
    Modelica.Blocks.Sources.Ramp y(
    height=1,
    duration=1,
    offset=0) "Control signal" 
                 annotation (Placement(transformation(extent={{-40,0},{-20,20}},
          rotation=0)));
  Modelica_Fluid.Sources.Boundary_pT sou(             redeclare package Medium
      = Medium,
    nPorts=2,
    use_p_in=true,
    T=313.15)                                       annotation (Placement(
        transformation(extent={{-50,-28},{-30,-8}}, rotation=0)));
  Modelica_Fluid.Sources.Boundary_pT sin(             redeclare package Medium
      = Medium,
    nPorts=2,
    use_p_in=true,
    T=313.15)                                       annotation (Placement(
        transformation(extent={{70,-28},{50,-8}}, rotation=0)));
    Modelica.Blocks.Sources.Constant PSin(k=3E5) 
      annotation (Placement(transformation(extent={{60,60},{80,80}}, rotation=0)));
    Modelica.Blocks.Sources.Constant PSou(k=306000) 
      annotation (Placement(transformation(extent={{-88,-20},{-68,0}},
          rotation=0)));
  Actuators.Valves.ThreeWayEqualPercentageLinear valEquPerLin(
    l={0.05,0.05},
    redeclare package Medium = Medium,
    R=10,
    m_flow_nominal=2) 
    annotation (Placement(transformation(extent={{0,-60},{20,-40}}, rotation=0)));
  Modelica_Fluid.Sources.Boundary_pT ret(
    redeclare package Medium = Medium,
    nPorts=2,
    use_p_in=true,
    T=303.15)                                       annotation (Placement(
        transformation(extent={{10,-10},{-10,10}},  rotation=0,
        origin={64,-70})));
  inner Modelica_Fluid.System system 
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
equation
  connect(y.y, valLin.y) annotation (Line(
      points={{-19,10},{10,10},{10,-8}},
      color={0,0,127},
      pattern=LinePattern.None));
  connect(PSin.y, sin.p_in) annotation (Line(points={{81,70},{86,70},{86,-10},{
          72,-10}}, color={0,0,127}));
  connect(y.y, valEquPerLin.y) annotation (Line(points={{-19,10},{-12,10},{-12,
          -38},{10,-38},{10,-42}},
                          color={0,0,127}));
  connect(sou.ports[1], valLin.port_1) annotation (Line(
      points={{-30,-16},{0,-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[2], valEquPerLin.port_1) annotation (Line(
      points={{-30,-20},{-24,-20},{-24,-50},{0,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valLin.port_2, sin.ports[1]) annotation (Line(
      points={{20,-16},{50,-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valEquPerLin.port_2, sin.ports[2]) annotation (Line(
      points={{20,-50},{37,-50},{37,-20},{50,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(PSou.y, ret.p_in) annotation (Line(
      points={{-67,-10},{-60,-10},{-60,-88},{90,-88},{90,-62},{76,-62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ret.ports[1], valLin.port_3) annotation (Line(
      points={{54,-68},{44,-68},{44,-34},{10,-34},{10,-26}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ret.ports[2], valEquPerLin.port_3) annotation (Line(
      points={{54,-72},{10,-72},{10,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(PSou.y, sou.p_in) annotation (Line(
      points={{-67,-10},{-52,-10}},
      color={0,0,127},
      smooth=Smooth.None));
end ThreeWayValves;
