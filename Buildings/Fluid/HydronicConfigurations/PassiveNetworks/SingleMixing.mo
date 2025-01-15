within Buildings.Fluid.HydronicConfigurations.PassiveNetworks;
model SingleMixing "Single mixing circuit"
  extends BaseClasses.SingleMixing(
    dpPum_nominal=dp2_nominal + dpBal2_nominal +
      max({val.dpValve_nominal + dp1_nominal, val.dp3Valve_nominal + dpBal3_nominal}),
    final dpBal1_nominal=0);

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
          origin={10,40}),
        Polygon(
          points={{54,-50},{60,-60},{66,-50},{54,-50}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,10},{-20,-10},{0,0},{20,-10},{20,10},{0,0},{-20,10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          rotation=180,
          visible=dpBal3_nominal > 0),
        Line(
          points={{-20,-1.83696e-15},{3.74941e-32,-6.12325e-16}},
          color={0,0,0},
          thickness=0.5,
          rotation=180,
          origin={-10,14},
          visible=dpBal3_nominal > 0),
        Line(
          points={{-14,-1.71451e-15},{3.74941e-32,-6.12325e-16}},
          color={0,0,0},
          thickness=0.5,
          rotation=270,
          visible=dpBal3_nominal > 0)}),
    Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4>Summary</h4>
<p>
This configuration (see schematic below) is used for variable
flow primary circuits and
either constant flow or variable flow secondary circuits that
have a design supply temperature identical to the primary circuit
but a varying set point during operation.
</p>
<p>
<img alt=\"Schematic\"
src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/PassiveNetworks/SingleMixing.png\"/>
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
Widely used in heating applications as it is very simple to achieve.

</td>
</tr>
<tr>
<td valign=\"top\">
Non-recommended applications
</td>
<td valign=\"top\">
Low-temperature systems that would require the control valve to
be operated on a limited opening range: use 
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.PassiveNetworks.DualMixing\">
Buildings.Fluid.HydronicConfigurations.PassiveNetworks.DualMixing</a>
instead.

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
<i>&beta; = &Delta;p<sub>A-AB</sub> /
(&Delta;p<sub>1</sub> + &Delta;p<sub>A-AB</sub>)</i><br/>
The control valve is sized with a pressure drop equal to the
maximum of <i>&Delta;p<sub>1</sub></i> and <i>3e3</i>&nbsp;Pa.
</td>
</tr>
<tr>
<td valign=\"top\">
Balancing requirement
</td>
<td valign=\"top\">
In most cases the bypass balancing valve is not needed.
However, it may be needed to counter negative back pressure
created by other served circuits, see 
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.PassiveNetworks.Examples.SingleMixingOpenLoop\">
Buildings.Fluid.HydronicConfigurations.PassiveNetworks.Examples.SingleMixingOpenLoop</a>.
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
The parameter <code>dp1_nominal</code> stands for the potential
primary back pressure and must be provided as an absolute value.
By default the secondary pump is parameterized with
a design pressure rise equal to
<code>dp2_nominal + dpBal2_nominal +
max({val.dpValve_nominal + dp1_nominal, val.dp3Valve_nominal + dpBal3_nominal}</code>.
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
