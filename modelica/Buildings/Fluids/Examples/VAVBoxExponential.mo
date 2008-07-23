model VAVBoxExponential 
  
 annotation (Diagram, Commands(file=
            "VAVBoxExponential.mos" "run"));
 package Medium = Modelica.Media.Air.SimpleAir(T_min=Modelica.SIunits.Conversions.from_degC(-50)) 
    "Medium in the component" 
         annotation (choicesAllMatching = true);
  
  Buildings.Fluids.Actuators.Dampers.Exponential dam(
         redeclare package Medium = Medium, A=1.8) 
         annotation (extent=[20,10; 40,30]);
    Modelica.Blocks.Sources.Ramp yRam(
    duration=0.4, 
    height=-1, 
    offset=1, 
    startTime=0.6) 
                 annotation (extent=[-60,60; -40,80]);
    Modelica.Blocks.Sources.Ramp P(
    duration=0.4, 
    height=-10, 
    offset=101330, 
    startTime=0) annotation (extent=[-100,40; -80,60]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sou(redeclare package Medium = 
               Medium, T=273.15 + 20)   annotation (extent=[-70,10; -50,30]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sin(redeclare package Medium = 
               Medium, T=273.15 + 20)   annotation (extent=[72,10; 52,30]);
    Modelica.Blocks.Sources.Constant PAtm(k=101325) 
      annotation (extent=[60,60; 80,80]);
  Buildings.Fluids.Actuators.Dampers.VAVBoxExponential vav(
                                                        m0_flow=2,
    redeclare package Medium = Medium, 
    dp0=5, 
    A=1.8) 
         annotation (extent=[-2,-50; 18,-30]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sou1(redeclare package Medium 
      =                                                                         Medium,
     T=273.15 + 10)    annotation (extent=[-70,-50; -50,-30]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sin1(redeclare package Medium 
      =                                                                         Medium,
     T=273.15 + 10)    annotation (extent=[72,-50; 52,-30]);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM res(
    from_dp=true,
    m0_flow=2,
    redeclare package Medium = Medium, 
    dp0=5 - 0.45*2^2/1.2/1.8^2/2) 
             annotation (extent=[-36,10; -16,30]);
equation 
  connect(yRam.y,dam. y) annotation (points=[-39,70; -12,70; -12,28; 18,28],
      style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(P.y, sou.p_in) annotation (points=[-79,50; -78,50; -78,26; -72,26],
                                                                         style(
        color=74, rgbcolor={0,0,127}));
  connect(PAtm.y, sin.p_in) annotation (points=[81,70; 92,70; 92,26; 74,26],
                                                                        style(
        color=74, rgbcolor={0,0,127}));
  connect(yRam.y, vav.y) annotation (points=[-39,70; -12,70; -12,-32; -4,-32],
      style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(sou1.port, vav.port_a) 
    annotation (points=[-50,-40; -2,-40],
                                     style(color=69, rgbcolor={0,127,255}));
  connect(vav.port_b, sin1.port) 
    annotation (points=[18,-40; 52,-40],
                                     style(color=69, rgbcolor={0,127,255}));
  connect(PAtm.y, sin1.p_in) 
                         annotation (points=[81,70; 92,70; 92,-34; 74,-34],
                                                                        style(
        color=74, rgbcolor={0,0,127}));
  connect(sou.port, res.port_a) annotation (points=[-50,20; -36,20], style(
        color=69, rgbcolor={0,127,255}));
  connect(res.port_b, dam.port_a) 
    annotation (points=[-16,20; 20,20], style(color=69, rgbcolor={0,127,255}));
  connect(P.y, sou1.p_in) annotation (points=[-79,50; -78,50; -78,-34; -72,-34],
      style(color=74, rgbcolor={0,0,127}));
  connect(dam.port_b, sin.port) 
    annotation (points=[40,20; 52,20], style(color=69, rgbcolor={0,127,255}));
end VAVBoxExponential;
