within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model SectionDedicatedPressure
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    redeclare
      .Buildings.Templates.AirHandlersFans.Components.OutdoorSection.DedicatedPressure
      secOut,
    final id="VAV_1",
    nZon=1,
    nGro=1);

end SectionDedicatedPressure;
