within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model RP1711_6_2
  "Parallel Chillers, Variable Primary CHW, Constant CW, Dedicated Pumps"
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
      Buildings.Templates.ChilledWaterPlant.Components.CondenserWaterPumpGroup.Dedicated
      pumCon,
    final have_byp=true);

  annotation (
    defaultComponentName="chw");
end RP1711_6_2;
