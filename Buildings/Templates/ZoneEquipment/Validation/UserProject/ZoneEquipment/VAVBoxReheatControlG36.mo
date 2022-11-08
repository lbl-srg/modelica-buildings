within Buildings.Templates.ZoneEquipment.Validation.UserProject.ZoneEquipment;
model VAVBoxReheatControlG36  "Configuration of VAV terminal unit with reheat"
  extends Buildings.Templates.ZoneEquipment.VAVBoxReheat;

  annotation (
    defaultComponentName="ter",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This is a configuration model with the same default options as
<a href=\"modelica://Buildings.Templates.ZoneEquipment.VAVBoxReheat\">
Buildings.Templates.ZoneEquipment.VAVBoxReheat</a>
except for the following options.<br/>
</p>
<table summary=\"summary\" border=\"1\">
<tr><th>Component</th><th>Configuration</th></tr>
<tr><td>Controller</td><td>Guideline 36 controller</td></tr>
</table>
</html>"));
end VAVBoxReheatControlG36;
