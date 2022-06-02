within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.BaseClasses;
partial model PartialInjectionTwoWay
  "Partial model of primary variable circuit serving an inversion circuit with two-way valve"
  extends Modelica.Icons.Example;

  package MediumLiq = Buildings.Media.Water
    "Medium model for hot water";

  parameter Boolean is_bal=false
    "Set to true for a primary balancing valve";

  parameter Data.Generic dat(
    final have_bypFix=con.have_bypFix,
    final typVal=con.typVal,
    final typCha=con.typCha,
    final have_ctl=con.have_ctl,
    final typFun=con.typFun,
    final have_pum=con.have_pum,
    final typPum=con.typPum,
    final typPumMod=con.typPumMod,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dpValve_nominal=0.5 * dp1Set,
    dpBal1_nominal=if is_bal then dp1Set - dat.dpValve_nominal else 0,
    ctl(k=0.1, Ti=60))
    "Design and operating parameters for hydronic connection"
    annotation (Placement(transformation(extent={{80,-18},{100,2}})));

  parameter Modelica.Units.SI.MassFlowRate mTer_flow_nominal = 1
    "Terminal unit mass flow rate at design conditions";
  final parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal(final min=0)=
    m2_flow_nominal * (TLiqEnt_nominal - TLiqLvg_nominal) / (TLiqSup_nominal - TLiqLvg_nominal)
    "Mass flow rate in primary branch at design conditions"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal(final min=0)=
    2 * mTer_flow_nominal
    "Mass flow rate in consumer circuit at design conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpTer_nominal(displayUnit="Pa")=3E4
    "Terminal unit pressure drop at design conditions";
  parameter Modelica.Units.SI.PressureDifference dpPip_nominal(displayUnit="Pa")=0.5E4
    "Pipe section pressure drop at design conditions";
  parameter Real kSizPum(final unit="1") = 1.0
    "Pump oversizing coefficient";
  final parameter Modelica.Units.SI.PressureDifference dpPum_nominal(
    final min=0,
    displayUnit="Pa")=
    (dpPip_nominal + dp1Set) * kSizPum
    "Pump head at design conditions";
  parameter Modelica.Units.SI.MassFlowRate mPum_flow_nominal=
    m1_flow_nominal / 0.9
    "Primary pump mass flow rate at design conditions";
  parameter Modelica.Units.SI.Pressure dp1Set(
    final min=0,
    displayUnit="Pa") = 1e4
    "Pressure differential set point";

  parameter Modelica.Units.SI.Pressure p_min=200000
    "Circuit minimum pressure";

  parameter Modelica.Units.SI.Temperature TAirEnt_nominal=293.15
    "Air entering temperature at design conditions";
  parameter Modelica.Units.SI.Temperature TLiqEnt_nominal=313.15
    "Hot water entering temperature at design conditions";
  parameter Modelica.Units.SI.Temperature TLiqLvg_nominal=TLiqEnt_nominal-5
    "Hot water leaving temperature at design conditions";
  parameter Modelica.Units.SI.Temperature TLiqSup_nominal=333.15
    "Hot water primary supply temperature at design conditions";

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  Sources.Boundary_pT ref(
    redeclare final package Medium = MediumLiq,
    final p=p_min,
    final T=TLiqSup_nominal,
    nPorts=2)
    "Pressure and temperature boundary condition"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-60,-110})));
  Movers.SpeedControlled_y pum(
    redeclare final package Medium = MediumLiq,
    final energyDynamics=energyDynamics,
    addPowerToMedium=false,
    use_inputFilter=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState,
    per(pressure(V_flow={0,1,2}*mPum_flow_nominal/996, dp={1.2,1,0.4}*
            dpPum_nominal)),
    inputType=Buildings.Fluid.Types.InputType.Continuous)
    "Circulation pump"
    annotation (Placement(transformation(extent={{-70,-90},{-50,-70}})));

  InjectionTwoWay con(
    have_ctl=true,
    typFun=Buildings.Fluid.HydronicConfigurations.Types.ControlFunction.Heating,
    typPum=Buildings.Fluid.HydronicConfigurations.Types.Pump.SingleConstant,
    redeclare final package Medium = MediumLiq,
    use_lumFloRes=false,
    final energyDynamics=energyDynamics,
    final dat=dat,
    pum(addPowerToMedium=false))
    "Hydronic connection"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));

  FixedResistances.PressureDrop res1(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mPum_flow_nominal,
    final dp_nominal=dpPip_nominal) "Pipe pressure drop"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Sensors.RelativePressure dp1(redeclare final package Medium = MediumLiq)
    "Differential pressure"
    annotation (Placement(transformation(extent={{20,-50},{40,-70}})));
  Sensors.TemperatureTwoPort TRet(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mPum_flow_nominal,
    T_start=TLiqSup_nominal)
    "Return temperature sensor"
    annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-20,-100})));
  Sensors.TemperatureTwoPort TSup(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mPum_flow_nominal,
    T_start=TLiqSup_nominal)
    "Supply temperature sensor"
    annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-40,-80})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract  delT(y(final unit="K"))
    "Primary delta-T"
    annotation (Placement(transformation(extent={{-8,-130},{12,-110}})));
  FixedResistances.PressureDrop resEnd1(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=0.1*mPum_flow_nominal,
    final dp_nominal=dp1Set) "Pipe pressure drop" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,-90})));
  Controls.PIDWithOperatingMode             ctl(
    k=1,
    Ti=60,
    r=MediumLiq.p_default,
    y_reset=1) "Pump controller"
    annotation (Placement(transformation(extent={{-70,-30},{-50,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dp1SetVal(final k=
        dp1Set) "Pressure differential set point"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable mod1(
    table=[0,0; 6,0; 6,1; 22,1; 22,0; 24,0],
    timeScale=3600,
    period=86400)
    "Operating mode (time schedule)"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Delays.DelayFirstOrder del2(
    redeclare final package Medium = MediumLiq,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=m2_flow_nominal,
    nPorts=1) "Fluid transport delay"
    annotation (Placement(transformation(extent={{50,20},{70,0}})));
  Delays.DelayFirstOrder del1(
    redeclare final package Medium = MediumLiq,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=mPum_flow_nominal,
    nPorts=3)
    "Fluid transport delay"
    annotation (Placement(transformation(extent={{30,-100},{50,-120}})));


equation
  connect(ref.ports[1],pum. port_a) annotation (Line(points={{-61,-100},{-80,-100},
          {-80,-80},{-70,-80}},
                            color={0,127,255}));
  connect(res1.port_b, dp1.port_a)
    annotation (Line(points={{10,-80},{20,-80},{20,-60}}, color={0,127,255}));
  connect(con.port_b1, dp1.port_b) annotation (Line(points={{36,0},{36,-20},{40,
          -20},{40,-60}}, color={0,127,255}));
  connect(con.port_a1, dp1.port_a) annotation (Line(points={{24,0},{24,-20},{20,
          -20},{20,-60}}, color={0,127,255}));
  connect(TRet.port_b,ref. ports[2])
    annotation (Line(points={{-30,-100},{-59,-100}},
                                                   color={0,127,255}));
  connect(pum.port_b,TSup. port_a)
    annotation (Line(points={{-50,-80},{-50,-80}}, color={0,127,255}));
  connect(TSup.port_b, res1.port_a)
    annotation (Line(points={{-30,-80},{-10,-80}}, color={0,127,255}));
  connect(TRet.T,delT. u1)
    annotation (Line(points={{-20,-111},{-20,-114},{-10,-114}},
                                                            color={0,0,127}));
  connect(TSup.T,delT. u2)
    annotation (Line(points={{-40,-91},{-40,-126},{-10,-126}},
                                                            color={0,0,127}));
  connect(dp1SetVal.y, ctl.u_s)
    annotation (Line(points={{-98,-20},{-72,-20}}, color={0,0,127}));
  connect(dp1.p_rel, ctl.u_m) annotation (Line(points={{30,-51},{30,-40},{-60,-40},
          {-60,-32}}, color={0,0,127}));
  connect(ctl.y,pum. y) annotation (Line(points={{-48,-20},{-40,-20},{-40,-60},{
          -60,-60},{-60,-68}},
                           color={0,0,127}));
  connect(mod1.y[1], con.mod) annotation (Line(points={{-98,20},{10,20},{10,18},
          {18,18}},
                color={255,127,0}));
  connect(mod1.y[1], ctl.mod) annotation (Line(points={{-98,20},{-80,20},{-80,-40},
          {-66,-40},{-66,-32}}, color={255,127,0}));
  connect(resEnd1.port_b, del1.ports[1])
    annotation (Line(points={{80,-100},{38.6667,-100}}, color={0,127,255}));
  connect(del1.ports[2], TRet.port_a)
    annotation (Line(points={{40,-100},{-10,-100}}, color={0,127,255}));
  connect(dp1.port_b, del1.ports[3]) annotation (Line(points={{40,-60},{40,-100},
          {41.3333,-100}}, color={0,127,255}));
  connect(res1.port_b, resEnd1.port_a)
    annotation (Line(points={{10,-80},{80,-80}}, color={0,127,255}));
  connect(del2.ports[1], con.port_a2) annotation (Line(points={{60,20},{48,20},{
          48,19.8},{36,19.8}},
                            color={0,127,255}));
  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,140}})));
end PartialInjectionTwoWay;
