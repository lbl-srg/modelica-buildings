within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model CoilWaterBasedHeating2WV
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    redeclare replaceable
      Buildings.Templates.Components.Coils.WaterBasedHeating coiHeaPre(
        redeclare replaceable
        Buildings.Templates.Components.Valves.TwoWayModulating val),
    nZon=2);
  annotation (
    defaultComponentName="ahu");
end CoilWaterBasedHeating2WV;
