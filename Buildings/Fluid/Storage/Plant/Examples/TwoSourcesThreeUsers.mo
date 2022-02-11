within Buildings.Fluid.Storage.Plant.Examples;
model TwoSourcesThreeUsers
  "(Draft) District model with two sources and three users"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=
    p_CHWS_nominal-p_CHWR_nominal
    "Nominal pressure difference";
  parameter Modelica.Units.SI.AbsolutePressure p_CHWS_nominal=800000
    "Nominal pressure at CHW supply line";
  parameter Modelica.Units.SI.AbsolutePressure p_CHWR_nominal=300000
    "Nominal pressure at CHW return line";
  parameter Modelica.Units.SI.Temperature T_CHWR_nominal=12+273.15
    "Nominal temperature of CHW return";
  parameter Modelica.Units.SI.Temperature T_CHWS_nominal=7+273.15
    "Nominal temperature of CHW supply";
  parameter Boolean allowFlowReversal=false
    "Flow reversal setting";


  Buildings.Fluid.Storage.Plant.DummyChillSource chi1(
    redeclare final package Medium = Medium,
    allowFlowReversal=true,
    m_flow_nominal=m_flow_nominal,
    p_nominal=p_CHWR_nominal,
    T_a_nominal=T_CHWR_nominal,
    T_b_nominal=T_CHWS_nominal) "Dummy chill source as chiller 1" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-60,40})));
  Buildings.Fluid.Storage.Plant.ChillerAndTankWithRemoteCharging cat(
    redeclare final package Medium=Medium,
    final m1_flow_nominal=1,
    final m2_flow_nominal=1,
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
  Buildings.Fluid.FixedResistances.Junction junCHWS1(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal*{1.5,-1,-0.5},
    dp_nominal=dp_nominal*{0,-0.3,-0.3},
    T_start=T_CHWR_nominal) "Junction one supply line" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-20,80})));
  Buildings.Fluid.FixedResistances.Junction junCHWS3(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal*{1.5,-1,-0.5},
    dp_nominal=dp_nominal*{0,-0.3,-0.3},
    T_start=T_CHWR_nominal) "Junction on supply line" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-20,-40})));
  Buildings.Fluid.FixedResistances.Junction junCHWS2(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal*{0.5,-1,0.5},
    dp_nominal={0,0,0},
    T_start=T_CHWR_nominal) "Junction on supply line" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-20,20})));
  Buildings.Fluid.FixedResistances.Junction junCHWR1(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal*{1,-1.5,-0.5},
    dp_nominal=dp_nominal*{0.3,0,-0.3},
    T_start=T_CHWR_nominal) "Junction on return line" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={20,40})));
  Buildings.Fluid.FixedResistances.Junction junCHWR2(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal*{1,-0.5,-0.5},
    dp_nominal=dp_nominal*{0,0,0},
    T_start=T_CHWR_nominal) "Junction on return line" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={20,-20})));
  Buildings.Fluid.FixedResistances.Junction junCHWR3(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal*{1,-1.5,0.5},
    dp_nominal=dp_nominal*{0.3,0,0.3},
    T_start=T_CHWR_nominal) "Junction on return line" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={20,-80})));
  Buildings.Fluid.Movers.SpeedControlled_y pumChi1(
    redeclare package Medium = Medium,
    per(pressure(dp=dp_nominal*{2,1.2,0}, V_flow=(m_flow_nominal)/1.2*{0,1.2,2})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=true,
    addPowerToMedium=false,
    y_start=0,
    T_start=T_CHWR_nominal) "Supply pump for chiller 1" annotation (Placement(
        transformation(extent={{-70,70},{-50,90}}, rotation=0)));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin mulMin_dpCon(nin=3)
    "Min of pressure head measured from all consumers"
    annotation (Placement(transformation(extent={{-10,160},{-30,180}})));
  Modelica.Blocks.Sources.Constant set_dpCon(k=1)
    "Normalised consumer differential pressure setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-90,150})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.PumChi1Control conPumChi1
    "Control block" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-60,110})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax mulMax_yVal12(nin=2)
    "Max of valve position measured from consumers 1 and 2"
    annotation (Placement(transformation(extent={{-20,120},{-40,140}})));
  Modelica.Blocks.Sources.Constant set_TRet(k=12 + 273.15)
    "CHW return setpoint"
    annotation (Placement(transformation(extent={{10,110},{30,130}})));
  Modelica.Blocks.Sources.TimeTable preQ1CooLoa_flow(table=[0*3600,0; 0.25*3600,
        0; 0.25*3600,5*4200*1.01; 0.75*3600,5*4200*1.01; 0.75*3600,0; 1*3600,0])
    "Placeholder, prescribed cooling load"
    annotation (Placement(transformation(extent={{120,80},{100,100}})));
  Modelica.Blocks.Sources.TimeTable preQ2CooLoa_flow(table=[0*3600,0; 0.25*3600,
        0; 0.25*3600,5*4200*1.01; 0.5*3600,5*4200*1.01; 0.5*3600,0; 1*3600,0])
    "Placeholder, prescribed cooling load"
    annotation (Placement(transformation(extent={{120,20},{100,40}})));
  Modelica.Blocks.Sources.TimeTable preQ3CooLoa_flow(table=[0*3600,0; 0.75*3600,
        0; 0.75*3600,5*4200*1.01; 1*3600,5*4200*1.01])
    "Placeholder, prescribed cooling load"
    annotation (Placement(transformation(extent={{120,-40},{100,-20}})));
  Controls.OBC.CDL.Continuous.Hysteresis hysCat(uLow=0.05, uHigh=0.5)
    "Shut off at con.yVal = 0.05 and restarts at 0.5" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={10,-110})));
  Controls.OBC.CDL.Continuous.MultiMax mulMax_yVal23(nin=2)
    "Max of valve position measured from consumers 2 and 3"
    annotation (Placement(transformation(extent={{60,-120},{40,-100}})));
  Modelica.Blocks.Sources.BooleanConstant booFloDir
    "Placeholder, constant normal direction"
    annotation (Placement(transformation(extent={{-20,-140},{-40,-120}})));
  Modelica.Blocks.Sources.Constant set_mTan_flow(k=0)
    "Placeholder, tank flow rate setpoint"
    annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));
  Modelica.Blocks.Sources.Constant set_mChi2_flow(k=m_flow_nominal)
    "Placeholder, chiller 2 flow rate setpoint"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Blocks.Math.Gain gai(k=1/con1.dp_nominal) "Gain" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-60,150})));
  Sources.Boundary_pT                 sou_p(
    redeclare final package Medium = Medium,
    final p=p_CHWR_nominal,
    final T=T_CHWR_nominal,
    nPorts=1) "Pressurisation point" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,0})));
equation
  connect(junCHWS1.port_2, con1.port_a)
    annotation (Line(points={{-10,80},{60,80},{60,70}},   color={0,127,255}));
  connect(cat.port_b, junCHWS3.port_1) annotation (Line(points={{-60,-50},{-60,-40},
          {-30,-40}}, color={0,127,255}));
  connect(junCHWS3.port_3, junCHWS2.port_3)
    annotation (Line(points={{-20,-30},{-20,10}}, color={0,127,255}));
  connect(junCHWS1.port_3, junCHWS2.port_1) annotation (Line(points={{-20,70},{-20,
          56},{-34,56},{-34,20},{-30,20}}, color={0,127,255}));
  connect(junCHWS2.port_2, con2.port_a)
    annotation (Line(points={{-10,20},{60,20},{60,10}},   color={0,127,255}));
  connect(junCHWS3.port_2, con3.port_a) annotation (Line(points={{-10,-40},{60,-40},
          {60,-50}},   color={0,127,255}));
  connect(con1.port_b, junCHWR1.port_1)
    annotation (Line(points={{60,50},{60,40},{30,40}}, color={0,127,255}));
  connect(junCHWR1.port_2, chi1.port_a)
    annotation (Line(points={{10,40},{-50,40}},            color={0,127,255}));
  connect(con3.port_b, junCHWR3.port_1)
    annotation (Line(points={{60,-70},{60,-80},{30,-80}}, color={0,127,255}));
  connect(junCHWR3.port_2, cat.port_a) annotation (Line(points={{10,-80},{-60,-80},
          {-60,-70}}, color={0,127,255}));
  connect(con2.port_b, junCHWR2.port_1)
    annotation (Line(points={{60,-10},{60,-20},{30,-20}}, color={0,127,255}));
  connect(junCHWR3.port_3, junCHWR2.port_2) annotation (Line(points={{20,-70},{20,
          -50},{2,-50},{2,-20},{10,-20}}, color={0,127,255}));
  connect(junCHWR2.port_3, junCHWR1.port_3)
    annotation (Line(points={{20,-10},{20,30}}, color={0,127,255}));
  connect(chi1.port_b, pumChi1.port_a)
    annotation (Line(points={{-70,40},{-80,40},{-80,80},{-70,80}},
                                                          color={0,127,255}));
  connect(pumChi1.port_b, junCHWS1.port_1)
    annotation (Line(points={{-50,80},{-30,80}}, color={0,127,255}));
  connect(con1.dp, mulMin_dpCon.u[1]) annotation (Line(points={{71,63},{80,63},
          {80,100},{0,100},{0,169.333},{-8,169.333}},
                                     color={0,0,127}));
  connect(con2.dp, mulMin_dpCon.u[2]) annotation (Line(points={{71,3},{80,3},{80,
          100},{0,100},{0,170},{-8,170}},
                          color={0,0,127}));
  connect(set_dpCon.y, conPumChi1.us_dpCon) annotation (Line(points={{-90,139},{
          -90,126},{-66,126},{-66,121}}, color={0,0,127}));
  connect(mulMax_yVal12.y, conPumChi1.yVal)
    annotation (Line(points={{-42,130},{-54,130},{-54,121}}, color={0,0,127}));
  connect(conPumChi1.y, pumChi1.y)
    annotation (Line(points={{-60,99},{-60,92}}, color={0,0,127}));
  connect(con1.yVal_actual, mulMax_yVal12.u[1]) annotation (Line(points={{71,67},
          {76,67},{76,94},{-10,94},{-10,129.5},{-18,129.5}}, color={0,0,127}));
  connect(con2.yVal_actual, mulMax_yVal12.u[2]) annotation (Line(points={{71,7},
          {76,7},{76,94},{-10,94},{-10,130.5},{-18,130.5}}, color={0,0,127}));
  connect(con3.dp, mulMin_dpCon.u[3]) annotation (Line(points={{71,-57},{80,-57},
          {80,100},{0,100},{0,170.667},{-8,170.667}},        color={0,0,127}));
  connect(set_TRet.y, con1.TSet) annotation (Line(points={{31,120},{36,120},{36,
          76},{65,76},{65,71}}, color={0,0,127}));
  connect(set_TRet.y, con2.TSet) annotation (Line(points={{31,120},{36,120},{36,
          16},{65,16},{65,11}}, color={0,0,127}));
  connect(set_TRet.y, con3.TSet) annotation (Line(points={{31,120},{36,120},{36,
          -44},{65,-44},{65,-49}}, color={0,0,127}));
  connect(preQ1CooLoa_flow.y, con1.QCooLoa_flow)
    annotation (Line(points={{99,90},{69,90},{69,71}}, color={0,0,127}));
  connect(preQ2CooLoa_flow.y, con2.QCooLoa_flow)
    annotation (Line(points={{99,30},{69,30},{69,11}}, color={0,0,127}));
  connect(preQ3CooLoa_flow.y, con3.QCooLoa_flow)
    annotation (Line(points={{99,-30},{69,-30},{69,-49}}, color={0,0,127}));
  connect(con3.yVal_actual, mulMax_yVal23.u[1]) annotation (Line(points={{71,-53},
          {86,-53},{86,-110},{74,-110},{74,-110.5},{62,-110.5}}, color={0,0,127}));
  connect(con2.yVal_actual, mulMax_yVal23.u[2]) annotation (Line(points={{71,7},
          {86,7},{86,-109.5},{62,-109.5}}, color={0,0,127}));
  connect(mulMax_yVal23.y, hysCat.u)
    annotation (Line(points={{38,-110},{22,-110}}, color={0,0,127}));
  connect(hysCat.y, cat.onOffLin) annotation (Line(points={{-2,-110},{-50,-110},
          {-50,-72},{-51,-72}}, color={255,0,255}));
  connect(booFloDir.y, cat.booFloDir) annotation (Line(points={{-41,-130},{-55,-130},
          {-55,-72}}, color={255,0,255}));
  connect(set_mTan_flow.y, cat.set_mTan_flow) annotation (Line(points={{-79,-130},
          {-65,-130},{-65,-71}}, color={0,0,127}));
  connect(set_mChi2_flow.y, cat.set_mPum1_flow) annotation (Line(points={{-79,-90},
          {-70,-90},{-70,-71},{-69,-71}}, color={0,0,127}));
  connect(mulMin_dpCon.y, gai.u)
    annotation (Line(points={{-32,170},{-60,170},{-60,162}}, color={0,0,127}));
  connect(gai.y, conPumChi1.um_dpCon)
    annotation (Line(points={{-60,139},{-60,121}}, color={0,0,127}));
  connect(sou_p.ports[1], chi1.port_a) annotation (Line(points={{-60,0},{-44,0},
          {-44,40},{-50,40}}, color={0,127,255}));
  annotation (experiment(Tolerance=1e-06, StopTime=3600),
        Diagram(coordinateSystem(extent={{-100,-140},{120,180}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})));
end TwoSourcesThreeUsers;
