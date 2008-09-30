model DryCoilDiscretizedPControl 
  import Buildings;
  
  annotation(Diagram, Commands(file="DryCoilDiscretizedPControl.mos" "run"),
    Coordsys(extent=[-100,-100; 200,200]));
 package Medium_1 = Buildings.Media.ConstantPropertyLiquidWater;
 //package Medium_2 = Buildings.Media.PerfectGases.MoistAir;
 //package Medium_2 = Buildings.Media.GasesPTDecoupled.MoistAir;
 // package Medium_2 = Buildings.Media.GasesPTDecoupled.MoistAirNoLiquid;
 package Medium_2 = Buildings.Media.GasesPTDecoupled.SimpleAir;
  
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sin_2(          redeclare 
      package Medium = Medium_2, T=303.15) 
                          annotation (extent=[-58,-26; -38,-6]);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sou_2(T=283.15, redeclare 
      package Medium = Medium_2) 
                          annotation (extent=[90,-80; 110,-60],
                                                             rotation=0);
  Modelica.Blocks.Sources.Constant TDb(k=293.15) "Drybulb temperature" 
    annotation (extent=[30,-100; 50,-80]);
    Modelica.Blocks.Sources.Constant POut(k=101325) 
      annotation (extent=[-100,-20; -80,0]);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sin_1(          redeclare 
      package Medium = Medium_1,
    p=300000,
    T=293.15)             annotation (extent=[164,22; 144,42],
                                                             rotation=0);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sou_1(
    T=293.15,
    redeclare package Medium = Medium_1,
    p=300000 + 9000)      annotation (extent=[-60,60; -40,80]);
    Fluids.FixedResistances.FixedResistanceDpM res_2(
    from_dp=true,
    m0_flow=5,
    dp0=10,
    redeclare package Medium = Medium_2) 
             annotation (extent=[-2,-26; -22,-6], rotation=0);
    Fluids.FixedResistances.FixedResistanceDpM res_1(
    from_dp=true,
    m0_flow=5,
    redeclare package Medium = Medium_1,
    dp0=3000) 
             annotation (extent=[90,22; 110,42]);
    Modelica.Blocks.Sources.Ramp PSin_1(
    duration=60,
    height=5000,
    startTime=240,
    offset=300000) 
                 annotation (extent=[120,80; 140,100]);
    Modelica.Blocks.Sources.Constant POut1(k=101525) 
      annotation (extent=[30,-68; 50,-48]);
  Modelica_Fluid.Sensors.Temperature temperature(redeclare package Medium = 
        Medium_2) annotation (extent=[14,-26; 34,-6]);
  Buildings.Fluids.Actuators.Valves.TwoWayEqualPercentage val(
    redeclare package Medium = Medium_1,
    k_SI=5/sqrt(9000),
    l=0.005) "Valve model" 
             annotation (extent=[28,40; 48,60]);
  Modelica.Blocks.Math.Gain P(k=10)   annotation (extent=[-38,120; -18,140]);
  Modelica.Blocks.Math.Feedback fedBac annotation (extent=[-78,120; -58,140]);
  Modelica.Blocks.Sources.TimeTable TSet(table=[0,298.15; 600,298.15; 600,
        303.15; 1200,303.15; 1800,298.15; 2400,298.15; 2400,304.15]) 
    "Setpoint temperature" 
    annotation (extent=[-80,162; -60,182]);
  Buildings.HeatExchangers.DryCoilDiscretized hex(
    redeclare package Medium_1 = Medium_1,
    redeclare package Medium_2 = Medium_2,
    m0_flow_1=5,
    dp0_1=2000,
    m0_flow_2=5,
    dp0_2=200,
    nPipPar=1,
    nPipSeg=3,
    nReg=4,
    Q0_flow=200000)      annotation (extent=[60,16; 80,36]);
    Modelica.Blocks.Sources.Constant TWat(k=273.15 + 40) 
      annotation (extent=[-100,60; -80,80]);
  Buildings.Fluids.Actuators.Motors.IdealMotor mot(tOpe=60) "Motor model" 
    annotation (extent=[-6,70; 14,90]);
equation 
  connect(POut.y,sin_2. p_in) annotation (points=[-79,-10; -60,-10],
              style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(sin_2.port,res_2. port_b) annotation (points=[-38,-16; -22,-16],
      style(
      color=69,
      rgbcolor={0,127,255},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(sin_1.port,res_1. port_b) annotation (points=[144,32; 110,32],
             style(
      color=69,
      rgbcolor={0,127,255},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(TDb.y, sou_2.T_in) annotation (points=[51,-90; 70,-90; 70,-70; 88,-70],
              style(color=74, rgbcolor={0,0,127}));
  connect(PSin_1.y, sin_1.p_in) annotation (points=[141,90; 180,90; 180,38; 166,
        38],
      style(color=74, rgbcolor={0,0,127}));
  connect(POut1.y, sou_2.p_in) annotation (points=[51,-58; 68,-58; 68,-64; 88,
        -64], style(color=74, rgbcolor={0,0,127}));
  connect(sou_1.port, val.port_a)                   annotation (points=[-40,70; 
        -20,70; -20,50; 28,50],           style(color=69, rgbcolor={0,127,255}));
  connect(P.u, fedBac.y)  annotation (points=[-40,130; -59,130], style(color=74,
        rgbcolor={0,0,127}));
  connect(temperature.T, fedBac.u2) annotation (points=[24,-27; 24,-42; -68,-42;
        -68,122], style(color=74, rgbcolor={0,0,127}));
  connect(TSet.y, fedBac.u1) annotation (points=[-59,172; -42,172; -42,148; -86,
        148; -86,130; -76,130], style(color=74, rgbcolor={0,0,127}));
  connect(hex.port_b1, res_1.port_a) 
    annotation (points=[80,32; 90,32], style(color=69, rgbcolor={0,127,255}));
  connect(TWat.y, sou_1.T_in) 
    annotation (points=[-79,70; -62,70], style(color=74, rgbcolor={0,0,127}));
  connect(res_2.port_a, temperature.port_a) annotation (points=[-2,-16; 6,-16; 
        6,-16; 14,-16], style(color=69, rgbcolor={0,127,255}));
  connect(temperature.port_b, hex.port_b2) annotation (points=[34,-16; 48,-16;
        48,20; 60,20], style(color=69, rgbcolor={0,127,255}));
  connect(sou_2.port, hex.port_a2) annotation (points=[110,-70; 120,-70; 120,20;
        80,20], style(color=69, rgbcolor={0,127,255}));
  connect(val.port_b, hex.port_a1)                   annotation (points=[48,50; 
        52,50; 52,32; 60,32], style(color=69, rgbcolor={0,127,255}));
  connect(mot.y, val.y) annotation (points=[15,80; 20,80; 20,58; 26,58], style(
        color=74, rgbcolor={0,0,127}));
  connect(P.y, mot.u) annotation (points=[-17,130; -16,130; -16,80; -8,80], 
      style(color=74, rgbcolor={0,0,127}));
end DryCoilDiscretizedPControl;
