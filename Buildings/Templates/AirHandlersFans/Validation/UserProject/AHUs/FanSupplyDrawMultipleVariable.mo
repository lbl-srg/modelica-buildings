within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model FanSupplyDrawMultipleVariable
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    nZon=2,
    nGro=1,
    id="VAV_1",
    redeclare replaceable Buildings.Templates.Components.Fans.ArrayVariable
      fanSupDra(nFan=2));

  annotation (
    defaultComponentName="ahu");
end FanSupplyDrawMultipleVariable;
