within Buildings.Utilities.Psychrometrics.Functions;
function TDewPoi_pW
  "Function to compute the water vapor partial pressure for a given dew point temperature of moist air"
  extends Modelica.Icons.Function;

  input Modelica.Units.SI.Pressure p_w(displayUnit="Pa", min=200)
    "Water vapor partial pressure";
  output Modelica.Units.SI.Temperature T "Dew point temperature";

protected
  function pW_TDewPoi_inversion
    "Internal function to solve eps=f(NTU, Z) for NTU for cross flow unmixed"
    extends Modelica.Math.Nonlinear.Interfaces.partialScalarFunction;

    input Modelica.Units.SI.Pressure p_w(displayUnit="Pa", min=200)
      "Water vapor partial pressure";

  algorithm
    y :=Buildings.Utilities.Psychrometrics.Functions.pW_TDewPoi(T=u) - p_w;
  end pW_TDewPoi_inversion;

algorithm
  T := Modelica.Math.Nonlinear.solveOneNonlinearEquation(
      f=function pW_TDewPoi_inversion(p_w=p_w),
      u_min=200,
      u_max=400);
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
February 28, 2020, by Michael Wetter:<br/>
Replaced call to <code>Media.Common.OneNonLinearEquation</code> to use
<a href=\"modelica://Modelica.Math.Nonlinear.solveOneNonlinearEquation\">
Modelica.Math.Nonlinear.solveOneNonlinearEquation</a>
because <code>Media.Common.OneNonLinearEquation</code> will be obsolete in MSL 4.0.0.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1299\">issue 1299</a>.
</li>
<li>
April 29, 2014 by Michael Wetter:<br/>
Added dummy argument to <code>Internal.solve</code> to avoid a warning
in Dymola 2015.
</li>
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
        Inline=true);
end TDewPoi_pW;
