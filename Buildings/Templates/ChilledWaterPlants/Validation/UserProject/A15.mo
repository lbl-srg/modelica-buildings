within Buildings.Templates.ChilledWaterPlants.Validation.UserProject;
model A15
  "Parallel Chillers, Variable Primary Chilled Water, Constant Condenser Water, Dedicated Pumps"
  extends Buildings.Templates.ChilledWaterPlants.WaterCooled(
    redeclare
      Buildings.Templates.ChilledWaterPlants.Components.CoolerGroups.CoolingTower
      cooTowSec(final nCooTow=2),
    redeclare
      Buildings.Templates.ChilledWaterPlants.Components.ChillerSection.Parallel
      chiSec(final nChi=2, redeclare
        Buildings.Templates.ChilledWaterPlants.Components.PumpsPrimary.Dedicated
        pumPri(final have_floSen=true)),
    redeclare
      Buildings.Templates.ChilledWaterPlants.Components.PumpsSecondary.None
      pumSec,
    redeclare
      Buildings.Templates.ChilledWaterPlants.Components.PumpsCondenserWater.Dedicated
      pumCon,
    redeclare
      Buildings.Templates.ChilledWaterPlants.Components.Economizers.None eco);

  annotation (
    defaultComponentName="chw");
end A15;
