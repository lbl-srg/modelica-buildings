within Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans;
model CoilEvaporatorVariableSpeed
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    nZon=2,
    redeclare replaceable
      Buildings.Templates.Components.Coils.EvaporatorVariableSpeed coiCoo);

  annotation (
    defaultComponentName="ahu");
end CoilEvaporatorVariableSpeed;
