within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model CoilEvaporatorVariableSpeed
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    nZon=2,
    redeclare replaceable
      Buildings.Templates.Components.Coils.EvaporatorVariableSpeed coiCoo);

  annotation (
    defaultComponentName="ahu");
end CoilEvaporatorVariableSpeed;
