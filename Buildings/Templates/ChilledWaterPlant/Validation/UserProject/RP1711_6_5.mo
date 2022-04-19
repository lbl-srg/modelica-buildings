within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model RP1711_6_5
  "Series Chillers with Waterside Economizer, Variable Primary Chilled Water, Variable Condenser Water, Headered Pumps"
  //ToDo
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
    redeclare Buildings.Templates.ChilledWaterPlant.Components.Economizer.WatersideEconomizer
      eco,
    final have_chiByp=false);

  annotation (
    defaultComponentName="chw");
end RP1711_6_5;
