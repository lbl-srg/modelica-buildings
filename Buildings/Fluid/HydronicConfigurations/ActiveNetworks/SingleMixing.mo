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
flow primary circuits and constant flow secondary circuits that
have a design supply temperature identical to the primary circuit
but a varying set point during operation.
</p>
Note about control valve sizing requirement that may 
be too constraining / secondary pump sizing 
(that must basically cover dp1)
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
Single heating or cooling coil served by a constant flow circuit
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
<i>&beta; = &Delta;p<sub>A-AB</sub> / 
(&Delta;p<sub>a1-b1</sub> + &Delta;p<sub>J-AB</sub>)</i><br/>
The valve is sized with a pressure drop of <i>&Delta;p<sub>a1-b1</sub></i>
which yields an authority close to <i>0.5</i>.
</td>
</tr>
<tr>
<td valign=\"top\">
Balancing requirement
</td>
<td valign=\"top\">

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
Valve authority <i>&beta; = Δp_V / (Δp1 + Δp_Vbyp)</i> 
(independent of the balancing valve pressure drop).
For good authority <i>Δp_V ~ Δp1</i> which must be compensated for 
by the secondary pump
in the case where the primary pressure differential is cancelled by
the primary balancing valve. 
</p>
<h4>
Parameterization
</h4>
<p>
By default the secondary pump is parameterized with 
<code>m2_flow_nominal</code> and 
<code>dp2_nominal + dpBal2_nominal + max({val.dpValve_nominal, val.dp3Valve_nominal})</code> 
at maximum speed.
The partner valve <code>bal2</code> is therefore configured with zero
pressure drop.
</p>
</html>"));

end SingleMixing;
