within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model RP1711_6_4
  "Series Chillers, Constant Primary Chilled Water, Constant Condenser Water, Headered Pumps"
  extends Buildings.Templates.ChilledWaterPlant.WaterCooled(
    redeclare Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerSection.Parallel
      cooTowSec(final nCooTow=2),
    redeclare Buildings.Templates.ChilledWaterPlant.Components.ChillerSection.Series
      chiSec(
        final nChi=2,
        redeclare Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumps.HeaderedSeries
          pumPri(final nPum=2, final have_floSen=true)),
    redeclare Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumps.None
      pumSec,
    redeclare Buildings.Templates.ChilledWaterPlant.Components.CondenserPumps.Headered
      pumCon(final nPum=2),
    redeclare Buildings.Templates.ChilledWaterPlant.Components.Economizer.None
      eco);

  annotation (
    defaultComponentName="chw");
end RP1711_6_4;
