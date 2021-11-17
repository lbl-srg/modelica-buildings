within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model DedicatedDamperAirflow
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    secOutRel(redeclare
        .Buildings.Templates.AirHandlersFans.Components.OutdoorSection.DedicatedDamperAirflow
        secOut
        "Dedicated minimum OA damper (two-position) with AFMS"),
    id="VAV_1",
    nZon=2,
    nGro=1);

  annotation (
    defaultComponentName="ahu");
end DedicatedDamperAirflow;
