within Buildings.Fluid.Movers.BaseClasses;
package Euler "Functions for Euler correlation"

  annotation (Documentation(info="<html>
<p>
This package implements a power computation path using the Euler number 
and its correlation.
</p>
<ul>
<li>
The correlation function using the Euler number is implemented in 
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Euler.correlation\">
Buildings.Fluid.Movers.BaseClasses.Euler.correlation</a>.
</li>
<li>
Efficiency and power curves are computed by 
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Euler.computeTables\">
Buildings.Fluid.Movers.BaseClasses.Euler.computeTables</a>.
</li>
<li>
When curves of power and pressure against flow rate is available,
the function 
<a href=\"Buildings.Fluid.Movers.BaseClasses.Euler.findPeak\">
Buildings.Fluid.Movers.BaseClasses.Euler.findPeak</a>
can identify the peak operating condition from them. 
This is useful comparing power computation results 
against other methods. 
</li>
<li>
The peak operating condition (where the efficiency <i>&eta;</i> is
at its maximum) which is used by the correlation is stored in the record
<a href=\"Buildings.Fluid.Movers.BaseClasses.Euler.peak\">
Buildings.Fluid.Movers.BaseClasses.Euler.peak</a>.
</li>
<li>
The results are stored in 
<a href=\"Buildings.Fluid.Movers.BaseClasses.Euler.lookupTables\">
Buildings.Fluid.Movers.BaseClasses.Euler.lookupTables</a>.
</li>
</ul>
<p>
To avoid unreasonable power values being computed at low flow,
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Euler.computeTables\">
Buildings.Fluid.Movers.BaseClasses.Euler.computeTables</a>
replaces the computed power at zero flow with extrapolation.
</p>
<p>
See the
<a href=\"modelica://Buildings.Fluid.Movers.UsersGuide\">
User's Guide</a> for more information.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 13, 2021, by Hongxiang Fu:<br/>
First implementation. This is for 
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
</ul>
</html>"));
end Euler;
