within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Types;
type SimpleController = enumeration(
    PI
  "PI controller",
    PID
  "PID controller")
  "Enumeration defining PI, or PID simple controller type"
  annotation (Evaluate=true,Documentation(info="<html>
<p>
Enumeration to define the type of the controller.
Possible values are:
</p>
<table border=\"1\" summary=\"Explanation of the enumeration\">
<tr>
<th>Enumeration</th>
<th>Description</th></tr>
<tr><td><code>PI</code></td>
<td>
Controller with proportional and integral terms.
</td></tr>
<tr><td><code>PID</code></td>
<td>
Controller with proportional, integral and derivative terms.
</td></tr>
</table>
</html>",revisions="<html>
<ul>
<li>
August 18, 2023, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
