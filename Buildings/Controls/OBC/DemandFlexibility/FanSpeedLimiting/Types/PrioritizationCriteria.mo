within Buildings.Controls.OBC.DemandFlexibility.FanSpeedLimiting.Types;
type PrioritizationCriteria = enumeration(
    CurrentFanSpeed "Prioritize air handling unit fans by current fan speed",
    FanSize "Prioritize air handling unit fans by fan size")
  "Prioritization criteria"
  annotation (Documentation(revisions="<html>
<ul>
<li>
October 21, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Enumeration to define the fan limiting prioritization criteria.
Possible values are:
</p>
<table border=\"1\" summary=\"Explanation of the enumeration\">
<tr>
<th>Enumeration</th>
<th>Description</th></tr>
<tr><td><code>CurrentFanSpeed</code></td>
<td>
Prioritize air handling unit fans by current fan speed.
</td></tr>
<tr><td><code>FanSize</code></td>
<td>
Prioritize air handling unit fans by fan size.
</td></tr>
</table>
</html>"));
