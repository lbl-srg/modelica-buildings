model CoolingTowerVariableSpeed 
  import Buildings;
  annotation(Diagram, Commands(file="CoolingTowerVariableSpeed.mos" "run"));
 package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sin_2(T=293.15, redeclare 
      package Medium = Medium) 
                          annotation (extent=[-60,-30; -40,-10]);
    Modelica.Blocks.Sources.Ramp PIn(
    duration=1,
    height=20,
    offset=101325) 
                 annotation (extent=[0,-60; 20,-40]);
  annotation (Diagram);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sou_2(T=283.15, redeclare 
      package Medium = Medium) 
                          annotation (extent=[40,-80; 60,-60],
                                                             rotation=0);
    Modelica.Blocks.Sources.Ramp TWat(
    duration=1,
    height=10,
    offset=283.15,
    startTime=1) "Water temperature" 
                 annotation (extent=[0,-92; 20,-72]);
  Modelica.Blocks.Sources.Constant TDb(k=293.15) "Drybulb temperature" 
    annotation (extent=[-100,40; -80,60]);
  Buildings.HeatExchangers.CoolingTowerVariableSpeed tow(redeclare package 
      Medium_1 = Medium, redeclare package Medium_2 = Medium) "Cooling tower" 
    annotation (extent=[20,-14; 40,6]);
    Modelica.Blocks.Sources.Constant POut(k=101325) 
      annotation (extent=[-100,80; -80,100]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sin_1(T=283.15, redeclare 
      package Medium = Medium) 
                          annotation (extent=[42,40; 62,60], rotation=0);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sou_1(
    T=293.15,
    redeclare package Medium = Medium,
    p=101335)             annotation (extent=[-60,40; -40,60]);
    Fluids.FixedResistances.FixedResistanceDpM res_2(
    from_dp=true,
    m0_flow=5,
    dp0=10,
    redeclare package Medium = Medium) 
             annotation (extent=[0,-30; -20,-10], rotation=0);
    Fluids.FixedResistances.FixedResistanceDpM res_1(
    from_dp=true,
    m0_flow=5,
    dp0=10,
    redeclare package Medium = Medium) 
             annotation (extent=[60,10; 80,30]);
equation 
  connect(tow.port_a2, sou_2.port) annotation (points=[40,-10; 68,-10; 68,-70;
        60,-70], style(
      color=69,
      rgbcolor={0,127,255},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(TDb.y, sou_1.T_in) annotation (points=[-79,50; -62,50], style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(POut.y, sin_1.p_in) annotation (points=[-79,90; 30,90; 30,56; 40,56],
      style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(PIn.y, sou_2.p_in) annotation (points=[21,-50; 30,-50; 30,-64; 38,-64],
      style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(TWat.y, sou_2.T_in) annotation (points=[21,-82; 30,-82; 30,-70; 38,
        -70], style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(sou_1.port, tow.port_a1) annotation (points=[-40,50; -24,50; -24,2; 
        20,2], style(
      color=69,
      rgbcolor={0,127,255},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(POut.y, sin_2.p_in) annotation (points=[-79,90; -70,90; -70,-14; -62,
        -14], style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(TDb.y, sin_2.T_in) annotation (points=[-79,50; -70,50; -70,-20; -62,
        -20], style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(tow.port_b2, res_2.port_a) annotation (points=[20,-10; 12,-10; 12,-20; 
        5.55112e-16,-20], style(
      color=69,
      rgbcolor={0,127,255},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(sin_2.port, res_2.port_b) annotation (points=[-40,-20; -20,-20],
      style(
      color=69,
      rgbcolor={0,127,255},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(tow.port_b1, res_1.port_a) annotation (points=[40,2; 56,2; 56,20; 60,
        20], style(
      color=69,
      rgbcolor={0,127,255},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(sin_1.port, res_1.port_b) annotation (points=[62,50; 90,50; 90,20; 80,
        20], style(
      color=69,
      rgbcolor={0,127,255},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
end CoolingTowerVariableSpeed;
