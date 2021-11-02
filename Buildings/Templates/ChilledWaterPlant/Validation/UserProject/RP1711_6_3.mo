within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model RP1711_6_3
  extends Buildings.Templates.ChilledWaterPlant.WaterCooledSeries(
    redeclare Components.ChillerGroup.ChillerSeries chi,
    final has_byp=true,
    final id="CHW_1");

  annotation (
    defaultComponentName="ahu");
end RP1711_6_3;
