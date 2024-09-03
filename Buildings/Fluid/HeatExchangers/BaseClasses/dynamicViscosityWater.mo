within Buildings.Fluid.HeatExchangers.BaseClasses;
function dynamicViscosityWater "Returns the dynamic viscosity for water"
  input Modelica.Units.SI.Temperature T "Thermodynamic state record";
  output Modelica.Units.SI.DynamicViscosity mu "Dynamic viscosity";
algorithm
        mu := ((2.86651*10^(-5))*T^4-0.039376307*T^3+20.32805026*T^2-
        4680.303158*T+406389.0375)*10^(-6);
        //Equation is a fourth order polynomial fit to data from Fundamentals of
        //Heat and Mass Transfer (Fourth Edition), Frank Incropera & David DeWitt,
        //John Wiley & Sons, 1996

annotation(Documentation(info = "<html>
<p>
This function is used to identify the dynamic viscosity of water at a given temperature.
The function used is a fourth order polynomial fit to data from Incropera and Dewitt (1996).
</p>
<h4>References</h4>
<p>
Fundamentals of Heat and Mass Transfer (Fourth Edition), Frank Incropera and David P. Dewitt,
John Wiley &amp; Sons, 1996
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
end dynamicViscosityWater;
