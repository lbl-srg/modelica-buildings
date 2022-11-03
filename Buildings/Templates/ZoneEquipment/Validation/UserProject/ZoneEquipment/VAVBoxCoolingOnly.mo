within Buildings.Templates.ZoneEquipment.Validation.UserProject.ZoneEquipment;
model VAVBoxCoolingOnly "Configuration of VAV terminal unit cooling only"
  extends Buildings.Templates.ZoneEquipment.VAVBoxCoolingOnly(
    redeclare replaceable Buildings.Templates.ZoneEquipment.Components.Controls.OpenLoop ctl
    "Open loop control");
  annotation (
    defaultComponentName="ter",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This is a configuration model with the same default options as
<a href=\"modelica://Buildings.Templates.ZoneEquipment.VAVBoxCoolingOnly\">
Buildings.Templates.ZoneEquipment.VAVBoxCoolingOnly</a>.
</p>
</html>"));
end VAVBoxCoolingOnly;
