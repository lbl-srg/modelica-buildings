within Buildings.Templates.ChilledWaterPlant;
model AirCooled
  extends Buildings.Templates.ChilledWaterPlant.BaseClasses.PartialChilledWaterLoop(
    dat(final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.Configuration.AirCooled));
end AirCooled;
