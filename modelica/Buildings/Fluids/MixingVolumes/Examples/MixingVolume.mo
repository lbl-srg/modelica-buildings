model MixingVolume 
  import Buildings;
  
    annotation (Diagram, Commands(file=
            "MixingVolume.mos" "run"),
    Coordsys(extent=[-100,-100; 180,100]));
  
// package Medium = Buildings.Media.IdealGases.SimpleAir;
 package Medium = Buildings.Media.PerfectGases.MoistAir;
  
    Modelica.Blocks.Sources.Ramp P(
    duration=0.5,
    startTime=0.5,
    height=-10,
    offset=101330) 
                 annotation (extent=[-100,60; -80,80]);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sou(redeclare package Medium = 
        Medium, T=293.15)                           annotation (extent=[-68,50;
        -48,70]);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sin(redeclare package Medium = 
        Medium, T=283.15)                           annotation (extent=[128,50;
        108,70]);
    Modelica.Blocks.Sources.Constant PAtm(k=101325) 
      annotation (extent=[114,80; 134,100]);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM res1(
    redeclare each package Medium = Medium,
    dp0=5,
    from_dp=true,
    m0_flow=2) 
             annotation (extent=[-36,50; -16,70]);
  MixingVolumes.MixingVolume vol1(
    redeclare package Medium = Medium,
    initType=Modelica_Fluid.Types.Init.SteadyStateHydraulic,
    nP=2,
    V=0.1) 
          annotation (extent=[0,10; 20,30]);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM res2(
    redeclare each package Medium = Medium,
    dp0=5,
    from_dp=true,
    m0_flow=2) 
             annotation (extent=[80,50; 100,70]);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sou1(
                                                    redeclare package Medium = 
        Medium, T=293.15)                           annotation (extent=[-72,10;
        -52,30]);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sin1(
                                                    redeclare package Medium = 
        Medium, T=283.15)                           annotation (extent=[128,10;
        108,30]);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM res11(
    redeclare each package Medium = Medium,
    dp0=5,
    from_dp=true,
    m0_flow=2) 
             annotation (extent=[-40,10; -20,30]);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM res12(
    redeclare each package Medium = Medium,
    dp0=5,
    from_dp=true,
    m0_flow=2) 
             annotation (extent=[80,10; 100,30]);
  Modelica_Fluid.Volumes.MixingVolume vol(
    redeclare package Medium = Medium,
    initType=Modelica_Fluid.Types.Init.SteadyStateHydraulic,
    V=0.1) 
         annotation (extent=[0,50; 22,70]);
  Buildings.Utilities.Diagnostics.AssertEquality assertEquality 
    annotation (extent=[160,0; 180,20]);
  Buildings.Fluids.Sensors.EnthalpyFlowRate entFloRat(redeclare package Medium 
      = Medium) "Enthalpy flow rate" annotation (extent=[40,50; 60,70]);
  Buildings.Fluids.Sensors.EnthalpyFlowRate entFloRat1(redeclare package Medium
      = Medium) "Enthalpy flow rate" annotation (extent=[40,10; 60,30]);
  Buildings.Fluids.MixingVolumes.MixingVolumeMoistAir vol2(
    redeclare package Medium = Medium,
    initType=Modelica_Fluid.Types.Init.SteadyStateHydraulic,
    nP=2,
    V=0.1) 
          annotation (extent=[0,-40; 20,-20]);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sou2(
                                                    redeclare package Medium = 
        Medium, T=293.15)                           annotation (extent=[-72,-40;
        -52,-20]);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sin2(
                                                    redeclare package Medium = 
        Medium, T=283.15)                           annotation (extent=[128,-40;
        108,-20]);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM res21(
    redeclare each package Medium = Medium,
    dp0=5,
    from_dp=true,
    m0_flow=2) 
             annotation (extent=[-40,-40; -20,-20]);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM res22(
    redeclare each package Medium = Medium,
    dp0=5,
    from_dp=true,
    m0_flow=2) 
             annotation (extent=[80,-40; 100,-20]);
  Buildings.Utilities.Diagnostics.AssertEquality assertEquality1 
    annotation (extent=[160,-50; 180,-30]);
  Buildings.Fluids.Sensors.EnthalpyFlowRate entFloRat2(redeclare package Medium
      = Medium) "Enthalpy flow rate" annotation (extent=[40,-40; 60,-20]);
    Modelica.Blocks.Sources.Constant zero(k=0) 
      annotation (extent=[-52,-70; -32,-50]);
    Modelica.Blocks.Sources.Constant TLiq(k=283.15) 
      annotation (extent=[-40,-100; -20,-80]);
equation 
  connect(P.y, sou.p_in) annotation (points=[-79,70; -74,70; -74,66; -70,66],
      style(color=74, rgbcolor={0,0,127}));
  connect(PAtm.y, sin.p_in) annotation (points=[135,90; 140,90; 140,66; 130,66],
      style(color=74, rgbcolor={0,0,127}));
  connect(sou.port, res1.port_a) annotation (points=[-48,60; -36,60], style(
        color=69, rgbcolor={0,127,255}));
  connect(sin.port, res2.port_b) 
    annotation (points=[108,60; 100,60],
                                       style(color=69, rgbcolor={0,127,255}));
  connect(sou1.port, res11.port_a) annotation (points=[-52,20; -40,20],   style(
        color=69, rgbcolor={0,127,255}));
  connect(sin1.port, res12.port_b) annotation (points=[108,20; 100,20], style(
        color=69, rgbcolor={0,127,255}));
  connect(P.y, sou1.p_in) annotation (points=[-79,70; -74,70; -74,26],
      style(color=74, rgbcolor={0,0,127}));
  connect(PAtm.y, sin1.p_in) annotation (points=[135,90; 140,90; 140,26; 130,26],
      style(color=74, rgbcolor={0,0,127}));
  connect(res2.port_a, entFloRat.port_b) annotation (points=[80,60; 60,60],
      style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(res12.port_a, entFloRat1.port_b) annotation (points=[80,20; 60,20],
      style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(entFloRat.H_flow, assertEquality.u1) annotation (points=[50,49; 50,40;
        148,40; 148,16; 158,16],  style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(entFloRat1.H_flow, assertEquality.u2) annotation (points=[50,9; 50,4; 
        158,4],        style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(res1.port_b, vol.port_a) annotation (points=[-16,60; -0.22,60], style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(vol.port_b, entFloRat.port_a) annotation (points=[22,60; 40,60],
      style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(res11.port_b, vol1.port[2]) annotation (points=[-20,20; -5,20; -5,
        20.5; 10,20.5],   style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(entFloRat1.port_a, vol1.port[1]) annotation (points=[40,20; 25,20; 25,
        19.5; 10,19.5],      style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(sou2.port, res21.port_a) annotation (points=[-52,-30; -40,-30], style(
        color=69, rgbcolor={0,127,255}));
  connect(sin2.port, res22.port_b) annotation (points=[108,-30; 100,-30],
                                                                        style(
        color=69, rgbcolor={0,127,255}));
  connect(P.y,sou2. p_in) annotation (points=[-79,70; -74,70; -74,-24],
      style(color=74, rgbcolor={0,0,127}));
  connect(PAtm.y,sin2. p_in) annotation (points=[135,90; 140,90; 140,-24; 130,
        -24],
      style(color=74, rgbcolor={0,0,127}));
  connect(res22.port_a, entFloRat2.port_b) annotation (points=[80,-30; 60,-30],
      style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(entFloRat.H_flow, assertEquality1.u1) annotation (points=[50,49; 50,
        40; 148,40; 148,-34; 158,-34],
                                  style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(entFloRat2.H_flow, assertEquality1.u2) annotation (points=[50,-41; 50,
        -46; 158,-46], style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(res21.port_b, vol2.port[2]) annotation (points=[-20,-30; -5,-30; -5,
        -29.5; 10,-29.5], style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(entFloRat2.port_a, vol2.port[1]) annotation (points=[40,-30; 25,-30;
        25,-30.5; 10,-30.5], style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(zero.y, vol2.mWat_flow) annotation (points=[-31,-60; -18,-60; -18,-32; 
        -2,-32], style(color=74, rgbcolor={0,0,127}));
  connect(TLiq.y, vol2.TWat) annotation (points=[-19,-90; -10,-90; -10,-38; -2,
        -38], style(color=74, rgbcolor={0,0,127}));
end MixingVolume;
