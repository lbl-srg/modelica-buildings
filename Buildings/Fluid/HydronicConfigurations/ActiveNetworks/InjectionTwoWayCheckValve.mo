within Buildings.Fluid.HydronicConfigurations.ActiveNetworks;
model InjectionTwoWayCheckValve
  "Injection circuit with two-way valve and check valve in bypass branch"
  extends Fluid.HydronicConfigurations.ActiveNetworks.InjectionTwoWay(
    pum(dp_nominal=dp2_nominal + dpBal2_nominal + res3.dpValve_nominal),
    redeclare FixedResistances.CheckValve res3(
      final dpValve_nominal=3.4e3,
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
<p>
This circuit is similar to
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
Primary pressure differential may be transmitted to the consumer circuit,
lowering the authority of the terminal control valves.
Therefore this configuration is rather recommended in conjunction with
a variable flow consumer circuit where the circulation pump speed is 
modulated to track a differential pressure set point.
Hence, when the primary and secondary pumps are in series, the secondary
pump is operated at a lower speed.
</p>
<p>
Note that 
Lumped flow resistance includes...

The check valve is configured with a default pressure drop 
<code>res3.dpValve_nominal=3.4e3</code>&nbsp;Pa
for a mass flow rate of...
</p>
</html>"));
end InjectionTwoWayCheckValve;
