within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model RP1711_6_8
  "Parallel Chillers with WSE, Primary-Secondary CHW, Variable CW, Headered Pumps"
  //ToDo
  extends Buildings.Templates.ChilledWaterPlant.WaterCooled(
    redeclare Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.ChillerParallel chiGro(
      final nChi=2,
      redeclare Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YT_1055kW_5_96COP_Vanes per),
    cooTow(final nCooTow=2),
    pumCon(final nPum=2),
    pumPri(final nPum=2),
    redeclare
      Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumpGroup.Centralized
      pumSec(final nPum=2),
    redeclare
      Buildings.Templates.ChilledWaterPlant.Components.ReturnSection.WatersideEconomizer
      retSec,
    final have_ChiByp=false,
    final have_byp=false,
    final id="CHW_1");

  annotation (
    defaultComponentName="chw");
end RP1711_6_8;
