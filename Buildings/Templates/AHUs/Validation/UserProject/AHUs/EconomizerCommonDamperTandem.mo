within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model EconomizerCommonDamperTandem
  extends VAVSingleDuct(final id="VAV_1", redeclare
      BaseClasses.Economizers.CommonDamperTandem eco
      "Single common OA damper - Dampers actuated in tandem");

  annotation (
    defaultComponentName="ahu");
end EconomizerCommonDamperTandem;
