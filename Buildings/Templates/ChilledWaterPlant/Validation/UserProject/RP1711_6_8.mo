within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model RP1711_6_8
  extends Buildings.Templates.ChilledWaterPlant.WaterCooledParallel(
    chiGro(final nChi=2,
    redeclare Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YT_1055kW_5_96COP_Vanes per),
    cooTow(final nCooTow=2),
    pumCon(final nPum=2),
    pumPri(final nPum=2),
    redeclare Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumpGroup.Centralized pumSec(final nPum=2),
    redeclare Buildings.Templates.ChilledWaterPlant.Components.ReturnSection.WatersideEconomizer WSE,
    final has_WSEByp=false,
    final has_byp=false,
    final id="CHW_1");

  annotation (
    defaultComponentName="ahu");
end RP1711_6_8;
