within Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans;
model VAVMZFanSupplyArrayVariable "Configuration of multiple-zone VAV"
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    nZon=2,
    redeclare replaceable Buildings.Templates.Components.Fans.ArrayVariable
      fanSupDra);

  annotation (
    defaultComponentName="ahu", Documentation(info="<html>
<p>
This is a configuration model with the same default options as
<a href=\"modelica://Buildings.Templates.AirHandlersFans.VAVMultiZone\">
Buildings.Templates.AirHandlersFans.VAVMultiZone</a>
except for the following options.<br/>
</p>
<table summary=\"summary\" border=\"1\">
<tr><th>Component</th><th>Configuration</th></tr>
<tr><td>Supply fan</td><td>Fan array - Variable speed - Draw-through position</td></tr>
</table>
</html>"));
end VAVMZFanSupplyArrayVariable;
