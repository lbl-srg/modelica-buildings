within Buildings.Fluid.Movers.BaseClasses;
package Characteristics "Functions for fan or pump characteristics"

  annotation (Documentation(info="<html>
<p>
This package implements performance curves for fans and pumps,
and records for parameter that can be used with these performance
curves.
</p>
<p>
See the
<a href=\"modelica://Buildings.Fluid.Movers.UsersGuide\">
User's Guide</a> for information about these performance curves.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 8, 2016, by Michael Wetter:<br/>
Deleted function <code>performanceCurve</code> as it is no longer needed. Instead, the function
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.pressure\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.pressure</a>
is used for all speeds.<br/>
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/458\">#458</a>.
</li>
<li>
September 29, 2011, by Michael Wetter:<br/>
New implementation due to changes from polynomial to cubic hermite splines.
</li>
</ul>
</html>"));
end Characteristics;
