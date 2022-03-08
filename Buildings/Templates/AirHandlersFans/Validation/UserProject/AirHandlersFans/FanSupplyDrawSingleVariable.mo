within Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans;
model FanSupplyDrawSingleVariable
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    nZon=2,
        redeclare replaceable Buildings.Templates.Components.Fans.SingleVariable
      fanSupDra);

  annotation (
    defaultComponentName="ahu");
end FanSupplyDrawSingleVariable;
