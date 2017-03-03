within Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Examples;
package PerformanceCurves "Package with sevral performance curves"

  annotation (Documentation(info="<html>
<p>
This package contains performance curves for the cooling capacity and the EIR
of water-cooled DX cooling coils that are used in the examples.

The data are described in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil\">
Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 17, 2012 by Michael Wetter:<br/>
Moved curves to <code>Examples</code> directory because these curves
are not of general applicability to other models. Users should use the
curve for the actual equipment rather than these curves.
</li>
<li>
July 23, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"));
end PerformanceCurves;
