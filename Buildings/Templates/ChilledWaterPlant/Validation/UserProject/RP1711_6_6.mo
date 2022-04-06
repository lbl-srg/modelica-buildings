within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model RP1711_6_6
  "Parallel Chillers, Primary-Secondary Chilled Water, Constant Condenser Water, Dedicated Primary Chilled Water Pumps, Headered Condenser Water Pumps"
  extends Buildings.Templates.ChilledWaterPlant.WaterCooled(
    final nCooTow=2,
    redeclare
      Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerGroup.CoolingTowerParallel
      cooTowGro,
    redeclare
      Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.ChillerParallel
      chiGro(final nChi=2, redeclare
        Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YT_1055kW_5_96COP_Vanes
        per),
    redeclare
      Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumpGroup.Dedicated
      pumPri(final have_floSen=true),
    redeclare
      Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumpGroup.Centralized
      pumSec(final nPum=2),
    pumCon(final nPum=2));

  annotation (
    defaultComponentName="chw");
end RP1711_6_6;
