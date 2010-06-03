within Buildings.Utilities.Psychrometrics.Functions;
function pW_Tdp_amb
  "Function to compute the water vapor partial pressure for a given dew point temperature of moist air"
  extends Buildings.Utilities.Psychrometrics.Functions.BaseClasses.pW_Tdp_amb;

  input Modelica.SIunits.Temperature T "Dew point temperature";
  output Modelica.SIunits.Pressure p_w "Water vapor partial pressure";

algorithm
  p_w := Modelica.Math.exp(a1 + a2*T);
  annotation (
    inverse(T=Tdp_pW_amb(p_w)),
    smoothOrder=1,
    derivative=BaseClasses.der_pW_Tdp_amb,
    Documentation(info="<html>
<p>
Dew point temperature calculation for moist air between <i>0 degC</i> and <i>30 degC</i>.
</p>
<p>
The correlation used in this model is valid for dew point temperatures between 
<tt>0 degC</tt> and <tt>30 degC</tt>. It is an approximation to the correlation from 2005
ASHRAE Handbook, p. 6.2, which is valid in a wider range of temperatures and implemented
in
<a href=\"modelica:Buildings.Utilities.Psychrometrics.Functions.pW_Tdp\">
Buildings.Utilities.Psychrometrics.Functions.pW_Tdp</a>.
The approximation error of this simplified function is below 5% for a 
temperature of <tt>0 degC</tt> to <tt>30 degC</tt>.
The benefit of this simpler function is that it can be inverted analytically,
whereas the other function requires a numerical solution.
</p>
</html>", revisions="<html>
<ul>
<li>
May 21, 2010 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics));
end pW_Tdp_amb;
