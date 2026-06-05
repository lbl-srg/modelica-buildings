within Buildings.Fluid.Humidifiers.EvaporativePads.Baseclasses.Characteristics;
record pressureParameters "Record for pressure vs. air velocity"
  extends Modelica.Icons.Record;
  parameter Real v[:](each min=0)
    "Part load ratio, y = PEle/PEle_nominal";
  parameter Modelica.Units.SI.Pressure dp[size(v, 1)]
    "Fan or pump efficiency at these part load ratios";
  annotation (Documentation(info="<html>
<p>
Data record for performance data that describe volume flow rate versus
pressure rise.
The volume flow rate <code>V_flow</code> must be increasing, i.e.,
<code>V_flow[i] &lt; V_flow[i+1]</code>.
Both vectors, <code>V_flow</code> and <code>dp</code>
must have the same size.
</p>
<p>
This record is identical to
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters</a>,
except that it takes the size of the array as a parameter. This is required
in Dymola 2014. Otherwise, the array size would need to be computed in
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface\">
Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface</a>
in the <code>initial algorithm</code> section, which is not supported.
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
