within Buildings.Controls.OBC.CDL.Types;
type SimpleController = enumeration(
    P
  "P controller",
    PI
  "PI controller",
    PD
  "PD controller",
    PID
  "PID controller")
  "Enumeration defining P, PI, PD, or PID simple controller type"
  annotation (Evaluate=true,Documentation(info="<html>
<p>
Enumeration to define the type of the controller.
Possible values are:
</p>
<table border=\"1\" summary=\"Explanation of the enumeration\">
<tr>
<th>Enumeration</th>
<th>Description</th></tr>
<tr><td><code>P</code></td>
<td>
Controller with proportional term.
</td></tr>
<tr><td><code>PI</code></td>
<td>
Controller with proportional and integral terms.
</td></tr>
<tr><td><code>PD</code></td>
<td>
Controller with proportional and derivative term.
</td></tr>
<tr><td><code>PID</code></td>
<td>
Controller with proportional, integral and derivative terms.
</td></tr>
</table>
</html>",revisions="<html>
<ul>
<li>
March 23, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
