within Buildings.Examples;
model VAVSystemCTControl
  "VAV system model of MIT building with continuous time control for static pressure reset"

  // package Medium = Buildings.Media.IdealGases.SimpleAir;
package Medium = Buildings.Media.GasesPTDecoupled.SimpleAir(extraPropertiesNames={"CO2"});
  //  package Medium = Buildings.Media.GasesPTDecoupled.MoistAir;

   annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{350,150}}), graphics),
                        Commands(
      file="run1DayCTControl.mos" "run",
      file="plotRooACH.mos" "plotRooACH",
      file="plotFan.mos" "plotFan",
      file="plotCO2.mos" "plotCO2",
      file="plotPCon.mos" "plotPCon"),
    experiment(
      StopTime=86400,
      Tolerance=1e-005,
      Algorithm="Radau"),         stopTime=86400,
    experimentSetupOutput);

 parameter Modelica.SIunits.MassFlowRate mMIT_flow = roo.m0Tot_flow
    "Nominal mass flow rate of MIT system model as in ASHRAE 825-RP";

parameter Modelica.SIunits.Pressure dpSuiSup_nominal = 95
    "Pressure drop supply air leg with splitters of one suite (obtained from simulation)";
parameter Modelica.SIunits.Pressure dpSuiRet_nominal = 233
    "Pressure drop return air leg with splitters of one suite (obtained from simulation)";
parameter Modelica.SIunits.Pressure dpFanSupMIT_nominal = 1050
    "Pressure increase over supply fan in MIT system model as in ASHRAE 825-RP (obtained from simulation)";
parameter Modelica.SIunits.Pressure dpFanRetMIT_nominal = 347
    "Pressure increase over supply fan in MIT system model as in ASHRAE 825-RP (obtained from simulation)";

parameter Real scaM_flow = 1/3 "Scaling factor for mass flow rate";
parameter Real scaDpFanSup_nominal = 1
    "Scaling factor for supply fan pressure lift with NSui number of suites";
parameter Real scaDpFanRet_nominal = 1
    "Scaling factor for supply fan pressure lift with NSui number of suites";

  Modelica.Blocks.Sources.Constant PAtm(k=101325) 
      annotation (extent=[-86,-50; -66,-30],
                                           style(thickness=2),
    Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Modelica.Blocks.Sources.Constant yDam(k=0.5) 
      annotation (extent=[-40,20; -20,40], style(thickness=2),
    Placement(transformation(extent={{-40,-20},{-20,0}})));
Buildings.Fluid.FixedResistances.FixedResistanceDpM res31(
                                               dp_nominal=0.546,
  m_flow_nominal=scaM_flow*1,
  dh=sqrt(scaM_flow)*1,
  redeclare package Medium = Medium) 
    annotation (extent=[50,-20; 70,0],style(thickness=2),
    Placement(transformation(extent={{50,-20},{70,0}})));
Buildings.Fluid.Movers.FlowMachinePolynomial fan32(
  D=0.6858,
  a={4.2904,-1.387,4.2293,-3.92920,0.8534},
  b={0.1162,1.5404,-1.4825,0.7664,-0.1971},
  mNorMin_flow=1,
  mNorMax_flow=2,
  scaM_flow=scaM_flow,
  scaDp=scaDpFanSup_nominal,
  redeclare package Medium = Medium,
    m_flow_nominal=mMIT_flow) 
    annotation (extent=[116,-20; 136,0],
                                       style(thickness=2));
Buildings.Fluid.FixedResistances.FixedResistanceDpM res33(
  dp_nominal=0.164,
  dh=sqrt(scaM_flow)*1,
  m_flow_nominal=scaM_flow*1,
  redeclare package Medium = Medium) 
    annotation (extent=[144,-20; 164,0],style(thickness=2),
    Placement(transformation(extent={{146,-20},{166,0}})));
Buildings.Fluid.FixedResistances.FixedResistanceDpM res57(
                                               dp_nominal=0.118000,
  m_flow_nominal=scaM_flow*1,
  dh=sqrt(scaM_flow)*1,
  redeclare package Medium = Medium) 
    annotation (extent=[54,-80; 74,-60], style(thickness=2),
    Placement(transformation(extent={{96,-80},{76,-60}})));
Buildings.Fluid.Movers.FlowMachinePolynomial fan56(
  D=1.13,
  a={4.19370,-1.63370,12.2110,-23.9619,9.81620},
  b={0.619000E-01,3.14170,-5.75510,6.16760,-3.37480},
  mNorMin_flow=0.7,
  mNorMax_flow=1.0,
  scaM_flow=scaM_flow,
  scaDp=scaDpFanRet_nominal,
  redeclare package Medium = Medium,
    m_flow_nominal=mMIT_flow) 
    annotation (extent=[122,-80; 102,-60],style(thickness=2),
    Placement(transformation(extent={{130,-80},{110,-60}})));
BaseClasses.Suite roo(redeclare package Medium = Medium, scaM_flow=scaM_flow) 
    annotation (extent=[198,-92; 302,20], Placement(transformation(extent={{198,
            -92},{302,20}})));
  annotation (Coordsys(extent=[-100,-100; 350,150]), Diagram);
Buildings.Fluid.Actuators.Dampers.OAMixingBoxMinimumDamper mixBox(
  dpOut_nominal=0.467,
  dpRec_nominal=0.665,
  dpExh_nominal=0.164,
  dpOutMin_nominal=0.467,
  AOutMin=scaM_flow*0.38,
  AOut=scaM_flow*1.32,
  AExh=scaM_flow*1.05,
  ARec=scaM_flow*1.05,
  m0OutMin_flow=scaM_flow*0.1*1,
  m0Out_flow=scaM_flow*1,
  m0Rec_flow=scaM_flow*1,
  m0Exh_flow=scaM_flow*1,
  redeclare package Medium = Medium) "mixing box" 
                            annotation (extent=[8,-72; 28,-52],  style(
        thickness=2),
    Placement(transformation(extent={{10,-72},{30,-52}})));
  Buildings.Fluid.Sources.Boundary_pT bouIn(
    redeclare package Medium = Medium,
    use_p_in=true,
    nPorts=3,
    T=293.15)                                           annotation (extent=[-38,-18;
        -18,2],  style(thickness=2),
    Placement(transformation(extent={{-38,-74},{-18,-54}})));
Modelica.Blocks.Continuous.FirstOrder gaiSup(
                                 k=22.333,
  y_start=0.01,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T=120) "Gain for supply air fan" 
    annotation (extent=[94,-4; 106,8], Placement(transformation(extent={{88,-6},
            {100,6}})));
Modelica.Blocks.Continuous.FirstOrder gaiRet(
                                 k=8,
  y_start=0.01,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T=120) "Gain for return air fan" 
    annotation (extent=[104,-46; 116,-34], Placement(transformation(extent={{88,
            -46},{100,-34}})));
  inner Modelica.Fluid.System system 
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

   Modelica.Blocks.Continuous.LimPID PID(
    Ti=60,
    yMax=1,
    yMin=0,
    initType=Modelica.Blocks.Types.InitPID.InitialState,
    k=0.01,
    controllerType=Modelica.Blocks.Types.SimpleController.PI) 
            annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Modelica.Blocks.Sources.Constant const(k=120) 
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Buildings.Fluid.Delays.DelayFirstOrder delSup(
    redeclare package Medium = Medium,
    m_flow_nominal=mMIT_flow,
    tau=120) "Delay to break algebraic loop" 
    annotation (Placement(transformation(extent={{170,-10},{190,10}})));
  Buildings.Fluid.Delays.DelayFirstOrder delRet(
    redeclare package Medium = Medium,
    m_flow_nominal=mMIT_flow,
    tau=120) "Delay to break algebraic loop" 
    annotation (Placement(transformation(extent={{150,-70},{170,-50}})));
equation
  connect(PAtm.y, bouIn.p_in) annotation (Line(
      points={{-59,-40},{-50,-40},{-50,-56},{-40,-56}},
      color={255,0,0},
      smooth=Smooth.None,
      thickness=0.5));
  connect(bouIn.ports[1], mixBox.port_OutMin) annotation (Line(
      points={{-18,-61.3333},{-6,-61.3333},{-6,-60},{9.8,-60}},
      color={0,127,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(bouIn.ports[2], mixBox.port_Out) annotation (Line(
      points={{-18,-64},{9.8,-64}},
      color={0,127,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(bouIn.ports[3], mixBox.port_Exh) annotation (Line(
      points={{-18,-66.6667},{-5.2,-66.6667},{-5.2,-70},{9.8,-70}},
      color={0,127,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(res57.port_a, fan56.port_b) annotation (Line(
      points={{96,-70},{110,-70}},
      color={0,127,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(fan32.N_in, gaiSup.y) annotation (Line(
      points={{126,-3},{126,0},{100.6,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fan56.N_in, gaiRet.y) annotation (Line(
      points={{120,-63},{120,-40},{100.6,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, PID.u_s) annotation (Line(
      points={{21,90},{38,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(roo.p_rel, PID.u_m) annotation (Line(
      points={{304.6,-17.3333},{320,-17.3333},{320,60},{50,60},{50,78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PID.y, gaiSup.u) annotation (Line(
      points={{61,90},{80,90},{80,0},{86.8,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PID.y, gaiRet.u) annotation (Line(
      points={{61,90},{80,90},{80,-40},{86.8,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(yDam.y, mixBox.yOutMin) annotation (Line(
      points={{-19,-10},{-10,-10},{-10,-52},{8,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(yDam.y, mixBox.y) annotation (Line(
      points={{-19,-10},{-10,-10},{-10,-56},{8,-56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(roo.p, PAtm.y) annotation (Line(
      points={{193.32,12.5333},{72,12},{-50,12},{-50,-40},{-59,-40}},
      color={255,0,0},
      smooth=Smooth.None,
      thickness=0.5));
  connect(res31.port_b, fan32.port_a) annotation (Line(
      points={{70,-10},{116,-10}},
      color={0,127,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(mixBox.port_Sup, res31.port_a) annotation (Line(
      points={{29.8,-60},{40,-60},{40,-10},{50,-10}},
      color={0,127,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(fan32.port_b, res33.port_a) annotation (Line(
      points={{136,-10},{146,-10}},
      color={0,127,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(res33.port_b, delSup.ports[1]) annotation (Line(
      points={{166,-10},{178,-10}},
      color={0,127,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(delSup.ports[2], roo.port_aSup) annotation (Line(
      points={{182,-10},{190,-10},{190,-9.86667},{198,-9.86667}},
      color={0,127,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(roo.port_bExh, delRet.ports[1]) annotation (Line(
      points={{198,-69.6},{180,-69.6},{180,-70},{158,-70}},
      color={0,127,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(delRet.ports[2], fan56.port_a) annotation (Line(
      points={{162,-70},{130,-70}},
      color={0,127,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(res57.port_b, mixBox.port_Ret) annotation (Line(
      points={{76,-70},{30,-70}},
      color={0,127,255},
      thickness=0.5,
      smooth=Smooth.None));
end VAVSystemCTControl;
