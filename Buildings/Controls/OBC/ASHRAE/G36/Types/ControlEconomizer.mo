within Buildings.Controls.OBC.ASHRAE.G36.Types;
type ControlEconomizer = enumeration(
    FixedDryBulb
      "Fixed dry bulb",
    DifferentialDryBulb
      "Differential dry bulb",
    FixedDryBulbWithDifferentialDryBulb
      "Fixed dry bulb with differential dry bulb",
    FixedEnthalpyWithFixedDryBulb
      "Fixed enthalpy with fixed dry bulb",
    DifferentialEnthalpyWithFixedDryBulb
      "Differential enthalpy with fixed dry bulb")
  "Enumeration to configure the economizer enable and disable control"
annotation (
 Evaluate=true, Documentation(info="<html>
<p>
Enumeration to define economizer divice type for enable and disable it. Possible values are:
</p>
<table border=\"1\" summary=\"Explanation of the enumeration\">
<tr>
<th>Enumeration</th>
<th>Description</th></tr>
<tr><td><code>FixedDryBulb</code></td>
<td>
Fixed dry bulb.
</td></tr>
<tr><td><code>DifferentialDryBulb</code></td>
<td>
Differential dry bulb.
</td></tr>
<tr><td><code>FixedDryBulbWithDifferentialDryBulb</code></td>
<td>
Fixed dry bulb with differential dry bulb.
</td></tr>
<tr><td><code>FixedEnthalpyWithFixedDryBulb</code></td>
<td>
Fixed enthalpy with fixed dry bulb.
</td></tr>
<tr><td><code>DifferentialEnthalpyWithFixedDryBulb</code></td>
<td>
Differential enthalpy with fixed dry bulb.
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
