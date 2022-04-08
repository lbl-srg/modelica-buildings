within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model RP1711_6_1
  "Parallel Chillers, Variable Primary Chilled Water, Constant Condenser Water, Headered Pumps"
  extends Buildings.Templates.ChilledWaterPlant.WaterCooled(
    redeclare Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerSection.Parallel
      cooTowSec(final nCooTow=2),
    redeclare Buildings.Templates.ChilledWaterPlant.Components.ChillerSection.Parallel
      chiSec(final nChi=2),
    pumPri(final nPum=2),
    pumCon(final nPum=2));

  annotation (
    defaultComponentName="chw");
end RP1711_6_1;
