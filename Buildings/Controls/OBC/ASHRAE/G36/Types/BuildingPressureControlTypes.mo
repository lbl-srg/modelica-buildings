within Buildings.Controls.OBC.ASHRAE.G36.Types;
type BuildingPressureControlTypes = enumeration(
    BarometricRelief "Nonactuated barometric relief",
    ReliefDamper "Actuated relief damper, without fan",
    ReliefFan "Actuated relief damper, with relief fan(s)",
    ReturnFanMeasuredAir "Return fan, tracking measured supply and return airflow",
    ReturnFanCalculatedAir "Return fan, tracking calculated supply and return airflow",
    ReturnFanDp "Return fan, with direct building pressure control")
  "Enumeration defining types of building pressure control system"
annotation (
 Evaluate=true, Documentation(info="<html>
<p>
Enumeration of define types of building pressure control system.
Possible values are:
</p>
<table border=\"1\" summary=\"Explanation of the enumeration\">
<tr>
<th>Enumeration</th>
<th>Description</th></tr>
<tr><td><code>BarometricRelief</code></td>
<td>
Nonactuated barometric relief.
</td></tr>
<tr><td><code>ReliefDamper</code></td>
<td>
Actuated relief damper, without fan.
</td></tr>
<tr><td><code>RelieFan</code></td>
<td>
Actuated relief damper, with relief fan(s).
</td></tr>
<tr><td><code>ReturnFanMeasuredAir</code></td>
<td>
Return fan control, tracking measured supply and return airflow.
</td></tr>
<tr><td><code>ReturnFanCalculatedAir</code></td>
<td>
Return fan control, tracking calculated supply and return airflow.
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
