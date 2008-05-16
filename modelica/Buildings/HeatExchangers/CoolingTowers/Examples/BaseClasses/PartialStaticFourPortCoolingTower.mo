partial model PartialStaticFourPortCoolingTower 
 package Medium_W = Modelica.Media.Water.ConstantPropertyLiquidWater;
 //package Medium_A = Modelica.Media.Water.ConstantPropertyLiquidWater;
 package Medium_A = Buildings.Media.PerfectGases.MoistAir;
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sin_2(T=293.15, redeclare 
      package Medium = Medium_A) 
                          annotation (extent=[-60,-20; -40,0]);
  
  parameter Modelica.SIunits.MassFlowRate mWat0_flow = 0.0015*1000 
    "Design air flow rate" 
      annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mAir0_flow = 1.64*1.2 
    "Design air flow rate" 
      annotation (Dialog(group="Nominal condition"));
  
    Modelica.Blocks.Sources.Ramp PIn(
    duration=1, 
    startTime=1, 
    offset=101340, 
    height=-10)  annotation (extent=[0,-60; 20,-40]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sou_2(T=283.15, redeclare 
      package Medium = Medium_A) 
                          annotation (extent=[40,-80; 60,-60],
                                                             rotation=0);
    Modelica.Blocks.Sources.Ramp TAir(
    duration=1,
    height=10,
    startTime=1,
    offset=273.15 + 25) "Air temperature" 
                 annotation (extent=[-34,-80; -14,-60]);
  Modelica.Blocks.Sources.Constant TWat(k=273.15 + 35) "Water temperature" 
    annotation (extent=[-60,10; -40,30]);
  replaceable 
    Buildings.HeatExchangers.CoolingTowers.BaseClasses.PartialStaticFourPortCoolingTower
    tow(   redeclare package Medium_1 = Medium_W,
       redeclare package Medium_2 = Medium_A) "Cooling tower" 
    annotation (extent=[28,-14; 48,6]);
    Modelica.Blocks.Sources.Constant POut(k=101325) 
      annotation (extent=[-100,80; -80,100]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sin_1(T=283.15, redeclare 
      package Medium = Medium_W) 
                          annotation (extent=[42,40; 62,60], rotation=0);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sou_1(
    T=293.15,
    p=101335,
    redeclare package Medium = Medium_W) 
                          annotation (extent=[-20,10; 0,30]);
    Fluids.FixedResistances.FixedResistanceDpM res_2(
    dp0=10,
    redeclare package Medium = Medium_A,
    from_dp=false,
    linearized=true, 
    m0_flow=mAir0_flow) 
             annotation (extent=[0,-20; -20,0],   rotation=0);
    Fluids.FixedResistances.FixedResistanceDpM res_1(
    from_dp=true,
    dp0=10,
    redeclare package Medium = Medium_W, 
    m0_flow=mWat0_flow) 
             annotation (extent=[60,10; 80,30]);
  Modelica.Blocks.Sources.Constant const annotation (extent=[-100,-60; -80,-40]);
  Modelica.Blocks.Math.Feedback feedback annotation (extent=[-72,-60; -52,-40]);
    Modelica.Blocks.Sources.Ramp XHum(
    duration=1,
    height=(0.0133 - 0.0175),
    offset=0.0175) "Humidity concentration" 
                 annotation (extent=[-100,-100; -80,-80]);
    Modelica.Blocks.Sources.Constant PWatIn(k=101335) 
      annotation (extent=[-60,40; -40,60]);
equation 
  connect(TWat.y, sou_1.T_in) 
                             annotation (points=[-39,20; -22,20], style(
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
  connect(TAir.y, sou_2.T_in) annotation (points=[-13,-70; 38,-70],
              style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(sou_1.port, tow.port_a1) annotation (points=[5.55112e-16,20; 10,20; 
        10,2; 28,2],
               style(
      color=69,
      rgbcolor={0,127,255},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(POut.y, sin_2.p_in) annotation (points=[-79,90; -70,90; -70,-4; -62,
        -4],  style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(tow.port_b1, res_1.port_a) annotation (points=[48,2; 56,2; 56,20; 60,
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
  connect(const.y,feedback. u1) annotation (points=[-79,-50; -70,-50], style(
        color=74, rgbcolor={0,0,127}));
  connect(XHum.y,feedback. u2) annotation (points=[-79,-90; -62,-90; -62,-58],
      style(color=74, rgbcolor={0,0,127}));
  connect(XHum.y, sou_2.X_in[1]) annotation (points=[-79,-90; 22,-90; 22,-76;
        38,-76], style(color=74, rgbcolor={0,0,127}));
  connect(feedback.y, sou_2.X_in[2]) annotation (points=[-53,-50; -50,-50; -50,
        -92; 24,-92; 24,-78; 32,-78; 32,-76; 38,-76], style(color=74, rgbcolor=
          {0,0,127}));
  connect(tow.port_b2, res_2.port_a) annotation (points=[28,-10; 5.55112e-16,
        -10], style(color=69, rgbcolor={0,127,255}));
  connect(sou_2.port, tow.port_a2) annotation (points=[60,-70; 66,-70; 66,-10;
        48,-10], style(color=69, rgbcolor={0,127,255}));
  connect(sin_2.port, res_2.port_b) annotation (points=[-40,-10; -20,-10],
      style(color=69, rgbcolor={0,127,255}));
  annotation (Diagram);
  connect(PWatIn.y, sou_1.p_in) annotation (points=[-39,50; -30,50; -30,26; -22,
        26], style(color=74, rgbcolor={0,0,127}));
end PartialStaticFourPortCoolingTower;
