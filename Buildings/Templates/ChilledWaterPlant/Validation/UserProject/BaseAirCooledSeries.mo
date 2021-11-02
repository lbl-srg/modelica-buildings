within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model BaseAirCooledSeries
  extends Buildings.Templates.ChilledWaterPlant.AirCooledParallel(
    final id="CHW_1");

  annotation (
    defaultComponentName="ahu");
end BaseAirCooledSeries;
