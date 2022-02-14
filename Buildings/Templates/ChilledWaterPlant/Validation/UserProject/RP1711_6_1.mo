within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model RP1711_6_1
  "Parallel Chillers, Variable Primary CHW, Constant CW, Headered Pumps"
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
    pumPri(final nPum=2, final have_floSen=true),
    pumCon(final nPum=2),
    final have_byp=true,
    final id="CHW_1");

  annotation (
    defaultComponentName="chw");
end RP1711_6_1;
