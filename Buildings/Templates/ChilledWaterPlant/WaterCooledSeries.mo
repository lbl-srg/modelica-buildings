within Buildings.Templates.ChilledWaterPlant;
model WaterCooledSeries
  extends Buildings.Templates.ChilledWaterPlant.BaseClasses.WaterCooled(
    final typ=Buildings.Templates.Types.ChilledWaterPlant.WaterCooledSeries,
    redeclare
      Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.ChillerSeries
      chiGro);
end WaterCooledSeries;
