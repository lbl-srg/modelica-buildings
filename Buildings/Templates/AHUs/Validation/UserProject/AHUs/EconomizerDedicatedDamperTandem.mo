within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model EconomizerDedicatedDamperTandem
  extends VAVSingleDuct(final id="VAV_1", redeclare
      BaseClasses.Economizers.DedicatedDamperTandem eco
      "Separate dedicated OA damper - Dampers actuated in tandem");

  annotation (
    defaultComponentName="ahu");
end EconomizerDedicatedDamperTandem;
