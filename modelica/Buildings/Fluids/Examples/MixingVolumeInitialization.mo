model MixingVolumeInitialization 
  import Buildings;
  
    annotation (Diagram, Commands(file=
            "MixingVolume.mos" "run"),
    Coordsys(extent=[-100,-100; 180,100]));
  
 package Medium = Modelica.Media.Air.SimpleAir;
// package Medium = Buildings.Media.PerfectGases.MoistAir;
  // package Medium = Buildings.Media.GasesPTDecoupled.SimpleAir;
  
    Modelica.Blocks.Sources.Ramp P(
    duration=0.5,
    height=-10,
    offset=101330,
    startTime=100) 
                 annotation (extent=[-100,60; -80,80]);
    Modelica.Blocks.Sources.Constant PAtm(k=101325) 
      annotation (extent=[114,80; 134,100]);
  Modelica_Fluid.Volumes.MixingVolume vol1(
    redeclare package Medium = Medium,
    V=0.1, 
    initType=Modelica_Fluid.Types.Init.SteadyStateHydraulic) 
          annotation (extent=[0,10; 20,30]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sou1(
                                                    redeclare package Medium = 
        Medium, T=293.15)                           annotation (extent=[-72,10;
        -52,30]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sin1(
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
  Modelica_Fluid.Volumes.MixingVolume vol2(
    redeclare package Medium = Medium,
    V=0.1, 
    initType=Modelica_Fluid.Types.Init.SteadyStateHydraulic) 
          annotation (extent=[40,10; 60,30]);
equation 
  connect(sou1.port, res11.port_a) annotation (points=[-52,20; -40,20],   style(
        color=69, rgbcolor={0,127,255}));
  connect(sin1.port, res12.port_b) annotation (points=[108,20; 100,20], style(
        color=69, rgbcolor={0,127,255}));
  connect(P.y, sou1.p_in) annotation (points=[-79,70; -74,70; -74,26],
      style(color=74, rgbcolor={0,0,127}));
  connect(PAtm.y, sin1.p_in) annotation (points=[135,90; 140,90; 140,26; 130,26],
      style(color=74, rgbcolor={0,0,127}));
  connect(res11.port_b, vol1.port_a) annotation (points=[-20,20; -0.2,20], 
      style(color=69, rgbcolor={0,127,255}));
  connect(vol1.port_b, vol2.port_a) annotation (points=[20,20; 39.8,20], style(
        color=69, rgbcolor={0,127,255}));
  connect(vol2.port_b, res12.port_a)
    annotation (points=[60,20; 80,20], style(color=69, rgbcolor={0,127,255}));
end MixingVolumeInitialization;
