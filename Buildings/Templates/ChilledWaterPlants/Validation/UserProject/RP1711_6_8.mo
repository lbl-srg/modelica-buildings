within Buildings.Templates.ChilledWaterPlants.Validation.UserProject;
model RP1711_6_8
  "Parallel Chillers with Waterside Economizer, Primary-Secondary Chilled Water, Variable Condenser Water, Headered Pumps"
  extends Buildings.Templates.ChilledWaterPlants.WaterCooled(
    redeclare
      Buildings.Templates.ChilledWaterPlants.Components.CoolingTowerSection.Parallel
      cooTowSec(final nCooTow=2),
    redeclare
      Buildings.Templates.ChilledWaterPlants.Components.ChillerSection.Parallel
      chiSec(final nChi=2, redeclare
        Buildings.Templates.ChilledWaterPlants.Components.PumpsPrimary.HeaderedParallel
        pumPri(final nPum=2, final have_floSen=true)),
    redeclare
      Buildings.Templates.ChilledWaterPlants.Components.PumpsSecondary.Centralized
      pumSec(final nPum=2),
    redeclare
      Buildings.Templates.ChilledWaterPlants.Components.PumpsCondenserWater.Headered
      pumCon(final nPum=2),
    redeclare
      Buildings.Templates.ChilledWaterPlants.Components.EconomizerSection.WatersideEconomizer
      eco,
    final have_chiWatChiByp=false);

  annotation (
    defaultComponentName="chw");
end RP1711_6_8;
