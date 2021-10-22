within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model EconomizerDedicatedOAPressure
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    secOutRel(redeclare
        .Buildings.Templates.AirHandlersFans.Components.OutdoorSection.DedicatedPressure
        secOut
        "Dedicated minimum OA damper (two-position) with differential pressure sensor"),

    final id="VAV_1",
    nZon=1,
    nGro=1);

  annotation (
    defaultComponentName="ahu");
end EconomizerDedicatedOAPressure;
