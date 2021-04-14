within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model SectionDedicatedPressure
  extends Buildings.Templates.AHUs.VAVSingleDuctWithEconomizer(
    secRel(typCtrFan=Buildings.Templates.Types.ReturnFanControl.None),
    redeclare BaseClasses.OutdoorAirSection.DedicatedPressure secOut,
    final id="VAV_1",
    nZon=1,
    nGro=1);

end SectionDedicatedPressure;
