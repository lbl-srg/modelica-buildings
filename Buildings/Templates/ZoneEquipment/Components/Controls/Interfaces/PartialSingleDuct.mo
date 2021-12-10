within Buildings.Templates.ZoneEquipment.Components.Controls.Interfaces;
partial block PartialSingleDuct
  "Partial control block for single duct terminal unit"
  extends
    Buildings.Templates.ZoneEquipment.Components.Controls.Interfaces.PartialController;

  outer replaceable Buildings.Templates.Components.Coils.None coiHea
    "Heating coil";

end PartialSingleDuct;
