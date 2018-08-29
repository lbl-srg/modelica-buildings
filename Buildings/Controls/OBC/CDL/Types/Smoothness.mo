within Buildings.Controls.OBC.CDL.Types;
type Smoothness = enumeration(
    LinearSegments "Table points are linearly interpolated",
    ConstantSegments
      "Table points are not interpolated, but the previous tabulated value is returned")
  "Enumeration defining the smoothness of table interpolation" annotation (
    Documentation(info="<html>
<p>
Enumeration for the type of smoothness that is used when interpolating data from a table.
The possible values are:
</p>

<table border=\"1\" summary=\"Explanation of the enumeration\">
<tr>
<th>Enumeration</th>
<th>Description</th></tr>
<tr><td><code>LinearSegments</code></td>
<td>
Linearly interpolate table points.
</td></tr>
<tr><td><code>ConstantSegments</code></td>
<td>
Do not interpolate, but rather use the previously tabulated value.
</td></tr>
</table>
</html>"));
