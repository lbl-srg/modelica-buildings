within Buildings.Templates.ZoneEquipment.Components.Controls.Interfaces;
partial block PartialVAVBoxController "Interface class for VAV terminal unit"
  extends
    Buildings.Templates.ZoneEquipment.Components.Controls.Interfaces.PartialController(
      redeclare
      Buildings.Templates.ZoneEquipment.Components.Data.VAVBoxController dat);

  parameter Boolean have_CO2Sen=false
    "Set to true if the zone has CO2 sensor"
    annotation (Dialog(group="Configuration"));

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard stdVen=
    Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016
    "Ventilation standard, ASHRAE 62.1 or Title 24"
    annotation(Evaluate=true,
       Dialog(group="Configuration", enable=
       typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxCoolingOnly or
       typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat));

  outer replaceable Buildings.Templates.Components.Dampers.PressureIndependent damVAV
    "VAV damper";

  annotation (Documentation(info="<html>
<p>
This partial class provides a standard interface for VAV terminal unit controllers.
</p>
</html>"));
end PartialVAVBoxController;
