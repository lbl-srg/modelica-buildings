within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.BaseClasses;
partial model PartialDecoupling
  "Partial model of primary variable circuit serving a decoupling circuit"
  extends BaseClasses.PartialActivePrimary(
    typ=Buildings.Fluid.HydronicConfigurations.Types.Control.ChangeOver,
    m2_flow_nominal=nTer*mTer_flow_nominal/0.9,
    m1_flow_nominal=1.1*m2_flow_nominal,
    mPum_flow_nominal=m1_flow_nominal/0.9,
    dpPum_nominal=10e4,
    del1(nPorts=3),
    redeclare Movers.FlowControlled_dp pum(
      final m_flow_nominal=mPum_flow_nominal,
      final dp_nominal=dpPum_nominal),
    ref(use_T_in=true));

  parameter Boolean is_bal=true
    "Set to true for balanced primary branch"
    annotation(Dialog(group="Configuration"), Evaluate=true);

  parameter Modelica.Units.SI.PressureDifference dp2Set(displayUnit="Pa")=
    loa1.dpTer_nominal + loa1.dpValve_nominal
    "Consumer circuit pressure differential set point"
    annotation (Dialog(group="Controls"));

  parameter Modelica.Units.SI.PressureDifference dp2_nominal(displayUnit="Pa")=
    dpPip_nominal + dp2Set
    "Consumer circuit pressure differential at design conditions"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.PressureDifference dp1_nominal(displayUnit="Pa")=
    dpPum_nominal - dpPip_nominal
    "Control valve pressure drop at design conditions";

  Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Decoupling con(
    typPum=Buildings.Fluid.HydronicConfigurations.Types.Pump.SingleVariable,
    typCtl=typ,
    redeclare final package Medium=MediumLiq,
    final energyDynamics=energyDynamics,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final dp1_nominal=dp1_nominal,
    final dp2_nominal=dp2_nominal,
    final dpBal1_nominal=if is_bal then
      dpPum_nominal-dpPip_nominal-con.dpValve_nominal-con.dpBal3_nominal else 0)
    "Hydronic connection"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));

  Sensors.RelativePressure dp(
    redeclare final package Medium = MediumLiq)
    "Differential pressure"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  BaseClasses.LoadTwoWayValveControl loa(
    redeclare final package MediumLiq = MediumLiq,
    final typ=typ,
    final energyDynamics=energyDynamics,
    final mLiq_flow_nominal=mTer_flow_nominal,
    final TLiqEnt_nominal=TLiqEnt_nominal,
    final TLiqEntChg_nominal=TLiqEntChg_nominal,
    final TLiqLvg_nominal=TLiqLvg_nominal,
    dpBal1_nominal=dp2_nominal - loa.dpTer_nominal - loa.dpValve_nominal)
    "Load"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));
  BaseClasses.LoadTwoWayValveControl loa1(
    redeclare final package MediumLiq = MediumLiq,
    final typ=typ,
    final energyDynamics=energyDynamics,
    final mLiq_flow_nominal=mTer_flow_nominal,
    final TLiqEnt_nominal=TLiqEnt_nominal,
    final TLiqEntChg_nominal=TLiqEntChg_nominal,
    final TLiqLvg_nominal=TLiqLvg_nominal,
    dpBal1_nominal=0)
    "Load"
    annotation (Placement(transformation(extent={{80,90},{100,110}})));
  FixedResistances.PressureDrop res2(
    redeclare final package Medium = MediumLiq,
    m_flow_nominal=con.pum.m_flow_nominal - loa.mLiq_flow_nominal,
    dp_nominal=dpPip_nominal)
    "Pipe pressure drop"
    annotation (Placement(transformation(extent={{50,50},{70,70}})));
  Sensors.RelativePressure dp2(redeclare final package Medium = MediumLiq)
    "Differential pressure"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  FixedResistances.PressureDrop resEnd2(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=0.1*m2_flow_nominal,
    final dp_nominal=dp2Set)
    "Pipe pressure drop"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={120,50})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dp2SetVal(final k=
        dp2Set) "Pressure differential set point"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));
  Controls.PIDWithOperatingMode ctlPum2(
    k=1,
    Ti=60,
    r=MediumLiq.p_default,
    y_reset=1) "Pump controller"
    annotation (Placement(transformation(extent={{-50,30},{-30,10}})));
  FixedResistances.PressureDrop resEnd1(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=0.1*mPum_flow_nominal,
    final dp_nominal=dpPum_nominal)
    "Pipe pressure drop"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,-70})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dp1SetVal(final k=
        dpPum_nominal)
                "Pressure differential set point"
    annotation (Placement(transformation(extent={{-140,-22},{-120,-2}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable fraLoa(table=[0,0,0; 6,
        0,0; 6.1,1,1; 8,1,1; 9,1,0; 14,0.5,0; 14.5,0,0; 16,0,0; 17,0,1; 21,0,1;
        22,0,0; 24,0,0], timeScale=3600) "Load modulating signal"
    annotation (Placement(transformation(extent={{-140,110},{-120,130}})));
  Delays.DelayFirstOrder del2(
    redeclare final package Medium = MediumLiq,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=m2_flow_nominal,
    nPorts=3) "Fluid transport delay"
    annotation (Placement(transformation(extent={{30,40},{50,20}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable mode(
    table=[0,0; 6,0; 6,2; 13,2; 13,1; 22,1; 22,0; 24,0],
    timeScale=3600,
    period=86400) "Operating mode (time schedule)"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold isEna(final t=Controls.OperatingModes.disabled)
    "Returns true if enabled"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-100,60})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Switch on/off"
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0) "Zero"
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger modPum
    "Pump operating mode"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant T1SetVal[2](
    final k={TLiqSup_nominal, TLiqSupChg_nominal})
    "Primary circuit temperature set point values"
    annotation (Placement(transformation(extent={{-140,-130},{-120,-110}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor T1Set(
    allowOutOfRange=true,
    nin=2,
    outOfRangeValue=20 + 273.15,
    y(final unit="K", displayUnit="degC"))
    "Primary circuit temperature set point"
    annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-100,-120})));
  Sensors.TemperatureTwoPort T1ConRet(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=con.m2_flow_nominal,
    tau=if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then 0
         else 1) "Primary branch return temperature sensor" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={20,-20})));
  FixedResistances.Junction jun(
    redeclare final package Medium=MediumLiq,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=m2_flow_nominal .* {1,-1,-1},
    final dp_nominal=fill(0, 3))
    "Junction"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={20,60})));
equation
  connect(con.port_a1, dp.port_a) annotation (Line(points={{4,0},{0,0},{0,-40}},
                     color={0,127,255}));
  connect(res1.port_b, dp.port_a) annotation (Line(points={{-10,-60},{0,-60},{0,
          -40}},     color={0,127,255}));
  connect(dp.port_b, del1.ports[2])
    annotation (Line(points={{20,-40},{20,-80}},   color={0,127,255}));
  connect(fraLoa.y[1],loa. u) annotation (Line(points={{-118,120},{10,120},{10,108},
          {18,108}}, color={0,0,127}));
  connect(fraLoa.y[2],loa1. u) annotation (Line(points={{-118,120},{70,120},{70,
          108},{78,108}},
                     color={0,0,127}));
  connect(res2.port_b,loa1. port_a)
    annotation (Line(points={{70,60},{80,60},{80,100}},   color={0,127,255}));
  connect(mode.y[1],loa. mode) annotation (Line(points={{-118,80},{10,80},{10,104},
          {18,104}}, color={255,127,0}));
  connect(mode.y[1],loa1. mode) annotation (Line(points={{-118,80},{70,80},{70,104},
          {78,104}},                  color={255,127,0}));
  connect(dp2.port_a,loa1. port_a)
    annotation (Line(points={{80,70},{80,100}},   color={0,127,255}));
  connect(dp2.port_b,loa1. port_b)
    annotation (Line(points={{100,70},{100,100}}, color={0,127,255}));
  connect(dp2.p_rel,ctlPum2. u_m) annotation (Line(points={{90,61},{90,50},{-40,
          50},{-40,32}}, color={0,0,127}));
  connect(res2.port_b,resEnd2. port_a)
    annotation (Line(points={{70,60},{120,60}},          color={0,127,255}));
  connect(res1.port_b, resEnd1.port_a)
    annotation (Line(points={{-10,-60},{40,-60}}, color={0,127,255}));
  connect(resEnd1.port_b, del1.ports[3])
    annotation (Line(points={{40,-80},{20,-80}}, color={0,127,255}));
  connect(dp2SetVal.y, ctlPum2.u_s)
    annotation (Line(points={{-118,20},{-52,20}}, color={0,0,127}));
  connect(mode.y[1], con.mode) annotation (Line(points={{-118,80},{-10,80},{-10,
          18},{-2,18}}, color={255,127,0}));
  connect(mode.y[1], isEna.u) annotation (Line(points={{-118,80},{-100,80},{-100,
          72}}, color={255,127,0}));
  connect(dp1SetVal.y, swi.u1) annotation (Line(points={{-118,-12},{-92,-12}},
                           color={0,0,127}));
  connect(zer.y, swi.u3) annotation (Line(points={{-118,-50},{-100,-50},{-100,-28},
          {-92,-28}}, color={0,0,127}));
  connect(isEna.y, swi.u2) annotation (Line(points={{-100,48},{-100,-20},{-92,-20}},
        color={255,0,255}));
  connect(swi.y, pum.dp_in) annotation (Line(points={{-68,-20},{-60,-20},{-60,-40},
          {-80,-40},{-80,-48}}, color={0,0,127}));
  connect(modPum.y, ctlPum2.mod)
    annotation (Line(points={{-58,40},{-46,40},{-46,32}}, color={255,127,0}));
  connect(isEna.y, modPum.u) annotation (Line(points={{-100,48},{-100,40},{-82,40}},
                              color={255,0,255}));
  connect(T1Set.y, ref.T_in) annotation (Line(points={{-88,-120},{-76,-120},{-76,
          -102}}, color={0,0,127}));
  connect(T1SetVal.y, T1Set.u)
    annotation (Line(points={{-118,-120},{-112,-120}}, color={0,0,127}));
  connect(mode.y[1], T1Set.index) annotation (Line(points={{-118,80},{-100,80},{
          -100,100},{-160,100},{-160,-100},{-100,-100},{-100,-108}},color={255,127,
          0}));
  connect(con.port_b1, T1ConRet.port_a)
    annotation (Line(points={{16,0},{20,0},{20,-10}}, color={0,127,255}));
  connect(T1ConRet.port_b, dp.port_b)
    annotation (Line(points={{20,-30},{20,-40}}, color={0,127,255}));

  connect(ctlPum2.y, con.yPum) annotation (Line(points={{-28,20},{-20,20},{-20,14},
          {-2,14}}, color={0,0,127}));
  connect(jun.port_2, res2.port_a)
    annotation (Line(points={{30,60},{50,60}}, color={0,127,255}));
  connect(jun.port_3, loa.port_a)
    annotation (Line(points={{20,70},{20,100}}, color={0,127,255}));
  connect(del2.ports[1], resEnd2.port_b)
    annotation (Line(points={{38.6667,40},{120,40}}, color={0,127,255}));
  connect(dp2.port_b, del2.ports[2])
    annotation (Line(points={{100,70},{100,40},{40,40}}, color={0,127,255}));
  connect(loa.port_b, del2.ports[3]) annotation (Line(points={{40,100},{40,70},
          {40,40},{41.3333,40}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(extent={{-180,-160},{180,160}})));
end PartialDecoupling;
