within Buildings.Fluid.Movers.BaseClasses;
package Euler "Functions for Euler correlation"

  annotation (Documentation(info="<html>
<p>
This package implements a power computation path using the Euler number 
and its correlation and the records for parameter that can be used with it.
It also comes with a function that identifies the peak operation point 
(where the efficiency is at its maximum) from mover curves.
Although this path is intended to be used with only one data point 
(the peak condition) supplied, the <code>findPeakCondition</code> function 
makes it convenient to compare results with those obtained 
by directly using the full curves. 
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
