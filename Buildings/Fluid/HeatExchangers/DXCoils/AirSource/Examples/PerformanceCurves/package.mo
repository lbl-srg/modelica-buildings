within Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Examples;
package PerformanceCurves "Package with several performance curves"




  annotation (Documentation(info="<html>
<p>
This package contains performance curves for the coil heat transfer capacity and the EIR
of air source DX cooling and heating coils that are used in the examples.
</p>
<p>
For performance data of specific air source DX cooling coils, see the packages
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.SingleSpeed\">
Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.SingleSpeed</a>
and
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.DoubleSpeed\">
Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.DoubleSpeed</a>.
</p>
<p>
The data are described in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.CoolingCoil\">
Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.CoolingCoil</a> and
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.HeatingCoil\">
Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.HeatingCoil</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 19, 2023 by Xing Lu and Karthik Devaprasad:<br/>
Added performance curves for DX heating coils.<br/>
Added prefix <code>DXCooling_</code> to performance curves for cooling coil.
</li>
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
