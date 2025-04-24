within Buildings.Templates.ZoneEquipment.Components.Interfaces;
partial block PartialControllerVAVBox
  "Interface class for VAV terminal unit controller"
  extends
    Buildings.Templates.ZoneEquipment.Components.Interfaces.PartialController(
      redeclare
      Buildings.Templates.ZoneEquipment.Components.Data.VAVBoxController dat(
        stdVen=stdVen));

  parameter Boolean have_CO2Sen=false
    "Set to true if the zone has CO2 sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  final parameter Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard stdVen=
    datAll.stdVen
    "Ventilation standard";

  outer replaceable Buildings.Templates.Components.Coils.None coiHea
    "Heating coil";

  annotation (Documentation(info="<html>
<p>
This partial class provides a standard interface for VAV terminal unit controllers.
</p>
</html>"));
end PartialControllerVAVBox;
