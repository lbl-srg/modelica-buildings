within Buildings.Fluid.HydronicConfigurations.ActiveNetworks;
model InjectionThreeWay "Injection circuit with three-way valve"
  extends Fluid.HydronicConfigurations.Interfaces.PartialHydronicConfiguration(
    dpValve_nominal=3e3,
    set(final unit="K", displayUnit="degC"),
    final dpBal3_nominal=0,
    final typVal=Buildings.Fluid.HydronicConfigurations.Types.Valve.ThreeWay,
    final have_typVar=true,
    final use_dp1=false,
    final use_dp2=use_siz and typPum<>Buildings.Fluid.HydronicConfigurations.Types.Pump.None);

  Buildings.Fluid.HydronicConfigurations.Components.ThreeWayValve val(
    redeclare final package Medium=Medium,
    final typCha=typCha,
    final energyDynamics=energyDynamics,
    use_inputFilter=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState,
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
    final dpFixed_nominal={0, 0},
    final flowCharacteristics1=flowCharacteristics1,
    final flowCharacteristics3=flowCharacteristics3)
    "Control valve"
    annotation (
      Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-40})));
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
    final dp_nominal=fill(0, 3)) "Junction"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,-40})));
  FixedResistances.Junction junBypSup(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final m_flow_nominal=m2_flow_nominal .* {1,-1,1},
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
    final m_flow_nominal=m2_flow_nominal .* {1,-1,-1},
    final dp_nominal=fill(0, 3))
    "Junction"
    annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={60,0})));
  FixedResistances.PressureDrop res1(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m1_flow_nominal,
    final dp_nominal=dpBal1_nominal)
    "Primary balancing valve"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-80})));
  FixedResistances.PressureDrop res2(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m2_flow_nominal,
    final dp_nominal=dpBal2_nominal) "Secondary balancing valve"
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
    use_inputFilter=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState,
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
    annotation (Placement(transformation(extent={{30,-70},{50,-50}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold isEna(
    final t=Controls.OperatingModes.disabled)
    "Returns true if enabled"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
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
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig(final nin=2)
    "Select measured signal"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,-80})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant ctlVar(
    final k=Integer(typVar))
    "Controlled variable selector"
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));
equation
  connect(jun.port_3, val.port_3)
    annotation (Line(points={{-50,-40},{50,-40}}, color={0,127,255}));
  connect(junBypRet.port_2, val.port_1)
    annotation (Line(points={{60,-10},{60,-30},{60,-30}}, color={0,127,255}));
  connect(junBypSup.port_3, junBypRet.port_3)
    annotation (Line(points={{-50,0},{50,0}}, color={0,127,255}));
  connect(jun.port_2, junBypSup.port_1)
    annotation (Line(points={{-60,-30},{-60,-10}}, color={0,127,255}));
  connect(port_a1, jun.port_1)
    annotation (Line(points={{-60,-100},{-60,-50}}, color={0,127,255}));
  connect(port_b1,res1. port_b)
    annotation (Line(points={{60,-100},{60,-90}}, color={0,127,255}));
  connect(res1.port_a, val.port_2)
    annotation (Line(points={{60,-70},{60,-50}}, color={0,127,255}));
  connect(res2.port_b, junBypRet.port_1)
    annotation (Line(points={{60,20},{60,10}}, color={0,127,255}));
  connect(junBypSup.port_2, pum.port_a)
    annotation (Line(points={{-60,10},{-60,30}}, color={0,127,255}));
  connect(pum.port_b, T2Sup.port_a)
    annotation (Line(points={{-60,50},{-60,50}}, color={0,127,255}));
  connect(T2Sup.port_b, port_b2)
    annotation (Line(points={{-60,70},{-60,100}}, color={0,127,255}));
  connect(mode, ctl.mode) annotation (Line(points={{-120,80},{-20,80},{-20,-80},
          {34,-80},{34,-72}}, color={255,127,0}));
  connect(set, ctl.u_s) annotation (Line(points={{-120,-40},{-80,-40},{-80,-60},
          {28,-60}},  color={0,0,127}));
  connect(yVal, val.y) annotation (Line(points={{-120,0},{-80,0},{-80,-20},{80,-20},
          {80,-40},{72,-40}}, color={0,0,127}));
  connect(mode, isEna.u)
    annotation (Line(points={{-120,80},{-12,80}}, color={255,127,0}));
  connect(port_a2, T2Ret.port_a)
    annotation (Line(points={{60,100},{60,70}}, color={0,127,255}));
  connect(T2Ret.port_b,res2. port_a)
    annotation (Line(points={{60,50},{60,40}}, color={0,127,255}));
  connect(extIndSig.y, ctl.u_m) annotation (Line(points={{-40,-92},{-40,-96},{40,
          -96},{40,-72}}, color={0,0,127}));
  connect(T2Sup.T, extIndSig.u[2]) annotation (Line(points={{-49,60},{-39.5,60},
          {-39.5,-68}},    color={0,0,127}));
  connect(T2Ret.T, extIndSig.u[1])
    annotation (Line(points={{49,60},{-40.5,60},{-40.5,-68}},
                                                          color={0,0,127}));
  connect(ctl.y, val.y) annotation (Line(points={{52,-60},{80,-60},{80,-40},{72,
          -40}}, color={0,0,127}));
  connect(ctlVar.y, extIndSig.index)
    annotation (Line(points={{-68,-80},{-52,-80}}, color={255,127,0}));
  connect(val.y_actual, yVal_actual) annotation (Line(points={{67,-46},{67,-50},
          {90,-50},{90,-40},{120,-40}}, color={0,0,127}));
  connect(pum.P, PPum) annotation (Line(points={{-69,52},{-69,54},{80,54},{80,
          60},{120,60}}, color={0,0,127}));
  connect(pum.y_actual, yPum_actual) annotation (Line(points={{-67,52},{80,52},
          {80,40},{120,40}}, color={0,0,127}));
  connect(yPum, pum.y)
    annotation (Line(points={{-120,40},{-72,40}}, color={0,0,127}));
  connect(isEna.y, pum.y1) annotation (Line(points={{12,80},{20,80},{20,20},{
          -67,20},{-67,34.8}}, color={255,0,255}));
  annotation (
    defaultComponentName="con",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(
          points={{-60,-90},{-60,90}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{60,-90},{60,90}},
          color={0,0,0},
          thickness=0.5),
        Polygon(
          points={{-10,10},{-10,-10},{10,0},{-10,10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          origin={60,-10},
          rotation=90,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-10,10},{10,10},{0,-10},{-10,10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          origin={60,10},
          rotation=0,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-10,10},{-10,-10},{10,0},{-10,10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          origin={50,0},
          rotation=0,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{74,10},{94,-10}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{-14,-1.71451e-15},{3.74941e-32,-6.12325e-16}},
          color={0,0,0},
          thickness=0.5,
          origin={60,0},
          rotation=180),
        Line(
          points={{2.29846e-15,-10},{0,90}},
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
          points={{34,34},{40,24},{46,34},{34,34}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          rotation=90,
          origin={30,-40}),
        Polygon(
          points={{54,-26},{60,-36},{66,-26},{54,-26}},
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
          origin={-30,70}),
        Line(
          points={{-100,0},{-80,0},{-80,24},{84,24},{84,10}},
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
          visible=dpBal1_nominal > 0)}),
    Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4>Summary</h4>
<p>
This configuration (see schematic below) is used
for constant flow primary and consumer circuits where the
consumer circuit has a different supply temperature set point,
either at design conditions or varying during operation.
Although this configuration may theoretically still be used
if the primary and secondary design temperatures are equal,
it loses its main advantage which is that the
control valve can be sized for a lower flow rate and can therefore
be smaller.
The fixed bypass ensures a consumer circuit operation hydronically decoupled
from the primary side and the control valve position.
</p>
<p>
<img alt=\"Schematic\"
src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/ActiveNetworks/InjectionThreeWay.png\"/>
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
Constant flow
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
Consumer circuit supply temperature different from primary circuit such
as underfloor heating systems<br/>
(Otherwise use
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Decoupling\">
Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Decoupling</a>)<br/>
Primary pressure differential either too low or too high
or varying too much
</td>
</tr>
<tr>
<td valign=\"top\">
Non-recommended applications
</td>
<td valign=\"top\">
DHC systems due to the significant recirculating primary flow rate at low load<br/>
Heating systems with condensing boilers for the same reason
</td>
</tr>
<tr>
<td valign=\"top\">
Built-in valve control options
</td>
<td valign=\"top\">
Supply temperature<br/>
Return temperature
</td>
</tr>
<tr>
<td valign=\"top\">
Control valve selection<br/>
</td>
<td valign=\"top\">
<i>&beta;
= &Delta;p<sub>A-AB</sub> / &Delta;p<sub>J-AB</sub>
&asymp; 1</i><br/>
Sizing is only based on a minimum pressure drop of
<i>3</i>&nbsp;kPa at design flow rate <i>m&#775;<sub>1, design</sub></i>
(see below).
</td>
</tr>
<tr>
<td valign=\"top\">
Balancing requirement
</td>
<td valign=\"top\">
The three-way valve should be fully open at design conditions.<br/>
<code>dpBal3_nominal=dp1_nominal-dpValve_nominal</code>
for the primary design flow rate
<i>m&#775;<sub>1, design</sub> = m&#775;<sub>2, design</sub> *
(T<sub>2, sup, design</sub> - T<sub>2, ret, design</sub>) /
(T<sub>1, sup, design</sub> - T<sub>2, ret, design</sub>)
</i>
</td>
</tr>
<tr>
<td valign=\"top\">
Lumped flow resistances include<br/>
(With the setting <code>use_lumFloRes=true</code>.)
</td>
<td valign=\"top\">
Control valve <code>val</code> only<br/>
(So the option has no effect here: the balancing valves are
always modeled as distinct flow resistances.)
</td>
</tr>
</table>
<h4>Additional comments</h4>
<p>
The reduced flow through the control valve due to the intermediary
bypass allows selecting a smaller valve for the same design pressure drop.
The pressure drop through the control valve is compensated by the primary pump,
reducing the secondary pump head.
</p>
<p>
The balancing procedure should ensure that the three-way valve is fully
open at design conditions.
Oversizing the primary balancing valve (yielding a lower pressure drop)
is not detrimental to the consumer circuit operation:
the control valve compensates by working at a lower opening fraction on average.
However, the primary circuit operation is degraded with a lower &Delta;T
and a higher mass flow rate.
See
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.InjectionThreeWay\">
Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.InjectionThreeWay</a>
for a numerical illustration of those effects.
</p>
</html>", revisions="<html>
<ul>
<li>
June 30, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end InjectionThreeWay;
