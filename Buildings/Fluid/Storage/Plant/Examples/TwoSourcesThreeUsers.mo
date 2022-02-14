within Buildings.Fluid.Storage.Plant.Examples;
model TwoSourcesThreeUsers
  "(Draft) District model with two sources and three users"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=500000
    "Nominal pressure difference";
  parameter Modelica.Units.SI.AbsolutePressure p_CHWS_nominal=
    p_CHWR_nominal+dp_nominal
    "Nominal pressure at CHW supply line";
  parameter Modelica.Units.SI.AbsolutePressure p_CHWR_nominal=500000
    "Nominal pressure at CHW return line";
  parameter Modelica.Units.SI.Temperature T_CHWR_nominal=12+273.15
    "Nominal temperature of CHW return";
  parameter Modelica.Units.SI.Temperature T_CHWS_nominal=7+273.15
    "Nominal temperature of CHW supply";
  parameter Boolean allowFlowReversal=false
    "Flow reversal setting";
  parameter Modelica.Units.SI.Power QCooLoa_flow_nominal=5*4200*1.01
    "Nominal cooling load of one consumer";

  Buildings.Fluid.Storage.Plant.TemperatureSource chi1(
    redeclare final package Medium = Medium,
    allowFlowReversal=true,
    m_flow_nominal=1.5*m_flow_nominal,
    p_nominal=p_CHWR_nominal,
    T_a_nominal=T_CHWR_nominal,
    T_b_nominal=T_CHWS_nominal) "Dummy chill source as chiller 1" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,60})));
  Buildings.Fluid.Storage.Plant.ChillerAndTankWithRemoteCharging cat(
    redeclare final package Medium=Medium,
    final m1_flow_nominal=0.75*m_flow_nominal,
    final m2_flow_nominal=0.75*m_flow_nominal,
    final p_CHWS_nominal=p_CHWS_nominal,
    final p_CHWR_nominal=p_CHWR_nominal,
    final T_CHWS_nominal=T_CHWS_nominal,
    final T_CHWR_nominal=T_CHWR_nominal)
    "Chiller and tank, tank can be charged remotely"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,-60})));
  Buildings.Fluid.Storage.Plant.DummyConsumer con1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    p_a_nominal=p_CHWS_nominal-dp_nominal*0.35,
    p_b_nominal=p_CHWR_nominal+dp_nominal*0.35,
    T_a_nominal=T_CHWS_nominal,
    T_b_nominal=T_CHWR_nominal)
    "Dummy consumer 1"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,60})));
  Buildings.Fluid.Storage.Plant.DummyConsumer con2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    p_a_nominal=p_CHWS_nominal - dp_nominal*0.35,
    p_b_nominal=p_CHWR_nominal + dp_nominal*0.35,
    T_a_nominal=T_CHWS_nominal,
    T_b_nominal=T_CHWR_nominal)
    "Dummy consumer 1"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,0})));
  Buildings.Fluid.Storage.Plant.DummyConsumer con3(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    p_a_nominal=p_CHWS_nominal - dp_nominal*0.35,
    p_b_nominal=p_CHWR_nominal + dp_nominal*0.35,
    T_a_nominal=T_CHWS_nominal,
    T_b_nominal=T_CHWR_nominal)
    "Dummy consumer 1"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-60})));
  Buildings.Fluid.Movers.SpeedControlled_y pumChi1(
    redeclare package Medium = Medium,
    per(pressure(dp=dp_nominal*{2,1.2,0}, V_flow=(m_flow_nominal*1.5)/1.2*{0,1.2,2})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=true,
    addPowerToMedium=false,
    final y_start=1,
    T_start=T_CHWR_nominal) "Supply pump for chiller 1" annotation (Placement(
        transformation(extent={{-70,70},{-50,90}}, rotation=0)));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin mulMin_dpCon(nin=3)
    "Min of pressure head measured from all consumers"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-90,150})));
  Modelica.Blocks.Sources.Constant set_dpCon(k=1)
    "Normalised consumer differential pressure setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,150})));
  Modelica.Blocks.Sources.Constant set_TRet(k=12 + 273.15)
    "CHW return setpoint"
    annotation (Placement(transformation(extent={{10,110},{30,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysCat(uLow=0.05, uHigh=0.5)
    "Shut off at con.yVal = 0.05 and restarts at 0.5" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={10,-110})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax mulMax_yVal(nin=3)
    "Max of valve positions"
    annotation (Placement(transformation(extent={{60,-120},{40,-100}})));
  Modelica.Blocks.Sources.BooleanConstant booFloDir
    "Placeholder, constant normal direction"
    annotation (Placement(transformation(extent={{-20,-140},{-40,-120}})));
  Modelica.Blocks.Sources.Constant set_mTan_flow(k=0.75*m_flow_nominal)
    "Placeholder, tank flow rate setpoint"
    annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));
  Modelica.Blocks.Sources.Constant set_mChi2_flow(k=0.75*m_flow_nominal)
    "Placeholder, chiller 2 flow rate setpoint"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Buildings.Fluid.Sources.Boundary_pT sou_p(
    redeclare final package Medium = Medium,
    final p=p_CHWR_nominal,
    final T=T_CHWR_nominal,
    nPorts=1) "Pressurisation point" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,0})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroChi1(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final dp_nominal=dp_nominal/10,
    final m_flow_nominal=1.5*m_flow_nominal)
                                         "Flow resistance" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-60,40})));
  Buildings.Controls.Continuous.LimPID conPI_PumChi1(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Td=1,
    k=1,
    Ti=100,
    reverseActing=true) "PI controller" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-60,120})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroS2C3(
    redeclare package Medium = Medium,
    final allowFlowReversal=true,
    final dp_nominal=0.3*dp_nominal,
    final m_flow_nominal=m_flow_nominal)
    "Flow resistance source 2 to consumer 3"
    annotation (Placement(transformation(extent={{-30,-50},{-10,-30}})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroC3S2(
    redeclare package Medium = Medium,
    final allowFlowReversal=true,
    final dp_nominal=0.3*dp_nominal,
    final m_flow_nominal=m_flow_nominal)
    "Flow resistance consumer 3 to source 2"
    annotation (Placement(transformation(extent={{30,-90},{10,-70}})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroS2C2(
    redeclare package Medium = Medium,
    final allowFlowReversal=true,
    final dp_nominal=0.3*dp_nominal,
    final m_flow_nominal=m_flow_nominal)
    "Flow resistance source 2 to consumer 2"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroC2S2(
    redeclare package Medium = Medium,
    final allowFlowReversal=true,
    final dp_nominal=0.3*dp_nominal,
    final m_flow_nominal=m_flow_nominal)
    "Flow resistance consumer 2 to source 2"
    annotation (Placement(transformation(extent={{30,-30},{10,-10}})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroS1C2(
    redeclare package Medium = Medium,
    final allowFlowReversal=true,
    final dp_nominal=0.3*dp_nominal,
    final m_flow_nominal=m_flow_nominal)
    "Flow resistance source 1 to consumer 2"
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroC2S1(
    redeclare package Medium = Medium,
    final allowFlowReversal=true,
    final dp_nominal=0.3*dp_nominal,
    final m_flow_nominal=m_flow_nominal)
    "Flow resistance consumer 2 to source 1"
    annotation (Placement(transformation(extent={{30,-10},{10,10}})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroS1C1(
    redeclare package Medium = Medium,
    final allowFlowReversal=true,
    final dp_nominal=0.3*dp_nominal,
    final m_flow_nominal=m_flow_nominal)
    "Flow resistance source 1 to consumer 3"
    annotation (Placement(transformation(extent={{-30,70},{-10,90}})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroC1S1(
    redeclare package Medium = Medium,
    final allowFlowReversal=true,
    final dp_nominal=0.3*dp_nominal,
    final m_flow_nominal=m_flow_nominal)
    "Flow resistance consumer 1 to source 1"
    annotation (Placement(transformation(extent={{30,30},{10,50}})));
  Modelica.Blocks.Sources.TimeTable set_QCooLoa1_flow(table=[0,0; 600,0; 600,
        QCooLoa_flow_nominal; 2400,QCooLoa_flow_nominal; 2400,0; 3600,0])
    "Cooling load"
    annotation (Placement(transformation(extent={{120,80},{100,100}})));
  Modelica.Blocks.Sources.TimeTable set_QCooLoa2_flow(table=[0,0; 1200,0; 1200,
        QCooLoa_flow_nominal; 3000,QCooLoa_flow_nominal; 3000,0; 3600,0])
    "Cooling load"
    annotation (Placement(transformation(extent={{120,20},{100,40}})));
  Modelica.Blocks.Sources.TimeTable set_QCooLoa3_flow(table=[0,0; 1800,0; 1800,
        QCooLoa_flow_nominal; 3600,QCooLoa_flow_nominal]) "Cooling load"
    annotation (Placement(transformation(extent={{120,-40},{100,-20}})));
  Modelica.Blocks.Math.Gain gaiCon1(k=1/con1.dp_nominal)
    "Gain to normalise dp measurement" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={110,60})));
  Modelica.Blocks.Math.Gain gaiCon2(k=1/con2.dp_nominal)
    "Gain to normalise dp measurement" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={110,0})));
  Modelica.Blocks.Math.Gain gaiCon3(k=1/con3.dp_nominal)
    "Gain to normalise dp measurement" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={110,-60})));
equation
  connect(set_TRet.y, con1.TSet) annotation (Line(points={{31,120},{36,120},{36,
          76},{65,76},{65,71}}, color={0,0,127}));
  connect(set_TRet.y, con2.TSet) annotation (Line(points={{31,120},{36,120},{36,
          16},{65,16},{65,11}}, color={0,0,127}));
  connect(set_TRet.y, con3.TSet) annotation (Line(points={{31,120},{36,120},{36,
          -44},{65,-44},{65,-49}}, color={0,0,127}));
  connect(con3.yVal_actual, mulMax_yVal.u[1]) annotation (Line(points={{71,-53},
          {86,-53},{86,-110},{74,-110},{74,-110.667},{62,-110.667}}, color={0,0,
          127}));
  connect(con2.yVal_actual, mulMax_yVal.u[2]) annotation (Line(points={{71,7},{86,
          7},{86,-110},{62,-110}}, color={0,0,127}));
  connect(mulMax_yVal.y, hysCat.u)
    annotation (Line(points={{38,-110},{22,-110}}, color={0,0,127}));
  connect(hysCat.y, cat.onOffLin) annotation (Line(points={{-2,-110},{-50,-110},
          {-50,-72},{-51,-72}}, color={255,0,255}));
  connect(booFloDir.y, cat.booFloDir) annotation (Line(points={{-41,-130},{-55,-130},
          {-55,-72}}, color={255,0,255}));
  connect(set_mTan_flow.y, cat.set_mTan_flow) annotation (Line(points={{-79,-130},
          {-65,-130},{-65,-71}}, color={0,0,127}));
  connect(set_mChi2_flow.y, cat.set_mPum1_flow) annotation (Line(points={{-79,-90},
          {-70,-90},{-70,-71},{-69,-71}}, color={0,0,127}));
  connect(preDroChi1.port_b, chi1.port_a)
    annotation (Line(points={{-70,40},{-80,40},{-80,50}}, color={0,127,255}));
  connect(chi1.port_b, pumChi1.port_a)
    annotation (Line(points={{-80,70},{-80,80},{-70,80}}, color={0,127,255}));
  connect(sou_p.ports[1], preDroChi1.port_b)
    annotation (Line(points={{-80,0},{-80,40},{-70,40}}, color={0,127,255}));
  connect(set_dpCon.y, conPI_PumChi1.u_s)
    annotation (Line(points={{-60,139},{-60,132}}, color={0,0,127}));
  connect(conPI_PumChi1.y, pumChi1.y)
    annotation (Line(points={{-60,109},{-60,92}}, color={0,0,127}));
  connect(con1.yVal_actual, mulMax_yVal.u[3]) annotation (Line(points={{71,67},
          {86,67},{86,-110},{62,-110},{62,-109.333}},color={0,0,127}));
  connect(cat.port_b, preDroS2C3.port_a) annotation (Line(points={{-60,-50},{-60,
          -40},{-30,-40}}, color={0,127,255}));
  connect(preDroS2C3.port_b, con3.port_a)
    annotation (Line(points={{-10,-40},{60,-40},{60,-50}}, color={0,127,255}));
  connect(con3.port_b, preDroC3S2.port_a)
    annotation (Line(points={{60,-70},{60,-80},{30,-80}}, color={0,127,255}));
  connect(preDroC3S2.port_b, cat.port_a) annotation (Line(points={{10,-80},{-60,
          -80},{-60,-70}}, color={0,127,255}));
  connect(cat.port_b, preDroS2C2.port_a) annotation (Line(points={{-60,-50},{-60,
          -40},{-36,-40},{-36,0},{-30,0}}, color={0,127,255}));
  connect(preDroS2C2.port_b, con2.port_a) annotation (Line(points={{-10,0},{-4,0},
          {-4,10},{60,10}}, color={0,127,255}));
  connect(con2.port_b, preDroC2S2.port_a)
    annotation (Line(points={{60,-10},{60,-20},{30,-20}}, color={0,127,255}));
  connect(preDroC2S2.port_b, cat.port_a) annotation (Line(points={{10,-20},{4,-20},
          {4,-80},{-60,-80},{-60,-70}}, color={0,127,255}));
  connect(pumChi1.port_b, preDroS1C2.port_a) annotation (Line(points={{-50,80},{
          -36,80},{-36,20},{-30,20}}, color={0,127,255}));
  connect(preDroS1C2.port_b, con2.port_a) annotation (Line(points={{-10,20},{-4,
          20},{-4,10},{60,10}}, color={0,127,255}));
  connect(con2.port_b, preDroC2S1.port_a) annotation (Line(points={{60,-10},{60,
          -20},{34,-20},{34,0},{30,0}}, color={0,127,255}));
  connect(preDroC2S1.port_b, preDroChi1.port_a) annotation (Line(points={{10,0},
          {4,0},{4,40},{-50,40}}, color={0,127,255}));
  connect(pumChi1.port_b, preDroS1C1.port_a)
    annotation (Line(points={{-50,80},{-30,80}}, color={0,127,255}));
  connect(preDroS1C1.port_b, con1.port_a)
    annotation (Line(points={{-10,80},{60,80},{60,70}}, color={0,127,255}));
  connect(con1.port_b, preDroC1S1.port_a)
    annotation (Line(points={{60,50},{60,40},{30,40}}, color={0,127,255}));
  connect(preDroC1S1.port_b, preDroChi1.port_a)
    annotation (Line(points={{10,40},{-50,40}}, color={0,127,255}));
  connect(set_QCooLoa1_flow.y, con1.QCooLoa_flow)
    annotation (Line(points={{99,90},{69,90},{69,71}}, color={0,0,127}));
  connect(set_QCooLoa2_flow.y, con2.QCooLoa_flow)
    annotation (Line(points={{99,30},{69,30},{69,11}}, color={0,0,127}));
  connect(set_QCooLoa3_flow.y, con3.QCooLoa_flow)
    annotation (Line(points={{99,-30},{69,-30},{69,-49}}, color={0,0,127}));
  connect(con1.dp, gaiCon1.u)
    annotation (Line(points={{71,63},{71,60},{98,60}}, color={0,0,127}));
  connect(con2.dp, gaiCon2.u) annotation (Line(points={{71,3},{71,1.55431e-15},{
          98,1.55431e-15}}, color={0,0,127}));
  connect(con3.dp, gaiCon3.u) annotation (Line(points={{71,-57},{92,-57},{92,-60},
          {98,-60}}, color={0,0,127}));
  connect(gaiCon1.y, mulMin_dpCon.u[1]) annotation (Line(points={{121,60},{126,
          60},{126,162},{-89.3333,162}},
                                     color={0,0,127}));
  connect(gaiCon2.y, mulMin_dpCon.u[2]) annotation (Line(points={{121,-1.38778e-15},
          {126,-1.38778e-15},{126,162},{-90,162}}, color={0,0,127}));
  connect(gaiCon3.y, mulMin_dpCon.u[3]) annotation (Line(points={{121,-60},{126,
          -60},{126,162},{-90.6667,162}}, color={0,0,127}));
  connect(mulMin_dpCon.y, conPI_PumChi1.u_m)
    annotation (Line(points={{-90,138},{-90,120},{-72,120}}, color={0,0,127}));
  annotation (experiment(Tolerance=1e-06, StopTime=3600,__Dymola_Algorithm="Cvode"),
        Diagram(coordinateSystem(extent={{-100,-140},{140,180}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})));
end TwoSourcesThreeUsers;
