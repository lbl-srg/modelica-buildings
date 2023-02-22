within Buildings.Fluid.Movers.BaseClasses.Characteristics;
record efficiencyParameters
  "Record for efficiency parameters vs. volumetric flow rate"
  extends Modelica.Icons.Record;
  parameter Modelica.Units.SI.VolumeFlowRate V_flow[:](each min=0)
    "Volumetric flow rate at user-selected operating points";
  parameter Modelica.Units.SI.Efficiency eta[size(V_flow, 1)](each max=1)
    "Fan or pump efficiency at these flow rates";
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
September 28, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end efficiencyParameters;
