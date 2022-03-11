within Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans;
model CoilWaterBasedCooling
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(redeclare replaceable
                  Buildings.Templates.Components.Coils.WaterBasedCooling coiCoo(
        redeclare final package MediumChiWat = MediumChiWat) "Chilled water coil",
    nZon=2);

  annotation (
    defaultComponentName="ahu");
end CoilWaterBasedCooling;
