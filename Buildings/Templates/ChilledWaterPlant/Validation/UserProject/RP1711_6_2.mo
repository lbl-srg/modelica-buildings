within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model RP1711_6_2
  extends Buildings.Templates.ChilledWaterPlant.WaterCooledParallel(
    redeclare Components.ChillerGroup.ChillerParallel chi,
    final has_byp=true,
    final id="CHW_1");

  annotation (
    defaultComponentName="ahu");
end RP1711_6_2;
