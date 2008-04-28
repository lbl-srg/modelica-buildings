model MixingVolume 
  
    annotation (Diagram, Commands(file=
            "MixingVolume.mos" "run"));
  
// package Medium = Modelica.Media.Air.SimpleAir(T_min=Modelica.SIunits.Conversions.from_degC(-50)) 
//    "Medium in the component";
 package Medium = Buildings.Fluids.Media.SimpleAirPTDecoupled 
    "Medium in the component";
  
    Modelica.Blocks.Sources.Ramp P(
    duration=0.5,
    startTime=0.5,
    height=-10,
    offset=101330) 
                 annotation (extent=[-100,40; -80,60]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sou(redeclare package Medium = 
        Medium, T=293.15)                           annotation (extent=[-68,10;
        -48,30]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sin(redeclare package Medium = 
        Medium, T=283.15)                           annotation (extent=[74,10;
        54,30]);
    Modelica.Blocks.Sources.Constant PAtm(k=101325) 
      annotation (extent=[60,60; 80,80]);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM res1(
    redeclare each package Medium = Medium,
    dp0=5,
    from_dp=true,
    m0_flow=2) 
             annotation (extent=[-36,10; -16,30]);
  Components.MixingVolume vol(
    redeclare package Medium = Medium,
    initType=Modelica_Fluid.Types.Init.SteadyStateHydraulic,
    nP=2,
    V=0.1) 
          annotation (extent=[-4,10; 16,30]);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM res2(
    redeclare each package Medium = Medium,
    dp0=5,
    from_dp=true,
    m0_flow=2) 
             annotation (extent=[26,10; 46,30]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sou1(
                                                    redeclare package Medium = 
        Medium, T=293.15)                           annotation (extent=[-68,-28;
        -48,-8]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sin1(
                                                    redeclare package Medium = 
        Medium, T=283.15)                           annotation (extent=[74,-28;
        54,-8]);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM res11(
    redeclare each package Medium = Medium,
    dp0=5,
    from_dp=true,
    m0_flow=2) 
             annotation (extent=[-36,-28; -16,-8]);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM res12(
    redeclare each package Medium = Medium,
    dp0=5,
    from_dp=true,
    m0_flow=2) 
             annotation (extent=[26,-28; 46,-8]);
  Modelica_Fluid.Volumes.MixingVolume vol1(
    redeclare package Medium = Medium,
    initType=Modelica_Fluid.Types.Init.SteadyStateHydraulic,
    V=0.1) 
         annotation (extent=[-6,-28; 16,-8]);
equation 
  connect(P.y, sou.p_in) annotation (points=[-79,50; -74,50; -74,26; -70,26],
      style(color=74, rgbcolor={0,0,127}));
  connect(PAtm.y, sin.p_in) annotation (points=[81,70; 86,70; 86,26; 76,26],
      style(color=74, rgbcolor={0,0,127}));
  connect(sou.port, res1.port_a) annotation (points=[-48,20; -36,20], style(
        color=69, rgbcolor={0,127,255}));
  connect(sin.port, res2.port_b) 
    annotation (points=[54,20; 46,20], style(color=69, rgbcolor={0,127,255}));
  connect(sou1.port, res11.port_a) annotation (points=[-48,-18; -36,-18], style(
        color=69, rgbcolor={0,127,255}));
  connect(sin1.port, res12.port_b) annotation (points=[54,-18; 46,-18], style(
        color=69, rgbcolor={0,127,255}));
  connect(P.y, sou1.p_in) annotation (points=[-79,50; -74,50; -74,-12; -70,-12],
      style(color=74, rgbcolor={0,0,127}));
  connect(PAtm.y, sin1.p_in) annotation (points=[81,70; 86,70; 86,-12; 76,-12],
      style(color=74, rgbcolor={0,0,127}));
  connect(res11.port_b, vol1.port_a) annotation (points=[-16,-18; -6.22,-18],
      style(color=69, rgbcolor={0,127,255}));
  connect(vol1.port_b, res12.port_a) annotation (points=[16,-18; 26,-18], style(
        color=69, rgbcolor={0,127,255}));
  connect(res1.port_b, vol.port[1]) annotation (points=[-16,20; -5,20; -5,19.5;
        6,19.5], style(color=69, rgbcolor={0,127,255}));
  connect(res2.port_a, vol.port[2]) annotation (points=[26,20; 16,20; 16,20.5;
        6,20.5], style(color=69, rgbcolor={0,127,255}));
end MixingVolume;
