within Buildings.Templates.ZoneEquipment.Validation.UserProject.TerminalUnits;
model VAVBoxReheatHotWater
  extends Buildings.Templates.ZoneEquipment.VAVBoxReheat(
                                                   redeclare replaceable
      Buildings.Templates.Components.Coils.WaterBasedHeating coiHea(
      redeclare replaceable Buildings.Templates.Components.HeatExchangers.DryCoilEffectivenessNTU
      hex "Epsilon-NTU heat exchanger model", redeclare replaceable
        Buildings.Templates.Components.Valves.TwoWayModulating val));
  annotation (
    defaultComponentName="ter",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end VAVBoxReheatHotWater;
