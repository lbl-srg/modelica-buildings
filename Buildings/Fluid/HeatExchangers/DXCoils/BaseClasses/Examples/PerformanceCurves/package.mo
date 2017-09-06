within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Examples;
package PerformanceCurves "Package with sevral performance curves"

  annotation (Documentation(info="<html>
<p>
This package contains performance curves for the cooling capacity and the EIR
of DX cooling coils that are used in the examples.
</p>
<p>
  For performance data of specific DX cooling coils, see the packages
  <a href=\"Buildings.Fluid.HeatExchangers.DXCoils.Data.SingleSpeed\">
  Buildings.Fluid.HeatExchangers.DXCoils.Data.SingleSpeed</a>
  and
  <a href=\"Buildings.Fluid.HeatExchangers.DXCoils.Data.DoubleSpeed\">
  Buildings.Fluid.HeatExchangers.DXCoils.Data.DoubleSpeed</a>.
</p>
<p>
The data are described in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.DXCoil\">
Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.DXCoil</a>.
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
