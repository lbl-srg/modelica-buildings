within Buildings.Fluid.HeatExchangers.BaseClasses;
function DynamicViscosityWater "Returns the dynamic viscosity for water"
    input Modelica.SIunits.Temperature T "Thermodynamic state record";
    output Modelica.SIunits.DynamicViscosity mu "Dynamic viscosity";
algorithm
        mu := ((2.86651*10^(-5))*T^4-0.039376307*T^3+20.32805026*T^2-4680.303158*T+406389.0375)*10^(-6);
        //Equation is a fourth order polynomial fit to data from Fundamentals of Heat and Mass Transfer (Fourth Edition), Frank Incropera & David DeWitt, John Wiley & Sons, 1996

end DynamicViscosityWater;
