within Buildings.Electrical.Transmission.Functions;
function selectVoltageLevel
  "This function computes the voltage level (low, medium or high) given the nominal voltage"
  input Modelica.Units.SI.Voltage V "Nominal voltage";
  output Buildings.Electrical.Types.VoltageLevel level "Type of voltage level";
algorithm
  if V <= 0 then
    assert(V > 0,
     "In function Buildings.Electrical.Transmission.Functions.selectVoltageLevel,
      does not support a voltage of " + String(V) + " [V].
      The selected voltage level will be assumed to be low.",
      level = AssertionLevel.warning);
    level := Buildings.Electrical.Types.VoltageLevel.Low;
  elseif V <= 1000 then
    level := Buildings.Electrical.Types.VoltageLevel.Low;
  elseif V > 1000 and V <= 50000 then
    level := Buildings.Electrical.Types.VoltageLevel.Medium;
  else
    level := Buildings.Electrical.Types.VoltageLevel.High;
  end if;
annotation(Inline = true, Documentation(revisions="<html>
<ul>
<li>
Sept 19, 2014, by Marco Bonvini:<br/>
Added warning instead of print.
</li>
<li>
June 3, 2014, by Marco Bonvini:<br/>
Added User's guide.
</li>
</ul>
</html>", info="<html>
<p>
This function computes the voltage level for a given voltage.
The computation is as follows:
</p>

<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr>
<th>Condition</th>
<th>Voltage Level</th>
</tr>
<!-- ************ -->
<tr>
<td><i>0 &le; V &lt; 1 kV</i></td>
<td>Low voltage</td>
</tr>
<!-- ************ -->
<tr>
<td><i>1 kV &le; V &lt; 50 kV</i></td>
<td>Medium voltage</td>
</tr>
<!-- ************ -->
<tr>
<td><i> V &ge; 50 kV</i></td>
<td>HIgh voltage</td>
</tr>
</table>

</html>"));
end selectVoltageLevel;
