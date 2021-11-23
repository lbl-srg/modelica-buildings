within Buildings.Templates.ChilledWaterPlant;
model AirCooledParallel
  extends Buildings.Templates.ChilledWaterPlant.BaseClasses.AirCooled(
    final typ=Buildings.Templates.Types.ChilledWaterPlant.AirCooledParallel,
    redeclare
      Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.ChillerParallel
      chiGro(final has_dedPum=pumPri.is_dedicated));

end AirCooledParallel;
