within Buildings.Templates.ChilledWaterPlant;
model WaterCooledParallel
  extends Buildings.Templates.ChilledWaterPlant.BaseClasses.WaterCooled(
    final typ=Buildings.Templates.Types.ChilledWaterPlant.WaterCooledParallel,
    redeclare final
      Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.ChillerParallel
      chiGro(has_dedPum=pumPri.is_dedicated));

equation

end WaterCooledParallel;
