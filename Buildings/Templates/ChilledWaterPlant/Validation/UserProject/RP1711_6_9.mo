within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model RP1711_6_9
  extends Buildings.Templates.ChilledWaterPlant.AirCooledParallel(
    chiGro(final nChi=2),
    cooTow(final nCooTow=2),
    pumCon(final nPum=2),
    pumPri(final nPum=2),
    final has_WSEByp=false,
    final has_byp=false,
    final id="CHW_1");

  annotation (
    defaultComponentName="ahu");
end RP1711_6_9;
