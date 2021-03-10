within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model EconomizerCommonDamperFree
  extends VAVSingleDuct(final id="VAV_1", redeclare
      BaseClasses.Economizers.CommonDamperFree eco
      "Single common OA damper - Dampers actuated individually");


  annotation (
    defaultComponentName="ahu");
end EconomizerCommonDamperFree;
