within Buildings.Templates.ZoneEquipment.BaseClasses.Controls;
partial block PartialSingleDuct
  "Partial control block for single duct terminal unit"
  extends Buildings.Templates.ZoneEquipment.Interfaces.Controller;

  outer replaceable Buildings.Templates.Components.Coils.None coiReh
    "Reheat coil";

end PartialSingleDuct;
