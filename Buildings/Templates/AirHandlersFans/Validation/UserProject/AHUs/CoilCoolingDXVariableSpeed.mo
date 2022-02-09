within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model CoilCoolingDXVariableSpeed
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    nZon=2,
    nGro=1,
    redeclare replaceable Buildings.Templates.Components.Coils.Evaporator
      coiCoo(redeclare replaceable
        Buildings.Templates.Components.HeatExchangers.DXCoilVariableSpeed hex));

  annotation (
    defaultComponentName="ahu");
end CoilCoolingDXVariableSpeed;
