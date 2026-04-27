within Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses;
package Characteristics "Functions for fan characteristics"

  annotation (Documentation(info="<html>
<p>
This package implements the performance curve for the fans,
and a record for performance data that can be used with the performance
curve.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 27, 2026, by Michael Wetter:<br/>
Refactored for new cooling tower implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4567\">issue 4567</a>.
</li>
<li>
June 4, 2016, by Michael Wetter:<br/>
Updated documentation.
</li>
<li>
September 29, 2011, by Michael Wetter:<br/>
New implementation due to changes from polynomial to cubic hermite splines.
</li>
</ul>
</html>"));
end Characteristics;
