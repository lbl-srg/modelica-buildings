within Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans;
model CoilWaterBasedHeating2WV
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(redeclare replaceable
                  Buildings.Templates.Components.Coils.WaterBasedHeating
      coiHeaPre(redeclare final package MediumHea = MediumHea, redeclare
        Buildings.Templates.Components.Valves.TwoWayModulating val)
      "Hot water coil",
    nZon=2);
  annotation (
    defaultComponentName="ahu");
end CoilWaterBasedHeating2WV;
