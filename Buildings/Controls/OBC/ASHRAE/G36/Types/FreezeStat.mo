within Buildings.Controls.OBC.ASHRAE.G36.Types;
type FreezeStat = enumeration(
    No_freeze_stat "No freeze stat",
    Hardwired_to_equipment "Freeze stat only hardwired to the equipment",
    Hardwired_to_BAS "Freeze stat hardwired to the equipment and the BAS")
    "Enumeration of different freeze stat options"
annotation (
 Evaluate=true, Documentation(info="<html>
<p>
Enumeration to define freeze stat options. Possible values are:
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
Freeze stat only hardwired to the equipment, no sequence needed.
</td></tr>
<tr><td><code>Hardwired_to_BAS</code></td>
<td>
Freeze stat hardwired to the equipment and the BAS.
</td></tr>
</table>
</html>", revisions="<html>
<ul>
<li>
December 15, 2022, by Jianjun Hu:<br/>
Removed the polarity option.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3139\">issue 3139</a>.
</li>
<li>
March 22, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
