within Buildings.Templates.TerminalUnits.Validation.UserProject.TerminalUnits;
model ControlsGuideline36
  extends Buildings.Templates.TerminalUnits.VAVReheat(
    redeclare BaseClasses.Sensors.Temperature TDis "Temperature sensor",
    redeclare Controls.Guideline36 conTer,
    redeclare BaseClasses.Dampers.PressureIndependent damVAV
      "Pressure independent damper",
    redeclare BaseClasses.Coils.WaterBased coiReh(redeclare
        Buildings.Templates.BaseClasses.Coils.Valves.TwoWayValve act,
        redeclare
        Buildings.Templates.BaseClasses.Coils.HeatExchangers.DryCoilEffectivenessNTU
        hex),
    id="Box_1");
  annotation (
    defaultComponentName="ter",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ControlsGuideline36;
