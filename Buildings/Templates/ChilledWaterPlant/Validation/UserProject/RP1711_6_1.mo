within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model RP1711_6_1
  extends Buildings.Templates.ChilledWaterPlant.WaterCooledParallel(
    final nChi=2,
    final nCooTow=2,
    final nPumCon=2,
    final nPumPri=2,
    has_WSEByp=false,
    final has_byp=true,
    final id="CHW_1");

  annotation (
    defaultComponentName="ahu");
end RP1711_6_1;
