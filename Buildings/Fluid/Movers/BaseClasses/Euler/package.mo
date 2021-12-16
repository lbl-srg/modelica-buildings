within Buildings.Fluid.Movers.BaseClasses;
package Euler "Functions and data record templates for Euler number"

  annotation (Documentation(info="<html>
<p>
This package implements a power computation path using the Euler number
and its correlation.
</p>
<ul>
<li>
Efficiency and power are computed and output as look-up tables by
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Euler.computeTables\">
Buildings.Fluid.Movers.BaseClasses.Euler.computeTables</a>.
</li>
<li>
The correlation function using the Euler number is implemented in
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Euler.correlation\">
Buildings.Fluid.Movers.BaseClasses.Euler.correlation</a>.
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
<a href=\"Buildings.Fluid.Movers.BaseClasses.Euler.initialTable\">
Buildings.Fluid.Movers.BaseClasses.Euler.initialTable</a>
assigns initial values to look-up tables that both satisfy format requirements
of <a href=\"modelica://Modelica.Blocks.Tables.CombiTable2D\">
Modelica.Blocks.Tables.CombiTable2D</a>
and are consistent with the dimensions set out by
<a href=\"Buildings.Fluid.Movers.BaseClasses.Euler.lookupTables\">
Buildings.Fluid.Movers.BaseClasses.Euler.lookupTables</a>.
This is to avoid error messages when the look-up tables are not used
and left at default values.
</li>
<li>
The computed look-up tables are stored in
<a href=\"Buildings.Fluid.Movers.BaseClasses.Euler.lookupTables\">
Buildings.Fluid.Movers.BaseClasses.Euler.lookupTables</a>.
</li>
<li>
The peak operating condition (where the efficiency <i>&eta;</i> is
at its maximum) which is used by the correlation is stored in the record
<a href=\"Buildings.Fluid.Movers.BaseClasses.Euler.peak\">
Buildings.Fluid.Movers.BaseClasses.Euler.peak</a>.
</li>
</ul>
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
