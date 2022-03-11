within Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans;
model CoilWaterBasedHeating3WV
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    redeclare replaceable
      Buildings.Templates.Components.Coils.WaterBasedHeating coiHeaReh(
        redeclare final package MediumHeaWat = MediumHeaWat,
        redeclare Buildings.Templates.Components.Valves.ThreeWayModulating val),
    nZon=2);
  annotation (
    defaultComponentName="ahu");
end CoilWaterBasedHeating3WV;
