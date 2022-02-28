within Buildings.Templates.ZoneEquipment.Validation.UserProject.TerminalUnits;
model VAVBoxReheatHotWaterG36
  extends Buildings.Templates.ZoneEquipment.VAVBoxReheat(
    redeclare replaceable
      Buildings.Templates.Components.Coils.WaterBasedHeating coiHea(redeclare replaceable
                    Buildings.Templates.Components.Valves.TwoWayModulating val),
    redeclare replaceable
      Buildings.Templates.ZoneEquipment.Components.Controls.G36VAVBoxReheat ctl);

  annotation (
    defaultComponentName="ter",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end VAVBoxReheatHotWaterG36;
