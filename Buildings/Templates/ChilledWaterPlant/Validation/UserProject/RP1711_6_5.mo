within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model RP1711_6_5
  "Series Chillers with WSE, Variable Primary CHW, Variable CW, Headered Pumps"
  //ToDo
  extends Buildings.Templates.ChilledWaterPlant.WaterCooled(
    final nCooTow=2,
    redeclare
      Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerGroup.CoolingTowerParallel
      cooTowGro,
    redeclare
      Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.ChillerSeries
      chiGro(final nChi=2, redeclare
        Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YT_1055kW_5_96COP_Vanes
        per),
    pumCon(final nPum=2),
    pumPri(final nPum=2),
    redeclare
      Buildings.Templates.ChilledWaterPlant.Components.ReturnSection.WatersideEconomizer
      retSec,
    final have_ChiByp=false,
    final have_byp=true,
    final id="CHW_1");

  annotation (
    defaultComponentName="chw");
end RP1711_6_5;
