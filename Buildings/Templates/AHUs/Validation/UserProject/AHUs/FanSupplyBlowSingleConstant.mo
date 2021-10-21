within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model FanSupplyBlowSingleConstant
  extends VAVMultiZone(
    nZon=1,
    nGro=1,
    final id="VAV_1",
    redeclare replaceable Buildings.Templates.Components.Fans.SingleConstant
      fanSupBlo);

  annotation (
    defaultComponentName="ahu");
end FanSupplyBlowSingleConstant;
