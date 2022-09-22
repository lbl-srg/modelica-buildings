within Buildings.Templates.ChilledWaterPlants.Validation.UserProject;
model A18
  "Series Chillers with Waterside Economizer, Variable Primary Chilled Water, Variable Condenser Water, Headered Pumps"
  extends Buildings.Templates.ChilledWaterPlants.ChilledWaterPlant(
    redeclare
      Buildings.Templates.ChilledWaterPlants.Components.CoolerGroups.CoolingTower
      cooTowSec(final nCooTow=2),
    redeclare
      Buildings.Templates.ChilledWaterPlants.Components.ChillerSection.Series
      chiSec(final nChi=2, redeclare
        Buildings.Templates.ChilledWaterPlants.Components.PumpsPrimary.HeaderedSeries
        pumPri(final nPum=2, final have_floSen=true)),
    redeclare
      Buildings.Templates.ChilledWaterPlants.Components.PumpsSecondary.None
      pumSec,
    redeclare
      Buildings.Templates.ChilledWaterPlants.Components.PumpsCondenserWater.Headered
      pumCon(final nPum=2),
    redeclare
      Buildings.Templates.ChilledWaterPlants.Components.Economizers.HeatExchangerWithPump
      eco(final have_valChiWatEcoByp=false),
    final have_chiWatChiByp=false);

  annotation (
    defaultComponentName="chw");
end A18;
