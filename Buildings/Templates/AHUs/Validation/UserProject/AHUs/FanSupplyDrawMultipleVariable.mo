within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model FanSupplyDrawMultipleVariable
  extends VAVSingleDuct(
    final id="VAV_1",
    redeclare replaceable BaseClasses.Fans.MultipleVariable fanSupDra(nFan=2));

  annotation (
    defaultComponentName="ahu");
end FanSupplyDrawMultipleVariable;
