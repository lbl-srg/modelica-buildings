within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model RP1711_6_1_G36Control
  "Parallel Chillers, Variable Primary Chilled Water, Constant Condenser Water, Headered Pumps with Guideline36 controls"
  extends Buildings.Templates.ChilledWaterPlant.WaterCooled(
    redeclare Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerSection.Parallel
      cooTowSec(final nCooTow=2),
    redeclare Buildings.Templates.ChilledWaterPlant.Components.ChillerSection.Parallel
      chiSec(final nChi=2),
    redeclare Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumps.HeaderedParallel
      pumPri(final nPum=2, final have_floSen=true),
    redeclare Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumps.None
      pumSec,
    redeclare Buildings.Templates.ChilledWaterPlant.Components.CondenserPumps.Headered
      pumCon(final nPum=2),
    redeclare Buildings.Templates.ChilledWaterPlant.Components.Economizer.None
      eco,
    redeclare Buildings.Templates.ChilledWaterPlant.Components.Controls.Guideline36WaterCooled
      con);

  annotation (
    defaultComponentName="chw");
end RP1711_6_1_G36Control;
