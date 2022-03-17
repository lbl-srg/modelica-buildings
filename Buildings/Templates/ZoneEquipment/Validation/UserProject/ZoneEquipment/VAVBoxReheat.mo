within Buildings.Templates.ZoneEquipment.Validation.UserProject.ZoneEquipment;
model VAVBoxReheat "Configuration of VAV terminal unit with reheat"
  extends Buildings.Templates.ZoneEquipment.VAVBoxReheat(
                                                   redeclare replaceable
      Buildings.Templates.Components.Coils.WaterBasedHeating coiHea(
      redeclare replaceable
        Buildings.Templates.Components.Valves.TwoWayModulating val));
  annotation (
    defaultComponentName="ter",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end VAVBoxReheat;
