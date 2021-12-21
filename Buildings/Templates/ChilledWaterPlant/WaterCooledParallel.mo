within Buildings.Templates.ChilledWaterPlant;
model WaterCooledParallel
  extends Buildings.Templates.ChilledWaterPlant.BaseClasses.WaterCooled(
    final typ=Buildings.Templates.Types.ChilledWaterPlant.WaterCooledParallel,
    redeclare
      Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.ChillerParallel
      chiGro(final have_dedPum=pumPri.is_dedicated));

equation

end WaterCooledParallel;
