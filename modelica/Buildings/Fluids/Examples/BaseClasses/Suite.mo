model Suite "Model of a suite consisting of five rooms of the MIT system model" 
  extends Buildings.BaseClasses.BaseIconLow;
  
  replaceable package Medium = 
      Modelica.Media.Interfaces.PartialMedium "Medium in the component" 
             annotation (choicesAllMatching = true);
  
  annotation (Diagram, Icon(
      Text(
        extent=[-140,146; -108,106],
        style(color=3, rgbcolor={0,0,255}),
        string="y"),
      Rectangle(extent=[-90,-38; 392,-42],   style(
          color=69,
          gradient=2,
          fillColor=69)),
      Rectangle(extent=[-90,122; 392,118],   style(
          color=69,
          gradient=2,
          fillColor=69)),
      Rectangle(extent=[-92,22; 390,18],     style(
          color=69,
          gradient=2,
          fillColor=69)),
      Rectangle(extent=[18,118; 22,-38], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=69,
          rgbfillColor={0,128,255})),
      Rectangle(extent=[78,118; 82,-38], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=69,
          rgbfillColor={0,128,255})),
      Rectangle(extent=[140,118; 144,-38], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=69,
          rgbfillColor={0,128,255})),
      Rectangle(extent=[198,118; 202,20], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=69,
          rgbfillColor={0,128,255})),
      Rectangle(extent=[258,120; 262,22], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=69,
          rgbfillColor={0,128,255})),
      Rectangle(extent=[258,-20; 262,-38], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=69,
          rgbfillColor={0,128,255})),
      Rectangle(extent=[198,-8; 202,-38], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=69,
          rgbfillColor={0,128,255})),
      Rectangle(extent=[258,10; 262,-10], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=69,
          rgbfillColor={0,128,255})),
      Rectangle(extent=[198,10; 202,0], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=69,
          rgbfillColor={0,128,255})),
      Rectangle(extent=[200,4; 232,0],       style(
          color=69,
          gradient=2,
          fillColor=69)),
      Rectangle(extent=[228,-18; 262,-22],   style(
          color=69,
          gradient=2,
          fillColor=69)),
      Rectangle(extent=[198,-8; 262,-12],    style(
          color=69,
          gradient=2,
          fillColor=69)),
      Rectangle(extent=[228,2; 232,-20], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=69,
          rgbfillColor={0,128,255})),
      Text(
        extent=[-140,234; -96,192],
        style(color=3, rgbcolor={0,0,255}),
        string="PAtm"),
      Line(points=[-102,88; 240,88; 240,88], style(color=3, rgbcolor={0,0,255})),
      Line(points=[-98,180; 228,180; 230,180], style(color=3, rgbcolor={0,0,255})),
      Line(points=[230,180; 230,40; 260,20], style(color=3, rgbcolor={0,0,255})),
      Rectangle(extent=[254,78; 268,58], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=74,
          rgbfillColor={0,0,127})),
      Rectangle(extent=[194,78; 208,58], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=74,
          rgbfillColor={0,0,127})),
      Rectangle(extent=[134,78; 148,58], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=74,
          rgbfillColor={0,0,127})),
      Rectangle(extent=[72,78; 86,58], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=74,
          rgbfillColor={0,0,127})),
      Rectangle(extent=[12,78; 26,58], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=74,
          rgbfillColor={0,0,127})),
      Line(points=[170,180; 170,40; 200,20], style(color=3, rgbcolor={0,0,255})),
      Line(points=[110,180; 110,40; 140,20], style(color=3, rgbcolor={0,0,255})),
      Line(points=[50,180; 50,40; 80,20], style(color=3, rgbcolor={0,0,255})),
      Line(points=[-10,180; -10,40; 20,20], style(color=3, rgbcolor={0,0,255})),
      Line(points=[240,88; 256,76], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=74,
          rgbfillColor={0,0,127},
          fillPattern=1)),
      Line(points=[180,88; 196,76], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=74,
          rgbfillColor={0,0,127},
          fillPattern=1)),
      Line(points=[120,88; 136,76], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=74,
          rgbfillColor={0,0,127},
          fillPattern=1)),
      Line(points=[60,88; 76,76], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=74,
          rgbfillColor={0,0,127},
          fillPattern=1)),
      Line(points=[0,88; 16,76], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=74,
          rgbfillColor={0,0,127},
          fillPattern=1))),
    Documentation(info="<html>
<p>
Model of a suite consisting of five rooms for the MIT system model.
</p></html>", revisions="<html>
<ul>
<li>
July 20, 2007 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Coordsys(extent=[-100,-100; 400,200]));
  
  Modelica.Blocks.Interfaces.RealInput p(redeclare type SignalType = 
        Modelica.SIunits.AbsolutePressure) "Pressure" 
    annotation (extent=[-140,160; -100,200]);
  Modelica_Fluid.Interfaces.FluidPort_b port_aSup(redeclare package Medium = 
        Medium)                 annotation (extent=[-110,110; -90,130]);
  parameter Modelica.SIunits.MassFlowRate m0Tot_flow = vav39.m0_flow+vav40.m0_flow+vav41.m0_flow+vav42.m0_flow+vav43.m0_flow;
  
  Buildings.Fluids.FixedResistances.SplitterFixedResistanceDpM spl34(
                                              m0_flow=ones(3), dp0={0.176,0.844,
        0.0662},
    redeclare package Medium = Medium)                             annotation (extent=[10,110; 
        30,130]);
  Buildings.Fluids.FixedResistances.SplitterFixedResistanceDpM mix55(
                                              m0_flow=ones(3), dp0=1E3*{
        0.263200E-02,0.999990E-03,0.649000E-03},
    redeclare package Medium = Medium) 
    annotation (extent=[10,-30; 30,-50]);
  Buildings.Fluids.Actuators.Dampers.VAVBoxExponential vav39(
    A=0.49,
    m0_flow=4.33*1.2,
    dp0=0.999E2,
    redeclare package Medium = Medium) 
    annotation (extent=[10,50; 30,70],  rotation=270);
  Buildings.Fluids.FixedResistances.FixedResistanceDpM res13(
                                      m0_flow=1, dp0=0.1E3,
    redeclare package Medium = Medium) 
    annotation (extent=[40,10; 60,30]);
  Buildings.Fluids.Actuators.Dampers.VAVBoxExponential vav40(
    A=0.245,
    m0_flow=2.369*1.2,
    dp0=0.999E2,
    redeclare package Medium = Medium) 
    annotation (extent=[70,50; 90,70],  rotation=270);
  Buildings.Fluids.Actuators.Dampers.VAVBoxExponential vav41(
    dp0=0.999E2,
    A=0.128,
    m0_flow=0.837*1.2,
    redeclare package Medium = Medium) 
    annotation (extent=[130,50; 150,70],rotation=270);
  Buildings.Fluids.Actuators.Dampers.VAVBoxExponential vav42(
    dp0=0.999E2,
    A=0.128,
    m0_flow=0.801*1.2,
    redeclare package Medium = Medium) 
    annotation (extent=[190,50; 210,70],rotation=270);
  Buildings.Fluids.Actuators.Dampers.VAVBoxExponential vav43(
    dp0=0.999E2,
    A=0.0494,
    m0_flow=0.302*1.2,
    redeclare package Medium = Medium) 
    annotation (extent=[250,48; 270,68],rotation=270);
  Buildings.Fluids.FixedResistances.FixedResistanceDpM res14(
                                      m0_flow=1, dp0=0.1E3,
    redeclare package Medium = Medium) 
    annotation (extent=[100,10; 120,30]);
  Buildings.Fluids.FixedResistances.FixedResistanceDpM res15(
                                      m0_flow=1, dp0=0.1E3,
    redeclare package Medium = Medium) 
    annotation (extent=[160,10; 180,30]);
  Buildings.Fluids.FixedResistances.FixedResistanceDpM res16(
                                      m0_flow=1, dp0=0.1E3,
    redeclare package Medium = Medium) 
    annotation (extent=[220,10; 240,30]);
  Buildings.Fluids.FixedResistances.FixedResistanceDpM res17(
                                      m0_flow=1, dp0=0.1E3,
    redeclare package Medium = Medium) 
    annotation (extent=[280,10; 300,30]);
  Buildings.Fluids.FixedResistances.SplitterFixedResistanceDpM spl35(
                                              m0_flow=ones(3), dp0=1E3*{
        0.371000E-04,0.259000E-02,0.131000E-02},
    redeclare package Medium = Medium)                             annotation (extent=[70,110; 
        90,130]);
  Buildings.Fluids.FixedResistances.SplitterFixedResistanceDpM spl36(
                                              m0_flow=ones(3), dp0=1E3*{
        0.211000E-03,0.128000E-01,0.223000E-02},
    redeclare package Medium = Medium)                             annotation (extent=[130,110; 
        150,130]);
  Buildings.Fluids.FixedResistances.SplitterFixedResistanceDpM spl37(
                                              m0_flow=ones(3), dp0=1E3*{
        0.730000E-03,0.128000E-01,0.938000E-02},
    redeclare package Medium = Medium)                             annotation (extent=[190,110; 
        210,130]);
  Buildings.Fluids.FixedResistances.SplitterFixedResistanceDpM spl38(
                                              m0_flow=ones(3), dp0=1E3*{
        0.731000E-02,0.895000E-01,0.942000E-01},
    redeclare package Medium = Medium)                             annotation (extent=[250,110; 
        270,130]);
  Buildings.Fluids.FixedResistances.SplitterFixedResistanceDpM mix54(
                                              m0_flow=ones(3), dp0=1E3*{
        0.653000E-02,0.271000E-03,0.402000E-04},
    redeclare package Medium = Medium) 
    annotation (extent=[70,-30; 90,-50]);
  Buildings.Fluids.FixedResistances.SplitterFixedResistanceDpM mix53(
                                              m0_flow=ones(3), dp0=1E3*{
        0.566000E-01,0.541000E-02,0.749000E-04},
    redeclare package Medium = Medium) 
    annotation (extent=[130,-30; 150,-50]);
  Buildings.Fluids.FixedResistances.SplitterFixedResistanceDpM mix52(
                                              m0_flow=ones(3), dp0=1E3*{
        0.353960,0.494000E-03,0.922000E-03},
    redeclare package Medium = Medium) 
    annotation (extent=[190,-30; 210,-50]);
  Buildings.Fluids.FixedResistances.SplitterFixedResistanceDpM mix51(
                                              m0_flow=ones(3), dp0=1E3*{
        0.847600E-01,1.89750,0.150000E-02},
    redeclare package Medium = Medium) 
    annotation (extent=[250,-30; 270,-50]);
  Buildings.Fluids.Examples.BaseClasses.RoomLeakage lea45(redeclare package 
      Medium = 
        Medium) "Room leakage model" 
    annotation (extent=[30,140; 50,160],  rotation=270);
  Buildings.Fluids.Examples.BaseClasses.RoomLeakage lea46(redeclare package 
      Medium = 
        Medium) "Room leakage model" 
    annotation (extent=[90,140; 110,160], rotation=270);
  Buildings.Fluids.Examples.BaseClasses.RoomLeakage lea47(redeclare package 
      Medium = 
        Medium) "Room leakage model" 
    annotation (extent=[150,140; 170,160],rotation=270);
  Buildings.Fluids.Examples.BaseClasses.RoomLeakage lea48(redeclare package 
      Medium = 
        Medium) "Room leakage model" 
    annotation (extent=[210,140; 230,160],rotation=270);
  Buildings.Fluids.Examples.BaseClasses.RoomLeakage lea49(redeclare package 
      Medium = 
        Medium) "Room leakage model" 
    annotation (extent=[270,140; 290,160],rotation=270);
  Buildings.Fluids.Components.MixingVolume roo45(redeclare package Medium = Medium,
    V=10*5*2.5,
    nP=5,
    initType=Modelica_Fluid.Types.Init.SteadyStateHydraulic) 
                          annotation (extent=[10,10; 30,30]);
  Buildings.Fluids.Components.MixingVolume roo46(redeclare package Medium = Medium,
    V=10*5*2.5,
    nP=5,
    initType=Modelica_Fluid.Types.Init.SteadyStateHydraulic) 
                          annotation (extent=[70,10; 90,30]);
  Buildings.Fluids.Components.MixingVolume roo47(redeclare package Medium = Medium,
    V=10*5*2.5,
    nP=5,
    initType=Modelica_Fluid.Types.Init.SteadyStateHydraulic) 
                          annotation (extent=[130,10; 150,30]);
  Buildings.Fluids.Components.MixingVolume roo48(redeclare package Medium = Medium,
    V=10*5*2.5,
    nP=5,
    initType=Modelica_Fluid.Types.Init.SteadyStateHydraulic) 
                          annotation (extent=[190,10; 210,30]);
  Buildings.Fluids.Components.MixingVolume roo49(redeclare package Medium = Medium,
    V=10*5*2.5,
    nP=5,
    initType=Modelica_Fluid.Types.Init.SteadyStateHydraulic) 
                          annotation (extent=[250,10; 270,30]);
  Modelica_Fluid.Interfaces.FluidPort_b port_bSup(redeclare package Medium = 
        Medium)                 annotation (extent=[390,110; 410,130]);
  Modelica_Fluid.Interfaces.FluidPort_b port_bExh(redeclare package Medium = 
        Medium)                 annotation (extent=[-110,-50; -90,-30]);
  Modelica_Fluid.Interfaces.FluidPort_b port_aExh(redeclare package Medium = 
        Medium)                 annotation (extent=[392,-50; 412,-30]);
  Modelica_Fluid.Interfaces.FluidPort_b port_aRoo(redeclare package Medium = 
        Medium)                 annotation (extent=[-110,10; -90,30]);
  Modelica_Fluid.Interfaces.FluidPort_b port_bRoo(redeclare package Medium = 
        Medium)                 annotation (extent=[390,10; 410,30]);
  Modelica.Blocks.Interfaces.RealInput yDam(redeclare type SignalType = Real) 
    "Damper signal" 
    annotation (extent=[-140,68; -100,108]);
equation 
  connect(spl34.port_3,vav39. port_a)                      annotation (points=[20,110; 
        20,90; 20,70; 20,70],    style(color=69, rgbcolor={0,127,255}));
  connect(vav39.port_b,roo45.port[1])  annotation (points=[20,50; 20,34.6; 20,
        34.6; 20,19.2],
      style(
      color=69,
      rgbcolor={0,127,255},
      gradient=3,
      fillColor=3,
      rgbfillColor={0,0,255}));
  connect(mix55.port_3,roo45.port[2])  annotation (points=[20,-30; 20,19.6],
      style(
      color=69,
      rgbcolor={0,127,255},
      gradient=3,
      fillColor=3,
      rgbfillColor={0,0,255}));
  connect(roo45.port[3],res13. port_a) annotation (points=[20,20; 40,20],     style(
      color=3,
      rgbcolor={0,0,255},
      gradient=3,
      fillColor=3,
      rgbfillColor={0,0,255}));
  connect(res13.port_b,roo46.port[1])  annotation (points=[60,20; 70,20; 70,
        19.2; 80,19.2],                                                       style(
      color=69,
      rgbcolor={0,127,255},
      gradient=3,
      fillColor=3,
      rgbfillColor={0,0,255}));
  connect(vav40.port_b,roo46.port[2])  annotation (points=[80,50; 80,19.6], style(
      color=69,
      rgbcolor={0,127,255},
      gradient=3,
      fillColor=3,
      rgbfillColor={0,0,255}));
  connect(vav41.port_b,roo47.port[1])  annotation (points=[140,50; 140,19.2],
                                                                            style(
      color=69,
      rgbcolor={0,127,255},
      gradient=3,
      fillColor=3,
      rgbfillColor={0,0,255}));
  connect(vav42.port_b,roo48.port[1])  annotation (points=[200,50; 200,19.2],
                                                                            style(
      color=69,
      rgbcolor={0,127,255},
      gradient=3,
      fillColor=3,
      rgbfillColor={0,0,255}));
  connect(vav43.port_b,roo49.port[1])  annotation (points=[260,48; 260,19.2],
                                                                            style(
      color=69,
      rgbcolor={0,127,255},
      gradient=3,
      fillColor=3,
      rgbfillColor={0,0,255}));
  connect(spl34.port_2,spl35. port_1) annotation (points=[31,120; 69,120],
      style(color=69, rgbcolor={0,127,255}));
  connect(spl35.port_2,spl36. port_1) annotation (points=[91,120; 129,120],
      style(color=69, rgbcolor={0,127,255}));
  connect(spl36.port_2,spl37. port_1) annotation (points=[151,120; 189,120],
      style(color=69, rgbcolor={0,127,255}));
  connect(spl35.port_3,vav40. port_a) annotation (points=[80,110; 80,70],
      style(color=69, rgbcolor={0,127,255}));
  connect(spl36.port_3,vav41. port_a) annotation (points=[140,110; 140,70],
      style(color=69, rgbcolor={0,127,255}));
  connect(spl37.port_3,vav42. port_a) annotation (points=[200,110; 200,70],
      style(color=69, rgbcolor={0,127,255}));
  connect(roo46.port[3],mix54. port_3) 
    annotation (points=[80,20; 80,-30],    style(color=3, rgbcolor={0,0,255}));
  connect(roo47.port[2],mix53. port_3) 
    annotation (points=[140,19.6; 140,-30],style(color=3, rgbcolor={0,0,255}));
  connect(roo47.port[3],res15. port_a) 
    annotation (points=[140,20; 160,20],   style(color=3, rgbcolor={0,0,255}));
  connect(res15.port_b,roo48.port[2])  annotation (points=[180,20; 190,20; 190,
        19.6; 200,19.6],                                                      style(
        color=69, rgbcolor={0,127,255}));
  connect(roo47.port[4],res14. port_b) 
    annotation (points=[140,20.4; 130,20.4; 130,20; 120,20],
                                           style(color=3, rgbcolor={0,0,255}));
  connect(res14.port_a,roo46.port[4])  annotation (points=[100,20; 90,20; 90,
        20.4; 80,20.4],                                                       style(
        color=69, rgbcolor={0,127,255}));
  connect(mix55.port_2,mix54. port_1) annotation (points=[31,-40; 69,-40],
      style(color=69, rgbcolor={0,127,255}));
  connect(mix54.port_2,mix53. port_1) annotation (points=[91,-40; 129,-40],
      style(color=69, rgbcolor={0,127,255}));
  connect(mix53.port_2,mix52. port_1) annotation (points=[151,-40; 189,-40],
                       style(color=69, rgbcolor={0,127,255}));
  connect(mix52.port_2,mix51. port_1) annotation (points=[211,-40; 249,-40],
      style(color=69, rgbcolor={0,127,255}));
  connect(roo48.port[3],mix51. port_3) annotation (points=[200,20; 200,-12; 260,
        -12; 260,-30],
                  style(color=3, rgbcolor={0,0,255}));
  connect(roo48.port[4],res16. port_a) 
    annotation (points=[200,20.4; 210,20.4; 210,20; 220,20],
                                           style(color=3, rgbcolor={0,0,255}));
  connect(res16.port_b,roo49.port[2]) 
                                  annotation (points=[240,20; 250,20; 250,19.6;
        260,19.6],                                                       style(
        color=69, rgbcolor={0,127,255}));
  connect(roo49.port[3],mix52. port_3) annotation (points=[260,20; 260,-6; 232,
        -6; 232,-20; 200,-20; 200,-30],
                                    style(color=3, rgbcolor={0,0,255}));
  connect(roo49.port[4],res17. port_a) 
    annotation (points=[260,20.4; 270,20.4; 270,20; 280,20],
                                           style(color=3, rgbcolor={0,0,255}));
  connect(spl37.port_2,spl38. port_1) annotation (points=[211,120; 249,120],
      style(color=69, rgbcolor={0,127,255}));
  connect(vav43.port_a,spl38. port_3) annotation (points=[260,68; 260,110],
             style(color=69, rgbcolor={0,127,255}));
  connect(lea45.port_b,roo45.port[4]) annotation (points=[40,140; 40,20.4; 20,
        20.4],
      style(color=69, rgbcolor={0,127,255}));
  connect(lea46.port_b,roo46.port[5]) annotation (points=[100,140; 100,20.8; 80,
        20.8],
      style(color=69, rgbcolor={0,127,255}));
  connect(lea47.port_b,roo47.port[5]) annotation (points=[160,140; 160,20.8;
        140,20.8],
      style(color=69, rgbcolor={0,127,255}));
  connect(lea48.port_b,roo48.port[5]) annotation (points=[220,140; 220,20.8;
        200,20.8],
      style(color=69, rgbcolor={0,127,255}));
  connect(lea49.port_b,roo49.port[5]) annotation (points=[280,140; 280,20.8;
        260,20.8],
      style(color=69, rgbcolor={0,127,255}));
  connect(port_aSup, spl34.port_1) annotation (points=[-100,120; 9,120], style(
        color=69, rgbcolor={0,127,255}));
  connect(port_bSup, spl38.port_2) annotation (points=[400,120; 271,120], style(
        color=69, rgbcolor={0,127,255}));
  connect(port_bExh, mix55.port_1) annotation (points=[-100,-40; 9,-40], style(
        color=69, rgbcolor={0,127,255}));
  connect(port_aExh, mix51.port_2) annotation (points=[402,-40; 271,-40], style(
        color=69, rgbcolor={0,127,255}));
  connect(port_bRoo, res17.port_b) annotation (points=[400,20; 300,20], style(
        color=69, rgbcolor={0,127,255}));
  connect(port_aRoo, roo45.port[5]) annotation (points=[-100,20; -42,20; -42,
        20.8; 20,20.8],                                                  style(color=69,
        rgbcolor={0,127,255}));
  connect(yDam, vav39.y) annotation (points=[-120,88; 28,88; 28,72], style(
        color=74, rgbcolor={0,0,127}));
  connect(yDam, vav40.y) annotation (points=[-120,88; 88,88; 88,72], style(
        color=74, rgbcolor={0,0,127}));
  connect(yDam, vav42.y) annotation (points=[-120,88; 208,88; 208,72], style(
        color=74, rgbcolor={0,0,127}));
  connect(yDam, vav43.y) annotation (points=[-120,88; 268,88; 268,70], style(
        color=74, rgbcolor={0,0,127}));
  connect(p, lea45.p) annotation (points=[-120,180; 40,180; 40,162], style(
        color=74, rgbcolor={0,0,127}));
  connect(p, lea46.p) annotation (points=[-120,180; 100,180; 100,162], style(
        color=74, rgbcolor={0,0,127}));
  connect(p, lea47.p) annotation (points=[-120,180; 160,180; 160,162], style(
        color=74, rgbcolor={0,0,127}));
  connect(p, lea48.p) annotation (points=[-120,180; 220,180; 220,162], style(
        color=74, rgbcolor={0,0,127}));
  connect(p, lea49.p) annotation (points=[-120,180; 280,180; 280,162], style(
        color=74, rgbcolor={0,0,127}));
  connect(yDam, vav41.y) annotation (points=[-120,88; 148,88; 148,72], style(
      color=74,
      rgbcolor={0,0,127},
      gradient=1,
      fillColor=69,
      rgbfillColor={0,128,255}));
end Suite;
