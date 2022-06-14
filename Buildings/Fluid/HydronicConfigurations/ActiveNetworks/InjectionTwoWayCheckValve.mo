within Buildings.Fluid.HydronicConfigurations.ActiveNetworks;
model InjectionTwoWayCheckValve
  "Injection circuit with two-way valve and check valve in bypass branch"
  extends Fluid.HydronicConfigurations.ActiveNetworks.InjectionTwoWay(
    pum(dp_nominal=dp2_nominal + dpBal2_nominal + res3.dpValve_nominal),
    redeclare FixedResistances.CheckValve res3(
      final dpValve_nominal=3.4e3,
      final allowFlowReversal=allowFlowReversal,
      final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
      final dpFixed_nominal=0))
  annotation (IconMap(primitivesVisible=false));

  annotation (
    defaultComponentName="con",
    Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={
      Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={175,175,175},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(
          extent={{-149,-114},{151,-154}},
          textColor={0,0,255},
          textString="%name"),
      Bitmap(
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/ActiveNetworks/InjectionTwoWayValveCheckValve.svg")}),
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
