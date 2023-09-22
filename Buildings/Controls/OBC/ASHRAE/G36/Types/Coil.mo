within Buildings.Controls.OBC.ASHRAE.G36.Types;
type Coil = enumeration(
    None "No coil",
    WaterBasedHeating "Hot water coil",
    ElectricHeating "Modulating electric heating coil",
    WaterBasedCooling "Chilled water coil",
    DXCoil "Direct expansion cooling coil")
  "Enumeration to configure the coil"
annotation (
 Evaluate=true, Documentation(info="<html>
<p>
Enumeration to define coil options. Possible values are:
</p>
<table border=\"1\" summary=\"Explanation of the enumeration\">
<tr>
<th>Enumeration</th>
<th>Description</th></tr>

<tr><td><code>None</code></td>
<td>
No coil.
</td></tr>
<tr><td><code>WaterBasedHeating</code></td>
<td>
Hot water coil.
</td></tr>
<tr><td><code>ElectricHeating</code></td>
<td>
Modulating electric heating coil.
</td></tr>
<tr><td><code>WaterBasedCooling</code></td>
<td>
Chilled water coil.
</td></tr>
<tr><td><code>DXCoil</code></td>
<td>
Direct expansion cooling coil.
</td></tr>
</table>
</html>", revisions="<html>
<ul>
<li>
September 22, 2023, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
