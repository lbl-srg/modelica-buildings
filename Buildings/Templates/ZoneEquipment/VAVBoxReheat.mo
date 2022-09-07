within Buildings.Templates.ZoneEquipment;
model VAVBoxReheat "VAV terminal unit with reheat"
  extends Buildings.Templates.ZoneEquipment.Interfaces.VAVBox(
    final typ=Buildings.Templates.ZoneEquipment.Types.Configuration.VAVBoxReheat,
    redeclare replaceable Buildings.Templates.ZoneEquipment.Components.Controls.G36VAVBoxReheat ctl
      "Guideline 36 controller for VAV terminal unit with reheat");

  annotation (
   defaultComponentName="VAVBox",
    Documentation(info="<html>
<h4>Description</h4>
<p>
This template represents a VAV terminal unit with reheat.
</p>
<p>
The possible equipment configurations are enumerated in the table below.
The user may refer to
<a href=\"#ASHRAE2021\">ASHRAE (2021)</a>
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
<tr><td>Reheat coil</td>
<td>
<b>Hot water coil</b><br/>
Modulating electric heating coil<br/>
No coil
</td>
<td>By default a two-way modulating valve is considered for
a hot water coil.
Alternative options for the control valve are available.</td>
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
<li id=\"ASHRAE2021\">
ASHRAE, 2021. Guideline 36-2021, High-Performance Sequences of Operation
for HVAC Systems. Atlanta, GA.
</li>
</ul>
</html>"));
end VAVBoxReheat;
