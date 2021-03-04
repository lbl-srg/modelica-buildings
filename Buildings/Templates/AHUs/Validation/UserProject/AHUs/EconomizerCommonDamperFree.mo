within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model EconomizerCommonDamperFree
  extends VAVSingleDuct(
    final id="VAV_1",
    redeclare replaceable record RecordEco =
        Economizers.Data.CommonDamperFree,
    redeclare
      Economizers.CommonDamperFree eco
      "Single common OA damper - Dampers actuated individually");


  annotation (
    defaultComponentName="ahu");
end EconomizerCommonDamperFree;
