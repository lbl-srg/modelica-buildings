within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model RP1711_6_1
  "Parallel Chillers, Variable Primary CHW, Constant CW, Headered Pumps"
  extends Buildings.Templates.ChilledWaterPlant.WaterCooled(
    redeclare final Buildings.Templates.ChilledWaterPlant.Validation.UserProject.UserData dat,
    redeclare
      Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerGroup.CoolingTowerParallel
      cooTowGro,
    redeclare Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.ChillerParallel chiGro,
    pumPri,
    pumCon,
    final have_byp=true);

  annotation (
    defaultComponentName="chw");
end RP1711_6_1;
