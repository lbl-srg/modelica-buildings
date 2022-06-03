within Buildings.Fluid.HydronicConfigurations.ActiveNetworks;
model InjectionTwoWayCheckValve
  "Injection circuit with two-way valve and check valve in bypass branch"
  extends Fluid.HydronicConfigurations.ActiveNetworks.InjectionTwoWay(
    redeclare FixedResistances.CheckValve byp(
      dpValve_nominal=0.34e4,
      final allowFlowReversal=allowFlowReversal,
      final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
      final dpFixed_nominal=0))
  annotation (
    IconMap(primitivesVisible = false));

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
Lumped flow resistance includes...

Default dpValve_nominal=0.34e4 for check valve
</p>
</html>"));
end InjectionTwoWayCheckValve;
