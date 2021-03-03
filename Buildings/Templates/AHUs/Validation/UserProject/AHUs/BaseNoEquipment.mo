within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model BaseNoEquipment
  extends VAVSingleDuct(
    final id="VAV_1");

  annotation (
    defaultComponentName="ahu");
end BaseNoEquipment;
