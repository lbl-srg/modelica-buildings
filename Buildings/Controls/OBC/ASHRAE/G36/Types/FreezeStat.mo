within Buildings.Controls.OBC.ASHRAE.G36.Types;
type FreezeStat = enumeration(
    No_freeze_stat "No freeze stat",
    Hardwired_to_equipment "Freeze stat directly hardwired to the equipment",
    Connected_to_BAS_NO "Freeze stat connected to BAS, normally open",
    Connected_to_BAS_NC "Freeze stat connected to BAS, normally close")
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
<tr><td><code>Hardwired_to_equipment</code></td>
<td>
Freeze stat directly hardwired to the equipment, no sequence needed.
</td></tr>
<tr><td><code>Connected_to_BAS_NO</code></td>
<td>
Freeze stat connected to BAS, normally open.
</td></tr>
<tr><td><code>Connected_to_BAS_NC</code></td>
<td>
Freeze stat connected to BAS, normally close.
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
