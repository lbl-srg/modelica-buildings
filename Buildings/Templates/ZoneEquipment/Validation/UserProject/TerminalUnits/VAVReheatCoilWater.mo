within Buildings.Templates.ZoneEquipment.Validation.UserProject.TerminalUnits;
model VAVReheatCoilWater
  extends Buildings.Templates.ZoneEquipment.VAVBox(redeclare replaceable
      Buildings.Templates.Components.Coils.WaterBasedHeating coiHea(
      redeclare replaceable Buildings.Templates.Components.HeatExchangers.DryCoilEffectivenessNTU
      hex "Epsilon-NTU heat exchanger model",
      redeclare replaceable Buildings.Templates.Components.Valves.TwoWay val),
                      tag="Box_1");
  annotation (
    defaultComponentName="ter",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end VAVReheatCoilWater;
