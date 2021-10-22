within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model CoilCoolingDXMultiStage
  extends VAVMultiZone(
    final id="VAV_1",
    nZon=1,
    nGro=1,
    redeclare Buildings.Templates.Components.Coils.DirectExpansion coiCoo(
        redeclare replaceable
        Buildings.Templates.Components.HeatExchangers.DXMultiStage hex));

  annotation (
    defaultComponentName="ahu");
end CoilCoolingDXMultiStage;
