within Buildings.Fluids.HeatExchangers.Examples;
model HexElement
  import Buildings;
  annotation(Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                     graphics),
                      Commands(file="HexElement.mos" "run"),
    experimentSetupOutput);
 package Medium_W = Buildings.Media.ConstantPropertyLiquidWater;
// package Medium_W = Modelica.Media.Air.SimpleAir;
// package Medium_A = Buildings.Media.GasesPTDecoupled.SimpleAir;
// package Medium_A = Modelica.Media.Air.SimpleAir;
// package Medium_A = Modelica.Media.Air.SimpleAir;
// package Medium_A = Buildings.Media.PerfectGases.MoistAirNonsaturated;
 package Medium_A = Buildings.Media.PerfectGases.MoistAir;
  Modelica_Fluid.Sources.Boundary_pT sin_2(
                                         redeclare package Medium = Medium_A,
    use_p_in=true,
    use_T_in=true,
    T=288.15,
    nPorts=1)             annotation (Placement(transformation(extent={{-60,-30},
            {-40,-10}}, rotation=0)));
    Modelica.Blocks.Sources.Ramp PIn(
    height=20,
    offset=101320,
    duration=300,
    startTime=300) 
                 annotation (Placement(transformation(extent={{0,-60},{20,-40}},
          rotation=0)));
  annotation (Diagram);
  Modelica_Fluid.Sources.Boundary_pT sou_2(                       redeclare
      package Medium = Medium_A,
    use_p_in=true,
    use_T_in=true,
    T=283.15,
    nPorts=1)             annotation (Placement(transformation(extent={{40,-80},
            {60,-60}}, rotation=0)));
    Modelica.Blocks.Sources.Ramp TWat(
    startTime=1,
    height=4,
    duration=300,
    offset=303.15) "Water temperature" 
                 annotation (Placement(transformation(extent={{0,-92},{20,-72}},
          rotation=0)));
  Modelica.Blocks.Sources.Constant TDb(k=278.15) "Drybulb temperature" 
    annotation (Placement(transformation(extent={{-100,40},{-80,60}}, rotation=
            0)));
    Modelica.Blocks.Sources.Constant POut(k=101325) 
      annotation (Placement(transformation(extent={{-100,80},{-80,100}},
          rotation=0)));
  Modelica_Fluid.Sources.Boundary_pT sin_1(
                                         redeclare package Medium = Medium_W,
    use_p_in=true,
    T=288.15,
    nPorts=1)             annotation (Placement(transformation(extent={{42,40},
            {62,60}}, rotation=0)));
  Modelica_Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium_W,
    use_T_in=true,
    p=101335,
    T=293.15,
    nPorts=1)             annotation (Placement(transformation(extent={{-60,40},
            {-40,60}}, rotation=0)));
    Fluids.FixedResistances.FixedResistanceDpM res_22(
    from_dp=true,
    m0_flow=5,
    dp0=5,
    redeclare package Medium = Medium_A) 
             annotation (Placement(transformation(extent={{-4,-30},{-24,-10}},
          rotation=0)));
    Fluids.FixedResistances.FixedResistanceDpM res_12(
    from_dp=true,
    m0_flow=5,
    dp0=5,
    redeclare package Medium = Medium_W) 
             annotation (Placement(transformation(extent={{48,10},{68,30}},
          rotation=0)));
  Buildings.Fluids.HeatExchangers.BaseClasses.HexElement hex(
    m0_flow_1=5,
    m0_flow_2=5,
    UA0=9999,
    redeclare package Medium_1 = Medium_W,
    redeclare package Medium_2 = Medium_A,
    allowCondensation=false) 
                    annotation (Placement(transformation(extent={{10,-10},{30,
            10}}, rotation=0)));
  Modelica.Blocks.Sources.Constant TDb1(k=303.15) "Drybulb temperature" 
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}},
          rotation=0)));
    Fluids.FixedResistances.FixedResistanceDpM res_11(
    from_dp=true,
    m0_flow=5,
    dp0=5,
    redeclare package Medium = Medium_W) 
             annotation (Placement(transformation(extent={{-24,10},{-4,30}},
          rotation=0)));
    Fluids.FixedResistances.FixedResistanceDpM res_21(
    from_dp=true,
    m0_flow=5,
    dp0=5,
    redeclare package Medium = Medium_A) 
             annotation (Placement(transformation(extent={{70,-30},{50,-10}},
          rotation=0)));
  Modelica.Blocks.Sources.Constant hACon(k=10000) "Convective heat transfer" 
    annotation (Placement(transformation(extent={{-20,60},{0,80}}, rotation=0)));
  inner Modelica_Fluid.System system 
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
equation
  connect(TDb.y, sou_1.T_in) annotation (Line(
      points={{-79,50},{-70.5,50},{-70.5,54},{-62,54}},
      color={0,0,127},
      pattern=LinePattern.None));
  connect(POut.y, sin_1.p_in) annotation (Line(
      points={{-79,90},{30,90},{30,58},{40,58}},
      color={0,0,127},
      pattern=LinePattern.None));
  connect(PIn.y, sou_2.p_in) annotation (Line(
      points={{21,-50},{30,-50},{30,-62},{38,-62}},
      color={0,0,127},
      pattern=LinePattern.None));
  connect(TWat.y, sou_2.T_in) annotation (Line(
      points={{21,-82},{30,-82},{30,-66},{38,-66}},
      color={0,0,127},
      pattern=LinePattern.None));
  connect(POut.y, sin_2.p_in) annotation (Line(
      points={{-79,90},{-70,90},{-70,-12},{-62,-12}},
      color={0,0,127},
      pattern=LinePattern.None));
  connect(hex.port_b1, res_12.port_a) 
                                     annotation (Line(points={{30,6},{42,6},{42,
          20},{48,20}}, color={0,127,255}));
  connect(res_22.port_a, hex.port_b2) 
                                     annotation (Line(points={{-4,-20},{2,-20},
          {2,-6},{10,-6}}, color={0,127,255}));
  connect(TDb1.y, sin_2.T_in) annotation (Line(points={{-79,-20},{-70.5,-20},{
          -70.5,-16},{-62,-16}},
        color={0,0,127}));
  connect(res_11.port_b, hex.port_a1) annotation (Line(points={{-4,20},{-2,20},
          {-2,6},{10,6}}, color={0,127,255}));
  connect(hex.port_a2, res_21.port_b) annotation (Line(points={{30,-6},{40,-6},
          {40,-20},{50,-20}}, color={0,127,255}));
  connect(hACon.y, hex.Gc_1) annotation (Line(points={{1,70},{16,70},{16,10}},
        color={0,0,127}));
  connect(hACon.y, hex.Gc_2) annotation (Line(points={{1,70},{8,70},{8,-16},{24,
          -16},{24,-10}}, color={0,0,127}));
  connect(sou_2.ports[1], res_21.port_a) annotation (Line(
      points={{60,-70},{80,-70},{80,-20},{70,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin_1.ports[1], res_12.port_b) annotation (Line(
      points={{62,50},{80,50},{80,20},{68,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou_1.ports[1], res_11.port_a) annotation (Line(
      points={{-40,50},{-34,50},{-34,20},{-24,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin_2.ports[1], res_22.port_b) annotation (Line(
      points={{-40,-20},{-24,-20}},
      color={0,127,255},
      smooth=Smooth.None));
end HexElement;
