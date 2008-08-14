model Manifold 
  import Buildings;
  annotation(Diagram, Commands(file="Manifold.mos" "run"),
    Coordsys(extent=[-100,-100; 180,100]));
 package Medium = Buildings.Media.ConstantPropertyLiquidWater;
 parameter Integer nPipPar = 3 "Number of parallel pipes";
 parameter Integer nPipSeg = 4 "Number of pipe segments";
    Modelica.Blocks.Sources.Constant POut(k=101325) 
      annotation (extent=[60,70; 80,90]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sin_1(T=283.15, redeclare 
      package Medium = Medium) 
                          annotation (extent=[102,64; 122,84],
                                                             rotation=0);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sou_1(
    T=293.15,
    redeclare package Medium = Medium,
    p=101335)             annotation (extent=[-60,24; -40,44]);
    Fluids.FixedResistances.FixedResistanceDpM res_1(
    m0_flow=5,
    redeclare package Medium = Medium,
    dp0=10,
    use_dh=true,
    from_dp=false) 
             annotation (extent=[120,24; 140,44]);
  Modelica_Fluid.Sensors.MassFlowRate[nPipPar] mfr_1(redeclare each package 
      Medium = Medium) 
    annotation (extent=[30,24; 50,44]);
  Modelica.Blocks.Sources.Ramp TDb(
    height=1,
    duration=1,
    offset=293.15) annotation (extent=[-100,20; -80,40]);
  Modelica.Blocks.Sources.Ramp P(
    duration=1,
    height=10,
    offset=101320) annotation (extent=[-100,60; -80,80]);
  Buildings.HeatExchangers.BaseClasses.PipeManifoldFixedResistance pipFixRes_1(
    redeclare package Medium = Medium,
    nPipPar=nPipPar,
    m0_flow=5,
    dp0=10) annotation (extent=[-30,24; -10,44]);
  Buildings.HeatExchangers.BaseClasses.PipeManifoldNoResistance pipNoRes_1(
      redeclare package Medium = Medium, nPipPar=nPipPar) 
    annotation (extent=[114,24; 94,44]);
    Modelica.Blocks.Sources.Constant POut1(
                                          k=101325) 
      annotation (extent=[60,-20; 80,0]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sin_2(T=283.15, redeclare 
      package Medium = Medium) 
                          annotation (extent=[98,-26; 118,-6],
                                                             rotation=0);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sou_2(
    T=293.15,
    redeclare package Medium = Medium,
    p=101335)             annotation (extent=[-60,-76; -40,-56]);
    Fluids.FixedResistances.FixedResistanceDpM res_2(
    m0_flow=5,
    redeclare package Medium = Medium,
    dp0=10,
    use_dh=true,
    from_dp=false) 
             annotation (extent=[122,-76; 142,-56]);
  Modelica_Fluid.Sensors.MassFlowRate[nPipPar, nPipSeg] mfr_2(redeclare each 
      package Medium = 
               Medium) 
    annotation (extent=[30,-76; 50,-56]);
  Modelica.Blocks.Sources.Ramp TDb1(
    height=1,
    duration=1,
    offset=293.15) annotation (extent=[-100,-80; -80,-60]);
  Modelica.Blocks.Sources.Ramp P1(
    duration=1,
    height=10,
    offset=101320) annotation (extent=[-100,-40; -80,-20]);
  Buildings.HeatExchangers.BaseClasses.DuctManifoldFixedResistance ducFixRes_2(
    redeclare package Medium = Medium,
    nPipPar=nPipPar,
    nPipSeg=nPipSeg,
    m0_flow=5,
    dp0=10) annotation (extent=[-32,-76; -12,-56]);
  Buildings.HeatExchangers.BaseClasses.DuctManifoldNoResistance ducNoRes_2(
      redeclare package Medium = Medium,
      nPipPar=nPipPar,
      nPipSeg=nPipSeg) 
    annotation (extent=[116,-76; 96,-56]);
  Buildings.HeatExchangers.BaseClasses.CoilHeader hea1(
      redeclare package Medium = Medium,
      nPipPar=nPipPar) "Header for water-side heat exchanger register" 
    annotation (extent=[0,24; 20,44]);
  Buildings.HeatExchangers.BaseClasses.CoilHeader hea2(
      redeclare package Medium = Medium,
      nPipPar=nPipPar) "Header for water-side heat exchanger register" 
    annotation (extent=[60,24; 80,44]);
equation 
  connect(POut.y, sin_1.p_in) annotation (points=[81,80; 100,80],
      style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(sin_1.port, res_1.port_b) annotation (points=[122,74; 150,74; 150,34;
        140,34],
             style(
      color=69,
      rgbcolor={0,127,255},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(TDb.y, sou_1.T_in) annotation (points=[-79,30; -72,30; -72,34; -62,34],
      style(color=74, rgbcolor={0,0,127}));
  connect(P.y, sou_1.p_in) annotation (points=[-79,70; -72,70; -72,40; -62,40],
      style(color=74, rgbcolor={0,0,127}));
  connect(sou_1.port, pipFixRes_1.port_a)  annotation (points=[-40,34; -30,34],
                         style(color=69, rgbcolor={0,127,255}));
  connect(res_1.port_a, pipNoRes_1.port_a) 
    annotation (points=[120,34; 114,34],
                                       style(color=69, rgbcolor={0,127,255}));
  connect(POut1.y, sin_2.p_in) 
                              annotation (points=[81,-10; 96,-10],
      style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(sin_2.port,res_2. port_b) annotation (points=[118,-16; 150,-16; 150,
        -66; 142,-66],
             style(
      color=69,
      rgbcolor={0,127,255},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(TDb1.y, sou_2.T_in) 
                             annotation (points=[-79,-70; -72,-70; -72,-66; -62,
        -66],
      style(color=74, rgbcolor={0,0,127}));
  connect(P1.y, sou_2.p_in) 
                           annotation (points=[-79,-30; -72,-30; -72,-60; -62,
        -60],
      style(color=74, rgbcolor={0,0,127}));
  connect(sou_2.port,ducFixRes_2. port_a)  annotation (points=[-40,-66; -32,-66],
                         style(color=69, rgbcolor={0,127,255}));
  connect(res_2.port_a,ducNoRes_2. port_a) 
    annotation (points=[122,-66; 116,-66],
                                       style(color=69, rgbcolor={0,127,255}));
  connect(pipFixRes_1.port_b, hea1.port_a) annotation (points=[-10,34;
        -5.55112e-16,34],
             style(color=69, rgbcolor={0,127,255}));
  connect(hea1.port_b, mfr_1.port_a) 
    annotation (points=[20,34; 30,34], style(color=69, rgbcolor={0,127,255}));
  connect(mfr_1.port_b, hea2.port_a) 
    annotation (points=[50,34; 60,34], style(color=69, rgbcolor={0,127,255}));
  connect(hea2.port_b, pipNoRes_1.port_b) 
    annotation (points=[80,34; 94,34], style(color=69, rgbcolor={0,127,255}));
  connect(ducFixRes_2.port_b, mfr_2.port_a) annotation (points=[-12,-66; 30,-66],
      style(color=69, rgbcolor={0,127,255}));
  connect(mfr_2.port_b, ducNoRes_2.port_b) annotation (points=[50,-66; 96,-66],
      style(color=69, rgbcolor={0,127,255}));
end Manifold;
