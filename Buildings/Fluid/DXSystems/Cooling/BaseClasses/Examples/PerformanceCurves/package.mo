within Buildings.Fluid.DXSystems.Cooling.BaseClasses.Examples;
package PerformanceCurves "Package with sevral performance curves"

  annotation (Documentation(info="<html>
<p>
This package contains performance curves for the cooling capacity and the EIR
of DX cooling coils that are used in the examples.
</p>
<p>
The data are described in
<a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.Coil\">
Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.Coil</a>.
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
