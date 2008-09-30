model HexElement 
  import Buildings;
  annotation(Diagram, Commands(file="HexElement.mos" "run"),
    experimentSetupOutput);
 package Medium_W = Buildings.Media.ConstantPropertyLiquidWater;
// package Medium_W = Modelica.Media.Air.SimpleAir;
// package Medium_A = Buildings.Media.GasesPTDecoupled.SimpleAir;
// package Medium_A = Modelica.Media.Air.SimpleAir;
// package Medium_A = Modelica.Media.Air.SimpleAir;
// package Medium_A = Buildings.Media.PerfectGases.MoistAirNonsaturated;
 package Medium_A = Buildings.Media.PerfectGases.MoistAir;
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sin_2(
                               T=288.15, redeclare package Medium = Medium_A) 
                          annotation (extent=[-60,-30; -40,-10]);
    Modelica.Blocks.Sources.Ramp PIn(
    height=20,
    offset=101320,
    duration=300,
    startTime=300) 
                 annotation (extent=[0,-60; 20,-40]);
  annotation (Diagram);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sou_2(T=283.15, redeclare 
      package Medium = Medium_A) 
                          annotation (extent=[40,-80; 60,-60],
                                                             rotation=0);
    Modelica.Blocks.Sources.Ramp TWat(
    startTime=1,
    height=4,
    duration=300,
    offset=303.15) "Water temperature" 
                 annotation (extent=[0,-92; 20,-72]);
  Modelica.Blocks.Sources.Constant TDb(k=278.15) "Drybulb temperature" 
    annotation (extent=[-100,40; -80,60]);
    Modelica.Blocks.Sources.Constant POut(k=101325) 
      annotation (extent=[-100,80; -80,100]);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sin_1(
                               T=288.15, redeclare package Medium = Medium_W) 
                          annotation (extent=[42,40; 62,60], rotation=0);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sou_1(
    T=293.15,
    p=101335,
    redeclare package Medium = Medium_W) 
                          annotation (extent=[-60,40; -40,60]);
    Fluids.FixedResistances.FixedResistanceDpM res_22(
    from_dp=true,
    m0_flow=5,
    dp0=5,
    redeclare package Medium = Medium_A) 
             annotation (extent=[-4,-30; -24,-10],rotation=0);
    Fluids.FixedResistances.FixedResistanceDpM res_12(
    from_dp=true,
    m0_flow=5,
    dp0=5,
    redeclare package Medium = Medium_W) 
             annotation (extent=[48,10; 68,30]);
  Buildings.HeatExchangers.BaseClasses.HexElement hex(
    m0_flow_1=5,
    m0_flow_2=5,
    UA0=9999,
    redeclare package Medium_1 = Medium_W,
    redeclare package Medium_2 = Medium_A,
    allowCondensation=false) 
                    annotation (extent=[10,-10; 30,10]);
  Modelica.Blocks.Sources.Constant TDb1(k=303.15) "Drybulb temperature" 
    annotation (extent=[-100,-30; -80,-10]);
    Fluids.FixedResistances.FixedResistanceDpM res_11(
    from_dp=true,
    m0_flow=5,
    dp0=5,
    redeclare package Medium = Medium_W) 
             annotation (extent=[-24,10; -4,30]);
    Fluids.FixedResistances.FixedResistanceDpM res_21(
    from_dp=true,
    m0_flow=5,
    dp0=5,
    redeclare package Medium = Medium_A) 
             annotation (extent=[70,-30; 50,-10], rotation=0);
  Modelica.Blocks.Sources.Constant hACon(k=10000) "Convective heat transfer" 
    annotation (extent=[-20,60; 0,80]);
equation 
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
  connect(POut.y, sin_2.p_in) annotation (points=[-79,90; -70,90; -70,-14; -62,
        -14], style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(sin_2.port, res_22.port_b) 
                                    annotation (points=[-40,-20; -24,-20],
      style(
      color=69,
      rgbcolor={0,127,255},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(sin_1.port, res_12.port_b) 
                                    annotation (points=[62,50; 80,50; 80,20; 68,
        20], style(
      color=69,
      rgbcolor={0,127,255},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(hex.port_b1, res_12.port_a) 
                                     annotation (points=[30,6; 42,6; 42,20; 48,
        20],    style(color=69, rgbcolor={0,127,255}));
  connect(res_22.port_a, hex.port_b2) 
                                     annotation (points=[-4,-20; 2,-20; 2,-6; 
        10,-6],      style(color=69, rgbcolor={0,127,255}));
  connect(TDb1.y, sin_2.T_in) annotation (points=[-79,-20; -62,-20],
                  style(color=74, rgbcolor={0,0,127}));
  connect(res_11.port_b, hex.port_a1) annotation (points=[-4,20; -2,20; -2,6; 
        10,6], style(color=69, rgbcolor={0,127,255}));
  connect(sou_1.port, res_11.port_a) annotation (points=[-40,50; -32,50; -32,20;
        -24,20], style(color=69, rgbcolor={0,127,255}));
  connect(hex.port_a2, res_21.port_b) annotation (points=[30,-6; 40,-6; 40,-20;
        50,-20], style(color=69, rgbcolor={0,127,255}));
  connect(sou_2.port, res_21.port_a) annotation (points=[60,-70; 80,-70; 80,-20;
        70,-20], style(color=69, rgbcolor={0,127,255}));
  connect(hACon.y, hex.Gc_1) annotation (points=[1,70; 16,70; 16,10], style(
        color=74, rgbcolor={0,0,127}));
  connect(hACon.y, hex.Gc_2) annotation (points=[1,70; 8,70; 8,-16; 24,-16; 24,
        -10], style(color=74, rgbcolor={0,0,127}));
end HexElement;
