within Buildings.Controls.OBC.DemandFlexibility.Types;
type ZoneControlVariant = enumeration(
    Variant_1 "Single-step temperature setpoint adjustment",
    Variant_2 "Multiple-step temperature setpoint adjustment without an electricity demand target",
    Variant_3 "Multiple-step temperature setpoint adjustment with a constant electricity demand target",
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
Multiple-step temperature setpoint adjustment with a constant electricity demand target.
</td></tr>
<tr><td><code>Variant_4</code></td>
<td>
Multiple-step temperature setpoint adjustment with a varying electricity demand target.
</td></tr>
</table>
<p>
Each variant is described in-depth below:
</p>
<ul>
<li>
Variant <i>1</i> is single setpoint adjustment, where a zone changes its setpoint
towards a setpoint limit in a single step. However, the single-step setpoint change
can still be done a few zones at a time, rather than all zones changing setpoints at
once. This variant does not take into account the electricity demand of the building.
</li>
<li>
Variant <i>2</i> is ratcheted setpoint adjustment, where a zone changes its setpoint
towards a setpoint limit in multiple small steps. This ratcheted multiple-step
setpoint change can also be done a few zones at a time, rather than all zones
changing setpoints at once. This provides an additional degree of freedom for the
setpoint change. This variant does not take into account the electricity demand of
the building.
</li>
<li>
Variant <i>3</i> is ratcheted setpoint adjustment with a constant electricity demand
target. This is similar to Variant <i>2</i>, except that the electricity demand of
the building needs to be higher than a constant electricity demand target in order
to execute setpoint change during the load-shed demand flexibility mode.
</li>
<li>
Variant <i>4</i> is ratcheted setpoint adjustment with a varying electricity demand
target. This is similar to Variant <i>2</i>, except that the electricity demand of
the building needs to be higher than a variable electricity demand target in order
to execute setpoint change during the load-shed demand flexibility mode.
</li>
</ul>
</html>"));
