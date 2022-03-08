within Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans;
model CoilWaterBasedHeating
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(redeclare replaceable
                  Buildings.Templates.Components.Coils.WaterBasedHeating
      coiHeaPre(redeclare final package MediumHea = MediumHea) "Hot water coil",
    nZon=2);
  annotation (
    defaultComponentName="ahu");
end CoilWaterBasedHeating;
