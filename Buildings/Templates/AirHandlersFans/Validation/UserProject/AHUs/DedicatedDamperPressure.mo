within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model DedicatedDamperPressure
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    secOutRel(redeclare replaceable
        Buildings.Templates.AirHandlersFans.Components.OutdoorSection.DedicatedDampersPressure
        secOut
        "Dedicated minimum OA damper (two-position) with differential pressure sensor"),
    tag="VAV_1",
    nZon=2,
    nGro=1);

  annotation (
    defaultComponentName="ahu");
end DedicatedDamperPressure;
