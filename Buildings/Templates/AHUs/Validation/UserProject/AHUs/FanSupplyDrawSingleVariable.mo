within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model FanSupplyDrawSingleVariable
  extends VAVSingleDuct(
    final id="VAV_1",
    redeclare replaceable BaseClasses.Fans.SingleVariable fanSupDra);

  annotation (
    defaultComponentName="ahu");
end FanSupplyDrawSingleVariable;
