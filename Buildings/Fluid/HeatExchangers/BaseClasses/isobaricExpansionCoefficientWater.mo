within Buildings.Fluid.HeatExchangers.BaseClasses;
function isobaricExpansionCoefficientWater
  "Returns the isobaric expansion coefficient for water"
  input Modelica.Units.SI.Temperature T "Thermodynamic state record";
    output Real beta( unit="1/K") "Dynamic viscosity";
algorithm
        beta := (-8.53296*10^(-6)*T^4+0.011562287*T^3-5.88800657*T^2+
        1341.798661*T-115406.5225)*10^(-6);
        //Equation is a fourth order polynomial fit to data from Fundamentals of
        //Heat and Mass Transfer (Fourth Edition), Frank Incropera & David DeWitt,
        //John Wiley & Sons, 1996

annotation(Documentation(info = "<html>
<p>
This function is used to identify the isobaric expansion coefficient of water at a
given temperature. The function used is a fourth order polynomial fit to data from
Incropera and Dewitt (1996).
</p>
<h4>References</h4>
<p>
Fundamentals of Heat and Mass Transfer (Fourth Edition), Frank Incropera and David P.
Dewitt, John Wiley &amp; Sons, 1996
</p>
</html>",
revisions="<html>
<ul>
<li>
May 7, 2013 by Peter Grant:<br/>
First implementation.
</li>
</ul>
</html>"));
end isobaricExpansionCoefficientWater;
