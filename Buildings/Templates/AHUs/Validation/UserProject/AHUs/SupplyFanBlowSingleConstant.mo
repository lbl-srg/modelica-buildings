within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model SupplyFanBlowSingleConstant
  extends VAVSingleDuct(
    final id="VAV_1",
    final have_draThr=false,
    redeclare replaceable BaseClasses.Fans.SingleConstant fanSupBlo);

  annotation (
    defaultComponentName="ahu");
end SupplyFanBlowSingleConstant;
