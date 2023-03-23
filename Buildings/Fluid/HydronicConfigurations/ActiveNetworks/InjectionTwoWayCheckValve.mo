within Buildings.Fluid.HydronicConfigurations.ActiveNetworks;
model InjectionTwoWayCheckValve
  "Injection circuit with two-way valve and check valve in bypass branch"
  extends Fluid.HydronicConfigurations.ActiveNetworks.InjectionTwoWay(
    dpPum_nominal=dp2_nominal + dpBal2_nominal + res3.dpValve_nominal,
    redeclare FixedResistances.CheckValve res3(
      final dpValve_nominal=5e3,
      final allowFlowReversal=allowFlowReversal,
      final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
      final dpFixed_nominal=0));

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
          origin={10,70}),
        Rectangle(
          extent={{-20,40},{20,20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Line(
          points={{-20,20},{20,40}},
          color={0,0,0},
          thickness=0.5),
        Ellipse(
          extent={{18,42},{22,38}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4>Summary</h4>
<p>
This configuration (see schematic hereunder) is nearly similar to
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.InjectionTwoWay\">
Buildings.Fluid.HydronicConfigurations.ActiveNetworks.InjectionTwoWay</a>
except for the check valve that is added into the bypass.
If used in DHC systems and if the control valve is not properly sized
to maintain the set point at all loads, the check valve prevents recirculation
in the service line which degrades the &Delta;T in the distribution system.
If used to connect a heating coil, the check valve reduces the risk
of freezing in case of secondary pump failure.
</p>
<p>
<img alt=\"Schematic\"
src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/ActiveNetworks/InjectionTwoWayCheckValve.png\"/>
</p>
<p>
See the documentation of
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.InjectionTwoWay\">
Buildings.Fluid.HydronicConfigurations.ActiveNetworks.InjectionTwoWay</a>
for a summary table of the main characteristics of this configuration.
In addition, the following non-recommended applications should be mentioned,
and the control valve authority is reduced by the check valve pressure drop.
</p>
<table class=\"releaseTable\" summary=\"Main characteristics\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr>
<td valign=\"top\">
Non-recommended applications
</td>
<td valign=\"top\">
Radiant systems due to the risk of overheating or condensation in case
of secondary pump failure<br/>
Constant flow consumer circuits due to the risk of elevated secondary pressure
when the check valve is closed and the primary and secondary pumps are
in series
</td>
</tr>
<tr>
<td valign=\"top\">
Control valve authority<br/>
(See the nomenclature in the schematic.)
</td>
<td valign=\"top\">
<i>&beta; = &Delta;p<sub>A-B</sub> /
(&Delta;p<sub>1</sub> + &Delta;p<sub>A-J</sub>)</i><br/>
</td>
</tr>
</table>
<h4>Additional comments</h4>
<p>
With this configuration, if the check valve is closed, the primary pressure
differential is transmitted to the consumer circuit,
lowering the authority of the terminal control valves.
Therefore this configuration is rather recommended in conjunction with
a variable flow consumer circuit where the circulation pump speed is
modulated to track a differential pressure set point.
Hence, when the primary and secondary pumps are in series, the secondary
pump is operated at a lower speed.
</p>
<p>
The check valve is configured with a default pressure drop
<code>res3.dpValve_nominal=5e3</code>&nbsp;Pa
for a mass flow rate equal to the maximum value of
<code>m2_flow_nominal</code> and the check valve fully open.
Note that with a variable flow consumer circuit the bypass
line may be sized with a lower design flow rate.
Hence the parameter <code>res3.m_flow_nominal</code> is not
assigned a final value and may be overwritten.
The pressure drop through the check valve is compensated by the secondary pump,
while the pressure drop through the control valve is compensated by the
primary pump.
</p>
</html>", revisions="<html>
<ul>
<li>
June 30, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end InjectionTwoWayCheckValve;
