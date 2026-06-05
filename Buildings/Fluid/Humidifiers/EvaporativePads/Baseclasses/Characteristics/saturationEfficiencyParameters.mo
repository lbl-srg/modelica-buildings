within Buildings.Fluid.Humidifiers.EvaporativePads.Baseclasses.Characteristics;
record saturationEfficiencyParameters
  "Record for saturation efficiency vs. air velocity"
  extends Modelica.Icons.Record;
  parameter Real v[:](each min=0)
    "Part load ratio, y = PEle/PEle_nominal";
  parameter Modelica.Units.SI.Efficiency eta[size(v, 1)](each max=1)
    "Fan or pump efficiency at these part load ratios";
  annotation (Documentation(info="<html>
<p>
Data record for performance data that describe efficiency
versus volumetric flow rate.
The volume flow rate <code>r_V</code> must be increasing, i.e.,
<code>V_flow[i] &lt; V_flow[i+1]</code>.
Both vectors, <code>V_flow</code> and <code>eta</code>
must have the same size.
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
