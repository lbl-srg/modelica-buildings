within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model CoilCoolingDXVariableSpeed
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    tag="VAV_1",
    nZon=2,
    nGro=1,
    redeclare replaceable Buildings.Templates.Components.Coils.Evaporator
      coiCoo(redeclare replaceable
        Buildings.Templates.Components.HeatExchangers.DXVariableSpeed hex));

  annotation (
    defaultComponentName="ahu");
end CoilCoolingDXVariableSpeed;
