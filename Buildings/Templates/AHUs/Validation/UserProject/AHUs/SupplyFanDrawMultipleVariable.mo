within Buildings.Experimental.Templates.AHUs.Validation.UserProject.AHUs;
model SupplyFanDrawMultipleVariable
  extends VAVSingleDuct(
    redeclare replaceable record RecordFanSup = Fans.Data.MultipleVariable,
    have_draThr=true,
    redeclare Fans.MultipleVariable fanSupDra);

  annotation (
    defaultComponentName="ahu");
end SupplyFanDrawMultipleVariable;
