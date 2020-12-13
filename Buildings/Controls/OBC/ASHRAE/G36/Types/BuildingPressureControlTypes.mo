within Buildings.Controls.OBC.ASHRAE.G36.Types;
type BuildingPressureControlTypes = enumeration(
    ReliefDamper "Relief damper",
    ReliefFan "Relief fan",
    ReturnFanAir "Return fan, with airflow tracking",
    ReturnFanDp "Return fan, with direct building pressure control")
  "Enumeration defining types of building pressure control system"
annotation (
 Evaluate=true, Documentation(info="<html>
<p>
Enumeration to define types of building pressure control system.
Possible values are:
</p>
<table border=\"1\" summary=\"Explanation of the enumeration\">
<tr>
<th>Enumeration</th>
<th>Description</th></tr>
<tr><td><code>ReliefDamper</code></td>
<td>
Relief damper.
</td></tr>
<tr><td><code>RelieFan</code></td>
<td>
Relief fan.
</td></tr>
<tr><td><code>ReturnFanAir</code></td>
<td>
Return fan control with airflow tracking.
</td></tr>
<tr><td><code>ReturnFanDp</code></td>
<td>
Return fan control with direct building pressure controls.
</td></tr>
</table>
</html>", revisions="<html>
<ul>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
