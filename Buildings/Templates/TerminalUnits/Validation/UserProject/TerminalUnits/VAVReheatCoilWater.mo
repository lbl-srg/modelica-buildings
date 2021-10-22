within Buildings.Templates.TerminalUnits.Validation.UserProject.TerminalUnits;
model VAVReheatCoilWater
  extends Buildings.Templates.TerminalUnits.VAVBox(redeclare
      Components.Coils.WaterBasedHeating coiReh(redeclare
        Buildings.Templates.Components.Actuators.TwoWayValve act, redeclare
        Components.HeatExchangers.DryCoilEffectivenessNTU hex
        "Epsilon-NTU heat exchanger model") "Water-based", id="Box_1");
  annotation (
    defaultComponentName="ter",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end VAVReheatCoilWater;
