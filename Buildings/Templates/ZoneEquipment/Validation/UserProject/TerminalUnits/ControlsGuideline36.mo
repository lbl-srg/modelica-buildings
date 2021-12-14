within Buildings.Templates.ZoneEquipment.Validation.UserProject.TerminalUnits;
model ControlsGuideline36
  extends Buildings.Templates.ZoneEquipment.VAVBox(
    redeclare replaceable Buildings.Templates.Components.Coils.WaterBasedHeating coiHea(
        redeclare replaceable
        Buildings.Templates.Components.Valves.TwoWayModulating val),
    redeclare replaceable Buildings.Templates.ZoneEquipment.Components.Controls.Guideline36 ctr,
    tag="Box_1");
  annotation (
    defaultComponentName="ter",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ControlsGuideline36;
