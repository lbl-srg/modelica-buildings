within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model RP1711_6_5
  extends Buildings.Templates.ChilledWaterPlant.WaterCooledChilledWaterPlant(
    redeclare Templates.BaseClasses.ChillerGroup.ChillerSeries chi,
    redeclare Templates.BaseClasses.Pump.MultipleVariable priPum,
    redeclare Templates.BaseClasses.Pump.None secPum,
    redeclare Templates.BaseClasses.Valve.Linear comLeg,
    final has_comLeg=true,
    final id="CHW_1");

  annotation (
    defaultComponentName="ahu");
end RP1711_6_5;
