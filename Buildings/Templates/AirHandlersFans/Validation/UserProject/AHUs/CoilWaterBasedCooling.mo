within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model CoilWaterBasedCooling
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    redeclare replaceable Buildings.Templates.Components.Coils.WaterBasedCooling coiCoo
    "Chilled water coil",
    nZon=2,
    nGro=1);

  annotation (
    defaultComponentName="ahu");
end CoilWaterBasedCooling;
