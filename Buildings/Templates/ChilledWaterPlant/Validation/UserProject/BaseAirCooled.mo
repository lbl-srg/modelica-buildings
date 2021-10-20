within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model BaseAirCooled
  extends Buildings.Templates.ChilledWaterPlant.AirCooledChilledWaterPlant(
    final id="CHW_1");

  annotation (
    defaultComponentName="ahu");
end BaseAirCooled;
