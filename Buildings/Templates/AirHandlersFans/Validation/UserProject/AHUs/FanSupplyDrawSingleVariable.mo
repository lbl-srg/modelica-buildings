within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model FanSupplyDrawSingleVariable
  extends NoFanNoReliefSingleDamper(
    nZon=1,
    nGro=1,
    id="VAV_1",
    redeclare replaceable Buildings.Templates.Components.Fans.SingleVariable
      fanSupDra);

  annotation (
    defaultComponentName="ahu");
end FanSupplyDrawSingleVariable;
