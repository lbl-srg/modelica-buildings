model SplitterFixedResistanceDpM 
  
  annotation (Diagram, Commands(file=
          "SplitterFixedResistanceDpM.mos" "run"));
  
 package Medium = Buildings.Media.IdealGases.SimpleAir;
  
  Buildings.Fluids.FixedResistances.SplitterFixedResistanceDpM spl(
    m0_flow={1,2,3},
    dp0={5,10,15},
    dh={1,2,3},
    redeclare package Medium = Medium) "Splitter" 
    annotation (extent=[-16,-10; 4,10]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX bou1(redeclare package Medium 
      =        Medium, T=273.15 + 10) annotation (extent=[-58,-10;
        -38,10]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX bou2(redeclare package Medium 
      =        Medium, T=273.15 + 20) annotation (extent=[52,-10;
        32,10]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX bou3(redeclare package Medium 
      =        Medium, T=273.15 + 30) annotation (extent=[-58,-66; -38,-46]);
    Modelica.Blocks.Sources.Constant P2(k=101325) 
      annotation (extent=[40,54; 60,74]);
    Modelica.Blocks.Sources.Ramp P1(
    offset=101320,
    height=10,
    duration=0.5) 
                 annotation (extent=[-100,-4; -80,16]);
    Modelica.Blocks.Sources.Ramp P3(
      offset=101320,
      height=10,
    duration=0.5,
    startTime=0.5) 
                 annotation (extent=[-100,-60; -80,-40]);
equation 
  connect(P1.y, bou1.p_in) 
    annotation (points=[-79,6; -74.25,6; -74.25,6; -69.5,6; -69.5,6; -60,6],
                                       style(color=74, rgbcolor={0,0,127}));
  connect(bou1.port, spl.port_1) annotation (points=[-38,6.10623e-16; -32.75,
        6.10623e-16; -32.75,1.22125e-15; -27.5,1.22125e-15; -27.5,6.10623e-16; 
        -17,6.10623e-16],
            style(color=69, rgbcolor={0,127,255}));
  connect(spl.port_2, bou2.port) 
    annotation (points=[5,6.10623e-16; 11.75,6.10623e-16; 11.75,1.22125e-15; 
        18.5,1.22125e-15; 18.5,6.10623e-16; 32,6.10623e-16],
                                    style(color=69, rgbcolor={0,127,255}));
  connect(P2.y, bou2.p_in) annotation (points=[61,64; 74,64; 74,6; 54,6], style(
        color=74, rgbcolor={0,0,127}));
  connect(bou3.port, spl.port_3) annotation (points=[-38,-56; -6,-56; -6,-10],
      style(color=69, rgbcolor={0,127,255}));
  connect(bou3.p_in, P3.y) 
    annotation (points=[-60,-50; -79,-50],
                                         style(color=74, rgbcolor={0,0,127}));
end SplitterFixedResistanceDpM;
