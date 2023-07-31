within Buildings.Fluid.Movers.BaseClasses;
package Euler "Functions and data record templates for Euler number"

  annotation (Documentation(info="<html>
<p>
This package implements a power computation using the Euler number
and its correlation.
</p>
<ul>
<li>
The correlation function using the Euler number is implemented in
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Euler.correlation\">
Buildings.Fluid.Movers.BaseClasses.Euler.correlation</a>.
</li>
<li>
When curves of power and pressure against flow rate is available,
the function
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Euler.getPeak\">
Buildings.Fluid.Movers.BaseClasses.Euler.getPeak</a>
can identify the peak operating condition from them.
This is useful comparing power computation results
against other methods.
</li>
<li>
The peak operating condition (where the efficiency <i>&eta;</i> is
at its maximum) which is used by the correlation is stored in an instance
of the record
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Euler.peak\">
Buildings.Fluid.Movers.BaseClasses.Euler.peak</a>.
</li>
<li>
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface\">
Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface</a>
uses the peak values and the correlation to generate a power curve against
volumetric flow rate. This estimated power curve is used in place of the
measured power that would otherwise be provided.
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
