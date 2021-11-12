within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model FanSupplyDrawMultipleVariable
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    nZon=1,
    nGro=1,
    id="VAV_1",
    redeclare replaceable Buildings.Templates.Components.Fans.MultipleVariable
      fanSupDra(nFan=2));

  annotation (
    defaultComponentName="ahu");
end FanSupplyDrawMultipleVariable;
