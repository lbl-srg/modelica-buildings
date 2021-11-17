within Buildings.Templates.ZoneEquipment.Validation.UserProject.TerminalUnits;
model ControlsGuideline36
  extends Buildings.Templates.ZoneEquipment.VAVBox(
    redeclare Components.Controls.Guideline36 con,
    redeclare .Buildings.Templates.Components.Coils.WaterBasedHeating coiReh(
        redeclare Buildings.Templates.Components.Actuators.TwoWayValve act)
      "Water-based",
    id="Box_1");
  annotation (
    defaultComponentName="ter",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ControlsGuideline36;
