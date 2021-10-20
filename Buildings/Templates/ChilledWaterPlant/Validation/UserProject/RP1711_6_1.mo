within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model RP1711_6_1
  extends Buildings.Templates.ChilledWaterPlant.WaterCooledChilledWaterPlant(
    redeclare Templates.BaseClasses.ChillerGroup.ChillerParallel chi,
    redeclare Templates.BaseClasses.Pump.MultipleVariable priPum,
    redeclare Templates.BaseClasses.Pump.None secPum,
    redeclare Templates.BaseClasses.Valve.Linear comLeg,
    final has_comLeg=true,
    final id="CHW_1");

  annotation (
    defaultComponentName="ahu");
end RP1711_6_1;
