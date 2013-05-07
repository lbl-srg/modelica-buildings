within Buildings.Fluid.HeatExchangers.BaseClasses;
function prandtlNumberWater "Returns the prandtl number for water"
    input Modelica.SIunits.Temperature T "Thermodynamic state record";
    output Real Pr "Dynamic viscosity";
algorithm
        Pr := ((2.55713*10^(-7))*T^4-0.000350293*T^3+0.180259651*T^2-41.34104323*T+3571.372195);
        //Equation is a fourth order polynomial fit to data from Fundamentals of Heat and Mass Transfer (Fourth Edition), Frank Incropera & David DeWitt, John Wiley & Sons, 1996

end prandtlNumberWater;
