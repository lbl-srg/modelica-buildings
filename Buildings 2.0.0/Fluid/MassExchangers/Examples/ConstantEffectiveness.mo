within Buildings.Fluid.MassExchangers.Examples;
model ConstantEffectiveness
  extends Modelica.Icons.Example;

 package Medium1 = Buildings.Media.Air;
 package Medium2 = Buildings.Media.Air;

  Buildings.Fluid.Sources.Boundary_pT sin_2(
    redeclare package Medium = Medium2, T=273.15 + 10,
    use_p_in=true,
    nPorts=1)             annotation (Placement(transformation(extent={{-58,-10},
            {-38,10}})));
    Modelica.Blocks.Sources.Ramp PIn(
    height=200,
    duration=60,
    offset=101330)
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
                 annotation (Placement(transformation(extent={{-100,44},{-80,64}})));
  Modelica.Blocks.Sources.Constant TDb(k=293.15) "Drybulb temperature"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
    Modelica.Blocks.Sources.Constant POut(k=101325)
      annotation (Placement(transformation(extent={{-100,-2},{-80,18}})));
  Buildings.Fluid.Sources.Boundary_pT sin_1(
    redeclare package Medium = Medium1,
    T=273.15 + 30,
    X={0.012,1 - 0.012},
    use_p_in=true,
    p=300000,
    nPorts=1)             annotation (Placement(transformation(extent={{84,2},{
            64,22}})));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium1,
    T=273.15 + 50,
    X={0.012,1 - 0.012},
    use_T_in=true,
    p=100000,
    nPorts=1)             annotation (Placement(transformation(extent={{-60,40},
            {-40,60}})));
    Modelica.Blocks.Sources.Ramp PSin_1(
    duration=60,
    startTime=240,
    height=100,
    offset=1E5 - 110)
                 annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Buildings.Fluid.MassExchangers.ConstantEffectiveness hex(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    m1_flow(start=5),
    m2_flow(start=5),
    m1_flow_nominal=5,
    m2_flow_nominal=5,
    dp1_nominal=100,
    dp2_nominal=100,
    show_T=true)
    annotation (Placement(transformation(extent={{6,-4},{26,16}})));

equation
  connect(PIn.y,sou_2. p_in) annotation (Line(
      points={{1,-40},{20,-40},{20,-52},{38,-52}},
      color={0,0,127}));
  connect(TDb.y, sou_2.T_in) annotation (Line(points={{1,-80},{20,-80},{20,-56},
          {38,-56}}, color={0,0,127}));
  connect(TWat.y, sou_1.T_in)
    annotation (Line(points={{-79,54},{-70.5,54},{-62,54}},
                                                 color={0,0,127}));
  connect(PSin_1.y, sin_1.p_in) annotation (Line(points={{61,70},{90,70},{90,20},
          {86,20}},     color={0,0,127}));
  connect(sou_1.ports[1], hex.port_a1) annotation (Line(
      points={{-40,50},{0,50},{0,12},{6,12}},
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
  connect(hex.port_b2, sin_2.ports[1]) annotation (Line(
      points={{6,5.55112e-16},{-18,5.55112e-16},{-18,6.66134e-16},{-38,
          6.66134e-16}},
      color={0,127,255},
      smooth=Smooth.None));
 annotation(experiment(StopTime=360),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/MassExchangers/Examples/ConstantEffectiveness.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
<b>Note:</b> This problem fails to translate in Dymola 2012 due to an error in Dymola's support
of stream connector. This bug will be corrected in future versions of Dymola.
</p>
</html>"));
end ConstantEffectiveness;
