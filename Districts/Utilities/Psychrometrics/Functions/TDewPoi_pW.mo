within Districts.Utilities.Psychrometrics.Functions;
function TDewPoi_pW
  "Function to compute the water vapor partial pressure for a given dew point temperature of moist air"

  input Modelica.SIunits.Pressure p_w(displayUnit="Pa", min=200)
    "Water vapor partial pressure";
  output Modelica.SIunits.Temperature T "Dew point temperature";

algorithm
  T := Internal.solve(
    y_zero=p_w,
    x_min=200,
    x_max=400);
  annotation (
    Documentation(info="<html>
<p>
Dew point temperature calculation for moist air above freezing temperature.
</p>
<p>
The correlation used in this model is valid for dew point temperatures between 
<code>0 degC</code> and <code>200 degC</code>. It is the correlation from 2005
ASHRAE Handbook, p. 6.2. In an earlier version of this model, the equation from
Peppers has been used, but this equation yielded about 15 Kelvin lower dew point 
temperatures.
</p>
</html>", revisions="<html>
<ul>
<li>
March 9, 2012 by Michael Wetter:<br/>
Added <code>smoothOrder=99</code> and <code>displayUnit</code> for pressure.
</li>
<li>
February 17, 2010 by Michael Wetter:<br/>
Renamed function from <code>dewPointTemperature</code> to <code>pW_TDewPoi</code>.
</li>
<li>
February 6, 2010 by Michael Wetter:<br/>
Fixed derivative implementation.
</li>
<li>
September 4, 2008 by Michael Wetter:<br/>
Changed from causal to acausal ports, needed, for example, for
<a href=\"modelica://Buildings.Fluid.Examples.MixingVolumeMoistAir\">
Buildings.Fluid.Examples.MixingVolumeMoistAir</a>.
</li>
<li>
August 7, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics),
        Inline=true);
end TDewPoi_pW;
