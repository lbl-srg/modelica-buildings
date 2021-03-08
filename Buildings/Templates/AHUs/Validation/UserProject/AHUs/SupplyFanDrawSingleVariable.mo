within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model SupplyFanDrawSingleVariable
  extends VAVSingleDuct(
    final id="VAV_1",
    final have_draThr=true,
    redeclare replaceable Fans.SingleVariable fanSupDra);

  annotation (
    defaultComponentName="ahu");
end SupplyFanDrawSingleVariable;
