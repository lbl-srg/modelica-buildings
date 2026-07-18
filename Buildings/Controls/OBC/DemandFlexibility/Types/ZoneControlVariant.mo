within Buildings.Controls.OBC.DemandFlexibility.Types;
type ZoneControlVariant = enumeration(
    Variant_1 "Single-step temperature setpoint adjustment",
    Variant_2 "Multiple-step temperature setpoint adjustment without an electricity demand target",
    Variant_3 "Multiple-step temperature setpoint adjustment with a single electricity demand target",
    Variant_4 "Multiple-step temperature setpoint adjustment with a varying electricity demand target")
  "Zone temperature setpoint control variant" annotation (Documentation(
      revisions="<html>
<ul>
<li>
July 17, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Enumeration to define control variants for the zone temperature setpoint change.
Possible values are:
</p>
<table border=\"1\" summary=\"Explanation of the enumeration\">
<tr>
<th>Enumeration</th>
<th>Description</th></tr>
<tr><td><code>Variant_1</code></td>
<td>
Single-step temperature setpoint adjustment.
</td></tr>
<tr><td><code>Variant_2</code></td>
<td>
Multiple-step temperature setpoint adjustment without an electricity demand target.
</td></tr>
<tr><td><code>Variant_3</code></td>
<td>
Multiple-step temperature setpoint adjustment with a single electricity demand target.
</td></tr>
<tr><td><code>Variant_4</code></td>
<td>
Multiple-step temperature setpoint adjustment with a varying electricity demand target.
</td></tr>
</table>
</html>"));
