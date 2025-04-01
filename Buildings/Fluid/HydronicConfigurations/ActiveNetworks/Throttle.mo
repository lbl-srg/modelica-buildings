within Buildings.Fluid.HydronicConfigurations.ActiveNetworks;
model Throttle "Throttle circuit"
  extends Fluid.HydronicConfigurations.Interfaces.PartialHydronicConfiguration(
    dpValve_nominal=dp2_nominal + dpBal1_nominal,
    final dpBal2_nominal=0,
    final dpBal3_nominal=0,
    final m1_flow_nominal=m2_flow_nominal,
    final typVal=Buildings.Fluid.HydronicConfigurations.Types.Valve.TwoWay,
    final typPum=Buildings.Fluid.HydronicConfigurations.Types.Pump.None,
    final typCtl=Buildings.Fluid.HydronicConfigurations.Types.Control.None,
    final have_typVar=false,
    final use_dp1=false,
    final use_dp2=use_lumFloRes or use_siz);

  Buildings.Fluid.HydronicConfigurations.Components.TwoWayValve val(
    redeclare final package Medium=Medium,
    final typCha=typCha,
    use_strokeTime=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m2_flow_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dpFixed_nominal=if use_lumFloRes then dpBal1_nominal + dp2_nominal else 0,
    final flowCharacteristics=flowCharacteristics)
    "Control valve"
    annotation (
      Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={60,0})));
  Buildings.Fluid.FixedResistances.PressureDrop res1(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m1_flow_nominal,
    final dp_nominal=if use_lumFloRes then 0 else dpBal1_nominal)
    "Primary balancing valve"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-50})));
equation
  connect(res1.port_b, port_b1)
    annotation (Line(points={{60,-60},{60,-100}}, color={0,127,255}));
  connect(port_b2, port_a1)
    annotation (Line(points={{-60,100},{-60,-100}}, color={0,127,255}));

  connect(val.port_b,res1. port_a)
    annotation (Line(points={{60,-10},{60,-40}}, color={0,127,255}));
  connect(val.port_a, port_a2)
    annotation (Line(points={{60,10},{60,100},{60,100}}, color={0,127,255}));
  connect(yVal, val.y)
    annotation (Line(points={{-120,0},{48,0}}, color={0,0,127}));
  connect(val.y_actual, yVal_actual) annotation (Line(points={{53,-6},{53,-20},{
          80,-20},{80,-40},{120,-40}},  color={0,0,127}));
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
          points={{-54,-40},{-60,-30},{-66,-40},{-54,-40}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{54,64},{60,54},{66,64},{54,64}},
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
          rotation=180),
        Polygon(
          points={{-20,10},{-20,-10},{0,0},{20,-10},{20,10},{0,0},{-20,10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={60,0},
          rotation=90),
        Line(
          points={{26,0},{-100,0}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dot,
          visible=typCtl == Buildings.Fluid.HydronicConfigurations.Types.Control.None),
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
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This configuration (see schematic below) is used for variable flow
primary and consumer circuits that have the same supply temperature
set point.
</p>
<p>
<img alt=\"Schematic\"
src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/ActiveNetworks/Throttle.png\"/>
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
Variable flow
</td>
</tr>
<tr>
<td valign=\"top\">
Typical applications
</td>
<td valign=\"top\">
Single heating or cooling coil served by a variable flow circuit<br/>
DHC system energy transfer station with intermediary heat exchanger
</td>
</tr>
<tr>
<td valign=\"top\">
Non-recommended applications
</td>
<td valign=\"top\">

</td>
</tr>
<tr>
<td valign=\"top\">
Built-in valve control options
</td>
<td valign=\"top\">
No built-in controls
</td>
</tr>
<tr>
<td valign=\"top\">
Control valve selection
</td>
<td valign=\"top\">
<i>&beta; = &Delta;p<sub>A-B</sub> /
&Delta;p<sub>1</sub> =
&Delta;p<sub>A-B</sub> /
(&Delta;p<sub>A-B</sub> + &Delta;p<sub>2</sub> + &Delta;p<sub>B-b1</sub>)</i><br/>
The valve is sized with a pressure drop equal to the one
of the consumer circuit and of the primary balancing valve (if any)
at design flow rate, yielding an authority of <i>0.5</i>.
</td>
</tr>
<tr>
<td valign=\"top\">
Balancing requirement
</td>
<td valign=\"top\">
No strict requirements: see additional comments below.
</td>
</tr>
<tr>
<td valign=\"top\">
Lumped flow resistances include<br/>
(With the setting <code>use_lumFloRes=true</code>.)
</td>
<td valign=\"top\">
Control valve <code>val</code>,
whole consumer circuit between <code>b2</code> and <code>a2</code><br/>
and primary balancing valve <code>res1</code>
</td>
</tr>
</table>
<h4>Additional comments</h4>
<p>
Some authors such as Taylor (2002, 2017) claim that variable flow circuits with variable
speed pumps and terminal units with two-valves should not be balanced.
The reason is that the circuit can only be balanced at one operating point.
At partial load, if remote consumers have a low demand while the consumers
closest to the pump have a high demand, the latter ones will experience
a flow shortage due to the balancing valve that generates too much pressure
drop for the lower available pressure differential due to the lower
pump speed.
In addition, there is no clear balancing procedure when a load diversity
factor is taken into account.
The example
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.ThrottleOpenLoop\">
Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.ThrottleOpenLoop</a>
allows drawing similar conclusions.
</p>
<h4>
References
</h4>
<p>
Taylor, S. T., 2002.
Balancing variable flow hydronic systems.
ASHRAE Journal.
URL: <a href=\"https://tayloreng.egnyte.com/dl/CZVS52ZTVB/ASHRAE_Journal_-_Balancing_Variable_Flow_Hydronic_Systems.pdf_\">
https://tayloreng.egnyte.com/dl/CZVS52ZTVB/ASHRAE_Journal_-_Balancing_Variable_Flow_Hydronic_Systems.pdf_</a>
</p>
<p>
Taylor, S. T., 2017.
Doubling down on not balancing variable flow hydronic systems.
ASHRAE Journal.
URL: <a href=\"https://tayloreng.egnyte.com/dl/W8sfOOuoni/ASHRAE_Journal_-_Doubling-Down_on_NOT_Balancing_Variable_Flow_Hydronic_Systems.pdf_\">
https://tayloreng.egnyte.com/dl/W8sfOOuoni/ASHRAE_Journal_-_Doubling-Down_on_NOT_Balancing_Variable_Flow_Hydronic_Systems.pdf_</a>
</p>
</html>", revisions="<html>
<ul>
<li>
June 30, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end Throttle;
