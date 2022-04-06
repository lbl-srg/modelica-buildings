within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model RP1711_6_9
  "Parallel Chillers, Primary-Distributed Secondary, Air-Cooled"
  //ToDo
  extends Buildings.Templates.ChilledWaterPlant.AirCooled(
    redeclare
      Buildings.Templates.ChilledWaterPlant.Components.ChillerSection.Parallel
      chiSec(final nChi=2, redeclare
        Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YT_1055kW_5_96COP_Vanes
        per),
    cooTowSec(final nCooTow=2),
    pumCon(final nPum=2),
    pumPri(final nPum=2));

  annotation (
    defaultComponentName="chw");
end RP1711_6_9;
