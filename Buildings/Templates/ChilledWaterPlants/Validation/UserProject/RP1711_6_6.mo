within Buildings.Templates.ChilledWaterPlants.Validation.UserProject;
model RP1711_6_6
  "Parallel Chillers, Primary-Secondary Chilled Water, Constant Condenser Water, Dedicated Primary Chilled Water Pumps, Headered Condenser Water Pumps"
  extends Buildings.Templates.ChilledWaterPlants.WaterCooled(
    redeclare
      Buildings.Templates.ChilledWaterPlants.Components.CoolingTowerSection.Parallel
      cooTowSec(final nCooTow=2),
    redeclare
      Buildings.Templates.ChilledWaterPlants.Components.ChillerSection.Parallel
      chiSec(final nChi=2, redeclare
        Buildings.Templates.ChilledWaterPlants.Components.PumpsPrimary.Dedicated
        pumPri(final have_floSen=true)),
    redeclare
      Buildings.Templates.ChilledWaterPlants.Components.PumpsSecondary.Centralized
      pumSec(final nPum=2),
    redeclare
      Buildings.Templates.ChilledWaterPlants.Components.PumpsCondenserWater.Headered
      pumCon(final nPum=2),
    redeclare
      Buildings.Templates.ChilledWaterPlants.Components.Economizers.None eco);

  annotation (
    defaultComponentName="chw");
end RP1711_6_6;
