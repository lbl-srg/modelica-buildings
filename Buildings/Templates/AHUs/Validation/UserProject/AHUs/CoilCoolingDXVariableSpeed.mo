within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model CoilCoolingDXVariableSpeed
  extends VAVMultiZone(
    final id="VAV_1",
    nZon=1,
    nGro=1,
    redeclare Buildings.Templates.Components.Coils.DirectExpansion coiCoo(
        redeclare replaceable
        Buildings.Templates.Components.Coils.HeatExchangers.DXVariableSpeed hex));

  annotation (
    defaultComponentName="ahu");
end CoilCoolingDXVariableSpeed;
