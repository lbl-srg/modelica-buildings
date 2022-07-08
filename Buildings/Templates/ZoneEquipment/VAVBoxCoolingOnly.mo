within Buildings.Templates.ZoneEquipment;
model VAVBoxCoolingOnly "VAV terminal unit cooling only"
  extends Buildings.Templates.ZoneEquipment.Interfaces.VAVBox(
    final typ=Buildings.Templates.ZoneEquipment.Types.Configuration.VAVBoxCoolingOnly,
    redeclare final Buildings.Templates.Components.Coils.None coiHea);

  annotation (
  defaultComponentName="VAVBox",
    Documentation(info="<html>
<h4>Description</h4>
<p>
This template represents a cooling-only VAV terminal unit
(or shut off box).
</p>
<p>
The possible equipment configurations are enumerated in the table below.
The user may refer to 
<a href=\"#ASHRAE2018\">ASHRAE (2018)</a>
for further details.
The first option displayed in bold characters corresponds to the default configuration.<br/>
</p>
<table summary=\"summary\" border=\"1\">
<tr><th>Component</th><th>Supported configuration</th><th>Note</th></tr>
<tr><td>VAV damper</td>
<td>
<b>Pressure independent damper</b><br/>
Modulating damper
</td>
<td></td>
</tr>
<tr><td>Controller</td>
<td>
<b>Open loop controller</b><br/>
ASHRAE Guideline 36 controller
</td>
<td></td>
</table>
<h4>References</h4>
<ul>
<li id=\"ASHRAE2018\">
ASHRAE, 2018. Guideline 36-2018, High-Performance Sequences of Operation 
for HVAC Systems. Atlanta, GA.
</li>
</ul>
</html>"));
end VAVBoxCoolingOnly;
