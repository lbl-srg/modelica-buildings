within Buildings.Templates.ZoneEquipment;
model VAVBoxCoolingOnly "VAV terminal unit cooling only"
  extends Buildings.Templates.ZoneEquipment.Interfaces.VAVBox(
    final typ=Buildings.Templates.ZoneEquipment.Types.Configuration.VAVBoxCoolingOnly,
    redeclare final Buildings.Templates.Components.Coils.None coiHea,
    redeclare replaceable
      Buildings.Templates.ZoneEquipment.Components.Controls.G36VAVBoxCoolingOnly ctl
      "Guideline 36 controller for VAV terminal unit cooling only");

annotation (
  __ctrlFlow_template,
  defaultComponentName="VAVBox",
  Documentation(info="<html>
<h4>Description</h4>
<p>
This template represents a cooling-only VAV terminal unit
(or shut off box).
</p>
<p>
The possible configuration options are enumerated in the table below.
The user may refer to ASHRAE (2021) for further details.
The first option displayed in bold characters corresponds to the default configuration.<br/>
</p>
<table summary=\"summary\" border=\"1\">
<tr><th>Configuration parameter</th><th>Options</th><th>Notes</th></tr>
<tr><td>VAV damper</td>
<td>
<b>Modulating damper</b><br/>
</td>
<td></td>
</tr>
<tr><td>Controller</td>
<td>
<b>ASHRAE Guideline 36 controller</b>
</td>
<td>
An open loop controller is also available for validation purposes only.
</td>
</table>
<h4>References</h4>
<ul>
<li>
ASHRAE, 2021. Guideline 36-2021, High-Performance Sequences of Operation
for HVAC Systems. Atlanta, GA.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
February 11, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end VAVBoxCoolingOnly;
