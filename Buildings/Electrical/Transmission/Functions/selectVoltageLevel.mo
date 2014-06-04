within Buildings.Electrical.Transmission.Functions;
function selectVoltageLevel
  "given the nominal voltage of the line defined the voltage level: low, medium or high"
  input Modelica.SIunits.Voltage V "Nominal voltage";
  output Buildings.Electrical.Types.VoltageLevel level "Type of voltage level";
algorithm
  if V<=0 then
    Modelica.Utilities.Streams.print("Error: the nominal voltage should be positive " +
        String(V) + " A. The voltage level cannot be choose, selected Low as default.");
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
June 3, 2014, by Marco Bonvini:<br/>
Added User's guide.
</li>
</ul>
</html>", info="<html>
<p>
This function given an input voltage determines which type
of voltage level is associated to it. There are three voltage
levels: low, medium and high.
</p>
<p>
<table summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<tr>
<th>Condition</th>
<th>Voltage Level</th>
</tr>
<!-- ************ -->
<tr>
<td><i>0 &le; V &lt; 1 kV</i></td>
<td>Low voltage</td>
</td>
</tr>
<!-- ************ -->
<tr>
<td><i>1 kV &le; V &lt; 50 kV</i></td>
<td>Medium voltage</td>
</td>
</tr>
<!-- ************ -->
<tr>
<td><i> V &ge; 50 kV</i></td>
<td>HIgh voltage</td>
</td>
</tr>
</table>
</p>
</html>"));
end selectVoltageLevel;
