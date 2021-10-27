within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model RP1711_6_5
  extends Buildings.Templates.ChilledWaterPlant.WaterCooledChilledWaterPlant(
    redeclare Templates.BaseClasses.ChillerGroup.ChillerSeries chi,
    final has_byp=true,
    final id="CHW_1");

  annotation (
    defaultComponentName="ahu");
end RP1711_6_5;
