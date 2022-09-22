within Buildings.Templates.ChilledWaterPlants.Validation.UserProject;
model A20
  "Parallel Chillers, Primary-Secondary Chilled Water, Constant Condenser Water, Headered Pumps"
  extends Buildings.Templates.ChilledWaterPlants.ChilledWaterPlant(
    redeclare
      Buildings.Templates.ChilledWaterPlants.Components.CoolerGroups.CoolingTower
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
      Buildings.Templates.ChilledWaterPlants.Components.Economizers.None eco);
  annotation (
    defaultComponentName="chw");
end A20;
