within Buildings.Templates.ZoneEquipment.Components.Controls.Interfaces;
partial block PartialVAVBox
  "Partial control block for VAV terminal unit"
  extends
    Buildings.Templates.ZoneEquipment.Components.Controls.Interfaces.PartialController(
    redeclare Buildings.Templates.ZoneEquipment.Components.Controls.Interfaces.DataG36VAVBox dat(
      have_CO2Sen=have_CO2Sen));

  parameter Boolean have_CO2Sen=false
    "Set to true if the zone has CO2 sensor"
    annotation (Dialog(group="Configuration"));

  outer replaceable Buildings.Templates.Components.Dampers.PressureIndependent damVAV
    "VAV damper";

end PartialVAVBox;
