within Buildings.Experimental.Templates.AHUs.Validation.UserProject.AHUs;
model EconomizerCommonDamperFree
  extends VAVSingleDuct(
    redeclare replaceable record RecordEco =
        Economizers.Data.CommonDamperFree,
    redeclare
      Economizers.CommonDamperFree eco
      "Single common OA damper - Dampers actuated individually");


  annotation (
    defaultComponentName="ahu");
end EconomizerCommonDamperFree;
