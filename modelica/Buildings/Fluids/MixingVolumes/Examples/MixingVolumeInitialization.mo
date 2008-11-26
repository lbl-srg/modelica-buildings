model MixingVolumeInitialization 
  
    annotation (Diagram, Commands(file=
            "MixingVolumeInitialization.mos" "run"),
    Coordsys(extent=[-100,-100; 180,100]));
  
// package Medium = Buildings.Media.IdealGases.SimpleAir;
 //package Medium = Buildings.Media.PerfectGases.MoistAir;
 package Medium = Buildings.Media.GasesPTDecoupled.SimpleAir;
  
    Modelica.Blocks.Sources.Constant PAtm(k=101320) 
      annotation (extent=[114,80; 134,100]);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sou1(
                                                    redeclare package Medium = 
        Medium, T=293.15)                           annotation (extent=[-60,10;
        -40,30]);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sin1(
                                                    redeclare package Medium = 
        Medium, T=293.15)                           annotation (extent=[120,10;
        100,30]);
  Modelica_Fluid.PressureLosses.WallFrictionAndGravity pipe1(
    redeclare package Medium = Medium,
    p_start=101325,
    flowDirection=Modelica_Fluid.Types.FlowDirection.Bidirectional,
    length=1,
    diameter=0.25) annotation (extent=[-20,10; 0,30]);
  Modelica_Fluid.PressureLosses.WallFrictionAndGravity pipe2(
    redeclare package Medium = Medium,
    p_start=101325,
    flowDirection=Modelica_Fluid.Types.FlowDirection.Bidirectional,
    length=1,
    diameter=0.25) annotation (extent=[60,10; 80,30]);
  inner Modelica_Fluid.Ambient ambient annotation (extent=[-80,-60; -60,-40]);
    Modelica.Blocks.Sources.Constant PAtm1(k=101330) 
      annotation (extent=[-100,60; -80,80]);
  MixingVolumes.MixingVolume vol1(
    redeclare package Medium = Medium,
    V=0.1,
    initType=Modelica_Fluid.Types.Init.NoInit) 
    annotation (extent=[20,10; 40,30]);
equation 
  connect(PAtm.y, sin1.p_in) annotation (points=[135,90; 140,90; 140,26; 122,26],
      style(color=74, rgbcolor={0,0,127}));
  connect(sou1.port, pipe1.port_a) annotation (points=[-40,20; -20,20], style(
        color=69, rgbcolor={0,127,255}));
  connect(pipe2.port_b, sin1.port) annotation (points=[80,20; 100,20],
             style(color=69, rgbcolor={0,127,255}));
  connect(PAtm1.y, sou1.p_in) annotation (points=[-79,70; -76,70; -76,26; -62,
        26], style(color=74, rgbcolor={0,0,127}));
  connect(pipe1.port_b, vol1.port[1]) annotation (points=[5.55112e-16,20; 15,20; 
        15,19.5; 30,19.5], style(color=69, rgbcolor={0,127,255}));
  connect(pipe2.port_a, vol1.port[2]) annotation (points=[60,20; 45,20; 45,20.5;
        30,20.5], style(color=69, rgbcolor={0,127,255}));
end MixingVolumeInitialization;
