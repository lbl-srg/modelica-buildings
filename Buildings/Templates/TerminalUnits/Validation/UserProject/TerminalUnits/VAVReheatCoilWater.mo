within Buildings.Templates.TerminalUnits.Validation.UserProject.TerminalUnits;
model VAVReheatCoilWater
  extends Buildings.Templates.TerminalUnits.VAVReheat(
    redeclare BaseClasses.Dampers.PressureIndependent damVAV
      "Pressure independent damper",
    redeclare BaseClasses.Coils.WaterBased coiReh(redeclare
        Buildings.Templates.BaseClasses.Coils.Valves.TwoWayValve act,
        redeclare
        Buildings.Templates.BaseClasses.Coils.HeatExchangers.DryCoilEffectivenessNTU
        hex),
    id="Box_1");
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end VAVReheatCoilWater;
