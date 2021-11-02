within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model BaseAirCooledParallel
  extends Buildings.Templates.ChilledWaterPlant.AirCooledParallel(
    final id="CHW_1");

  annotation (
    defaultComponentName="ahu");
end BaseAirCooledParallel;
