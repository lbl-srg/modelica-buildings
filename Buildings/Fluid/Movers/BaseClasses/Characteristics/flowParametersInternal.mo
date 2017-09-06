within Buildings.Fluid.Movers.BaseClasses.Characteristics;
record flowParametersInternal "Record for flow parameters with prescribed size"
  extends Modelica.Icons.Record;
  parameter Integer n "Number of elements in each array"
   annotation(Evaluate=true);
  parameter Modelica.SIunits.VolumeFlowRate V_flow[n](each min=0)
    "Volume flow rate at user-selected operating points";
  parameter Modelica.SIunits.PressureDifference dp[n](
     each min=0, each displayUnit="Pa")
    "Fan or pump total pressure at these flow rates";
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
April 11, 2016 by Michael Wetter:<br/>
Corrected wrong hyperlink in documentation for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/450\">issue 450</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
March 22, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end flowParametersInternal;
