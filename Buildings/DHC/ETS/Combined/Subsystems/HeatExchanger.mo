within Buildings.DHC.ETS.Combined.Subsystems;
model HeatExchanger
  "Base subsystem with district heat exchanger"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
    final m1_flow_nominal=abs(Q_flow_nominal/4200/(T_b1_nominal - T_a1_nominal)),
    final m2_flow_nominal=abs(Q_flow_nominal/4200/(T_b2_nominal - T_a2_nominal)));
  parameter DHC.ETS.Types.ConnectionConfiguration conCon
    "District connection configuration" annotation (Evaluate=true);
  parameter Modelica.Units.SI.PressureDifference dp1Hex_nominal(displayUnit=
        "Pa") "Nominal pressure drop across heat exchanger on district side"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dp2Hex_nominal(displayUnit=
        "Pa") "Nominal pressure drop across heat exchanger on building side"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpVal1_nominal(displayUnit=
        "Pa") = dp1Hex_nominal/2
    "Nominal pressure drop of primary control valve"
    annotation (Dialog(enable=have_val1, group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpVal2_nominal(displayUnit=
        "Pa") = dp2Hex_nominal/2
    "Nominal pressure drop of secondary control valve"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal
    "Nominal heat flow rate (from district to building)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature T_a1_nominal
    "Nominal water inlet temperature on district side"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature T_b1_nominal
    "Nominal water outlet temperature on district side"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature T_a2_nominal
    "Nominal water inlet temperature on building side"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature T_b2_nominal
    "Nominal water outlet temperature on building side"
    annotation (Dialog(group="Nominal condition"));
  parameter Real spePum1Min(unit="1")=0.1
    "Heat exchanger primary pump minimum speed (fractional)"
    annotation (Dialog(group="Controls",enable=not have_val1));
  parameter Real spePum2Min(unit="1")=0.1
    "Heat exchanger secondary pump minimum speed (fractional)"
    annotation (Dialog(group="Controls"));
  // IO CONNECTORS
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput on
    "Control signal for secondary side (from supervisory). Set to true to operate subsystem"
    annotation (Placement(transformation(extent={{-140,120},{-100,160}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PPum(
    final unit="W")
    "Power drawn by pump motors"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
    iconTransformation(extent={{100,-20},{140,20}})));
  // COMPONENTS
  Buildings.Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU hex(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
    show_T=true,
    final use_Q_flow_nominal=true,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    final allowFlowReversal1=allowFlowReversal1,
    final allowFlowReversal2=allowFlowReversal2,
    final dp1_nominal=if have_val1 then 0 else dp1Hex_nominal,
    final dp2_nominal=0,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final Q_flow_nominal=Q_flow_nominal,
    final T_a1_nominal=T_a1_nominal,
    final T_a2_nominal=T_a2_nominal)
    "Heat exchanger" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={0,0})));

  DHC.ETS.BaseClasses.Pump_m_flow pum1(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=m1_flow_nominal,
    final dp_nominal=dp1Hex_nominal,
    final allowFlowReversal=allowFlowReversal1) if not have_val1
    "District heat exchanger primary pump" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-60,80})));
  DHC.ETS.BaseClasses.Pump_m_flow pum2(
    redeclare final package Medium = Medium2,
    final m_flow_nominal=m2_flow_nominal,
    final dp_nominal=dp2Hex_nominal,
    final allowFlowReversal=allowFlowReversal2)
    "Secondary pump" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={70,-60})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senT2WatEnt(
    redeclare final package Medium = Medium2,
    final m_flow_nominal=m2_flow_nominal,
    final allowFlowReversal=allowFlowReversal2)
    "Heat exchanger secondary water entering temperature" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={40,-60})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senT2WatLvg(
    redeclare final package Medium = Medium2,
    final m_flow_nominal=m2_flow_nominal,
    final allowFlowReversal=allowFlowReversal2)
    "Heat exchanger secondary water leaving temperature" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-50,-60})));
  Fluid.Actuators.Valves.TwoWayPressureIndependent val1(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=m1_flow_nominal,
    from_dp=true,
    final dpValve_nominal=dpVal1_nominal,
    use_strokeTime=false,
    final dpFixed_nominal=dp1Hex_nominal) if have_val1
    "Heat exchanger primary control valve"
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum totPPum(
    final nin=
      if have_val1 then
        1
      else
        2)
    "Total pump power"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal mPum1_flow(
    realTrue=m1_flow_nominal)
    if not have_val1
   "Set mass flow rate of pump 1"
    annotation (Placement(transformation(extent={{-86,110},{-66,130}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal mPum2_flow2(
    realTrue=m2_flow_nominal)
   "Set mass flow rate of pump 2"
    annotation (Placement(transformation(extent={{-40,130},{-20,150}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal yVal(realTrue=1)
    if have_val1
    "Control signal for valves"
    annotation (Placement(transformation(extent={{0,150},{20,170}})));
protected
  parameter Boolean have_val1=
    conCon == DHC.ETS.Types.ConnectionConfiguration.TwoWayValve
    "True in case of control valve on district side, false in case of a pump";
equation
  if have_val1 then
    connect(port_a1, hex.port_a1)
      annotation (Line(points={{-100,60},{-20,60},{-20,6},{-10,6}}, color={0,127,255}));
  else
    connect(hex.port_b1, port_b1)
      annotation (Line(points={{10,6},{20,6},{20,60},{100,60}}, color={0,127,255}));
  end if;
  connect(port_a1,pum1.port_a)
    annotation (Line(points={{-100,60},{-90,60},{-90,80},{-70,80}},color={0,127,255}));
  connect(val1.port_b,port_b1)
    annotation (Line(points={{90,80},{94,80},{94,60},{100,60}},color={0,127,255}));
  connect(pum2.port_b,senT2WatEnt.port_a)
    annotation (Line(points={{60,-60},{50,-60}},         color={0,127,255}));
  connect(senT2WatEnt.port_b,hex.port_a2)
    annotation (Line(points={{30,-60},{20,-60},{20,-6},{10,-6}},
                                                       color={0,127,255}));
  connect(pum1.P,totPPum.u[2])
    annotation (Line(points={{-49,89},{50,89},{50,0},{68,0}},color={0,0,127}));
  connect(pum2.P,totPPum.u[1])
    annotation (Line(points={{59,-51},{50,-51},{50,0},{68,0}},color={0,0,127}));
  connect(totPPum.y,PPum)
    annotation (Line(points={{92,0},{120,0}},color={0,0,127}));
  connect(hex.port_b2,senT2WatLvg.port_a)
    annotation (Line(points={{-10,-6},{-20,-6},{-20,-60},{-40,-60}},
                                                          color={0,127,255}));
  connect(hex.port_b1, val1.port_a) annotation (Line(points={{10,6},{20,6},{20,80},{70,80}}, color={0,127,255}));
  connect(pum1.port_b, hex.port_a1) annotation (Line(points={{-50,80},{-20,80},{-20,6},{-10,6}}, color={0,127,255}));
  connect(pum1.m_flow_in, mPum1_flow.y)
    annotation (Line(points={{-60,92},{-60,120},{-64,120}}, color={0,0,127}));
  connect(pum2.m_flow_in, mPum2_flow2.y) annotation (Line(points={{70,-48},{70,
          -20},{40,-20},{40,140},{-18,140}},
                                        color={0,0,127}));
  connect(yVal.y, val1.y)
    annotation (Line(points={{22,160},{80,160},{80,92}}, color={0,0,127}));
  connect(port_a2, pum2.port_a)
    annotation (Line(points={{100,-60},{80,-60}}, color={0,127,255}));
  connect(senT2WatLvg.port_b, port_b2)
    annotation (Line(points={{-60,-60},{-100,-60}}, color={0,127,255}));
  connect(on, yVal.u) annotation (Line(points={{-120,140},{-92,140},{-92,160},{
          -2,160}}, color={255,0,255}));
  connect(on, mPum2_flow2.u)
    annotation (Line(points={{-120,140},{-42,140}}, color={255,0,255}));
  connect(mPum1_flow.u, on) annotation (Line(points={{-88,120},{-92,120},{-92,
          140},{-120,140}}, color={255,0,255}));
  annotation (
    defaultComponentName="hex",
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{2,26},{-2,-26}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-74,-60},
          rotation=90),
        Rectangle(
          extent={{2,28},{-2,-28}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-76,60},
          rotation=90),
        Rectangle(
          extent={{2,26},{-2,-26}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={70,-60},
          rotation=90),
        Rectangle(
          extent={{2,28},{-2,-28}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={68,60},
          rotation=90),
        Rectangle(
          extent={{-52,68},{50,-68}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,60},{-34,-58}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-34,60},{-22,-58}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-22,60},{-16,-58}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-16,60},{-4,-58}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{14,60},{20,-58}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{20,60},{32,-58}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{2,60},{14,-58}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-4,60},{2,-58}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{32,60},{38,-58}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-160},{100,180}})),
    Documentation(
      revisions="<html>
<ul>
<li>
November 14, 2025, by Michael Wetter:<br/>
Refactored implementation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4354\">#4354</a>.
</li>
<li>
March 27, 2024, by David Blum:<br/>
Update icon.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3606\">issue #3606</a>.
</li>
<li>
July 14, 2021, by Antoine Gautier:<br/>
Refactored after updating the control logic, changed the primary control valve to pressure-independent.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2561\">issue #2561</a>.
</li>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This is a model for a district heat exchanger system with a variable speed
pump on the secondary side, and a variable speed pump (in case of a passive
network) or a two-way modulating valve (in case of an active network)
on the primary side.
</p>
<p>
The system is controlled based on the logic described in
<a href=\"modelica://Buildings.Obsolete.DHC.ETS.Combined.Controls.HeatExchanger\">
Buildings.Obsolete.DHC.ETS.Combined.Controls.HeatExchanger</a>.
The pump flow rate is considered proportional to the pump speed
under the assumption of a constant flow resistance in both the primary and
the secondary loops.
</p>
</html>"));
end HeatExchanger;
