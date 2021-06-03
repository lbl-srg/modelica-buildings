within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model FanSupplyDrawSingleVariable
  extends VAVMultiZone(
    nZon=1,
    nGro=1,
    final id="VAV_1",
    redeclare replaceable Buildings.Templates.BaseClasses.Fans.SingleVariable
      fanSupDra);

  annotation (
    defaultComponentName="ahu");
end FanSupplyDrawSingleVariable;
