within Buildings.Templates.AirHandlersFans.Components.OutdoorSection;
model DedicatedDampersAirflow
  "Separate dampers for ventilation and economizer, with airflow measurement station"
  extends Buildings.Templates.AirHandlersFans.Components.Interfaces.PartialOutdoorSectionDedicatedDampers(
    final typ=Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow);

  annotation (Documentation(info="<html>
<p>
This model represents a configuration with an air economizer and
minimum OA control with a separate minimum OA damper and airflow measurement.
</p>
</html>"));
end DedicatedDampersAirflow;
