within Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans;
model DedicatedDampersPressure
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    secOutRel(redeclare replaceable
        Buildings.Templates.AirHandlersFans.Components.OutdoorSection.DedicatedDampersPressure
        secOut
        "Dedicated minimum OA damper (two-position) with differential pressure sensor"),
    nZon=2);

  annotation (
    defaultComponentName="ahu");
end DedicatedDampersPressure;
