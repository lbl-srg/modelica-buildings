within Buildings.Templates.ChilledWaterPlant.Data;
record AirCooled "Data for air cooled chilled water plants"
  extends Buildings.Templates.ChilledWaterPlant.Interfaces.Data(
    final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.Configuration.AirCooled);
end AirCooled;
