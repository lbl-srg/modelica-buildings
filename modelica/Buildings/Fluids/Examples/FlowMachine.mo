model FlowMachine 
  
    annotation (Diagram, Commands(file=
            "FlowMachine.mos" "run"));
   //package Medium = Buildings.Media.IdealGases.SimpleAir;
    package Medium =  Buildings.Media.PerfectGases.MoistAir;
    Modelica.Blocks.Sources.Ramp P(
    height=-1500,
    offset=101325,
    duration=1.5) 
                 annotation (extent=[-80,-10; -60,10]);
  Buildings.Fluids.Movers.FlowMachinePolynomial fan(
    D=0.6858,
    a={4.2904,-1.387,4.2293,-3.92920,0.8534},
    b={0.1162,1.5404,-1.4825,0.7664,-0.1971},
    mNorMin_flow=1,
    mNorMax_flow=2,
    redeclare package Medium = Medium) 
                    annotation (extent=[0,-10; 20,10]);
  Modelica.Blocks.Sources.Constant N(k=22.3333) 
                                         annotation (extent=[-40,50; -20,70]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sou(redeclare package Medium = 
        Medium, T=293.15)                           annotation (extent=[-42,-10; -22,10]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sin(redeclare package Medium = 
        Medium, T=293.15)                           annotation (extent=[60,-10; 40,10]);
    Modelica.Blocks.Sources.Constant PAtm(k=101325) 
      annotation (extent=[40,32; 60,52]);
  Utilities.printer printer(
    fileName="outputFan.txt",
    nin=6,
    header="time dp dpNorm mNorm m_flow power") 
    annotation (extent=[16,-42; 36,-22]);
  Modelica.Blocks.Sources.RealExpression fan_mFlow(y=fan.m_flow) 
    annotation (extent=[-40,-94; -20,-74]);
  Modelica.Blocks.Sources.RealExpression simTim2(y=time) 
    annotation (extent=[-40,-32; -20,-12]);
  Modelica.Blocks.Sources.RealExpression fan_dp(y=fan.dp) 
    annotation (extent=[-40,-48; -20,-28]);
  Modelica.Blocks.Sources.RealExpression fan_dpNor(y=fan.pNor) 
    annotation (extent=[-40,-64; -20,-44]);
  Modelica.Blocks.Sources.RealExpression fan_mNor(y=fan.mNor_flow) 
    annotation (extent=[-40,-80; -20,-60]);
  Modelica.Blocks.Sources.RealExpression fan_PSha(y=fan.PSha) 
    annotation (extent=[-40,-106; -20,-86]);
equation 
  
  annotation (Diagram);
  connect(simTim2.y, printer.x[1]) annotation (points=[-19,-22; -2,-22; -2,
        -33.6667; 14,-33.6667], style(color=74, rgbcolor={0,0,127}));
  connect(fan_dp.y, printer.x[2]) annotation (points=[-19,-38; -4,-38; -4,-33;
        14,-33], style(color=74, rgbcolor={0,0,127}));
  connect(fan_dpNor.y, printer.x[3]) annotation (points=[-19,-54; -8,-54; -8,
        -32.3333; 14,-32.3333], style(color=74, rgbcolor={0,0,127}));
  connect(fan_mNor.y, printer.x[4]) annotation (points=[-19,-70; -8,-70; -8,
        -31.6667; 14,-31.6667], style(color=74, rgbcolor={0,0,127}));
  connect(fan_PSha.y, printer.x[6]) annotation (points=[-19,-96; 0,-96; 0,
        -30.3333; 14,-30.3333], style(color=74, rgbcolor={0,0,127}));
  connect(fan_mFlow.y, printer.x[5]) annotation (points=[-19,-84; -6,-84; -6,
        -31; 14,-31], style(color=74, rgbcolor={0,0,127}));
  connect(sin.port, fan.port_b) annotation (points=[40,6.10623e-16; 30,
        -3.36456e-22; 30,6.10623e-16; 20,6.10623e-16], style(color=69, rgbcolor=
         {0,127,255}));
  connect(sou.port, fan.port_a) annotation (points=[-22,6.10623e-16; -12,
        -3.36456e-22; -12,6.10623e-16; -5.55112e-16,6.10623e-16], style(color=
          69, rgbcolor={0,127,255}));
  connect(N.y, fan.N_in) annotation (points=[-19,60; -10,60; -10,6; -1,6],
      style(color=74, rgbcolor={0,0,127}));
  connect(P.y, sou.p_in) annotation (points=[-59,6.10623e-16; -51.5,6.10623e-16; 
        -51.5,6; -44,6], style(color=74, rgbcolor={0,0,127}));
  connect(PAtm.y, sin.p_in) annotation (points=[61,42; 74,42; 74,6; 62,6],
      style(color=74, rgbcolor={0,0,127}));
end FlowMachine;
