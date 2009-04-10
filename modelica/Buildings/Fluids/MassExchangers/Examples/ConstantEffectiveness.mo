within Buildings.Fluids.MassExchangers.Examples;
model ConstantEffectiveness
  import Buildings;

 annotation(Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                    graphics),
                     Commands(file="ConstantEffectiveness.mos" "run"));
 package Medium1 = Modelica.Media.Air.MoistAir;
 package Medium2 = Buildings.Media.PerfectGases.MoistAir;

  Modelica_Fluid.Sources.Boundary_pT sin_2(                       redeclare
      package Medium = Medium2, T=273.15 + 10,
    use_p_in=true,
    nPorts=1)             annotation (Placement(transformation(extent={{-58,-10},
            {-38,10}}, rotation=0)));
    Modelica.Blocks.Sources.Ramp PIn(
    height=200,
    duration=60,
    offset=101330) 
                 annotation (Placement(transformation(extent={{-20,-50},{0,-30}},
          rotation=0)));
  Modelica_Fluid.Sources.Boundary_pT sou_2(                       redeclare
      package Medium = Medium2, T=273.15 + 5,
    use_p_in=true,
    use_T_in=true,
    nPorts=1)             annotation (Placement(transformation(extent={{40,-70},
            {60,-50}}, rotation=0)));
    Modelica.Blocks.Sources.Ramp TWat(
    height=10,
    duration=60,
    offset=273.15 + 30,
    startTime=60) "Water temperature" 
                 annotation (Placement(transformation(extent={{-100,44},{-80,64}},
          rotation=0)));
  Modelica.Blocks.Sources.Constant TDb(k=293.15) "Drybulb temperature" 
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}}, rotation=0)));
    Modelica.Blocks.Sources.Constant POut(k=101325) 
      annotation (Placement(transformation(extent={{-100,-2},{-80,18}},
          rotation=0)));
  Modelica_Fluid.Sources.Boundary_pT sin_1(                       redeclare
      package Medium = Medium1,
    T=273.15 + 30,
    X={0.012,1 - 0.012},
    use_p_in=true,
    p=300000,
    nPorts=1)             annotation (Placement(transformation(extent={{84,2},{
            64,22}}, rotation=0)));
  Modelica_Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium1,
    T=273.15 + 50,
    X={0.012,1 - 0.012},
    use_T_in=true,
    p=100000,
    nPorts=1)             annotation (Placement(transformation(extent={{-60,40},
            {-40,60}}, rotation=0)));
    Fluids.FixedResistances.FixedResistanceDpM res_2(
    from_dp=true,
    m_flow_nominal=5,
    dp_nominal=10,
    redeclare package Medium = Medium2) 
             annotation (Placement(transformation(extent={{-2,-10},{-22,10}},
          rotation=0)));
    Fluids.FixedResistances.FixedResistanceDpM res_1(
    from_dp=true,
    m_flow_nominal=5,
    redeclare package Medium = Medium1,
    dp_nominal=100) annotation (Placement(transformation(extent={{34,2},{54,22}},
          rotation=0)));
    Modelica.Blocks.Sources.Ramp PSin_1(
    duration=60,
    startTime=240,
    height=100,
    offset=1E5 - 110) 
                 annotation (Placement(transformation(extent={{40,60},{60,80}},
          rotation=0)));
  Buildings.Fluids.MassExchangers.ConstantEffectiveness hex(redeclare package
      Medium1 = 
        Medium1, redeclare package Medium2 = Medium2,
    m1_flow(start=5),
    m2_flow(start=5),
    m1_flow_nominal=5) 
    annotation (Placement(transformation(extent={{6,-4},{26,16}}, rotation=0)));
  inner Modelica_Fluid.System system 
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
equation
  connect(PIn.y,sou_2. p_in) annotation (Line(
      points={{1,-40},{20,-40},{20,-52},{38,-52}},
      color={0,0,127},
      pattern=LinePattern.None));
  connect(TDb.y, sou_2.T_in) annotation (Line(points={{1,-80},{20,-80},{20,-56},
          {38,-56}}, color={0,0,127}));
  connect(TWat.y, sou_1.T_in) 
    annotation (Line(points={{-79,54},{-70.5,54},{-62,54}},
                                                 color={0,0,127}));
  connect(PSin_1.y, sin_1.p_in) annotation (Line(points={{61,70},{90,70},{90,20},
          {86,20}},     color={0,0,127}));
  connect(res_2.port_a, hex.port_b2) annotation (Line(points={{-2,0},{3,0},{6,0}},
                                                               color={0,127,255}));
  connect(hex.port_b1, res_1.port_a) annotation (Line(points={{26,12},{30,12},{
          34,12}},         color={0,127,255}));
  connect(sou_1.ports[1], hex.port_a1) annotation (Line(
      points={{-40,50},{0,50},{0,12},{6,12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin_2.ports[1], res_2.port_b) annotation (Line(
      points={{-38,0},{-22,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res_1.port_b, sin_1.ports[1]) annotation (Line(
      points={{54,12},{64,12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hex.port_a2, sou_2.ports[1]) annotation (Line(
      points={{26,0},{32,0},{32,-20},{70,-20},{70,-60},{60,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(POut.y, sin_2.p_in) annotation (Line(
      points={{-79,8},{-60,8}},
      color={0,0,127},
      smooth=Smooth.None));
end ConstantEffectiveness;
