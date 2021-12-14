within Buildings.Templates.ZoneEquipment.Validation.UserProject.TerminalUnits;
model BaseNoEquipment
  extends Buildings.Templates.ZoneEquipment.VAVBox(tag="Box_1");
  annotation (
    defaultComponentName="ter",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BaseNoEquipment;
