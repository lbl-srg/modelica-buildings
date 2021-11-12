within Buildings.Templates.ChilledWaterPlant;
model AirCooledSeries
  extends Buildings.Templates.ChilledWaterPlant.BaseClasses.AirCooled(
    final typ=Buildings.Templates.Types.ChilledWaterPlant.AirCooledSeries,
    redeclare final
      Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.ChillerSeries
      chiGro);
end AirCooledSeries;
