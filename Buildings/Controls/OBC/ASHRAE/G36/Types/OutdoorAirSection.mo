within Buildings.Controls.OBC.ASHRAE.G36.Types;
type OutdoorAirSection = enumeration(
    DedicatedDampersAirflow   "Separate dedicated OA dampers with AFMS",
    DedicatedDampersPressure   "Separate dedicated OA dampers with differential pressure sensor",
    NoEconomizer   "No economizer",
    SingleDamper   "Single common OA damper with AFMS")
  "Enumeration to configure the outdoor air section"
annotation (
 Evaluate=true, Documentation(info="<html>
<p>
Enumeration to define how minimum outdoor air and economizer function being
designed in multizone AHU. Possible values are:
</p>
<table border=\"1\" summary=\"Explanation of the enumeration\">
<tr>
<th>Enumeration</th>
<th>Description</th></tr>
<tr><td><code>DedicatedDampersAirflow</code></td>
<td>
Minimum outdoor air and economizer function use separate dampers, with airflow measurement.
</td></tr>
<tr><td><code>DedicatedDampersPressure</code></td>
<td>
Minimum outdoor air and economizer function use separate dampers, with differential pressure measurement.
</td></tr>
<tr><td><code>NoEconomizer</code></td>
<td>
No economizer.
</td></tr>
<tr><td><code>SingleDamper</code></td>
<td>
Minimum outdoor air and economizer function use single common damper.
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
