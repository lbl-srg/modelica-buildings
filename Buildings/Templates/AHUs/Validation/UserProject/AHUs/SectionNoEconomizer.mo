within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model SectionNoEconomizer
  extends Buildings.Templates.AHUs.VAVSingleDuctWithEconomizer(
    secRel(typCtrFan=Buildings.Templates.Types.ReturnFanControl.None),
    final id="VAV_1",
    nZon=1,
    nGro=1);

end SectionNoEconomizer;
