within Buildings.Templates.ZoneEquipment.Components.Controls.Interfaces;
partial block PartialVAVBoxController "Interface class for VAV terminal unit"
  extends
    Buildings.Templates.ZoneEquipment.Components.Controls.Interfaces.PartialController(
      redeclare
      Buildings.Templates.ZoneEquipment.Components.Data.VAVBoxController dat(
        have_CO2Sen=have_CO2Sen));

  parameter Boolean have_CO2Sen=false
    "Set to true if the zone has CO2 sensor"
    annotation (Dialog(group="Configuration"));

  outer replaceable Buildings.Templates.Components.Dampers.PressureIndependent damVAV
    "VAV damper";

  annotation (Documentation(info="<html>
<p>
This partial class provides a standard interface for VAV terminal unit controllers.
</p>
</html>"));
end PartialVAVBoxController;
