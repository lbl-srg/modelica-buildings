within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model RP1711_6_4
  extends Buildings.Templates.ChilledWaterPlant.WaterCooledParallel(
    redeclare Components.ChillerGroup.ChillerSeries chi,
    final has_byp=false,
    final id="CHW_1");

  annotation (
    defaultComponentName="ahu");
end RP1711_6_4;
