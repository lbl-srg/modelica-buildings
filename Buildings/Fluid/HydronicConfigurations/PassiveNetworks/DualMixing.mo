within Buildings.Fluid.HydronicConfigurations.PassiveNetworks;
model DualMixing "Dual mixing circuit"
  extends HydronicConfigurations.Interfaces.PartialHydronicConfiguration(
    dpValve_nominal=max(dp1_nominal, 3e3),
    dpBal3_nominal=dp1_nominal+dpValve_nominal,
    dpPum_nominal=dp2_nominal + dpBal2_nominal + dpBal3_nominal,
    set(final unit="K", displayUnit="degC"),
    final dpBal1_nominal=0,
    final typVal=Buildings.Fluid.HydronicConfigurations.Types.Valve.ThreeWay,
    final typVar=Buildings.Fluid.HydronicConfigurations.Types.ControlVariable.SupplyTemperature,
    final have_typVar=false,
    final use_dp1=use_siz,
    final use_dp2=use_siz and typPum<>Buildings.Fluid.HydronicConfigurations.Types.Pump.None);

  Buildings.Fluid.HydronicConfigurations.Components.ThreeWayValve val(
    redeclare final package Medium=Medium,
    final typCha=typCha,
    final energyDynamics=energyDynamics,
    use_strokeTime=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState,
    final portFlowDirection_1=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional else
      Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional else
      Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional else
      Modelica.Fluid.Types.PortFlowDirection.Entering,
    final m_flow_nominal=m1_flow_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dpFixed_nominal={0,0},
    final flowCharacteristics1=flowCharacteristics1,
    final flowCharacteristics3=flowCharacteristics3)
    "Control valve"
    annotation (
      Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-60,-40})));
  FixedResistances.Junction jun(
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
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={60,-40})));
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
  Buildings.Fluid.HydronicConfigurations.Components.Pump pum(
    redeclare final package Medium = Medium,
    final typ=typPum,
    final typMod=typPumMod,
    final m_flow_nominal=mPum_flow_nominal,
    final dp_nominal=dpPum_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    use_riseTime=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState,
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
      else 1)
    "Consumer circuit supply temperature sensor"
    annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-60,60})));
  FixedResistances.Junction junBypSup(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final m_flow_nominal=(m2_flow_nominal - m1_flow_nominal) .* {1,-1,1},
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
    final m_flow_nominal=(m2_flow_nominal - m1_flow_nominal) .* {1,-1,-1},
    final dp_nominal=fill(0, 3))
    "Junction"
    annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={60,0})));
  Sensors.TemperatureTwoPort T2Ret(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m2_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    tau=if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then 0
         else 1) "Consumer circuit return temperature sensor" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={60,60})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold isEna(final t=Controls.OperatingModes.disabled)
    "Returns true if enabled"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Controls.PIDWithOperatingMode ctl(
    u_s(final unit="K", displayUnit="degC"),
    u_m(final unit="K", displayUnit="degC"),
    final reverseActing=typCtl == Buildings.Fluid.HydronicConfigurations.Types.Control.Heating,
    final yMin=0,
    final yMax=1,
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti)
    if typCtl <> Buildings.Fluid.HydronicConfigurations.Types.Control.None
    "Controller"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));

  FixedResistances.PressureDrop res3(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m2_flow_nominal - m1_flow_nominal,
    final dp_nominal=dpBal3_nominal)
    "Bypass balancing valve"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0)));

initial equation
  assert(
    m2_flow_nominal > m1_flow_nominal,
    "In " + getInstanceName() +
    ": Primary mass flow rate must be strictly lower than consumer circuit mass flow rate " +
    "at design conditions.");

  if dpBal3_nominal <= dpValve_nominal then
    Modelica.Utilities.Streams.print(
      "*** Warning: In " + getInstanceName() +
      ": The bypass balancing valve should generate a pressure drop higher than " +
      "the control valve at design conditions to provide sufficient primary flow.");
  end if;

equation
  connect(val.port_3, jun.port_3)
    annotation (Line(points={{-50,-40},{50,-40}}, color={0,127,255}));
  connect(jun.port_2, port_b1)
    annotation (Line(points={{60,-50},{60,-100}}, color={0,127,255}));
  connect(val.port_1, port_a1)
    annotation (Line(points={{-60,-50},{-60,-100}}, color={0,127,255}));
  connect(junBypRet.port_2, jun.port_1)
    annotation (Line(points={{60,-10},{60,-30}}, color={0,127,255}));
  connect(pum.port_b, T2Sup.port_a)
    annotation (Line(points={{-60,50},{-60,50}}, color={0,127,255}));
  connect(T2Sup.port_b, port_b2)
    annotation (Line(points={{-60,70},{-60,100}}, color={0,127,255}));
  connect(pum.port_a, junBypSup.port_2)
    annotation (Line(points={{-60,30},{-60,10}}, color={0,127,255}));
  connect(val.port_2, junBypSup.port_1)
    annotation (Line(points={{-60,-30},{-60,-10}}, color={0,127,255}));
  connect(port_a2, T2Ret.port_a)
    annotation (Line(points={{60,100},{60,70}}, color={0,127,255}));
  connect(T2Ret.port_b, res2.port_a)
    annotation (Line(points={{60,50},{60,40}}, color={0,127,255}));
  connect(res2.port_b, junBypRet.port_1)
    annotation (Line(points={{60,20},{60,10}}, color={0,127,255}));
  connect(mode, isEna.u)
    annotation (Line(points={{-120,80},{-12,80}}, color={255,127,0}));
  connect(set, ctl.u_s) annotation (Line(points={{-120,-40},{-86,-40},{-86,-60},
          {-12,-60}}, color={0,0,127}));
  connect(T2Sup.T, ctl.u_m) annotation (Line(points={{-49,60},{-40,60},{-40,-80},
          {0,-80},{0,-72}}, color={0,0,127}));
  connect(ctl.y, val.y) annotation (Line(points={{12,-60},{20,-60},{20,-20},{
          -80,-20},{-80,-40},{-72,-40}}, color={0,0,127}));
  connect(mode, ctl.mode) annotation (Line(points={{-120,80},{-90,80},{-90,-76},
          {-6,-76},{-6,-72}}, color={255,127,0}));
  connect(junBypSup.port_3, res3.port_b)
    annotation (Line(points={{-50,0},{-10,0}}, color={0,127,255}));
  connect(res3.port_a, junBypRet.port_3)
    annotation (Line(points={{10,0},{50,0}}, color={0,127,255}));
  connect(yVal, val.y) annotation (Line(points={{-120,0},{-80,0},{-80,-40},{-72,
          -40}}, color={0,0,127}));
  connect(pum.P, PPum) annotation (Line(points={{-69,52},{-69,54},{90,54},{90,
          60},{120,60}}, color={0,0,127}));
  connect(pum.y_actual, yPum_actual) annotation (Line(points={{-67,52},{90,52},
          {90,40},{120,40}}, color={0,0,127}));
  connect(val.y_actual, yVal_actual) annotation (Line(points={{-67,-34},{-67,-26},
          {90,-26},{90,-40},{120,-40}},      color={0,0,127}));
  connect(pum.y1, isEna.y) annotation (Line(points={{-67,34.8},{-67,20},{20,20},
          {20,80},{12,80}}, color={255,0,255}));
  connect(yPum, pum.y)
    annotation (Line(points={{-120,40},{-72,40}}, color={0,0,127}));
  annotation (
    defaultComponentName="con",
    Documentation(info="<html>
<h4>Summary</h4>
<p>
This configuration (see schematic below) is used instead of
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.PassiveNetworks.SingleMixing\">
Buildings.Fluid.HydronicConfigurations.PassiveNetworks.SingleMixing</a>
when the primary and secondary circuits have a different design supply temperature.
Contrary to the single mixing circuit,
the use of this configuration is restricted to constant flow secondary circuits
due to the constraint on the fixed bypass pressure differential that must remain sufficiently
high.
</p>
<p>
<img alt=\"Schematic\"
src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/PassiveNetworks/DualMixing.png\"/>
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
Constant flow
</td>
</tr>
<tr>
<td valign=\"top\">
Typical applications
</td>
<td valign=\"top\">
Consumer circuit supply temperature different from primary circuit
such as underfloor heating systems
</td>
</tr>
<tr>
<td valign=\"top\">
Non-recommended applications
</td>
<td valign=\"top\">
Applications where primary and secondary supply temperature must
be equal as secondary flow recirculation cannot be avoided.
</td>
</tr>
<tr>
<td valign=\"top\">
Built-in valve control options
</td>
<td valign=\"top\">
Supply temperature
</td>
</tr>
<tr>
<td valign=\"top\">
Control valve selection<br/>
(See the nomenclature in the schematic.)
</td>
<td valign=\"top\">
<i>&beta; = &Delta;p<sub>A-AB</sub> / &Delta;p<sub>K-L</sub> =
&Delta;p<sub>A-AB</sub> /
(&Delta;p<sub>1</sub> + &Delta;p<sub>A-AB</sub>) </i><br/>
The control valve is sized with a pressure drop equal to the
maximum of <i>&Delta;p<sub>1</sub></i> and <i>3e3</i>&nbsp;Pa
at <i>m&#775;<sub>1, design</sub></i> (see below).
</td>
</tr>
<tr>
<td valign=\"top\">
Balancing requirement
</td>
<td valign=\"top\">
<p>
The three-way valve should be fully open at design conditions.<br/>
<code>dpBal3_nominal=dpValve_nominal+dp1_nominal</code> for a design
flow rate in the fixed bypass equal to:
<i>
m&#775;<sub>3, design</sub> =
m&#775;<sub>2, design</sub> - m&#775;<sub>1, design</sub> =
m&#775;<sub>2, design</sub> *
(T<sub>1, sup, design</sub> - T<sub>2, sup, design</sub>) /
(T<sub>1, sup, design</sub> - T<sub>2, ret, design</sub>)
</i><br/>
The primary design flow rate is:
<i>
m&#775;<sub>1, design</sub> = m&#775;<sub>2, design</sub> *
(T<sub>2, sup, design</sub> - T<sub>2, ret, design</sub>) /
(T<sub>1, sup, design</sub> - T<sub>2, ret, design</sub>)
</i>
</td>
</tr>
<tr>
<td valign=\"top\">
Lumped flow resistance includes<br/>
(With the setting <code>use_lumFloRes=true</code>.)
</td>
<td valign=\"top\">
Control valve <code>val</code> only<br/>
(So the option has no effect here: the balancing valves are always modeled as distinct flow resistances.)
</td>
</tr>
</table>
<h4>Additional comments</h4>
<p>
The bypass balancing valve works <i>together</i> with
the secondary pump to generate the pressure differential differential at the
boundaries of the control valve.
So it is paramount for proper operation of the consumer circuit that the
bypass balancing valve generates enough pressure drop at its design flow rate
<i>m&#775;<sub>3, design</sub></i> otherwise the consumer circuit is starved
with primary flow rate despite the control valve being fully open.
So oversizing the bypass balancing valve (yielding a lower pressure drop)
is detrimental to the consumer circuit operation.
Undersizing the bypass balancing valve (yielding a lower pressure drop)
does not disturb the secondary circuit operation as the control valve
then compensates for the elevated pressure differential by
working at a lower opening on average.
However, the secondary pump head is increased and so is the electricity
consumption.
See
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.PassiveNetworks.Examples.DualMixing\">
Buildings.Fluid.HydronicConfigurations.PassiveNetworks.Examples.DualMixing</a>
for a numerical illustration of those effects.
</p>
<p>
The parameter <code>dp1_nominal</code> stands for the potential
primary back pressure and must be provided as an absolute value.
By default the secondary pump is parameterized with a design pressure rise
equal to <code>dp2_nominal + dpBal2_nominal + dpBal3_nominal</code>.
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
        Polygon(
          points={{-10,10},{10,10},{0,-10},{-10,10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          origin={-60,10},
          rotation=0,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-10,-10},{10,-10},{0,10},{-10,-10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          origin={-60,-10},
          rotation=0,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{10,10},{10,-10},{-10,0},{10,10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          origin={-50,0},
          rotation=0,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-94,10},{-74,-10}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{-14,-1.71451e-15},{3.74941e-32,-6.12325e-16}},
          color={0,0,0},
          thickness=0.5,
          origin={-74,0},
          rotation=180),
        Line(
          points={{2.17103e-15,-30},{0,90}},
          color={0,0,0},
          thickness=0.5,
          origin={30,0},
          rotation=90),
        Polygon(
          points={{-54,-60},{-60,-50},{-66,-60},{-54,-60}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{54,-50},{60,-60},{66,-50},{54,-50}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-80,80},{-40,40}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=typPum<>Buildings.Fluid.HydronicConfigurations.Types.Pump.None,
          startAngle=0,
          endAngle=360),
        Polygon(
          points={{-60,80},{-42.5,50},{-77.5,50}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=typPum <> Buildings.Fluid.HydronicConfigurations.Types.Pump.None),
        Line(
          points={{3.5231e-15,-30},{0,90}},
          color={0,0,0},
          thickness=0.5,
          origin={30,30},
          rotation=90),
        Polygon(
          points={{34,34},{40,24},{46,34},{34,34}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          rotation=270,
          origin={-30,40}),
        Polygon(
          points={{34,34},{40,24},{46,34},{34,34}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          rotation=270,
          origin={10,70}),
        Line(
          points={{-94,0},{-100,0}},
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
end DualMixing;
