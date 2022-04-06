within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model RP1711_6_8
  "Parallel Chillers with Waterside Economizer, Primary-Secondary Chilled Water, Variable Condenser Water, Headered Pumps"
  //ToDo
  extends Buildings.Templates.ChilledWaterPlant.WaterCooled(
    final nCooTow=2,
    redeclare
      Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerSection.Parallel
      cooTowSec,
    redeclare
      Buildings.Templates.ChilledWaterPlant.Components.ChillerSection.Parallel
      chiSec(final nChi=2, redeclare
        Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YT_1055kW_5_96COP_Vanes
        per),
    pumCon(final nPum=2),
    pumPri(final nPum=2),
    redeclare
      Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumps.Centralized
      pumSec(final nPum=2),
    redeclare
      Buildings.Templates.ChilledWaterPlant.Components.Economizer.WatersideEconomizer
      retSec,
    final have_chiByp=false);

  annotation (
    defaultComponentName="chw");
end RP1711_6_8;
