model Damper 
  
    annotation (Diagram, Commands(file=
            "Damper.mos" "run"));
  
 package Medium = Modelica.Media.Air.SimpleAir(T_min=Modelica.SIunits.Conversions.from_degC(-50)) 
    "Medium in the component" 
           annotation (choicesAllMatching = true);
  
  Buildings.Fluids.Actuators.DamperExponential res(
    A=1,
    redeclare package Medium = Medium) 
         annotation (extent=[0,10; 20,30]);
    Modelica.Blocks.Sources.Ramp yRam(
    height=(50 - 20)/90,
    offset=20/90,
    duration=0.3) 
                 annotation (extent=[-60,60; -40,80]);
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
        Medium, T=293.15)                           annotation (extent=[74,10;
        54,30]);
    Modelica.Blocks.Sources.Constant PAtm(k=101325) 
      annotation (extent=[60,60; 80,80]);
  Modelica.Blocks.Sources.RealExpression simTim1(y=time) 
    annotation (extent=[-44,-16; -24,4]);
  Utilities.printer pri(
    samplePeriod=0.05,
    header=" time  y dp m_flow m_small_flow",
    fileName="outputRes.txt",
    nin=5) annotation (extent=[20,-30; 40,-10]);
  Modelica.Blocks.Sources.RealExpression res_m_flow(y=res.m_flow) 
    annotation (extent=[-42,-66; -22,-46]);
  Modelica.Blocks.Sources.RealExpression y(y=res.y) 
    annotation (extent=[-44,-32; -24,-12]);
  Modelica.Blocks.Sources.RealExpression res_dp(y=res.dp) 
    annotation (extent=[-42,-48; -22,-28]);
  Modelica.Blocks.Sources.RealExpression res_m_small_flow(y=res.m_small_flow) 
    annotation (extent=[-44,-86; -24,-66]);
equation 
  connect(yRam.y, res.y) annotation (points=[-39,70; -12,70; -12,28; -2,28],
      style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(simTim1.y, pri.x[1]) annotation (points=[-23,-6; -12,-6; -12,-21.6;
        18,-21.6],              style(color=74, rgbcolor={0,0,127}));
  connect(y.y, pri.x[2]) annotation (points=[-23,-22; -2,-22; -2,-20.8; 18,
        -20.8], style(color=74, rgbcolor={0,0,127}));
  connect(res_dp.y, pri.x[3]) annotation (points=[-21,-38; -2,-38; -2,-20; 18,
        -20], style(color=74, rgbcolor={0,0,127}));
  connect(res_m_small_flow.y, pri.x[5]) annotation (points=[-23,-76; -2,-76; -2,
        -18.4; 18,-18.4], style(color=74, rgbcolor={0,0,127}));
  connect(res_m_flow.y, pri.x[4]) annotation (points=[-21,-56; -6,-56; -6,-19.2;
        18,-19.2], style(color=74, rgbcolor={0,0,127}));
  connect(res.port_b, sin.port) 
    annotation (points=[20,20; 54,20], style(color=69, rgbcolor={0,127,255}));
  connect(res.port_a, sou.port) annotation (points=[-5.55112e-16,20; -48,20],
                         style(color=69, rgbcolor={0,127,255}));
  connect(P.y, sou.p_in) annotation (points=[-79,50; -74,50; -74,26; -70,26],
      style(color=74, rgbcolor={0,0,127}));
  connect(PAtm.y, sin.p_in) annotation (points=[81,70; 86,70; 86,26; 76,26],
      style(color=74, rgbcolor={0,0,127}));
end Damper;
