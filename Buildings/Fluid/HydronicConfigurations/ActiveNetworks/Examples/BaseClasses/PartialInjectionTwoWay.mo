within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.BaseClasses;
partial model PartialInjectionTwoWay
  "Partial model of primary variable circuit serving an inversion circuit with two-way valve"
  extends PartialActivePrimary(
    TLiqEnt_nominal=55+273.15,
    dpPum_nominal=(dpPip_nominal + dp1Set) * kSizPum,
    m1_flow_nominal=m2_flow_nominal * (TLiqEnt_nominal - TLiqLvg_nominal) /
      (TLiqSup_nominal - TLiqLvg_nominal),
    mPum_flow_nominal=m1_flow_nominal / 0.9,
    del1(nPorts=3));

  parameter Modelica.Units.SI.PressureDifference dp1Set(displayUnit="Pa")=1e4
    "Pressure differential set point"
    annotation (Dialog(group="Controls"));
  parameter Modelica.Units.SI.PressureDifference dp2_nominal(displayUnit="Pa")
    "Consumer circuit pressure differential at design conditions"
    annotation (Dialog(group="Nominal condition"));

  Sensors.RelativePressure dp1(
    redeclare final package Medium = MediumLiq)
    "Differential pressure"
    annotation (Placement(transformation(extent={{20,-30},{40,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable mod(
    table=[0,0; 6,0; 6,1; 22,1; 22,0; 24,0],
    timeScale=3600,
    period=86400) "Operating mode (time schedule)"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));

  InjectionTwoWay con(
    have_ctl=true,
    typFun=Buildings.Fluid.HydronicConfigurations.Types.ControlFunction.Heating,
    typPum=Buildings.Fluid.HydronicConfigurations.Types.Pump.SingleConstant,
    redeclare final package Medium = MediumLiq,
    use_lumFloRes=true,
    final energyDynamics=energyDynamics,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final dp2_nominal=dp2_nominal,
    dpValve_nominal=0.5 * dp1Set,
    final dpBal1_nominal=if is_bal then dp1Set - con.dpValve_nominal else 0,
    pum(addPowerToMedium=false))
    "Hydronic connection"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));

  FixedResistances.PressureDrop resEnd1(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=0.1*mPum_flow_nominal,
    final dp_nominal=dp1Set)
    "Pipe pressure drop"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,-70})));
  Controls.PIDWithOperatingMode ctlPum(
    k=1,
    Ti=60,
    r=MediumLiq.p_default,
    y_reset=1) "Primary pump controller"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dp1SetVal(final k=
        dp1Set) "Pressure differential set point"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));


  Delays.DelayFirstOrder del2(
    redeclare final package Medium = MediumLiq,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=m2_flow_nominal,
    nPorts=1) "Fluid transport delay"
    annotation (Placement(transformation(extent={{50,20},{70,0}})));



equation
  connect(con.port_b1, dp1.port_b) annotation (Line(points={{36,0},{36,-10},{40,
          -10},{40,-40}}, color={0,127,255}));
  connect(con.port_a1, dp1.port_a) annotation (Line(points={{24,0},{24,-10},{20,
          -10},{20,-40}}, color={0,127,255}));
  connect(dp1SetVal.y, ctlPum.u_s)
    annotation (Line(points={{-118,-40},{-102,-40}},
                                                   color={0,0,127}));
  connect(dp1.p_rel, ctlPum.u_m) annotation (Line(points={{30,-31},{30,-20},{
          -90,-20},{-90,-28}},
                           color={0,0,127}));
  connect(mod.y[1], con.mod) annotation (Line(points={{-118,0},{10,0},{10,18},{
          18,18}},  color={255,127,0}));
  connect(mod.y[1], ctlPum.mod) annotation (Line(points={{-118,0},{-96,0},{-96,
          -28}},                     color={255,127,0}));
  connect(del2.ports[1], con.port_a2) annotation (Line(points={{60,20},{48,20},
          {48,19.8},{36,19.8}},
                            color={0,127,255}));

  connect(res1.port_b, dp1.port_a) annotation (Line(points={{10,-60},{20,-60},{
          20,-40}},   color={0,127,255}));
  connect(res1.port_b, resEnd1.port_a)
    annotation (Line(points={{10,-60},{46,-60},{46,-60},{80,-60}},
                                                   color={0,127,255}));
  connect(dp1.port_b, del1.ports[2])
    annotation (Line(points={{40,-40},{40,-80}},   color={0,127,255}));
  connect(resEnd1.port_b, del1.ports[3])
    annotation (Line(points={{80,-80},{60,-80},{60,-80},{40,-80}},
                                                   color={0,127,255}));
  connect(ctlPum.y, pum.y) annotation (Line(points={{-78,-40},{-60,-40},{-60,
          -48}},                  color={0,0,127}));
end PartialInjectionTwoWay;
