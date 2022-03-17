within Buildings.Templates.ZoneEquipment.Validation.UserProject.ZoneEquipment;
model VAVBoxReheatControlG36  "Configuration of VAV terminal unit with reheat"
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
end VAVBoxReheatControlG36;
