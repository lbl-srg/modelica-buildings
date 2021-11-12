within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model CoilCoolingDXVariableSpeed
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    id="VAV_1",
    nZon=2,
    nGro=1,
    redeclare Buildings.Templates.Components.Coils.DirectExpansion coiCoo(
        redeclare replaceable
        Buildings.Templates.Components.HeatExchangers.DXVariableSpeed hex));

  annotation (
    defaultComponentName="ahu");
end CoilCoolingDXVariableSpeed;
