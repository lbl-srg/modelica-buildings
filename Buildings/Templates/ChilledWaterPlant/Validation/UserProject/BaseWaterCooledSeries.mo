within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model BaseWaterCooledSeries
  extends Buildings.Templates.ChilledWaterPlant.WaterCooledParallel(
    final id="CHW_1");

  annotation (
    defaultComponentName="ahu");
end BaseWaterCooledSeries;
