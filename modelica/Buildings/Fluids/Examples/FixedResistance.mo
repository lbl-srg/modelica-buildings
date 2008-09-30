model FixedResistance 
  import Buildings;
  
    annotation (Diagram, Commands(file=
            "FixedResistance.mos" "run"));
 package Medium = 
        Buildings.Media.ConstantPropertyLiquidWater;
    Modelica.Blocks.Sources.Constant PAtm(k=101325) 
      annotation (extent=[66,76; 86,96]);
    Modelica.Blocks.Sources.Ramp P(
      duration=1,
    height=20,
    offset=101315) 
                 annotation (extent=[-100,70; -80,90]);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM res1(
    redeclare package Medium = Medium,
    from_dp=true,
    m0_flow=5,
    dp0=10)  annotation (extent=[-28,30; -8,50]);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sou1(
                                                    redeclare package Medium = 
        Medium, T=293.15) annotation (extent=[-68,30; -48,50]);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sin1(
                                                    redeclare package Medium = 
        Medium, T=283.15) annotation (extent=[84,30; 64,50], rotation=0);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM res2(
    redeclare package Medium = Medium,
    from_dp=true,
    m0_flow=5,
    dp0=10,
    use_dh=true) 
             annotation (extent=[-28,-10; -8,10]);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sou2(
                                                    redeclare package Medium = 
        Medium, T=293.15) annotation (extent=[-68,-10; -48,10]);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sin2(
                                                    redeclare package Medium = 
        Medium, T=283.15) annotation (extent=[84,-10; 64,10],rotation=0);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM res3(
    redeclare package Medium = Medium,
    from_dp=true,
    m0_flow=5,
    dp0=10,
    use_dh=true) 
             annotation (extent=[-28,-50; -8,-30]);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sou3(
                                                    redeclare package Medium = 
        Medium, T=293.15) annotation (extent=[-68,-50; -48,-30]);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sin3(
                                                    redeclare package Medium = 
        Medium, T=283.15) annotation (extent=[84,-50; 64,-30],
                                                             rotation=0);
  FixedResistances.LosslessPipe pipCon(redeclare package Medium = Medium) 
    "Lossless pipe connection" annotation (extent=[34,-50; 54,-30]);
  Modelica_Fluid.Sensors.MassFlowRate masFlo2(redeclare package Medium = Medium) 
    "Mass flow rate sensor" annotation (extent=[0,-10; 20,10]);
  Modelica_Fluid.Sensors.MassFlowRate masFlo3(redeclare package Medium = Medium) 
    "Mass flow rate sensor" annotation (extent=[0,-50; 20,-30]);
  Buildings.Utilities.Controls.AssertEquality assEqu(threShold=1E-4, message=
        "Inputs differ, check that lossless pipe is correctly implemented.") 
    "Assert equality of the two mass flow rates" 
    annotation (extent=[40,-80; 60,-60]);
equation 
  connect(PAtm.y, sin1.p_in) 
                            annotation (points=[87,86; 94,86; 94,46; 86,46],
      style(color=74, rgbcolor={0,0,127}));
  connect(sou1.port, res1.port_a) 
                                annotation (points=[-48,40; -28,40],
                      style(color=69, rgbcolor={0,127,255}));
  connect(sin1.port, res1.port_b) 
                                annotation (points=[64,40; -8,40],
                     style(color=69, rgbcolor={0,127,255}));
  connect(PAtm.y, sin2.p_in) 
                            annotation (points=[87,86; 94,86; 94,6; 86,6],
      style(color=74, rgbcolor={0,0,127}));
  connect(sou2.port, res2.port_a) 
                                annotation (points=[-48,6.10623e-16; -44,0; -38,
        1.22125e-15; -38,6.10623e-16; -28,6.10623e-16],
                      style(color=69, rgbcolor={0,127,255}));
  connect(PAtm.y,sin3. p_in) 
                            annotation (points=[87,86; 94,86; 94,-34; 86,-34],
      style(color=74, rgbcolor={0,0,127}));
  connect(sou3.port,res3. port_a) 
                                annotation (points=[-48,-40; -28,-40],
                      style(color=69, rgbcolor={0,127,255}));
  connect(pipCon.port_b, sin3.port) annotation (points=[54,-40; 64,-40], style(
        color=69, rgbcolor={0,127,255}));
  connect(P.y, sou1.p_in) annotation (points=[-79,80; -74,80; -74,46; -70,46],
      style(color=74, rgbcolor={0,0,127}));
  connect(P.y, sou2.p_in) annotation (points=[-79,80; -74,80; -74,6; -70,6],
      style(color=74, rgbcolor={0,0,127}));
  connect(P.y, sou3.p_in) annotation (points=[-79,80; -74,80; -74,-34; -70,-34],
      style(color=74, rgbcolor={0,0,127}));
  connect(res2.port_b, masFlo2.port_a) annotation (points=[-8,6.10623e-16; -4,
        6.10623e-16; -4,6.10623e-16; -5.55112e-16,6.10623e-16], style(color=69,
        rgbcolor={0,127,255}));
  connect(masFlo2.port_b, sin2.port) annotation (points=[20,6.10623e-16; 44,
        6.10623e-16; 44,6.10623e-16; 64,6.10623e-16], style(color=69, rgbcolor=
          {0,127,255}));
  connect(res3.port_b, masFlo3.port_a) annotation (points=[-8,-40; -5.55112e-16,
        -40], style(color=69, rgbcolor={0,127,255}));
  connect(masFlo3.port_b, pipCon.port_a) annotation (points=[20,-40; 34,-40],
      style(color=69, rgbcolor={0,127,255}));
  connect(masFlo2.m_flow, assEqu.u1) annotation (points=[10,-11; 10,-22; 26,-22;
        26,-64; 38,-64], style(color=74, rgbcolor={0,0,127}));
  connect(masFlo3.m_flow, assEqu.u2) annotation (points=[10,-51; 10,-76; 38,-76],
      style(color=74, rgbcolor={0,0,127}));
end FixedResistance;
