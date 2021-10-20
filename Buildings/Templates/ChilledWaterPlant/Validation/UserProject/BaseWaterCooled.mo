within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model BaseWaterCooled
  extends Buildings.Templates.ChilledWaterPlant.WaterCooledChilledWaterPlant(
    final id="CHW_1");

  annotation (
    defaultComponentName="ahu");
end BaseWaterCooled;
