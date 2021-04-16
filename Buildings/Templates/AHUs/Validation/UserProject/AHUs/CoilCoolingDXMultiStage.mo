within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model CoilCoolingDXMultiStage
  extends VAVSingleDuct(
    final id="VAV_1",
    nZon=1,
    nGro=1,
    redeclare
      Buildings.Templates.BaseClasses.Coils.DirectExpansion coiCoo(redeclare replaceable
        Buildings.Templates.BaseClasses.Coils.HeatExchangers.DXMultiStage hex));

  annotation (
    defaultComponentName="ahu");
end CoilCoolingDXMultiStage;
