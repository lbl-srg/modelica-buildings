within Buildings.Utilities.Psychrometrics.Functions;
function pW_TDewPoi_amb
  "Function to compute the water vapor partial pressure for a given dew point temperature of moist air"
  extends
    Buildings.Utilities.Psychrometrics.Functions.BaseClasses.pW_TDewPoi_amb;

  input Modelica.SIunits.Temperature T "Dew point temperature";
  output Modelica.SIunits.Pressure p_w(displayUnit="Pa", min=100)
    "Water vapor partial pressure";

algorithm
  p_w := Modelica.Math.exp(a1 + a2*T);
  annotation (
    inverse(T=TDewPoi_pW_amb(p_w)),
    smoothOrder=99,
    Inline=true,
    derivative=BaseClasses.der_pW_TDewPoi_amb,
    Documentation(info="<html>
<p>
Dew point temperature calculation for moist air between <i>0 degC</i> and <i>30 degC</i>.
</p>
<p>
The correlation used in this model is valid for dew point temperatures between 
<code>0 degC</code> and <code>30 degC</code>. It is an approximation to the correlation from 2005
ASHRAE Handbook, p. 6.2, which is valid in a wider range of temperatures and implemented
in
<a href=\"modelica://Buildings.Utilities.Psychrometrics.Functions.pW_TDewPoi\">
Buildings.Utilities.Psychrometrics.Functions.pW_TDewPoi</a>.
The approximation error of this simplified function is below 5% for a 
temperature of <code>0 degC</code> to <code>30 degC</code>.
The benefit of this simpler function is that it can be inverted analytically,
whereas the other function requires a numerical solution.
</p>
</html>", revisions="<html>
<ul>
<li>
March 9, 2012 by Michael Wetter:<br/>
Added <code>smoothOrder=99</code> and <code>displayUnit</code> for pressure.
</li>
<li>
May 21, 2010 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics));
end pW_TDewPoi_amb;
