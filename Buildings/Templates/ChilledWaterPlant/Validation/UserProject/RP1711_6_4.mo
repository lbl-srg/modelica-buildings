within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model RP1711_6_4
  extends Buildings.Templates.ChilledWaterPlant.WaterCooledSeries(
    chiGro(
      final nChi=2,
      redeclare Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YT_1055kW_5_96COP_Vanes per),
    pumPri(final nPum=2, final have_floSen=true),
    pumCon(final nPum=2),
    cooTow(final nCooTow=2),
    final have_byp=false,
    final id="CHW_1");

  annotation (
    defaultComponentName="chw");
end RP1711_6_4;
