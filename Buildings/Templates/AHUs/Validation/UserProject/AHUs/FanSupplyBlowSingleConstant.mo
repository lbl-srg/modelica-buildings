within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model FanSupplyBlowSingleConstant
  extends VAVSingleDuct(
    nZon=1,
    final id="VAV_1",
    redeclare replaceable Buildings.Templates.BaseClasses.Fans.SingleConstant
      fanSupBlo);

  annotation (
    defaultComponentName="ahu");
end FanSupplyBlowSingleConstant;
