model MITScalable "System model for MIT building" 
  
   annotation (Diagram, Commands(file=
          "MITScalable.mos" "run"),
    experiment(
      Tolerance=1e-006));
  
// package Medium = Buildings.Media.IdealGases.SimpleAir
// package Medium = Modelica.Media.Air.SimpleAir;
// package Medium = Modelica.Media.Air.MoistAir;
// package Medium = Buildings.Media.GasesPTDecoupled.SimpleAir;
// package Medium = Buildings.Media.PerfectGases.MoistAir;
// this currently does not converge package Medium = Buildings.Media.PerfectGases.MoistAirNonsaturated;
  package Medium = Buildings.Media.GasesPTDecoupled.MoistAir;
  
  parameter Integer NSui = 1 "Number of suites";
  parameter Modelica.SIunits.MassFlowRate mOneSuite_flow = sui[1].m0Tot_flow 
    "Nominal mass flow rate of one suite";
  parameter Modelica.SIunits.MassFlowRate mMIT_flow = mOneSuite_flow + vav44.m0_flow 
    "Nominal mass flow rate of MIT system model as in ASHRAE 825-RP";
  
  parameter Modelica.SIunits.Pressure dp0SuiSup = 95 
    "Pressure drop supply air leg with splitters of one suite (obtained from simulation)";
  parameter Modelica.SIunits.Pressure dp0SuiRet = 233 
    "Pressure drop return air leg with splitters of one suite (obtained from simulation)";
  parameter Modelica.SIunits.Pressure dp0FanSupMIT = 1050 
    "Pressure increase over supply fan in MIT system model as in ASHRAE 825-RP (obtained from simulation)";
  parameter Modelica.SIunits.Pressure dp0FanRetMIT = 347 
    "Pressure increase over supply fan in MIT system model as in ASHRAE 825-RP (obtained from simulation)";
  
  parameter Real scaM_flow = ( mMIT_flow + (NSui-1) * mOneSuite_flow)  / mMIT_flow 
    "Scaling factor for mass flow rate with NSui number of suites";
  parameter Real scaDp0FanSup = ( dp0FanSupMIT + (NSui-1) * dp0SuiSup) / dp0FanSupMIT 
    "Scaling factor for supply fan pressure lift with NSui number of suites";
  parameter Real scaDp0FanRet = ( dp0FanRetMIT + (NSui-1) * dp0SuiRet)  / dp0FanRetMIT 
    "Scaling factor for supply fan pressure lift with NSui number of suites";
  
  Buildings.Fluids.Actuators.Dampers.OAMixingBoxMinimumDamper mixBox(
    dp0Out=0.467,
    dp0Rec=0.665,
    dp0Exh=0.164,
    dp0OutMin=0.467,
    AOutMin=scaM_flow*0.38,
    AOut=scaM_flow*1.32,
    AExh=scaM_flow*1.05,
    ARec=scaM_flow*1.05,
    m0OutMin_flow=scaM_flow*0.1*1,
    m0Out_flow=scaM_flow*1,
    m0Rec_flow=scaM_flow*1,
    m0Exh_flow=scaM_flow*1,
    redeclare package Medium = Medium) "mixing box" 
                            annotation (extent=[20,-42; 40,-22], style(
        thickness=2));
    Modelica_Fluid.Sources.PrescribedBoundary_pTX bouIn(redeclare package 
      Medium = Medium, T=293.15)                        annotation (extent=[-40,10;
        -20,30], style(thickness=2));
    Modelica_Fluid.Sources.PrescribedBoundary_pTX bouExh(redeclare package 
      Medium = Medium, T=293.15)                         annotation (extent=[-40,-50;
        -20,-30], style(thickness=2));
    Modelica.Blocks.Sources.Constant PAtm(k=101325) 
      annotation (extent=[-80,-20; -60,0], style(thickness=2));
    Modelica.Blocks.Sources.Constant yMinOA(k=0.5) 
      annotation (extent=[-40,40; -20,60], style(thickness=2));
    Modelica_Fluid.Sources.PrescribedBoundary_pTX bouIn2(redeclare package 
      Medium = Medium, T=293.15)                          annotation (extent=[-40,-20;
        -20,0], style(thickness=2));
  Buildings.Fluids.FixedResistances.FixedResistanceDpM res31(
                                                 dp0=0.546,
    m0_flow=scaM_flow*1,
    dh=sqrt(scaM_flow)*1,
    redeclare package Medium = Medium) 
    annotation (extent=[58,4; 78,24], style(thickness=2));
  Buildings.Fluids.Movers.FlowMachinePolynomial fan32(
    D=0.6858,
    a={4.2904,-1.387,4.2293,-3.92920,0.8534},
    b={0.1162,1.5404,-1.4825,0.7664,-0.1971},
    mNorMin_flow=1,
    mNorMax_flow=2,
    scaM_flow=scaM_flow,
    scaDp=scaDp0FanSup,
    redeclare package Medium = Medium) 
    annotation (extent=[90,4; 110,24], style(thickness=2));
  Buildings.Fluids.FixedResistances.FixedResistanceDpM res33(
    dp0=0.164,
    dh=sqrt(scaM_flow)*1,
    m0_flow=scaM_flow*1,
    redeclare package Medium = Medium) 
    annotation (extent=[118,6; 138,26], style(thickness=2));
  Buildings.Fluids.FixedResistances.FixedResistanceDpM res57(
                                                 dp0=0.118000,
    m0_flow=scaM_flow*1,
    dh=sqrt(scaM_flow)*1,
    redeclare package Medium = Medium) 
    annotation (extent=[54,-50; 74,-30], style(thickness=2));
  Buildings.Fluids.Movers.FlowMachinePolynomial fan56(
    D=1.13,
    a={4.19370,-1.63370,12.2110,-23.9619,9.81620},
    b={0.619000E-01,3.14170,-5.75510,6.16760,-3.37480},
    mNorMin_flow=0.7,
    mNorMax_flow=1.0,
    scaM_flow=scaM_flow,
    scaDp=scaDp0FanRet,
    redeclare package Medium = Medium) 
    annotation (extent=[110,-50; 90,-30], style(thickness=2));
  Buildings.Fluids.Actuators.Dampers.VAVBoxExponential vav44(
    dp0=0.999E2,
    A=0.024,
    m0_flow=0.132*1.2,
    redeclare package Medium = Medium) 
    annotation (extent=[276,6; 296,26], rotation=270,
    style(thickness=2));
  Buildings.Fluids.MixingVolumes.MixingVolume roo50(redeclare package Medium = Medium,
    initType=Modelica_Fluid.Types.Init.SteadyStateHydraulic,
    V=10*5*2.5,
    nP=5)                                     annotation (extent=[280,-28; 294,-14], style(
        thickness=2));
  Buildings.Fluids.Examples.BaseClasses.RoomLeakage lea50(redeclare package 
      Medium = 
        Medium) "Room leakage model" 
    annotation (extent=[308,8; 328,28],   rotation=270,
    style(thickness=2));
  Buildings.Fluids.FixedResistances.FixedResistanceDpM res1(
                                      m0_flow=1, dp0=0.1E3,
    redeclare package Medium = Medium) 
    annotation (extent=[136,-32; 156,-12], style(thickness=2));
  Buildings.Fluids.Examples.BaseClasses.Suite[NSui] sui(redeclare each package 
      Medium = Medium) 
                 annotation (extent=[166,-58; 256,34], style(thickness=2));
  Buildings.Fluids.Examples.BaseClasses.ControlSignals y 
                               annotation (extent=[-40,80; -20,100], style(
        thickness=2));
equation 
  connect(yMinOA.y, mixBox.yOutMin) 
                               annotation (points=[-19,50; 4,50; 4,-22; 18,-22],
      style(
      color=58,
      rgbcolor={0,165,0},
      thickness=2));
  annotation (Coordsys(extent=[-100,-100; 350,150]), Diagram);
  connect(mixBox.port_Sup, res31.port_a) annotation (points=[39.8,-30; 46,-30;
        46,14; 58,14], style(
      color=69,
      rgbcolor={0,127,255},
      thickness=2));
  connect(res31.port_b,fan32.port_a) 
    annotation (points=[78,14; 90,14], style(
      color=69,
      rgbcolor={0,127,255},
      thickness=2));
  connect(fan32.port_b, res33.port_a) 
                                     annotation (points=[110,14; 118,14; 118,16],
      style(
      color=69,
      rgbcolor={0,127,255},
      thickness=2));
  connect(fan56.port_b, res57.port_b) annotation (points=[90,-40; 74,-40],
      style(
      color=69,
      rgbcolor={0,127,255},
      thickness=2));
  connect(res57.port_a, mixBox.port_Ret) annotation (points=[54,-40; 40,-40],
      style(
      color=69,
      rgbcolor={0,127,255},
      thickness=2));
  connect(bouExh.port, mixBox.port_Exh) annotation (points=[-20,-40; 19.8,-40],
      style(
      color=69,
      rgbcolor={0,127,255},
      thickness=2));
  connect(PAtm.y, bouExh.p_in) annotation (points=[-59,-10; -50,-10; -50,-34;
        -42,-34],
              style(
      color=1,
      rgbcolor={255,0,0},
      thickness=2));
  connect(PAtm.y, bouIn2.p_in) annotation (points=[-59,-10; -50.5,-10; -50.5,-4; 
        -42,-4],                                                      style(
      color=1,
      rgbcolor={255,0,0},
      thickness=2));
  connect(PAtm.y, bouIn.p_in) annotation (points=[-59,-10; -50,-10; -50,26; -42,
        26],
      style(
      color=1,
      rgbcolor={255,0,0},
      thickness=2));
  connect(bouIn.port, mixBox.port_OutMin) annotation (points=[-20,20; -12,20;
        -12,-30; 19.8,-30], style(
      color=69,
      rgbcolor={0,127,255},
      thickness=2,
      gradient=3,
      fillColor=3,
      rgbfillColor={0,0,255}));
  connect(bouIn2.port, mixBox.port_Out) annotation (points=[-20,-10; -16,-10;
        -16,-34; 19.8,-34], style(
      color=69,
      rgbcolor={0,127,255},
      thickness=2,
      gradient=3,
      fillColor=3,
      rgbfillColor={0,0,255}));
  connect(vav44.port_b,roo50.port[1]) 
                               annotation (points=[286,6; 286,-21.56; 287,
        -21.56],
      style(
      color=69,
      rgbcolor={0,127,255},
      thickness=2,
      gradient=3,
      fillColor=3,
      rgbfillColor={0,0,255}));
  connect(PAtm.y, lea50.p) annotation (points=[-59,-10; -50,-10; -50,106; 318,
        106; 318,30], style(
      color=1,
      rgbcolor={255,0,0},
      thickness=2));
  connect(lea50.port_b,roo50.port[2]) 
                              annotation (points=[318,8; 318,-21.28; 287,-21.28],
      style(
      color=69,
      rgbcolor={0,127,255},
      thickness=2));
  connect(res1.port_a, roo50.port[3]) 
                              annotation (points=[136,-22; 134,-22; 134,-54;
        287,-54; 287,-21], style(
      color=69,
      rgbcolor={0,127,255},
      pattern=2,
      thickness=2,
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(sui[1].port_aRoo, res1.port_b)   annotation (points=[166,-21.2; 190,
        -21.2; 190,-22; 156,-22], style(
      color=69,
      rgbcolor={0,127,255},
      thickness=2,
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(roo50.port[4], sui[NSui].port_aExh) 
                                        annotation (points=[287,-20.72; 287,
        -39.6; 256.36,-39.6],
                       style(
      color=69,
      rgbcolor={0,128,255},
      thickness=2,
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(vav44.port_a, sui[NSui].port_bSup)   annotation (points=[286,26; 286,
        30; 276,30; 276,10; 256,10; 256,9.46667], style(
      color=69,
      rgbcolor={0,127,255},
      thickness=2,
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(sui[NSui].port_bRoo, roo50.port[5]) 
                                        annotation (points=[256,-21.2; 287,
        -21.2; 287,-20.44],
                         style(
      color=69,
      rgbcolor={0,127,255},
      thickness=2,
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(res33.port_b, sui[1].port_aSup)   annotation (points=[138,16; 166,16; 
        166,9.46667], style(
      color=69,
      rgbcolor={0,127,255},
      thickness=2,
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(fan56.port_a, sui[1].port_bExh)   annotation (points=[110,-40; 170,
        -40; 170,-39.6; 166,-39.6],
                               style(
      color=69,
      rgbcolor={0,127,255},
      thickness=2,
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  for i in 1:NSui loop
  connect(PAtm.y, sui[i].p)   annotation (points=[-59,-10; -50,-10; -50,106; 
          144,106; 144,27.8667; 162.4,27.8667], style(
        color=1,
        rgbcolor={255,0,0},
        thickness=2,
        fillColor=74,
        rgbfillColor={0,0,127},
        fillPattern=1));
  connect(y.yVAV, sui[i].yDam)   annotation (points=[-19,84; 10,84; 10,
          -0.346667; 162.4,-0.346667], style(
        color=58,
        rgbcolor={0,165,0},
        thickness=2,
        fillColor=74,
        rgbfillColor={0,0,127},
        fillPattern=1));
  end for;
  for i in 1:NSui-1 loop
  connect(sui[i+1].port_aSup, sui[i].port_bSup)     annotation (points=[166,
          9.46667; 166,16; 150,16; 150,38; 264,38; 264,10; 256,10; 256,9.46667],
        style(
        color=69,
        rgbcolor={0,127,255},
        pattern=2,
        thickness=2,
        fillColor=74,
        rgbfillColor={0,0,127},
        fillPattern=1));
  connect(sui[i+1].port_bExh, sui[i].port_aExh)     annotation (points=[166,
          -39.6; 166,-46; 256.36,-46; 256.36,-39.6], style(
        color=69,
        rgbcolor={0,127,255},
        pattern=2,
        thickness=2,
        fillColor=74,
        rgbfillColor={0,0,127},
        fillPattern=1));
  connect(sui[i+1].port_aRoo, sui[i].port_bRoo)     annotation (points=[166,
          -21.2; 166,-22; 162,-22; 162,-50; 264,-50; 264,-21.2; 256,-21.2],
        style(
        color=69,
        rgbcolor={0,127,255},
        pattern=2,
        thickness=2,
        fillColor=74,
        rgbfillColor={0,0,127},
        fillPattern=1));
  end for;
  
  connect(y.ySupFan, fan32.N_in) annotation (points=[-19,99; 84,99; 84,20; 89,
        20], style(
      color=58,
      rgbcolor={0,165,0},
      thickness=2));
  connect(y.yRetFan, fan56.N_in) annotation (points=[-19,95; 80,95; 80,-6; 130,
        -6; 130,-34; 111,-34], style(
      color=58,
      rgbcolor={0,165,0},
      thickness=2));
  connect(y.yOSA, mixBox.y) annotation (points=[-19,90; -2,90; -2,-26; 18,-26],
      style(
      color=58,
      rgbcolor={0,165,0},
      thickness=2));
  connect(y.yVAV, vav44.y) annotation (points=[-19,84; 30,84; 30,48; 294,48;
        294,28], style(
      color=58,
      rgbcolor={0,165,0},
      thickness=2));
end MITScalable;
