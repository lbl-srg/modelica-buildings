within Buildings.Controls.OBC.ASHRAE.G36.Types;
type CoolingCoil = enumeration(
    None "No coil",
    WaterBased "Chilled water coil",
    DXCoil "Direct expansion cooling coil")
  "Enumeration to configure the cooling coil"
annotation (
 Evaluate=true, Documentation(info="<html>
<p>
Enumeration to define cooling coil options. Possible values are:
</p>
<table border=\"1\" summary=\"Explanation of the enumeration\">
<tr>
<th>Enumeration</th>
<th>Description</th></tr>
<tr><td><code>None</code></td>
<td>
No coil.
</td></tr>
<tr><td><code>WaterBased</code></td>
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
