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
This enumeration defines the control variants for changing zone temperature
setpoints. Possible values are:
</p>
<table border=\"1\" summary=\"Explanation of the enumeration\">
<tr>
<th>Enumeration</th>
<th>Description</th></tr>
<tr><td>Variant <i>1</i></td>
<td>
Single-step temperature setpoint adjustment.
</td></tr>
<tr><td>Variant <i>2</i></td>
<td>
Multiple-step temperature setpoint adjustment without an electricity demand target.
</td></tr>
<tr><td>Variant <i>3</i></td>
<td>
Multiple-step temperature setpoint adjustment with a constant electricity demand target.
</td></tr>
<tr><td>Variant <i>4</i></td>
<td>
Multiple-step temperature setpoint adjustment with a varying electricity demand target.
</td></tr>
</table>
<p>
Below are in-depth descriptions for each variant:
</p>
<ul>
<li>
In Variant <i>1</i> (single-step setpoint adjustment), each zone changes its setpoint
to the target limit in a single step. The controller can either adjust setpoints for
a few zones at a time, or for all zones at once. This variant does not consider
building electricity demand.
</li>
<li>
In Variant <i>2</i> (ratcheted setpoint adjustment), each zone changes its setpoint
toward the target limit in multiple small steps. The controller can either adjust
setpoints for a few zones at a time, or for all zones at once. This variant does not
consider building electricity demand.
</li>
<li>
In Variant <i>3</i> and Variant <i>4</i>, the controller operates as in Variant
<i>2</i>, except that during the load-shed mode, it only adjusts setpoints when the
building electricity demand exceeds a constant target (Variant <i>3</i>) or a
varying target (Variant <i>4</i>).
</li>
</ul>
</html>"));
