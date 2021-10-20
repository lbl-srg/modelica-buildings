within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model RP1711_6_4
  extends Buildings.Templates.ChilledWaterPlant.WaterCooledChilledWaterPlant(
    redeclare Templates.BaseClasses.ChillerGroup.ChillerSeries chi,
    redeclare Templates.BaseClasses.Pump.MultipleVariable priPum,
    redeclare Templates.BaseClasses.Pump.None secPum,
    final has_comLeg=false,
    final id="CHW_1");

  annotation (
    defaultComponentName="ahu");
end RP1711_6_4;
