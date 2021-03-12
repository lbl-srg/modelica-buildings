within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model FanSupplyBlowSingleConstant
  extends VAVSingleDuct(
    final id="VAV_1",
    redeclare replaceable BaseClasses.Fans.SingleConstant fanSupBlo);

  annotation (
    defaultComponentName="ahu");
end FanSupplyBlowSingleConstant;
