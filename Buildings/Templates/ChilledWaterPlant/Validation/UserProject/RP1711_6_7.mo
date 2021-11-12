within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model RP1711_6_7
  extends Buildings.Templates.ChilledWaterPlant.WaterCooledParallel(
    final nChi=2,
    final nCooTow=2,
    final nPumCon=2,
    final nPumPri=2,
    final has_byp=false,
    final id="CHW_1");

  annotation (
    defaultComponentName="ahu");
end RP1711_6_7;
