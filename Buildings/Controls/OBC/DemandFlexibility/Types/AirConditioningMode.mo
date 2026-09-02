within Buildings.Controls.OBC.DemandFlexibility.Types;
type AirConditioningMode = enumeration(
    Heating "Heating mode, by bringing the space temperature warmer during cold weather",
    Cooling "Cooling mode, by bringing the space temperature cooler during hot weather")
  "Air conditioning mode" annotation (Documentation(revisions="<html>
<ul>
<li>
September 02, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Enumeration to define whether the air conditioning system should be on the heating
mode or on the cooling mode.
Possible values are:
</p>
<table border=\"1\" summary=\"Explanation of the enumeration\">
<tr>
<th>Enumeration</th>
<th>Description</th></tr>
<tr><td><code>Heating</code></td>
<td>
Heating mode, by bringing the space temperature warmer during cold weather.
</td></tr>
<tr><td><code>Cooling</code></td>
<td>
Cooling mode, by bringing the space temperature cooler during hot weather.
</td></tr>
</table>
</html>"));
