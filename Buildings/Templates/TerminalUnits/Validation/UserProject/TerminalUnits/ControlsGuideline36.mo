within Buildings.Templates.TerminalUnits.Validation.UserProject.TerminalUnits;
model ControlsGuideline36
  extends Buildings.Templates.TerminalUnits.VAVBox(
    redeclare Controls.Guideline36 conTer,
    redeclare Components.Coils.WaterBasedHeating coiReh(redeclare
        Buildings.Templates.Components.Actuators.TwoWayValve act)
      "Water-based",
    id="Box_1");
  annotation (
    defaultComponentName="ter",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ControlsGuideline36;
