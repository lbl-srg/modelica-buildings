within Buildings.Fluid.HydronicConfigurations.ActiveNetworks;
model Decoupling "Decoupling circuit with self-acting Delta-p control valve"
  extends Fluid.HydronicConfigurations.Interfaces.PartialHydronicConfiguration(
    dpBal3_nominal=if typCtl<>Buildings.Fluid.HydronicConfigurations.Types.Control.None
      then 1e4 else 0,
    dpValve_nominal=dp1_nominal/2,
    m1_flow_nominal(min=(1+1e-2)*m2_flow_nominal)=1.05 * m2_flow_nominal,
    k=5,
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final typVal=Buildings.Fluid.HydronicConfigurations.Types.Valve.TwoWay,
    final have_set=false,
    final have_typVar=false,
    final use_dp1=use_siz,
    final use_dp2=use_siz and typPum<>Buildings.Fluid.HydronicConfigurations.Types.Pump.None);

  FixedResistances.Junction junBypSup(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final m_flow_nominal=m1_flow_nominal .* {1,-1,-1},
    final dp_nominal=fill(0, 3))
    "Junction"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,0})));
  FixedResistances.Junction junBypRet(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final m_flow_nominal=m1_flow_nominal .* {1,-1,1},
    final dp_nominal=fill(0, 3))
    "Junction"
    annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={60,0})));

  Components.TwoWayValve val(
    redeclare final package Medium = Medium,
    final typCha=typCha,
    use_inputFilter=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m1_flow_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dpFixed_nominal=if use_lumFloRes then dpBal1_nominal else 0,
    final flowCharacteristics=flowCharacteristics)
    "Control valve"
    annotation (
      Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={60,-40})));

  FixedResistances.PressureDrop res1(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m1_flow_nominal,
    final dp_nominal=if use_lumFloRes then 0 else dpBal1_nominal)
    "Primary balancing valve"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-70})));
  FixedResistances.PressureDrop res2(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m2_flow_nominal,
    final dp_nominal=dpBal2_nominal)
    "Secondary balancing valve"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,30})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold isEna(
    final t=Controls.OperatingModes.disabled)
    "Returns true if enabled"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Components.Pump pum(
    redeclare final package Medium = Medium,
    final typ=typPum,
    final typMod=typPumMod,
    final m_flow_nominal=mPum_flow_nominal,
    final dp_nominal=dpPum_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    use_inputFilter=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState,
    final per=perPum)
    "Pump"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,40})));
  Sensors.TemperatureTwoPort T2Sup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m2_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    tau=if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then 0
         else 1) "Consumer circuit supply temperature sensor" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-60,60})));
  Controls.PIDWithOperatingMode ctl(
    r=dpBal3_nominal,
    final reverseActing=true,
    final yMin=0,
    final yMax=1,
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti)
    if typCtl <> Buildings.Fluid.HydronicConfigurations.Types.Control.None
    "Controller"
    annotation (Placement(transformation(extent={{-10,-50},{10,-70}})));
  Sensors.TemperatureTwoPort T2Ret(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m2_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    tau=if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then 0
    else 1)
    "Consumer circuit return temperature sensor"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={60,60})));
  FixedResistances.PressureDrop res3(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m1_flow_nominal-m2_flow_nominal,
    final dp_nominal=dpBal3_nominal)
    "Bypass balancing valve"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0)));
  Sensors.RelativePressure dp3(
    redeclare final package Medium = Medium)
    "Pressure drop across bypass balancing valve"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dp3Set(
    y(final unit="Pa"),
    final k=dpBal3_nominal)
    "Pressure differential set point"
    annotation (Placement(transformation(extent={{-50,-70},{-30,-50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger enaCtl
    "Enable signal for control loop"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,-20})));
equation
  connect(port_a1, junBypSup.port_1)
    annotation (Line(points={{-60,-100},{-60,-10}}, color={0,127,255}));
  connect(val.port_b, res1.port_a)
    annotation (Line(points={{60,-50},{60,-60}}, color={0,127,255}));
  connect(res1.port_b, port_b1)
    annotation (Line(points={{60,-80},{60,-100}}, color={0,127,255}));
  connect(mode, isEna.u)
    annotation (Line(points={{-120,80},{-12,80}}, color={255,127,0}));
  connect(junBypSup.port_2, pum.port_a)
    annotation (Line(points={{-60,10},{-60,30}}, color={0,127,255}));
  connect(pum.port_b, T2Sup.port_a)
    annotation (Line(points={{-60,50},{-60,50}}, color={0,127,255}));
  connect(T2Sup.port_b, port_b2)
    annotation (Line(points={{-60,70},{-60,100}}, color={0,127,255}));
  connect(ctl.y, val.y)
    annotation (Line(points={{12,-60},{40,-60},{40,-40},{48,-40}},
                                                 color={0,0,127}));
  connect(yVal, val.y) annotation (Line(points={{-120,0},{-80,0},{-80,-80},{40,-80},
          {40,-40},{48,-40}}, color={0,0,127}));
  connect(val.y_actual, yVal_actual) annotation (Line(points={{53,-46},{53,-54},
          {80,-54},{80,-40},{120,-40}}, color={0,0,127}));
  connect(pum.y_actual, yPum_actual) annotation (Line(points={{-67,52},{80,52},
          {80,40},{120,40}},color={0,0,127}));
  connect(pum.P, PPum) annotation (Line(points={{-69,52},{-69,54},{80,54},{80,
          60},{120,60}},
                     color={0,0,127}));
  connect(junBypRet.port_2, val.port_a)
    annotation (Line(points={{60,-10},{60,-30},{60,-30}}, color={0,127,255}));
  connect(res2.port_b, junBypRet.port_1)
    annotation (Line(points={{60,20},{60,10}}, color={0,127,255}));
  connect(port_a2, T2Ret.port_a)
    annotation (Line(points={{60,100},{60,70}}, color={0,127,255}));
  connect(T2Ret.port_b, res2.port_a)
    annotation (Line(points={{60,50},{60,40}}, color={0,127,255}));
  connect(junBypSup.port_3, res3.port_a)
    annotation (Line(points={{-50,0},{-10,0}}, color={0,127,255}));
  connect(res3.port_b, junBypRet.port_3)
    annotation (Line(points={{10,0},{50,0}}, color={0,127,255}));
  connect(dp3.port_a, res3.port_a) annotation (Line(points={{-10,-20},{-20,-20},
          {-20,0},{-10,0}}, color={0,127,255}));
  connect(dp3.port_b, res3.port_b) annotation (Line(points={{10,-20},{20,-20},{20,
          0},{10,0}}, color={0,127,255}));
  connect(dp3.p_rel, ctl.u_m)
    annotation (Line(points={{0,-29},{0,-48}}, color={0,0,127}));
  connect(dp3Set.y, ctl.u_s) annotation (Line(points={{-28,-60},{-12,-60}},
                      color={0,0,127}));
  connect(enaCtl.y, ctl.mode) annotation (Line(points={{-40,-32},{-40,-40},{-6,
          -40},{-6,-48}}, color={255,127,0}));
  connect(isEna.y, enaCtl.u) annotation (Line(points={{12,80},{20,80},{20,20},{
          -40,20},{-40,-8}},  color={255,0,255}));
  connect(isEna.y, pum.y1) annotation (Line(points={{12,80},{20,80},{20,20},{
          -67,20},{-67,34.8}}, color={255,0,255}));
  connect(yPum, pum.y)
    annotation (Line(points={{-120,40},{-72,40}}, color={0,0,127}));
  annotation (
    defaultComponentName="con",                                                                                                                                                                                             Diagram(
    coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4>Summary</h4>
<p>
This configuration (see schematic below) is used for variable flow
primary and consumer circuits where the
consumer circuit has the same supply temperature set point as the
primary circuit.
The fixed bypass prevents the primary pressure differential from being
transmitted to the consumer circuit.
This allows a proper operation of the terminal
control valves on the consumer side
when the primary pressure differential is either
too low or too high or varying too much.
The self-acting &Delta;p control valve maintains a nearly constant
bypass mass flow rate, set by default to <i>5%</i> of the
consumer circuit design mass flow rate.
</p>
<p>
<img alt=\"Schematic\"
src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/ActiveNetworks/Decoupling.png\"/>
</p>
<p>
The following table presents the main characteristics of this configuration.
</p>
<table class=\"releaseTable\" summary=\"Main characteristics\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr>
<td valign=\"top\">
Primary circuit
</td>
<td valign=\"top\">
Variable flow
</td>
</tr>
<tr>
<td valign=\"top\">
Secondary (consumer) circuit
</td>
<td valign=\"top\">
Variable flow
</td>
</tr>
<tr>
<td valign=\"top\">
Typical applications
</td>
<td valign=\"top\">
Same consumer circuit supply temperature set point as primary circuit<br/>
(Otherwise use either this model in conjunction with
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.PassiveNetworks.SingleMixing\">
Buildings.Fluid.HydronicConfigurations.PassiveNetworks.SingleMixing</a>,
or
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.InjectionTwoWay\">
Buildings.Fluid.HydronicConfigurations.ActiveNetworks.InjectionTwoWay</a>)<br/>
Primary pressure differential either too low or too high
or varying too much such as in DHC systems
</td>
</tr>
<tr>
<td valign=\"top\">
Non-recommended applications
</td>
<td valign=\"top\">
Heating systems with condensing boilers due to the recirculating primary flow rate<br/>
(Since the recirculating primary flow rate is controlled to a nearly constant value,
this configuration is used in DHC systems.)
</td>
</tr>
<tr>
<td valign=\"top\">
Built-in valve control options
</td>
<td valign=\"top\">
Self-acting &Delta;p control valve with a proportional band of
<i>&plusmn;20%</i> around the pressure differential set point
</td>
</tr>
<tr>
<td valign=\"top\">
Control valve selection<br/>
(See the nomenclature in the schematic.)
</td>
<td valign=\"top\">
<i>&beta; = &Delta;p<sub>A-B</sub> /
(&Delta;p<sub>1</sub> + &Delta;p<sub>A-J</sub>)
&asymp;  &Delta;p<sub>A-B</sub> / &Delta;p<sub>1</sub></i><br/>
The valve is sized with a pressure drop of <i>&Delta;p<sub>1</sub> / 2</i>
for a mass flow rate <i>5</i> to <i>10%</i> higher than <code>m2_flow_nominal</code>.
</td>
</tr>
<tr>
<td valign=\"top\">
Balancing requirement
</td>
<td valign=\"top\">
The design pressure drop of the bypass balancing valve
<code>dpBal3_nominal</code> is typically around <i>10</i>&nbsp;kPa
for a mass flow rate of <code>m1_flow_nominal-m2_flow_nominal</code>.
No primary balancing valve is needed in addition to the self-acting
&Delta;p control valve.<br/>
(For an actuated control valve with external controls,
the same balancing requirements as for
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.InjectionTwoWay\">
Buildings.Fluid.HydronicConfigurations.ActiveNetworks.InjectionTwoWay</a>
hold.
No bypass balancing valve is needed.)
</td>
</tr>
<tr>
<td valign=\"top\">
Lumped flow resistance includes<br/>
(With the setting <code>use_lumFloRes=true</code>.)
</td>
<td valign=\"top\">
Control valve <code>val</code> and primary balancing valve <code>res1</code>
</td>
</tr>
</table>
<h4>Additional comments</h4>
<p>
The P-controller used in the model mimics a self-acting &Delta;p control valve
with a proportional band of <i>&plusmn;20%</i> around the
pressure differential set point.
This set point corresponds to the design pressure drop of the
bypass balancing valve.
Note that this configuration yields a nearly constant
bypass mass flow rate, as opposed to a constant <i>percentage</i>
of the consumer circuit mass flow rate provided by a control based on
the return temperature upstream and downstream of the bypass.
However, as illustrated in
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.DecouplingTemperature\">
Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.DecouplingTemperature</a>
the latter control logic is flawed at low load, and the primary mass
flow rate potentially maxed out.
Since there is no standard strategy to counteract that effect,
the configuration with built-in controls based on return
temperature is not included in this package.
</p>
<p>
The specific built-in control option implemented in this model does not
depend on the actual function of the consumer circuit 
(such as cooling, heating, or change-over).
Therefore, the model remains the same whatever the value
assigned to the parameter <code>typCtl</code> except if 
<code>None</code> (no built-in controls) is selected.
In that latter case only, no built-in controls are included and the user
must connect a control signal to modulate the valve.
</p>
<p>
For consumer circuits with a different supply temperature set
point, this configuration is sometimes used in conjunction with
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.PassiveNetworks.SingleMixing\">
Buildings.Fluid.HydronicConfigurations.PassiveNetworks.SingleMixing</a>,
see the example
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.DecouplingMixing\">
Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.DecouplingMixing</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 30, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Line(
          points={{-60,-90},{-60,90}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{60,-90},{60,90}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-14,-8},{3.74941e-32,-6.12325e-16}},
          color={0,0,0},
          thickness=0.5,
          origin={46,4},
          rotation=180,
          visible=typCtl <> Buildings.Fluid.HydronicConfigurations.Types.Control.None),
        Polygon(
          points={{54,-26},{60,-36},{66,-26},{54,-26}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{3.43156e-15,-30},{0,90}},
          color={0,0,0},
          thickness=0.5,
          origin={30,30},
          rotation=90),
        Polygon(
          points={{-20,10},{-20,-10},{0,0},{20,-10},{20,10},{0,0},{-20,10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={60,0},
          rotation=90),
        Ellipse(
          extent={{30,16},{46,-14}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          rotation=27,
          origin={2,0},
          visible=typCtl<>Buildings.Fluid.HydronicConfigurations.Types.Control.None),
        Line(
          points={{35.5,6.5},{36,-23.5}},
          color={0,0,0},
          thickness=0.5,
          rotation=27,
          origin={4,-8},
          visible=typCtl <> Buildings.Fluid.HydronicConfigurations.Types.Control.None),
        Line(
          points={{-16,22},{-16,0},{32,0}},
          color={0,0,0},
          pattern=LinePattern.Dot,
          thickness=0.5,
          visible=typCtl <> Buildings.Fluid.HydronicConfigurations.Types.Control.None),
        Line(
          points={{51.5,17.5},{42,12}},
          color={0,0,0},
          pattern=LinePattern.Dot,
          thickness=0.5,
          visible=typCtl <> Buildings.Fluid.HydronicConfigurations.Types.Control.None),
        Polygon(
          points={{34,34},{40,24},{46,34},{34,34}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          rotation=90,
          origin={70,-10}),
        Ellipse(
          extent={{-80,80},{-40,40}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=typPum<>Buildings.Fluid.HydronicConfigurations.Types.Pump.None),
        Polygon(
          points={{-60,80},{-42.5,50},{-77.5,50}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=typPum<>Buildings.Fluid.HydronicConfigurations.Types.Pump.None),
        Polygon(
          points={{-54,-60},{-60,-50},{-66,-60},{-54,-60}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{26,10},{46,-10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          visible=typCtl==Buildings.Fluid.HydronicConfigurations.Types.Control.None),
        Line(
          points={{-14,-1.71451e-15},{3.74941e-32,-6.12325e-16}},
          color={0,0,0},
          thickness=0.5,
          origin={46,0},
          rotation=180,
          visible=typCtl == Buildings.Fluid.HydronicConfigurations.Types.Control.None),
        Line(
          points={{26,0},{-100,0}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dot,
          visible=typCtl == Buildings.Fluid.HydronicConfigurations.Types.Control.None),
        Line(
          points={{-20,-1.83696e-15},{3.74941e-32,-6.12325e-16}},
          color={0,0,0},
          thickness=0.5,
          origin={60,60},
          rotation=360,
          visible=dpBal2_nominal > 0),
        Line(
          points={{-20,-1.83696e-15},{3.74941e-32,-6.12325e-16}},
          color={0,0,0},
          thickness=0.5,
          origin={40,50},
          rotation=270,
          visible=dpBal2_nominal > 0),
        Polygon(
          points={{-20,10},{-20,-10},{0,0},{20,-10},{20,10},{0,0},{-20,10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          rotation=270,
          origin={60,60},
          visible=dpBal2_nominal > 0),
        Line(
          points={{-14,-1.71451e-15},{3.74941e-32,-6.12325e-16}},
          color={0,0,0},
          thickness=0.5,
          origin={46,-60},
          rotation=180,
          visible=dpBal1_nominal > 0),
        Polygon(
          points={{-20,10},{-20,-10},{0,0},{20,-10},{20,10},{0,0},{-20,10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={60,-60},
          rotation=90,
          visible=dpBal1_nominal > 0),
        Line(
          points={{-20,-1.83696e-15},{3.74941e-32,-6.12325e-16}},
          color={0,0,0},
          thickness=0.5,
          origin={46,-70},
          rotation=270,
          visible=dpBal1_nominal > 0),
        Polygon(
          points={{-20,10},{-20,-10},{0,0},{20,-10},{20,10},{0,0},{-20,10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          rotation=180,
          origin={0,30},
          visible=dpBal3_nominal > 0),
        Line(
          points={{-20,-1.83696e-15},{3.74941e-32,-6.12325e-16}},
          color={0,0,0},
          thickness=0.5,
          rotation=180,
          origin={-10,44},
          visible=dpBal3_nominal > 0),
        Line(
          points={{-14,-1.71451e-15},{3.74941e-32,-6.12325e-16}},
          color={0,0,0},
          thickness=0.5,
          origin={0,30},
          rotation=270,
          visible=dpBal3_nominal > 0)}));
end Decoupling;
