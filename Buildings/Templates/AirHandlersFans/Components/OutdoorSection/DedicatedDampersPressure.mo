within Buildings.Templates.AirHandlersFans.Components.OutdoorSection;
model DedicatedDampersPressure
  "Separate dampers for ventilation and economizer, with differential pressure sensor"
  extends Buildings.Templates.AirHandlersFans.Components.Interfaces.PartialOutdoorSectionDedicatedDampers(
    final typ=Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure);

  annotation (Documentation(info="<html>
<p>
This model represents a configuration with an air economizer and
minimum OA control with a separate minimum OA damper and differential
pressure control.
</p>
</html>"));
end DedicatedDampersPressure;
