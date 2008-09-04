model DryCoilDiscretized 
  
  annotation(Diagram, Commands(file="DryCoilDiscretized.mos" "run"));
 package Medium_1 = Buildings.Media.ConstantPropertyLiquidWater;
 //package Medium_2 = Buildings.Media.PerfectGases.MoistAir;
 package Medium_2 = Buildings.Media.GasesPTDecoupled.SimpleAir;
 //package Medium_2 = Buildings.Media.GasesPTDecoupled.MoistAir;
 //package Medium_2 = Buildings.Media.GasesPTDecoupled.MoistAirNoLiquid;
//package Medium_2 = Buildings.Media.IdealGases.SimpleAir;
  
  Buildings.HeatExchangers.DryCoilDiscretized hex(
    redeclare package Medium_1 = Medium_1,
    redeclare package Medium_2 = Medium_2,
    m0_flow_1=5,
    dp0_1=2000,
    m0_flow_2=5,
    dp0_2=200,
    Q0_flow=50000,
    nPipPar=1,
    nPipSeg=3,
    steadyState_2=false,
    nReg=2)              annotation (extent=[8,-4; 28,16]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sin_2(          redeclare 
      package Medium = Medium_2, T=303.15) 
                          annotation (extent=[-58,-10; -38,10]);
    Modelica.Blocks.Sources.Ramp PIn(
    duration=60,
    offset=101525,
    height=-199) annotation (extent=[-20,-50; 0,-30]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sou_2(T=283.15, redeclare 
      package Medium = Medium_2) 
                          annotation (extent=[40,-70; 60,-50],
                                                             rotation=0);
    Modelica.Blocks.Sources.Ramp TWat(
    duration=60,
    startTime=60,
    height=15,
    offset=273.15 + 5) "Water temperature" 
                 annotation (extent=[-100,40; -80,60]);
  Modelica.Blocks.Sources.Constant TDb(k=293.15) "Drybulb temperature" 
    annotation (extent=[-20,-90; 0,-70]);
    Modelica.Blocks.Sources.Constant POut(k=101325) 
      annotation (extent=[-100,-4; -80,16]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sin_1(          redeclare 
      package Medium = Medium_1,
    p=300000,
    T=293.15)             annotation (extent=[84,2; 64,22],  rotation=0);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sou_1(
    T=293.15,
    redeclare package Medium = Medium_1,
    p=300000 + 5000)      annotation (extent=[-60,40; -40,60]);
    Fluids.FixedResistances.FixedResistanceDpM res_2(
    from_dp=true,
    m0_flow=5,
    dp0=10,
    redeclare package Medium = Medium_2) 
             annotation (extent=[-2,-10; -22,10], rotation=0);
    Fluids.FixedResistances.FixedResistanceDpM res_1(
    from_dp=true,
    m0_flow=5,
    dp0=10,
    redeclare package Medium = Medium_1) 
             annotation (extent=[34,2; 54,22]);
    Modelica.Blocks.Sources.Ramp PSin_1(
    duration=60,
    startTime=240,
    offset=300000,
    height=4990) annotation (extent=[40,60; 60,80]);
equation 
  connect(PIn.y,sou_2. p_in) annotation (points=[1,-40; 20,-40; 20,-54; 38,-54],
      style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(POut.y,sin_2. p_in) annotation (points=[-79,6; -74.25,6; -74.25,6; 
        -69.5,6; -69.5,6; -60,6],
              style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(sin_2.port,res_2. port_b) annotation (points=[-38,6.10623e-16; -34,
        6.10623e-16; -34,6.10623e-16; -30,6.10623e-16; -30,6.10623e-16; -22,
        6.10623e-16],
      style(
      color=69,
      rgbcolor={0,127,255},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(sin_1.port,res_1. port_b) annotation (points=[64,12; 54,12],
             style(
      color=69,
      rgbcolor={0,127,255},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(sou_1.port, hex.port_a1) annotation (points=[-40,50; 0,50; 0,12; 8,12],
               style(color=69, rgbcolor={0,127,255}));
  connect(res_2.port_a, hex.port_b2) annotation (points=[-2,6.10623e-16; 4,
        6.10623e-16; 4,5.55112e-16; 8,5.55112e-16],
                                       style(color=69, rgbcolor={0,127,255}));
  connect(hex.port_b1, res_1.port_a) annotation (points=[28,12; 31,12; 31,12; 
        34,12], style(color=69, rgbcolor={0,127,255}));
  connect(hex.port_a2, sou_2.port) annotation (points=[28,5.55112e-16; 68,
        5.55112e-16; 68,-60; 60,-60], style(color=69, rgbcolor={0,127,255}));
  connect(TDb.y, sou_2.T_in) annotation (points=[1,-80; 20,-80; 20,-60; 38,-60],
              style(color=74, rgbcolor={0,0,127}));
  connect(TWat.y, sou_1.T_in) 
    annotation (points=[-79,50; -62,50], style(color=74, rgbcolor={0,0,127}));
  connect(PSin_1.y, sin_1.p_in) annotation (points=[61,70; 100,70; 100,18; 86,18],
      style(color=74, rgbcolor={0,0,127}));
end DryCoilDiscretized;
