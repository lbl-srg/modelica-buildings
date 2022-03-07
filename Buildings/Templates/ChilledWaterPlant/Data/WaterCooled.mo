within Buildings.Templates.ChilledWaterPlant.Data;
record WaterCooled "Data for water cooled chilled water plants"
  extends Buildings.Templates.ChilledWaterPlant.Interfaces.Data(
    final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.Configuration.WaterCooled);

end WaterCooled;
