within Buildings.Fluid.Movers.BaseClasses.Characteristics;
record powerParameters "Record for electrical power parameters"
  extends Modelica.Icons.Record;
  parameter Modelica.Units.SI.VolumeFlowRate V_flow[:](each min=0)
    "Volume flow rate at user-selected operating points";
  parameter Modelica.Units.SI.Power P[size(V_flow, 1)](each min=0)
    "Fan or pump electrical power at these flow rates";
  annotation (Documentation(info="<html>
<p>
Data record for performance data that describe volume flow rate versus
electrical power.
The volume flow rate <code>V_flow</code> must be increasing, i.e.,
<code>V_flow[i] &lt; V_flow[i+1]</code>.
Both vectors, <code>V_flow</code> and <code>P</code>
must have the same size.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 10, 2012, by Michael Wetter:<br/>
Fixed wrong <code>displayUnit</code> and
<code>max</code> attribute for power.
</li>
<li>
September 28, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end powerParameters;
