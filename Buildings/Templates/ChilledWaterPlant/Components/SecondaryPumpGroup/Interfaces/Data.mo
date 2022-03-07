within Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumpGroup.Interfaces;
record Data "Data for secondary pump groups"
  extends Buildings.Templates.Components.Pumps.Interfaces.Data;

  // Structure parameters

  parameter Buildings.Templates.ChilledWaterPlant.Components.Types.SecondaryPumpGroup typ
    "Type of chilled water secondary pump group"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

end Data;
