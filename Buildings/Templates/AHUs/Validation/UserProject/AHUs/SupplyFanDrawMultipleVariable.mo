within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model SupplyFanDrawMultipleVariable
  extends VAVSingleDuct(
    final id="VAV_1",
    final have_draThr=true,
    redeclare replaceable Fans.MultipleVariable fanSupDra(nFan=2));

  annotation (
    defaultComponentName="ahu");
end SupplyFanDrawMultipleVariable;
