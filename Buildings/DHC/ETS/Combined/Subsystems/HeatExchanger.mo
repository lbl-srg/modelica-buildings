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
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValIso_actual[2]
    "Isolation valves return position (index 1 for condenser)"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
    iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Control signal for secondary side (from supervisory)"
    annotation (Placement(transformation(extent={{-140,120},{-100,160}}),
    iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PPum(
    final unit="W")
    "Power drawn by pump motors"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
    iconTransformation(extent={{100,-20},{140,20}})));
  // COMPONENTS
  Buildings.DHC.ETS.Combined.Controls.HeatExchanger con(
    final conCon=conCon,
    final spePum1Min=spePum1Min,
    final spePum2Min=spePum2Min)
    "District heat exchanger loop controller"
    annotation (Placement(transformation(extent={{-70,150},{-50,170}})));
  Buildings.Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU hex(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
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
    final dp_nominal=dp2Hex_nominal + dpVal2_nominal,
    final allowFlowReversal=allowFlowReversal2)
    "Secondary pump" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={40,-60})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senT2WatEnt(
    redeclare final package Medium = Medium2,
    final m_flow_nominal=m2_flow_nominal,
    final allowFlowReversal=allowFlowReversal2)
    "Heat exchanger secondary water entering temperature" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,-40})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senT2WatLvg(
    redeclare final package Medium = Medium2,
    final m_flow_nominal=m2_flow_nominal,
    final allowFlowReversal=allowFlowReversal2)
    "Heat exchanger secondary water leaving temperature" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-20,-20})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai2(final k=
        m2_flow_nominal) "Scale to nominal mass flow rate" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,118})));
  Fluid.Actuators.Valves.TwoWayPressureIndependent val1(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=m1_flow_nominal,
    from_dp=true,
    final dpValve_nominal=dpVal1_nominal,
    use_strokeTime=false,
    final dpFixed_nominal=dp1Hex_nominal) if have_val1
    "Heat exchanger primary control valve"
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai1(final k=
        m1_flow_nominal) if not have_val1 "Scale to nominal mass flow rate"
    annotation (Placement(transformation(extent={{-12,110},{-32,130}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum totPPum(
    final nin=
      if have_val1 then
        1
      else
        2)
    "Total pump power"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear val2(
    redeclare final package Medium = Medium2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false,
    use_strokeTime=false,
    final m_flow_nominal=m2_flow_nominal,
    final dpValve_nominal=dpVal2_nominal,
    final dpFixed_nominal=fill(dp2Hex_nominal, 2)) "Control valve" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={80,-60})));
  DHC.ETS.BaseClasses.Junction spl(
    redeclare final package Medium = Medium2,
    final m_flow_nominal=m2_flow_nominal .* {1,-1,-1})
    "Flow splitter" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-60,-60})));
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
  connect(gai2.y,pum2.m_flow_in)
    annotation (Line(points={{40,106},{40,-48}},color={0,0,127}));
  connect(port_a1,pum1.port_a)
    annotation (Line(points={{-100,60},{-90,60},{-90,80},{-70,80}},color={0,127,255}));
  connect(val1.port_b,port_b1)
    annotation (Line(points={{90,80},{94,80},{94,60},{100,60}},color={0,127,255}));
  connect(pum2.port_b,senT2WatEnt.port_a)
    annotation (Line(points={{30,-60},{20,-60},{20,-50}},color={0,127,255}));
  connect(senT2WatEnt.port_b,hex.port_a2)
    annotation (Line(points={{20,-30},{20,-6},{10,-6}},color={0,127,255}));
  connect(con.y1, val1.y)
    annotation (Line(points={{-48,166},{80,166},{80,92}}, color={0,0,127}));
  connect(con.y1, gai1.u) annotation (Line(points={{-48,166},{0,166},{0,120},{-10,
          120}}, color={0,0,127}));
  connect(gai1.y,pum1.m_flow_in)
    annotation (Line(points={{-34,120},{-60,120},{-60,92}},color={0,0,127}));
  connect(pum1.P,totPPum.u[2])
    annotation (Line(points={{-49,89},{60,89},{60,0},{68,0}},color={0,0,127}));
  connect(pum2.P,totPPum.u[1])
    annotation (Line(points={{29,-51},{28,-51},{28,0},{68,0}},color={0,0,127}));
  connect(totPPum.y,PPum)
    annotation (Line(points={{92,0},{120,0}},color={0,0,127}));
  connect(yValIso_actual,con.yValIso)
    annotation (Line(points={{-120,100},{-92,100},{-92,155},{-72,155}},color={0,0,127}));
  connect(con.yPum2,gai2.u)
    annotation (Line(points={{-48,160},{40,160},{40,130}},color={0,0,127}));
  connect(u,con.u)
    annotation (Line(points={{-120,140},{-96,140},{-96,165},{-72,165}},color={0,0,127}));
  connect(hex.port_b2,senT2WatLvg.port_a)
    annotation (Line(points={{-10,-6},{-20,-6},{-20,-10}},color={0,127,255}));
  connect(val2.port_2,pum2.port_a)
    annotation (Line(points={{70,-60},{50,-60}},color={0,127,255}));
  connect(port_a2,val2.port_1)
    annotation (Line(points={{100,-60},{90,-60}},color={0,127,255}));
  connect(spl.port_1,senT2WatLvg.port_b)
    annotation (Line(points={{-50,-60},{-20,-60},{-20,-30}},color={0,127,255}));
  connect(spl.port_2,port_b2)
    annotation (Line(points={{-70,-60},{-100,-60}},color={0,127,255}));
  connect(spl.port_3,val2.port_3)
    annotation (Line(points={{-60,-70},{-60,-80},{80,-80},{80,-70}},color={0,127,255}));
  connect(con.yVal2,val2.y)
    annotation (Line(points={{-48,154},{64,154},{64,-40},{80,-40},{80,-48}},color={0,0,127}));
  connect(hex.port_b1, val1.port_a) annotation (Line(points={{10,6},{20,6},{20,80},{70,80}}, color={0,127,255}));
  connect(pum1.port_b, hex.port_a1) annotation (Line(points={{-50,80},{-20,80},{-20,6},{-10,6}}, color={0,127,255}));
  annotation (
    defaultComponentName="hex",
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-34,38},{36,-42}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-26,32},{-22,-36}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-22,32},{-14,-36}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-10,32},{0,-36}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-14,32},{-10,-36}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{4,32},{12,-36}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{0,32},{4,-36}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{16,32},{24,-36}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{12,32},{16,-36}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{24,32},{28,-36}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-1,42},{1,-42}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-58,59},
          rotation=90),
        Rectangle(
          extent={{-18,60},{-16,38}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-1,42},{1,-42}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={58,59},
          rotation=90),
        Rectangle(
          extent={{16,60},{18,38}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-1,42},{1,-42}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={58,-61},
          rotation=90),
        Rectangle(
          extent={{-1,42},{1,-42}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-58,-61},
          rotation=90),
        Rectangle(
          extent={{-18,-42},{-16,-62}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{16,-42},{18,-62}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-160},{100,180}})),
    Documentation(
      revisions="<html>
<ul>
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
<a href=\"modelica://Buildings.DHC.ETS.Combined.Controls.HeatExchanger\">
Buildings.DHC.ETS.Combined.Controls.HeatExchanger</a>.
The pump flow rate is considered proportional to the pump speed
under the assumption of a constant flow resistance in both the primary and
the secondary loops.
</p>
</html>"));
end HeatExchanger;
