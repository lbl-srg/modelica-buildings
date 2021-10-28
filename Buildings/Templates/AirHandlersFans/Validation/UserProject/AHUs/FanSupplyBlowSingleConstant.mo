within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model FanSupplyBlowSingleConstant
  extends NoFanNoReliefSingleDamper(
    nZon=1,
    nGro=1,
    final id="VAV_1",
    redeclare replaceable Buildings.Templates.Components.Fans.SingleConstant
      fanSupBlo);

  annotation (
    defaultComponentName="ahu");
end FanSupplyBlowSingleConstant;
