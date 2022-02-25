within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model CoilEvaporatorMultiStage
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    nZon=2,
    nGro=1,
    redeclare replaceable
      Buildings.Templates.Components.Coils.EvaporatorMultiStage coiCoo);

  annotation (
    defaultComponentName="ahu");
end CoilEvaporatorMultiStage;
