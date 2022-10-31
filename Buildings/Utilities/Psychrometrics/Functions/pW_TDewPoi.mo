within Buildings.Utilities.Psychrometrics.Functions;
function pW_TDewPoi
  "Function to compute the water vapor partial pressure for a given dew point temperature of moist air"
  extends Modelica.Icons.Function;
  input Modelica.Units.SI.Temperature T(min=100) "Dew point temperature";
  output Modelica.Units.SI.Pressure p_w(displayUnit="Pa", min=100)
    "Water vapor partial pressure";
protected
  constant Real C8=-5.800226E3;
  constant Real C9=1.3914993E0;
  constant Real C10=-4.8640239E-2;
  constant Real C11=4.1764768E-5;
  constant Real C12=-1.4452093E-8;
  constant Real C13=6.5459673E0;

algorithm
  p_w := Modelica.Math.exp(C8/T + C9 + T*(C10 + T*(C11 + T*C12)) + C13*
    Modelica.Math.log(T));
  annotation (
    Documentation(info="<html>
<p>
Dew point temperature calculation for moist air above freezing temperature.
</p>
<p>
The correlation used in this model is valid for dew point temperatures between
<i>0</i>&deg;C and <i>200</i>&deg;C. It is the correlation from 2005
ASHRAE Handbook, p. 6.2. In an earlier version of this model, the equation from
Peppers has been used, but this equation yielded about <i>15</i> Kelvin lower dew point
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
    Inline=true,
    smoothOrder=99,
    derivative=BaseClasses.der_pW_TDewPoi);
end pW_TDewPoi;
