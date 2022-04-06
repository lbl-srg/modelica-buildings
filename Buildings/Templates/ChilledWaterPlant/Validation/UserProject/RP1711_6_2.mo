within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model RP1711_6_2
  "Parallel Chillers, Variable Primary Chilled Water, Constant Condenser Water, Dedicated Pumps"
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
    redeclare
      Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumps.Dedicated
      pumPri(final have_floSen=true),
    redeclare
      Buildings.Templates.ChilledWaterPlant.Components.CondenserPumps.Dedicated
      pumCon);

  annotation (
    defaultComponentName="chw");
end RP1711_6_2;
