within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model FanSupplyDrawMultipleVariable
  extends NoFanNoReliefSingleDamper(
    nZon=1,
    nGro=1,
    final id="VAV_1",
    redeclare replaceable Buildings.Templates.Components.Fans.MultipleVariable
      fanSupDra(nFan=2));

  annotation (
    defaultComponentName="ahu");
end FanSupplyDrawMultipleVariable;
