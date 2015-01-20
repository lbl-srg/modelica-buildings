within Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Characteristics;
record efficiencyParameters "Record for efficiency parameters"
  extends Modelica.Icons.Record;
  parameter Real r_V[:](each min=0, each unit="1")
    "Volumetric flow rate divided by nominal flow rate at user-selected operating points";
  parameter Real eta[size(r_V,1)](
     each min=0, each max=1, each displayUnit="1")
    "Fan efficiency at these flow rates";
  annotation (Documentation(info="<html>
<p>
Data record for performance data that describe volume flow rate versus
efficiency.
The volume flow rate <code>r_V</code> must be increasing, i.e.,
<code>r_V[i] &lt; r_V[i+1]</code>.
Both vectors, <code>r_V</code> and <code>eta</code>
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
