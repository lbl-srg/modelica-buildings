within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model CoilWaterBasedHeating
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    redeclare replaceable
      Buildings.Templates.Components.Coils.WaterBasedHeating coiHeaPre,
    nZon=2);
  annotation (
    defaultComponentName="ahu");
end CoilWaterBasedHeating;
