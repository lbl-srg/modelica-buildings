within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model RP1711_6_9
  extends Buildings.Templates.ChilledWaterPlant.AirCooledChilledWaterPlant(
    redeclare Templates.BaseClasses.ChillerGroup.ChillerParallel chi,
    final has_byp=false,
    final id="CHW_1");

  annotation (
    defaultComponentName="ahu");
end RP1711_6_9;
