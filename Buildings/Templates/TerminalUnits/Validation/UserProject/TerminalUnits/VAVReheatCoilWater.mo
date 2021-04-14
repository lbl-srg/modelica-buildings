within Buildings.Templates.TerminalUnits.Validation.UserProject.TerminalUnits;
model VAVReheatCoilWater
  extends Buildings.Templates.TerminalUnits.VAVBox(redeclare
      Templates.BaseClasses.Coils.WaterBasedHeating coiReh(redeclare
        Buildings.Templates.BaseClasses.Coils.Actuators.TwoWayValve act,
        redeclare
        Templates.BaseClasses.Coils.HeatExchangers.DryCoilEffectivenessNTU hex
        "Epsilon-NTU heat exchanger model") "Water-based",
    id="Box_1");
  annotation (
    defaultComponentName="ter",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end VAVReheatCoilWater;
