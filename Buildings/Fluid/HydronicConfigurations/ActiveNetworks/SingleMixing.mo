within Buildings.Fluid.HydronicConfigurations.ActiveNetworks;
model SingleMixing "Single mixing circuit"
  extends BaseClasses.SingleMixing(
    final dpBal3_nominal=0);

  annotation (
    defaultComponentName="con",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Polygon(
          points={{34,34},{40,24},{46,34},{34,34}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          rotation=270,
          origin={-30,40}),
        Polygon(
          points={{54,-16},{60,-26},{66,-16},{54,-16}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
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
This configuration (see schematic below) is used for variable
flow primary circuits and
either constant flow or variable flow secondary circuits that
have a design supply temperature close or identical to the primary circuit
but a varying set point during operation.
The control valve should be sized with a pressure drop equal
to the primary pressure differential.
That pressure drop must be compensated for by the secondary
pump which excludes the use of this configuration to
applications with a high primary pressure differential.
<p>
<img alt=\"Schematic\"
src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/ActiveNetworks/SingleMixing.png\"/>
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
Constant or variable flow
</td>
</tr>
<tr>
<td valign=\"top\">
Typical applications
</td>
<td valign=\"top\">
Circuits that have a design supply temperature close or identical 
to the primary circuit but a varying set point during operation.
</td>
</tr>
<tr>
<td valign=\"top\">
Non-recommended applications
</td>
<td valign=\"top\">
Applications with a high primary pressure differential such as DHC systems
due to the constraints on the control valve and secondary pump selection:
for those applications use either
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.InjectionTwoWay\">
Buildings.Fluid.HydronicConfigurations.ActiveNetworks.InjectionTwoWay</a>,
or
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Decoupling\">
Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Decoupling</a>
in conjunction with
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.PassiveNetworks.SingleMixing\">
Buildings.Fluid.HydronicConfigurations.PassiveNetworks.SingleMixing</a>.
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
Control valve selection
</td>
<td valign=\"top\">
<i>&beta; = &Delta;p<sub>A-AB</sub> /
(&Delta;p<sub>1</sub> + &Delta;p<sub>A-AB</sub>)</i><br/>
The valve is sized with a pressure drop of <i>&Delta;p<sub>1</sub></i>
which yields an authority close to <i>0.5</i>.
</td>
</tr>
<tr>
<td valign=\"top\">
Balancing requirement
</td>
<td valign=\"top\">
The primary balancing valve should compensate for the primary
pressure differential (see additional comments below).
<br/>
Bypass balancing valve not recommended.
</td>
</tr>
<tr>
<td valign=\"top\">
Lumped flow resistances include<br/>
(With the setting <code>use_lumFloRes=true</code>.)
</td>
<td valign=\"top\">
Direct branch: control valve direct branch <code>val.res1</code>
and whole consumer circuit between <code>b2</code> and <code>a2</code><br/>
Bypass branch: control valve bypass branch <code>val.res3</code>
and bypass balancing valve <code>res3</code>
</td>
</tr>
</table>
<h4>Additional comments</h4>
<p>
The primary pressure differential tends to oppose the bypass flow rate.
It is possible to reach zero bypass flow at partial valve opening and
a negative bypass flow for even lower opening values.
Therefore, a balancing valve in the bypass is not recommended as it
would further reduce the bypass flow rate.
When using that model, one should keep the default setting
<code>dpBal3_nominal=0</code>&nbsp;Pa.
</p>
<p>
The balancing procedure should ensure that the
primary pressure differential is compensated for by the primary balancing valve.
Otherwise, the flow may reverse in the bypass branch and the mixing function of
the three-way valve cannot be achieved.
The control valve pressure drop must be compensated for
by the secondary pump.
</p>
</html>", revisions="<html>
<ul>
<li>
June 30, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));

end SingleMixing;
