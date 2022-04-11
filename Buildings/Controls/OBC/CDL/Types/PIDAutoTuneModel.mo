within Buildings.Controls.OBC.CDL.Types;
type PIDAutoTuneModel = enumeration(
    FOTD
  "First-order models with time delay") "Enumeration to set the reduced order model for PID tuning"
  annotation (Documentation(info="<html>
<p>
Enumeration for the type of reduced model that is used when tuning a PID controller.
The possible values are:
</p>

<table border=\"1\" summary=\"Explanation of the enumeration\">
<tr>
<th>Enumeration</th>
<th>Description</th></tr>
<tr><td><code>FOTD</code></td>
<td>
First order model with time delay
</td></tr>
</table>
</html>"));
