within Buildings.Obsolete.Controls.OBC.ASHRAE.G36.Types;
type FreezeStat = enumeration(
    No_freeze_stat "No freeze stat",
    With_reset_switch_NO "Freeze stat with manual reset switch, normally open",
    With_reset_switch_NC "Freeze stat with manual reset switch, normally closed",
    Without_reset_switch_NO "Freeze stat without manual reset switch, normally open",
    Without_reset_switch_NC "Freeze stat without manual reset switch, normally closed")
    "Enumeration of different freeze stat"
annotation (
 Evaluate=true, Documentation(info="<html>
<p>
Enumeration to define freeze stat types. Possible values are:
</p>
<table border=\"1\" summary=\"Explanation of the enumeration\">
<tr>
<th>Enumeration</th>
<th>Description</th></tr>
<tr><td><code>No_freeze_stat</code></td>
<td>
No freeze stat.
</td></tr>
<tr><td><code>With_reset_switch_NO</code></td>
<td>
Freeze stat with manual reset switch, normally open.
</td></tr>
<tr><td><code>With_reset_switch_NC</code></td>
<td>
Freeze stat with manual reset switch, normally closed.
</td></tr>
<tr><td><code>Without_reset_switch_NO</code></td>
<td>
Freeze stat without manual reset switch, normally open.
</td></tr>
<tr><td><code>Without_reset_switch_NC</code></td>
<td>
Freeze stat without manual reset switch, normally closed.
</td></tr>
</table>
</html>", revisions="<html>
<ul>
<li>
March 22, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
