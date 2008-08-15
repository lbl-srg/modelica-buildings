model OAMixingBoxMinimumDamper 
  
  annotation (Diagram, Commands(file=
          "OAMixingBoxMinimumDamper.mos" "run"));
  
 package Medium = Buildings.Media.GasesPTDecoupled.SimpleAir 
    "Medium in the component" 
         annotation (choicesAllMatching = true);
  
  Buildings.Fluids.Actuators.Dampers.OAMixingBoxMinimumDamper mixBox(
    AOutMin=0.3,
    AOut=0.7,
    AExh=1,
    ARec=1,
    m0OutMin_flow=0.3,
    dp0OutMin=20,
    m0Out_flow=1,
    dp0Out=20,
    m0Rec_flow=1,
    dp0Rec=20,
    m0Exh_flow=1,
    dp0Exh=20,
    redeclare package Medium = Medium) "mixing box" 
                            annotation (extent=[14,-22; 34,-2]);
    Modelica_Fluid.Sources.PrescribedBoundary_pTX bouIn(redeclare package 
      Medium = Medium, T=273.15 + 10)                     annotation (extent=[-60,38;
        -40,58]);
    Modelica_Fluid.Sources.PrescribedBoundary_pTX bouSup(redeclare package 
      Medium = Medium, T=273.15 + 26)                                               annotation (extent=[68,-10;
        48,10]);
    Modelica_Fluid.Sources.PrescribedBoundary_pTX bouRet(redeclare package 
      Medium = Medium, T=273.15 + 20)                                 annotation (extent=[68,-90; 48,-70]);
    Modelica_Fluid.Sources.PrescribedBoundary_pTX bouExh(redeclare package 
      Medium = Medium, T=273.15 + 10)                    annotation (extent=[-60,-16; -40,4]);
    Modelica.Blocks.Sources.Constant PAtm(k=101325) 
      annotation (extent=[-100,10; -80,30]);
    Modelica.Blocks.Sources.Constant yDamMin(k=0.5) 
      annotation (extent=[-20,80; 0,100]);
    Modelica_Fluid.Sources.PrescribedBoundary_pTX bouIn2(redeclare package 
      Medium = Medium, T=273.15 + 10)                     annotation (extent=[-60,10; -40,30]);
    Modelica.Blocks.Sources.Ramp PSup(
    offset=101320,
    height=-10,
    startTime=0,
    duration=20) annotation (extent=[60,40; 80,60]);
    Modelica.Blocks.Sources.Ramp PRet(
    height=10,
    offset=101330,
    duration=20,
    startTime=20) 
                 annotation (extent=[60,-50; 80,-30]);
    Modelica.Blocks.Sources.Ramp yDam(
    duration=20,
    startTime=40,
    height=0.1,
    offset=0.45) annotation (extent=[-40,58; -20,78]);
  
equation 
  connect(yDamMin.y, mixBox.yOutMin) 
                               annotation (points=[1,90; 4,90; 4,-2; 12,-2],
      style(color=74, rgbcolor={0,0,127}));
  connect(yDam.y, mixBox.y) annotation (points=[-19,68; -4,68; -4,-6; 12,-6],
      style(color=74, rgbcolor={0,0,127}));
  connect(bouIn.p_in, PAtm.y) annotation (points=[-62,54; -72,54; -72,20; -79,
        20], style(color=74, rgbcolor={0,0,127}));
  connect(bouIn2.p_in, PAtm.y) annotation (points=[-62,26; -70,26; -70,20; -79,
        20], style(color=74, rgbcolor={0,0,127}));
  connect(bouExh.p_in, PAtm.y) annotation (points=[-62,1.22125e-15; -62,0; -76,
        0; -76,20; -79,20], style(color=74, rgbcolor={0,0,127}));
  connect(PRet.y, bouRet.p_in) annotation (points=[81,-40; 90,-40; 90,-74; 70,
        -74], style(color=74, rgbcolor={0,0,127}));
  connect(bouSup.p_in, PSup.y) annotation (points=[70,6; 92,6; 92,50; 81,50],
      style(color=74, rgbcolor={0,0,127}));
  connect(mixBox.port_Sup, bouSup.port) annotation (points=[33.8,-10; 40,-10;
        40,6.10623e-16; 48,6.10623e-16], style(color=69, rgbcolor={0,127,255}));
  connect(mixBox.port_Ret, bouRet.port) annotation (points=[34,-20; 42,-20; 42,
        -80; 48,-80], style(color=69, rgbcolor={0,127,255}));
  connect(bouIn.port, mixBox.port_OutMin) annotation (points=[-40,48; -8,48; -8,
        -10; 13.8,-10], style(color=69, rgbcolor={0,127,255}));
  connect(bouIn2.port, mixBox.port_Out) annotation (points=[-40,20; -12,20; -12,
        -14; 13.8,-14], style(color=69, rgbcolor={0,127,255}));
  connect(bouExh.port, mixBox.port_Exh) annotation (points=[-40,-6; -18,-6; -18,
        -20; 13.8,-20], style(color=69, rgbcolor={0,127,255}));
end OAMixingBoxMinimumDamper;
