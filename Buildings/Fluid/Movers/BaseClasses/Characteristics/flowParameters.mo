within Buildings.Fluid.Movers.BaseClasses.Characteristics;
record flowParameters "Record for flow parameters"
  extends Modelica.Icons.Record;

  parameter Modelica.Units.SI.VolumeFlowRate V_flow[:](each min=0)
    "Volume flow rate at user-selected operating points";
  parameter Modelica.Units.SI.PressureDifference dp[size(V_flow, 1)](each min=0,
      each displayUnit="Pa") "Fan or pump total pressure at these flow rates";

  annotation (Documentation(info="<html>
<p>
Data record for performance data that describe volume flow rate versus
pressure rise.
The volume flow rate <code>V_flow</code> must be increasing, i.e.,
<code>V_flow[i] &lt; V_flow[i+1]</code>.
Both vectors, <code>V_flow</code> and <code>dp</code>
must have the same size.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
September 28, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end flowParameters;
