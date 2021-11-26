within Buildings.Templates.ZoneEquipment.Validation.UserProject.TerminalUnits;
model VAVReheatCoilWater
  extends Buildings.Templates.ZoneEquipment.VAVBox(redeclare
      .Buildings.Templates.Components.Coils.WaterBasedHeating coiReh(redeclare
        Buildings.Templates.Components.Valves.TwoWayValve act,    redeclare
        .Buildings.Templates.Components.HeatExchangers.DryCoilEffectivenessNTU
        hex "Epsilon-NTU heat exchanger model") "Water-based", id="Box_1");
  annotation (
    defaultComponentName="ter",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end VAVReheatCoilWater;
