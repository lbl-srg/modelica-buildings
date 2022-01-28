within Buildings.Controls.OBC.ASHRAE.G36.Types;
type MultizoneAHUMinOADesigns = enumeration(
    SeparateDamper_AFMS "Separate, with airflow measurement",
    SeparateDamper_DP "Separate, with differential pressure measurement",
    CommonDamper "Single common")
  "Enumeration defining how minimum outdoor air and economizer function being designed in multizone AHU"
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
<tr><td><code>SeparateDamper_AFMS</code></td>
<td>
Minimum outdoor air and economizer function use separate dampers, with airflow measurement.
</td></tr>
<tr><td><code>SeparateDamper_DP</code></td>
<td>
Minimum outdoor air and economizer function use separate dampers, with differential pressure measurement.
</td></tr>
<tr><td><code>CommonDamper</code></td>
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
