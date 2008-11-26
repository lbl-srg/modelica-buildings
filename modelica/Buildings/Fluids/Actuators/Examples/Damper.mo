model Damper 
  
    annotation (Diagram, Commands(file=
            "Damper.mos" "run"));
  
 package Medium = Buildings.Media.IdealGases.SimpleAir;
  
  Buildings.Fluids.Actuators.Dampers.Exponential res(
    A=1,
    redeclare package Medium = Medium) 
         annotation (extent=[0,10; 20,30]);
    Modelica.Blocks.Sources.Ramp yRam(
    duration=0.3, 
    height=1, 
    offset=0, 
    startTime=0.2) 
                 annotation (extent=[-60,60; -40,80]);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sou(redeclare package Medium = 
        Medium, T=293.15)                           annotation (extent=[-68,10;
        -48,30]);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sin(redeclare package Medium = 
        Medium, T=293.15)                           annotation (extent=[74,10;
        54,30]);
    Modelica.Blocks.Sources.Constant PAtm(k=101325) 
      annotation (extent=[60,60; 80,80]);
  Buildings.Fluids.Actuators.Dampers.Exponential res1(
    A=1,
    redeclare package Medium = Medium) 
         annotation (extent=[0,-90; 20,-70]);
    Modelica.Blocks.Sources.Ramp yRam1(
    duration=0.3, 
    height=1, 
    offset=0)    annotation (extent=[-60,-40; -40,-20]);
    Modelica.Blocks.Sources.Ramp P1(
    duration=0.5,
    startTime=0.5,
    height=-10,
    offset=101330) 
                 annotation (extent=[-100,-60; -80,-40]);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sou1(
                                                    redeclare package Medium = 
        Medium, T=293.15)                           annotation (extent=[-68,-90; 
        -48,-70]);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sin1(
                                                    redeclare package Medium = 
        Medium, T=293.15)                           annotation (extent=[74,-90; 
        54,-70]);
    Modelica.Blocks.Sources.Constant PAtm1(
                                          k=101325) 
      annotation (extent=[60,-40; 80,-20]);
    Modelica.Blocks.Sources.Constant PAtm0(k=101335) 
      annotation (extent=[-100,16; -80,36]);
equation 
  connect(yRam.y, res.y) annotation (points=[-39,70; -12,70; -12,28; -2,28],
      style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(res.port_b, sin.port) 
    annotation (points=[20,20; 54,20], style(color=69, rgbcolor={0,127,255}));
  connect(res.port_a, sou.port) annotation (points=[-5.55112e-16,20; -48,20],
                         style(color=69, rgbcolor={0,127,255}));
  connect(PAtm.y, sin.p_in) annotation (points=[81,70; 86,70; 86,26; 76,26],
      style(color=74, rgbcolor={0,0,127}));
  connect(yRam1.y, res1.y) 
                         annotation (points=[-39,-30; -12,-30; -12,-72; -2,-72],
      style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(res1.port_b, sin1.port) 
    annotation (points=[20,-80; 54,-80],
                                       style(color=69, rgbcolor={0,127,255}));
  connect(res1.port_a, sou1.port) 
                                annotation (points=[-5.55112e-16,-80; -48,-80],
                         style(color=69, rgbcolor={0,127,255}));
  connect(P1.y, sou1.p_in) 
                         annotation (points=[-79,-50; -74,-50; -74,-74; -70,-74],
      style(color=74, rgbcolor={0,0,127}));
  connect(PAtm1.y, sin1.p_in) 
                            annotation (points=[81,-30; 86,-30; 86,-74; 76,-74],
      style(color=74, rgbcolor={0,0,127}));
  connect(PAtm0.y, sou.p_in)
    annotation (points=[-79,26; -70,26], style(color=74, rgbcolor={0,0,127}));
end Damper;
