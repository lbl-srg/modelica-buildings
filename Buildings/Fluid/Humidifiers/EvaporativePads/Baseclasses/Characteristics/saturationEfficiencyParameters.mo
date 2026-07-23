within Buildings.Fluid.Humidifiers.EvaporativePads.Baseclasses.Characteristics;
record saturationEfficiencyParameters
  "Record for saturation efficiency vs. air velocity"
  extends Modelica.Icons.Record;
  parameter Real v[:](each min=0)
    "Air velocity";
  parameter Modelica.Units.SI.Efficiency eta[size(v, 1)](each min=0,max=1)
    "Saturation efficiency at the corresponding air velocity";
  annotation (Documentation(info="<html>
<p>
Data record for performance data that describe saturation efficiency versus air
velocity. The air velocity <i>v</i> must be increasing, i.e.,
<i>v[i] &lt; v[i+1]</i>. Both vectors, <i>v</i> and the saturation efficiency
<i>eta</i> must have the same size.
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
end saturationEfficiencyParameters;
