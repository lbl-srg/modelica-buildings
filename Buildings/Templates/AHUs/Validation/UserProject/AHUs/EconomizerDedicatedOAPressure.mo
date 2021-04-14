within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model EconomizerDedicatedOAPressure
  extends Buildings.Templates.AHUs.VAVSingleDuctWithEconomizer(
    redeclare BaseClasses.OutdoorAirSection.DedicatedPressure secOut
      "Outdoor air section - Dedicated minimum OA damper (two-position) with differential pressure sensor",
    final id="VAV_1",
    nZon=1,
    nGro=1);

  annotation (
    defaultComponentName="ahu");
end EconomizerDedicatedOAPressure;
