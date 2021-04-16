within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model EconomizerDedicatedOAPressure
  extends Buildings.Templates.AHUs.VAVSingleDuct(
    secOutRel(redeclare BaseClasses.OutdoorSection.DedicatedPressure secOut
        "Dedicated minimum OA damper (two-position) with differential pressure sensor"),
    final id="VAV_1",
    nZon=1,
    nGro=1);

  annotation (
    defaultComponentName="ahu");
end EconomizerDedicatedOAPressure;
