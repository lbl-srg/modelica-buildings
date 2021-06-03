within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model BaseNoEquipment
  extends VAVMultiZone(
    final id="VAV_1",
    nZon=1,
    nGro=1);

  annotation (
    defaultComponentName="ahu");
end BaseNoEquipment;
