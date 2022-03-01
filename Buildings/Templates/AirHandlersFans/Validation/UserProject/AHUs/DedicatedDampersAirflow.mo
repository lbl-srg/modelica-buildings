within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model DedicatedDampersAirflow
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    secOutRel(redeclare replaceable
        Buildings.Templates.AirHandlersFans.Components.OutdoorSection.DedicatedDampersAirflow
        secOut "Dedicated minimum OA damper (two-position) with AFMS"),
    nZon=2);

  annotation (
    defaultComponentName="ahu");
end DedicatedDampersAirflow;
