within Buildings.Controls.OBC.CDL.Types;
type Extrapolation = enumeration(
    HoldLastPoint
  "Hold the first/last table point outside of the table scope",
    LastTwoPoints
  "Extrapolate by using the derivative at the first/last table points outside of the table scope",
    Periodic
  "Repeat the table scope periodically")
  "Enumeration defining the extrapolation of time table interpolation"
  annotation (Documentation(info="<html>
<p>
Enumeration for the type of extrapolation that is used when reading data from a table.
The possible values are:
</p>

<table border=\"1\" summary=\"Explanation of the enumeration\">
<tr>
<th>Enumeration</th>
<th>Description</th></tr>
<tr><td><code>HoldLastPoint</code></td>
<td>
Hold the first or last point outside of the table scope.
</td></tr>
<tr><td><code>LastTwoPoints</code></td>
<td>
Extrapolate by using the derivative at the first or last table points outside of the table scope.
</td></tr>
<tr><td><code>Periodic</code></td>
<td>
Repeat the table scope periodically.
</td></tr>
</table>
</html>"));
