within Buildings.Fluid.HeatExchangers.BaseClasses;
function prandtlNumberWater "Returns the Prandtl number for water"
  input Modelica.Units.SI.Temperature T "Thermodynamic state record";
    output Real Pr "Prandtl number";
algorithm
        Pr := ((2.55713*10^(-7))*T^4-0.000350293*T^3+0.180259651*T^2-
        41.34104323*T+3571.372195);
        //Equation is a fourth order polynomial fit to data from Fundamentals
        //of Heat and Mass Transfer (Fourth Edition), Frank Incropera & David DeWitt,
        //John Wiley & Sons, 1996

annotation(Documentation(info = "<html>
<p>
This function is used to identify the Prandtl number of water at a given temperature.
The function used is a fourth order polynomial fit to data from Incropera and Dewitt
(1996).
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
end prandtlNumberWater;
