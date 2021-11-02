within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model BaseWaterCooledParallel
  extends Buildings.Templates.ChilledWaterPlant.WaterCooledParallel(
    final id="CHW_1");

  annotation (
    defaultComponentName="ahu");
end BaseWaterCooledParallel;
