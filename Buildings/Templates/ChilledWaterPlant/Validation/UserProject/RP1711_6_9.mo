within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model RP1711_6_9
  "Parallel Chillers, Primary-Distributed Secondary, Air-Cooled"
  //ToDo
  extends Buildings.Templates.ChilledWaterPlant.AirCooled(
    redeclare Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.ChillerParallel chiGro(
      final nChi=2,
      redeclare Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YT_1055kW_5_96COP_Vanes per),
    cooTowGro(final nCooTow=2),
    pumCon(final nPum=2),
    pumPri(final nPum=2),
    final have_byp=false);

  annotation (
    defaultComponentName="chw");
end RP1711_6_9;
