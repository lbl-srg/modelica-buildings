within Buildings.Fluid.Storage.Plant.Examples;
model TwoSourcesThreeUsers
  "(Draft) District system model with two sources and three users"
  extends Modelica.Icons.Example;

  package Medium1 = Buildings.Media.Water "Medium model for CDW";
  package Medium2 = Buildings.Media.Water "Medium model for CHW";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=500000
    "Nominal pressure difference";
  parameter Modelica.Units.SI.AbsolutePressure p_CHWS_nominal=
    p_CHWR_nominal+dp_nominal
    "Nominal pressure at CHW supply line";
  parameter Modelica.Units.SI.AbsolutePressure p_CHWR_nominal=300000
    "Nominal pressure at CHW return line";
  parameter Modelica.Units.SI.Temperature T_CHWR_nominal=12+273.15
    "Nominal temperature of CHW return";
  parameter Modelica.Units.SI.Temperature T_CHWS_nominal=7+273.15
    "Nominal temperature of CHW supply";
  parameter Modelica.Units.SI.Power QCooLoa_flow_nominal=5*4200*0.6
    "Nominal cooling load of one consumer";

  Buildings.Fluid.Storage.Plant.ChillerAndTank cat(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
    final mEva_flow_nominal=0.3*m_flow_nominal,
    final mCon_flow_nominal=0.3*m_flow_nominal,
    final mTan_flow_nominal=0.3*m_flow_nominal,
    final dp_nominal=dp_nominal,
    final T_CHWS_nominal=T_CHWS_nominal,
    final T_CHWR_nominal=T_CHWR_nominal,
    final preDroTan(final dp_nominal=cat.dp_nominal*0.1),
    final valCha(final dpValve_nominal=cat.dp_nominal*0.1),
    final valDis(final dpValve_nominal=cat.dp_nominal*0.1),
    final cheValPumPri(final dpValve_nominal=cat.dp_nominal*0.1,
                       final dpFixed_nominal=cat.dp_nominal*0.1),
    final cheValPumSec(final dpValve_nominal=cat.dp_nominal*0.1,
                       final dpFixed_nominal=cat.dp_nominal*0.1))
    "Chiller and tank, tank can be charged remotely" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-60,-60})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.DummyUser usr1(
    redeclare package Medium = Medium2,
    m_flow_nominal=m_flow_nominal,
    p_a_nominal=p_CHWS_nominal - dp_nominal*0.35,
    p_b_nominal=p_CHWR_nominal + dp_nominal*0.35,
    T_a_nominal=T_CHWS_nominal,
    T_b_nominal=T_CHWR_nominal) "Dummy user 1" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,60})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.DummyUser usr2(
    redeclare package Medium = Medium2,
    m_flow_nominal=m_flow_nominal,
    p_a_nominal=p_CHWS_nominal - dp_nominal*0.35,
    p_b_nominal=p_CHWR_nominal + dp_nominal*0.35,
    T_a_nominal=T_CHWS_nominal,
    T_b_nominal=T_CHWR_nominal) "Dummy usr 2" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,0})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.DummyUser usr3(
    redeclare package Medium = Medium2,
    m_flow_nominal=m_flow_nominal,
    p_a_nominal=p_CHWS_nominal - dp_nominal*0.35,
    p_b_nominal=p_CHWR_nominal + dp_nominal*0.35,
    T_a_nominal=T_CHWS_nominal,
    T_b_nominal=T_CHWR_nominal) "Dummy user 3" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-60})));
  Buildings.Fluid.Movers.SpeedControlled_y pumChi1(
    redeclare package Medium = Medium2,
    per(pressure(dp=dp_nominal*{2,1.2,0}, V_flow=(m_flow_nominal*1.5)/1.2*{0,1.2,2})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    addPowerToMedium=false,
    final y_start=1,
    T_start=T_CHWR_nominal) "Supply pump for chiller 1" annotation (Placement(
        transformation(extent={{-50,30},{-70,50}}, rotation=0)));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin mulMin_dpUsr(nin=3)
    "Min of pressure head measured from all users"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-10,130})));
  Modelica.Blocks.Sources.Constant set_dpUsr(k=1)
    "Normalised consumer differential pressure setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,150})));
  Modelica.Blocks.Sources.Constant set_TRet(k=12 + 273.15)
    "CHW return setpoint"
    annotation (Placement(transformation(extent={{20,100},{40,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysCat(uLow=0.05, uHigh=0.5)
    "Shut off at con.yVal = 0.05 and restarts at 0.5" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={10,-110})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax mulMax_yVal(nin=3)
    "Max of valve positions"
    annotation (Placement(transformation(extent={{60,-120},{40,-100}})));
  Modelica.Blocks.Sources.Constant set_mChi2PumPri_flow(k=0.75*m_flow_nominal)
    "Placeholder, primary flow rate setpoint"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  Buildings.Fluid.Sources.Boundary_pT sou_p(
    redeclare final package Medium = Medium2,
    final p=p_CHWR_nominal,
    final T=T_CHWR_nominal,
    nPorts=1) "Pressurisation point" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,30})));
  Buildings.Controls.Continuous.LimPID conPI_PumChi1(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=1,
    Ti=100,
    reverseActing=true) "PI controller" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-60,110})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroS2U3(
    redeclare package Medium = Medium2,
    final allowFlowReversal=true,
    final dp_nominal=0.3*dp_nominal,
    final m_flow_nominal=m_flow_nominal) "Flow resistance source 2 to user 3"
    annotation (Placement(transformation(extent={{-30,-50},{-10,-30}})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroU3S2(
    redeclare package Medium = Medium2,
    final allowFlowReversal=true,
    final dp_nominal=0.3*dp_nominal,
    final m_flow_nominal=m_flow_nominal) "Flow resistance user 3 to source 2"
    annotation (Placement(transformation(extent={{30,-90},{10,-70}})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroS2U2(
    redeclare package Medium = Medium2,
    final allowFlowReversal=true,
    final dp_nominal=0.3*dp_nominal,
    final m_flow_nominal=m_flow_nominal) "Flow resistance source 2 to user 2"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroU2S2(
    redeclare package Medium = Medium2,
    final allowFlowReversal=true,
    final dp_nominal=0.3*dp_nominal,
    final m_flow_nominal=m_flow_nominal) "Flow resistance user 2 to source 2"
    annotation (Placement(transformation(extent={{30,-30},{10,-10}})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroS1U2(
    redeclare package Medium = Medium2,
    final allowFlowReversal=true,
    final dp_nominal=0.3*dp_nominal,
    final m_flow_nominal=m_flow_nominal) "Flow resistance source 1 to user 2"
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroU2S1(
    redeclare package Medium = Medium2,
    final allowFlowReversal=true,
    final dp_nominal=0.3*dp_nominal,
    final m_flow_nominal=m_flow_nominal) "Flow resistance user 2 to source 1"
    annotation (Placement(transformation(extent={{30,-10},{10,10}})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroS1U1(
    redeclare package Medium = Medium2,
    final allowFlowReversal=true,
    final dp_nominal=0.3*dp_nominal,
    final m_flow_nominal=m_flow_nominal) "Flow resistance source 1 to user 3"
    annotation (Placement(transformation(extent={{-30,70},{-10,90}})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroU1S1(
    redeclare package Medium = Medium2,
    final allowFlowReversal=true,
    final dp_nominal=0.3*dp_nominal,
    final m_flow_nominal=m_flow_nominal) "Flow resistance user 1 to source 1"
    annotation (Placement(transformation(extent={{30,30},{10,50}})));
  Modelica.Blocks.Sources.TimeTable set_QCooLoa1_flow(table=[0,0; 3600/9*1,0;
        3600/9*1,QCooLoa_flow_nominal; 3600/9*4,QCooLoa_flow_nominal; 3600/9*4,
        0; 3600,0])
    "Cooling load"
    annotation (Placement(transformation(extent={{120,80},{100,100}})));
  Modelica.Blocks.Sources.TimeTable set_QCooLoa2_flow(table=[0,0; 3600/9*2,0;
        3600/9*2,QCooLoa_flow_nominal; 3600/9*5,QCooLoa_flow_nominal; 3600/9*5,
        0; 3600,0])
    "Cooling load"
    annotation (Placement(transformation(extent={{120,20},{100,40}})));
  Modelica.Blocks.Sources.TimeTable set_QCooLoa3_flow(table=[0,0; 3600/9*3,0;
        3600/9*3,QCooLoa_flow_nominal; 3600/9*7,QCooLoa_flow_nominal; 3600/9*7,
        0; 3600,0])                                       "Cooling load"
    annotation (Placement(transformation(extent={{120,-40},{100,-20}})));
  Modelica.Blocks.Math.Gain gaiUsr1(k=1/usr1.dp_nominal)
    "Gain to normalise dp measurement" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={110,60})));
  Modelica.Blocks.Math.Gain gaiUsr2(k=1/usr2.dp_nominal)
    "Gain to normalise dp measurement" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={110,0})));
  Modelica.Blocks.Math.Gain gaiUsr3(k=1/usr3.dp_nominal)
    "Gain to normalise dp measurement" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={110,-60})));
  Modelica.Blocks.Sources.BooleanTable booFloDir(table={3600/9*6,3600/9*8},
      startValue=true) "Flow direction: True = normal; False = reverse"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-80,10})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiTanCha
    "Tank setpoint: True = positive (discharging); False = negative (charging)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-10})));
  Modelica.Blocks.Sources.Constant set_mTan_flow_discharge(k=0.75*
        m_flow_nominal) "Placeholder, tank flow rate setpoint when discharging"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-140,10})));
  Modelica.Blocks.Sources.Constant set_mTan_flow_charge(k=-0.75*m_flow_nominal)
    "Placeholder, tank flow rate setpoint when charging" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-140,-30})));
  Modelica.Blocks.Sources.BooleanTable booTanCha(table={3600/9*1,3600/9*6,3600/
        9*8},startValue=false)
    "Tank charging status (local or remote): True = discharging; False = charging"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,-10})));
  Buildings.Fluid.Sources.MassFlowSource_T souCDW2(
    redeclare package Medium = Medium1,
    m_flow=1,
    T=305.15,
    nPorts=1) "Source representing CDW supply line"
    annotation (Placement(transformation(extent={{-108,-50},{-88,-30}})));
  Buildings.Fluid.Sources.Boundary_pT sinCDW2(
    redeclare final package Medium = Medium1,
    final p=300000,
    final T=310.15,
    nPorts=1) "Sink representing CDW return line" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-100,-100})));
  Buildings.Fluid.Chillers.ElectricEIR chi1(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
    final m1_flow_nominal=1.2*chi1.m2_flow_nominal,
    final m2_flow_nominal=0.7*m_flow_nominal,
    final dp1_nominal=0,
    final dp2_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    p2_start=p_CHWS_nominal,
    T2_start=T_CHWS_nominal,
    final per=cat.perChi)
    "Placeholder chiller" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-110,60})));
  Buildings.Fluid.Sources.MassFlowSource_T souCDW1(
    redeclare package Medium = Medium1,
    m_flow=1,
    T=305.15,
    nPorts=1) "Source representing CDW supply line"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));
  Buildings.Fluid.Sources.Boundary_pT sinCDW1(
    redeclare final package Medium = Medium1,
    final p=300000,
    final T=310.15,
    nPorts=1) "Sink representing CDW return line" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-150,70})));
  Modelica.Blocks.Sources.Constant set_TEvaLvg_chi1(k=T_CHWS_nominal)
    "Constant setpoint" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-90,150})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chi1On(k=true)
    "Placeholder, chi1 always on" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-120,150})));
  Buildings.Fluid.FixedResistances.CheckValve cheValChi1Pum(
    redeclare package Medium = Medium2,
    m_flow_nominal=chi1.vol2.m_flow_nominal,
    dpValve_nominal=0.1*dp_nominal,
    dpFixed_nominal=0.1*dp_nominal) "Check valve with series resistance"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
equation
  connect(set_TRet.y,usr1. TSet) annotation (Line(points={{41,110},{44,110},{44,
          82},{64,82},{64,71}}, color={0,0,127}));
  connect(set_TRet.y,usr2. TSet) annotation (Line(points={{41,110},{44,110},{44,
          22},{64,22},{64,11}}, color={0,0,127}));
  connect(set_TRet.y,usr3. TSet) annotation (Line(points={{41,110},{44,110},{44,
          -38},{64,-38},{64,-49}}, color={0,0,127}));
  connect(usr3.yVal_actual, mulMax_yVal.u[1]) annotation (Line(points={{71,-54},
          {86,-54},{86,-110},{74,-110},{74,-110.667},{62,-110.667}}, color={0,0,
          127}));
  connect(usr2.yVal_actual, mulMax_yVal.u[2]) annotation (Line(points={{71,6},{86,
          6},{86,-110},{62,-110}}, color={0,0,127}));
  connect(mulMax_yVal.y, hysCat.u)
    annotation (Line(points={{38,-110},{22,-110}}, color={0,0,127}));
  connect(hysCat.y, cat.uOnl) annotation (Line(points={{-2,-110},{-44,-110},{-44,
          -48},{-50,-48}}, color={255,0,255}));
  connect(set_mChi2PumPri_flow.y, cat.mPumPriSet_flow) annotation (Line(points=
          {{-119,-70},{-80,-70},{-80,-49},{-70,-49}}, color={0,0,127}));
  connect(set_dpUsr.y, conPI_PumChi1.u_s)
    annotation (Line(points={{-60,139},{-60,122}}, color={0,0,127}));
  connect(conPI_PumChi1.y, pumChi1.y)
    annotation (Line(points={{-60,99},{-60,52}},  color={0,0,127}));
  connect(usr1.yVal_actual, mulMax_yVal.u[3]) annotation (Line(points={{71,66},
          {86,66},{86,-110},{62,-110},{62,-109.333}},color={0,0,127}));
  connect(preDroS2U3.port_b,usr3. port_a)
    annotation (Line(points={{-10,-40},{60,-40},{60,-50}}, color={0,127,255}));
  connect(usr3.port_b,preDroU3S2. port_a)
    annotation (Line(points={{60,-70},{60,-80},{30,-80}}, color={0,127,255}));
  connect(preDroS2U2.port_b,usr2. port_a) annotation (Line(points={{-10,0},{-4,
          0},{-4,20},{60,20},{60,10}},
                            color={0,127,255}));
  connect(usr2.port_b,preDroU2S2. port_a)
    annotation (Line(points={{60,-10},{60,-20},{30,-20}}, color={0,127,255}));
  connect(preDroS1U2.port_b,usr2. port_a) annotation (Line(points={{-10,20},{60,
          20},{60,10}},         color={0,127,255}));
  connect(usr2.port_b,preDroU2S1. port_a) annotation (Line(points={{60,-10},{60,
          -20},{34,-20},{34,0},{30,0}}, color={0,127,255}));
  connect(preDroS1U1.port_b,usr1. port_a)
    annotation (Line(points={{-10,80},{60,80},{60,70}}, color={0,127,255}));
  connect(usr1.port_b,preDroU1S1. port_a)
    annotation (Line(points={{60,50},{60,40},{30,40}}, color={0,127,255}));
  connect(set_QCooLoa1_flow.y,usr1. QCooLoa_flow)
    annotation (Line(points={{99,90},{68,90},{68,71}}, color={0,0,127}));
  connect(set_QCooLoa2_flow.y,usr2. QCooLoa_flow)
    annotation (Line(points={{99,30},{68,30},{68,11}}, color={0,0,127}));
  connect(set_QCooLoa3_flow.y,usr3. QCooLoa_flow)
    annotation (Line(points={{99,-30},{68,-30},{68,-49}}, color={0,0,127}));
  connect(usr1.dpUsr, gaiUsr1.u)
    annotation (Line(points={{71,62},{71,60},{98,60}}, color={0,0,127}));
  connect(usr2.dpUsr, gaiUsr2.u) annotation (Line(points={{71,2},{71,1.55431e-15},
          {98,1.55431e-15}}, color={0,0,127}));
  connect(usr3.dpUsr, gaiUsr3.u) annotation (Line(points={{71,-58},{72,-58},{72,
          -60},{98,-60}}, color={0,0,127}));
  connect(gaiUsr1.y,mulMin_dpUsr. u[1]) annotation (Line(points={{121,60},{126,
          60},{126,142},{-9.33333,142}},
                                     color={0,0,127}));
  connect(gaiUsr2.y,mulMin_dpUsr. u[2]) annotation (Line(points={{121,-1.38778e-15},
          {126,-1.38778e-15},{126,142},{-10,142}}, color={0,0,127}));
  connect(gaiUsr3.y,mulMin_dpUsr. u[3]) annotation (Line(points={{121,-60},{126,
          -60},{126,142},{-10.6667,142}}, color={0,0,127}));
  connect(mulMin_dpUsr.y, conPI_PumChi1.u_m)
    annotation (Line(points={{-10,118},{-10,110},{-48,110}}, color={0,0,127}));
  connect(booFloDir.y, cat.booFloDir) annotation (Line(points={{-69,10},{-58,10},
          {-58,-48}},                                  color={255,0,255}));
  connect(set_mTan_flow_discharge.y, swiTanCha.u1) annotation (Line(points={{-129,10},
          {-126,10},{-126,-2},{-122,-2}},          color={0,0,127}));
  connect(set_mTan_flow_charge.y, swiTanCha.u3) annotation (Line(points={{-129,-30},
          {-126,-30},{-126,-18},{-122,-18}}, color={0,0,127}));
  connect(booTanCha.y, swiTanCha.u2)
    annotation (Line(points={{-159,-10},{-122,-10}}, color={255,0,255}));
  connect(swiTanCha.y, cat.mTanSet_flow)
    annotation (Line(points={{-98,-10},{-62,-10},{-62,-49}}, color={0,0,127}));
  connect(sinCDW2.ports[1], cat.port_b1) annotation (Line(points={{-90,-100},{-66,
          -100},{-66,-70}}, color={0,127,255}));
  connect(cat.port_a2, preDroU3S2.port_b) annotation (Line(points={{-54,-70},{-54,
          -80},{10,-80}}, color={0,127,255}));
  connect(cat.port_a2, preDroU2S2.port_b) annotation (Line(points={{-54,-70},{-54,
          -80},{-4,-80},{-4,-20},{10,-20}}, color={0,127,255}));
  connect(cat.port_a1, souCDW2.ports[1]) annotation (Line(points={{-66,-50},{-66,
          -40},{-88,-40}}, color={0,127,255}));
  connect(cat.port_b2, preDroS2U3.port_a) annotation (Line(points={{-54,-50},{-54,
          -40},{-30,-40}}, color={0,127,255}));
  connect(cat.port_b2, preDroS2U2.port_a) annotation (Line(points={{-54,-50},{-54,
          -40},{-36,-40},{-36,0},{-30,0}}, color={0,127,255}));
  connect(chi1.port_a1, souCDW1.ports[1]) annotation (Line(points={{-116,70},{
          -134,70},{-134,110},{-140,110}}, color={0,127,255}));
  connect(sinCDW1.ports[1], chi1.port_b1) annotation (Line(points={{-140,70},{
          -140,44},{-116,44},{-116,50}}, color={0,127,255}));
  connect(set_TEvaLvg_chi1.y, chi1.TSet) annotation (Line(points={{-90,139},{-90,
          112},{-107,112},{-107,72}},   color={0,0,127}));
  connect(chi1On.y, chi1.on) annotation (Line(points={{-120,138},{-120,78},{
          -113,78},{-113,72}}, color={255,0,255}));
  connect(chi1.port_b2, cheValChi1Pum.port_a) annotation (Line(points={{-104,70},
          {-104,80},{-90,80}},  color={0,127,255}));
  connect(preDroU1S1.port_b, pumChi1.port_a)
    annotation (Line(points={{10,40},{-50,40}}, color={0,127,255}));
  connect(pumChi1.port_b, chi1.port_a2) annotation (Line(points={{-70,40},{-104,
          40},{-104,50}}, color={0,127,255}));
  connect(preDroU2S1.port_b, pumChi1.port_a) annotation (Line(points={{10,0},{4,
          0},{4,40},{-50,40}}, color={0,127,255}));
  connect(cheValChi1Pum.port_b, preDroS1U1.port_a)
    annotation (Line(points={{-70,80},{-30,80}}, color={0,127,255}));
  connect(sou_p.ports[1], pumChi1.port_a)
    annotation (Line(points={{-160,30},{-50,30},{-50,40}}, color={0,127,255}));
  connect(cheValChi1Pum.port_b, preDroS1U2.port_a) annotation (Line(points={{-70,
          80},{-36,80},{-36,20},{-30,20}}, color={0,127,255}));
  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Examples/TwoSourcesThreeUsers.mos"
        "Simulate and plot"),
        experiment(Tolerance=1e-06, StopTime=3600,__Dymola_Algorithm="Dassl"),
        Diagram(coordinateSystem(extent={{-180,-140},{140,180}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
(Draft)
This is a district system model with two CHW sources and three users
as described in
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</p>
<p>
The first source is a simplified CHW plant with only a chiller,
a single supply pump, and a check valve (with series resistance built in).
This supply pump is controlled to ensure that all users have enough pressure head.
The system is pressurised before this supply pump.
</p>
<p>
The second source has a chiller and a stratified CHW tank. Its piping is arranged
in a way that allows the tank to be charged remotely by the other source.
Its supply pump is controlled to maintain the flow rate setpoint of the tank.
This plant is offline when the most open control valve of all users is less than
5% open and is back online when this value is more than 50%.
</p>
<p>
The timetables give the system the following behaviour:
</p>
<table summary= \"system modes\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<thead>
  <tr>
    <th>Time slots</th>
    <th>1</th>
    <th>2</th>
    <th>3</th>
    <th>4</th>
    <th>5</th>
    <th>6</th>
    <th>7</th>
    <th>8</th>
    <th>9</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>User 1</td>
    <td>-</td>
    <td>Has load</td>
    <td>Has load</td>
    <td>Has load</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
  </tr>
  <tr>
    <td>User 2</td>
    <td>-</td>
    <td>-</td>
    <td>Has load</td>
    <td>Has load</td>
    <td>Has load</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
  </tr>
  <tr>
    <td>User 3</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>Has load</td>
    <td>Has load</td>
    <td>Has load</td>
    <td>Has load</td>
    <td>-</td>
    <td>-</td>
  </tr>
  <tr>
    <td>Tank <br>(being charged)</td>
    <td>Local</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>Remote</td>
    <td>Remote</td>
    <td>-</td>
  </tr>
</tbody>
</table>
</html>", revisions="<html>
<ul>
<li>
February 18, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end TwoSourcesThreeUsers;
