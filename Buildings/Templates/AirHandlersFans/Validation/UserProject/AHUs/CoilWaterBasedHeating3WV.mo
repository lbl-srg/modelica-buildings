within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model CoilWaterBasedHeating3WV
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    redeclare replaceable
      Buildings.Templates.Components.Coils.WaterBasedHeating coiHeaReh(
        redeclare Buildings.Templates.Components.Valves.ThreeWayModulating val),
    nZon=2,
    nGro=1);
  annotation (
    defaultComponentName="ahu");
end CoilWaterBasedHeating3WV;
