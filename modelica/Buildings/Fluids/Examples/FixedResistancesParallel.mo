model FixedResistancesParallel 
  import Buildings;
  
    annotation (Diagram, Commands(file=
            "FixedResistancesParallel.mos" "run"));
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
    m0_flow=5,
    dp0=10,
    deltaM=0.3,
    linearized=false,
    from_dp=false) 
             annotation (extent=[-28,30; -8,50]);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sou1(
                                                    redeclare package Medium = 
        Medium, T=293.15) annotation (extent=[-68,30; -48,50]);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sin1(
                                                    redeclare package Medium = 
        Medium, T=283.15) annotation (extent=[84,30; 64,50], rotation=0);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM res2(
    redeclare package Medium = Medium,
    m0_flow=5,
    dp0=10,
    deltaM=0.3,
    linearized=false,
    from_dp=false) 
             annotation (extent=[-28,-10; -8,10]);
  Modelica_Fluid.Sensors.MassFlowRate masFlo2(redeclare package Medium = Medium) 
    "Mass flow rate sensor" annotation (extent=[0,-10; 20,10]);
  Buildings.Utilities.Controls.AssertEquality assEqu(threShold=1E-4, message=
        "Inputs differ, check that lossless pipe is correctly implemented.") 
    "Assert equality of the two mass flow rates" 
    annotation (extent=[60,-60; 80,-40]);
  Modelica_Fluid.Sensors.MassFlowRate masFlo1(redeclare package Medium = Medium) 
    "Mass flow rate sensor" annotation (extent=[4,30; 24,50]);
equation 
  connect(PAtm.y, sin1.p_in) 
                            annotation (points=[87,86; 94,86; 94,46; 86,46],
      style(color=74, rgbcolor={0,0,127}));
  connect(sou1.port, res1.port_a) 
                                annotation (points=[-48,40; -28,40],
                      style(color=69, rgbcolor={0,127,255}));
  connect(P.y, sou1.p_in) annotation (points=[-79,80; -74,80; -74,46; -70,46],
      style(color=74, rgbcolor={0,0,127}));
  connect(res2.port_b, masFlo2.port_a) annotation (points=[-8,6.10623e-16; -4,
        -3.36456e-22; -4,6.10623e-16; -5.55112e-16,6.10623e-16],style(color=69,
        rgbcolor={0,127,255}));
  connect(res1.port_b, masFlo1.port_a) 
    annotation (points=[-8,40; 4,40], style(color=69, rgbcolor={0,127,255}));
  connect(masFlo1.port_b, sin1.port) 
    annotation (points=[24,40; 64,40], style(color=69, rgbcolor={0,127,255}));
  connect(masFlo2.port_b, sin1.port) annotation (points=[20,6.10623e-16; 50,
        6.10623e-16; 50,40; 64,40], style(color=69, rgbcolor={0,127,255}));
  connect(sou1.port, res2.port_a) annotation (points=[-48,40; -38,40; -38,
        6.10623e-16; -28,6.10623e-16], style(color=69, rgbcolor={0,127,255}));
  connect(masFlo1.m_flow, assEqu.u1) annotation (points=[14,29; 14,18; 40,18;
        40,-44; 58,-44],
                 style(color=74, rgbcolor={0,0,127}));
  connect(masFlo2.m_flow, assEqu.u2) annotation (points=[10,-11; 10,-56; 58,-56],
                 style(color=74, rgbcolor={0,0,127}));
end FixedResistancesParallel;
