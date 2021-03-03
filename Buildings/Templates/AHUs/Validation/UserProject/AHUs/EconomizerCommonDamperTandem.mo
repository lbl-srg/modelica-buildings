within Buildings.Experimental.Templates.AHUs.Validation.UserProject.AHUs;
model EconomizerCommonDamperTandem
  extends VAVSingleDuct(
    redeclare replaceable record RecordEco =
        Economizers.Data.CommonDamperTandem,
    redeclare Economizers.CommonDamperTandem eco
      "Single common OA damper - Dampers actuated in tandem");

  annotation (
    defaultComponentName="ahu");
end EconomizerCommonDamperTandem;
