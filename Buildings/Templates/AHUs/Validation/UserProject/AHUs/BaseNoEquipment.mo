within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model BaseNoEquipment
  extends VAVSingleDuctWithEconomizer(
    final id="VAV_1",
    nZon=1,
    nGro=1);

  annotation (
    defaultComponentName="ahu");
end BaseNoEquipment;
