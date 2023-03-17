within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.BaseClasses;
partial model PartialInjectionTwoWay
  "Partial model of primary variable circuit serving an inversion circuit with two-way valve"
  extends PartialActivePrimary(
    TLiqEnt_nominal=55+273.15,
    TLiqSup_nominal=60+273.15,
    dpPum_nominal=(dpPip_nominal + dp1Set) * kSizPum,
    m1_flow_nominal=m2_flow_nominal * (TLiqEnt_nominal - TLiqLvg_nominal) /
      (TLiqSup_nominal - TLiqLvg_nominal),
    mPum_flow_nominal=m1_flow_nominal / 0.9,
    del1(nPorts=3));

  parameter Boolean is_bal=false
    "Set to true for balanced primary branch"
    annotation(Dialog(group="Configuration"), Evaluate=true);

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
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable mode(
    table=[0,0; 6,0; 6,1; 22,1; 22,0; 24,0],
    timeScale=3600,
    period=86400) "Operating mode (time schedule)"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));

  replaceable InjectionTwoWay con(
    use_lumFloRes=true,
    typCtl=typ,
    typPum=Buildings.Fluid.HydronicConfigurations.Types.Pump.NoVariableInput,
    redeclare final package Medium = MediumLiq,
    final energyDynamics=energyDynamics,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final dp1_nominal=dp1Set,
    final dp2_nominal=dp2_nominal,
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
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset ctlPum1(
    k=0.1,
    Ti=60,
    r=1e4,
    y_reset=0) "Primary pump controller"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dp1SetVal(final k=
        dp1Set) "Pressure differential set point"
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));


  Delays.DelayFirstOrder del2(
    redeclare final package Medium = MediumLiq,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=m2_flow_nominal,
    nPorts=1) "Fluid transport delay"
    annotation (Placement(transformation(extent={{50,20},{70,0}})));



  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold isEna(final t=Controls.OperatingModes.disabled)
    "Returns true if enabled"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,-60})));
equation
  connect(con.port_b1, dp1.port_b) annotation (Line(points={{36,0},{40,0},{40,-40}},
                          color={0,127,255}));
  connect(con.port_a1, dp1.port_a) annotation (Line(points={{24,0},{20,0},{20,-40}},
                          color={0,127,255}));
  connect(dp1SetVal.y, ctlPum1.u_s)
    annotation (Line(points={{-118,-30},{-102,-30}}, color={0,0,127}));
  connect(dp1.p_rel, ctlPum1.u_m) annotation (Line(points={{30,-31},{30,-20},{
          -74,-20},{-74,-44},{-90,-44},{-90,-42}},
                               color={0,0,127}));
  connect(mode.y[1], con.mode) annotation (Line(points={{-118,0},{10,0},{10,18},
          {18,18}}, color={255,127,0}));
  connect(del2.ports[1], con.port_a2) annotation (Line(points={{60,20},{48,20},
          {48,20},{36,20}}, color={0,127,255}));

  connect(res1.port_b, dp1.port_a) annotation (Line(points={{-10,-60},{20,-60},{
          20,-40}},   color={0,127,255}));
  connect(res1.port_b, resEnd1.port_a)
    annotation (Line(points={{-10,-60},{46,-60},{46,-60},{80,-60}},
                                                   color={0,127,255}));
  connect(dp1.port_b, del1.ports[2])
    annotation (Line(points={{40,-40},{40,-60},{40,-80},{20,-80}},
                                                   color={0,127,255}));
  connect(resEnd1.port_b, del1.ports[3])
    annotation (Line(points={{80,-80},{60,-80},{60,-80},{20,-80}},
                                                   color={0,127,255}));
  connect(ctlPum1.y, pum.y) annotation (Line(points={{-78,-30},{-70,-30},{-70,
          -46},{-80,-46},{-80,-48}},
                                color={0,0,127}));
  connect(isEna.y, pum.y1) annotation (Line(points={{-118,-60},{-110,-60},{-110,
          -53},{-85.2,-53}}, color={255,0,255}));
  connect(mode.y[1], isEna.u) annotation (Line(points={{-118,0},{-110,0},{-110,
          -14},{-150,-14},{-150,-60},{-142,-60}}, color={255,127,0}));
  connect(isEna.y, ctlPum1.trigger) annotation (Line(points={{-118,-60},{-110,
          -60},{-110,-48},{-96,-48},{-96,-42}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-160,-160},{160,200}})),
      Documentation(info="<html>
<p>
This is a partial model of a variable flow primary loop with a
variable speed pump serving an injection circuit
with a two-way valve.
The primary pump model takes a normalized speed as input.
The speed is modulated to track a constant pressure differential
at the boundaries of the injection unit.
That model is used to construct some example models within
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples\">
Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 30, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialInjectionTwoWay;
