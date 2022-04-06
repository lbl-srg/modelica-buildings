within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model RP1711_6_1
  "Parallel Chillers, Variable Primary Chilled Water, Constant Condenser Water, Headered Pumps"
  extends Buildings.Templates.ChilledWaterPlant.WaterCooled(
    redeclare Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerGroup.CoolingTowerParallel
      cooTowGro(final nCooTow=2),
    redeclare Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.ChillerParallel
      chiGro(final nChi=2),
    pumPri(final nPum=2),
    pumCon(final nPum=2));

  annotation (
    defaultComponentName="chw");
end RP1711_6_1;
