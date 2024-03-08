within Buildings.Controls.OBC.ASHRAE.G36.Types;
type HeatingCoil = enumeration(
    None "No coil",
    WaterBased "Hot water coil",
    Electric "Modulating electric heating coil")
  "Enumeration to configure the heating coil"
annotation (
 Evaluate=true, Documentation(info="<html>
<p>
Enumeration to define heating coil options. Possible values are:
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
Hot water coil.
</td></tr>
<tr><td><code>Electric</code></td>
<td>
Modulating electric heating coil.
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
