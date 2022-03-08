within Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans;
model FanSupplyBlowSingleConstant
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    redeclare replaceable Buildings.Templates.Components.Fans.None fanSupDra,
    nZon=2,
        redeclare replaceable Buildings.Templates.Components.Fans.SingleConstant
      fanSupBlo);

  annotation (
    defaultComponentName="ahu");
end FanSupplyBlowSingleConstant;
