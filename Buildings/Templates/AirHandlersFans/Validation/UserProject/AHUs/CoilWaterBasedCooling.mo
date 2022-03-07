within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model CoilWaterBasedCooling
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(redeclare replaceable
                  Buildings.Templates.Components.Coils.WaterBasedCooling coiCoo(
        redeclare final package MediumCoo = MediumCoo) "Chilled water coil",
    nZon=2);

  annotation (
    defaultComponentName="ahu");
end CoilWaterBasedCooling;
