within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model RP1711_6_2
  "Parallel Chillers, Variable Primary Chilled Water, Constant Condenser Water, Dedicated Pumps"
  extends Buildings.Templates.ChilledWaterPlant.WaterCooled(
    redeclare Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerSection.Parallel
      cooTowSec(final nCooTow=2),
    redeclare Buildings.Templates.ChilledWaterPlant.Components.ChillerSection.Parallel
      chiSec(
        final nChi=2,
        redeclare Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumps.Dedicated
          pumPri(final have_floSen=true)),
    redeclare Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumps.None
      pumSec,
    redeclare Buildings.Templates.ChilledWaterPlant.Components.CondenserPumps.Dedicated
      pumCon,
    redeclare Buildings.Templates.ChilledWaterPlant.Components.Economizer.None
      eco);

  annotation (
    defaultComponentName="chw");
end RP1711_6_2;
