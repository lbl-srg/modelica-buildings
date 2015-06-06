within Buildings.Fluid.HeatExchangers.Validation;
model ConstantEffectiveness
  "Model that demonstrates use of a heat exchanger with constant effectiveness"
  extends Modelica.Icons.Example;

 package Medium1 = Buildings.Media.Water;
 package Medium2 = Buildings.Media.Air;
  Buildings.Fluid.Sources.Boundary_pT sin_2(
    redeclare package Medium = Medium2,
    use_p_in=true,
    nPorts=1,
    T=273.15 + 10,
    X={0.001,0.999})      annotation (Placement(transformation(extent={{-58,-10},
            {-38,10}})));
    Modelica.Blocks.Sources.Ramp PIn(
    height=200,
    duration=60,
    offset=101325,
    startTime=50)
                 annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Buildings.Fluid.Sources.Boundary_pT sou_2(
    redeclare package Medium = Medium2, T=273.15 + 5,
    use_p_in=true,
    use_T_in=true,
    nPorts=1)             annotation (Placement(transformation(extent={{40,-70},
            {60,-50}})));
    Modelica.Blocks.Sources.Ramp TWat(
    height=10,
    duration=60,
    offset=273.15 + 30,
    startTime=60) "Water temperature"
                 annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Modelica.Blocks.Sources.Constant TDb(k=293.15) "Drybulb temperature"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
    Modelica.Blocks.Sources.Constant POut(k=101325)
      annotation (Placement(transformation(extent={{-100,-2},{-80,18}})));
  Buildings.Fluid.Sources.Boundary_pT sin_1(
    redeclare package Medium = Medium1,
    use_p_in=true,
    nPorts=1,
    p=300000,
    T=273.15 + 25)        annotation (Placement(transformation(extent={{84,2},{
            64,22}})));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium1,
    p=300000 + 5000,
    T=273.15 + 50,
    use_T_in=true,
    nPorts=1)             annotation (Placement(transformation(extent={{-60,36},
            {-40,56}})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    show_T=true,
    m1_flow_nominal=5,
    m2_flow_nominal=5,
    dp1_nominal=500,
    dp2_nominal=10)
    annotation (Placement(transformation(extent={{6,-4},{26,16}})));

  Modelica.Blocks.Sources.Trapezoid trapezoid(
    amplitude=5000,
    rising=10,
    width=100,
    falling=10,
    period=3600,
    offset=300000)
    annotation (Placement(transformation(extent={{40,62},{60,82}})));
equation
  connect(PIn.y,sou_2. p_in) annotation (Line(
      points={{1,-40},{20,-40},{20,-52},{38,-52}},
      color={0,0,127}));
  connect(TDb.y, sou_2.T_in) annotation (Line(points={{1,-80},{20,-80},{20,-56},
          {38,-56}}, color={0,0,127}));
  connect(TWat.y, sou_1.T_in)
    annotation (Line(points={{-79,50},{-70.5,50},{-62,50}},
                                                 color={0,0,127}));
  connect(sou_1.ports[1], hex.port_a1) annotation (Line(
      points={{-40,46},{0,46},{0,12},{6,12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hex.port_a2, sou_2.ports[1]) annotation (Line(
      points={{26,5.55112e-16},{32,5.55112e-16},{32,-20},{70,-20},{70,-60},{60,
          -60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(POut.y, sin_2.p_in) annotation (Line(
      points={{-79,8},{-69.5,8},{-69.5,8},{-60,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hex.port_b1, sin_1.ports[1]) annotation (Line(
      points={{26,12},{45,12},{45,12},{64,12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin_2.ports[1], hex.port_b2) annotation (Line(
      points={{-38,6.66134e-16},{-27,6.66134e-16},{-27,1.22125e-15},{-16,
          1.22125e-15},{-16,5.55112e-16},{6,5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(trapezoid.y, sin_1.p_in) annotation (Line(
      points={{61,72},{94,72},{94,20},{86,20}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation(experiment(StopTime=360),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Validation/ConstantEffectiveness.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This model tests
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ConstantEffectiveness\">
Buildings.Fluid.HeatExchangers.ConstantEffectiveness</a>
for different inlet conditions.
</p>
</html>", revisions="<html>
<ul>
<li>
April 28, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ConstantEffectiveness;
