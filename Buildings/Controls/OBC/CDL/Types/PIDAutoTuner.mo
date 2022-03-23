within Buildings.Controls.OBC.CDL.Types;
type PIDAutoTuner = enumeration(
    tau
  "tau")
   "Enumeration to set the tuner for PID tuning"
  annotation (Documentation(info="<html>
<p>
Enumeration for the type of tuner that is used when tuning a PID controller.
The possible values are:
</p>

<table border=\"1\" summary=\"Explanation of the enumeration\">
<tr>
<th>Enumeration</th>
<th>Description</th></tr>
<tr><td><code>tau</code></td>
<td>
An autotuner for single-input-single-ouput systems that uses asymmetric relay feedback to create limit cycle oscillations
</td></tr>
</tr>
</table>
</html>"));
