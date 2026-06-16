within Buildings.Fluid.Humidifiers.EvaporativePads.Baseclasses.Characteristics;
record pressureParameters "Record for pressure vs. air velocity"
  extends Modelica.Icons.Record;
  parameter Real v[:](each min=0)
    "Air velocity";
  parameter Modelica.Units.SI.Pressure dp[size(v, 1)]
    "Pressure drop at the corresponding air velocity";
  annotation (Documentation(info="<html>
<p>
Data record for performance data that describe pressure drop versus air velocity.
The air velocity <i>v</i> must be increasing, i.e., <i>v[i] &lt; v[i+1]</i>. Both
vectors, <i>v</i> and the pressure drop <i>dp</i> must have the same size.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 03, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end pressureParameters;
