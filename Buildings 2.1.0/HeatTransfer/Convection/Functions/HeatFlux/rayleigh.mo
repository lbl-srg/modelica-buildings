within Buildings.HeatTransfer.Convection.Functions.HeatFlux;
function rayleigh "Rayleigh number with smooth transition to lower limit"
  extends Modelica.Icons.Function;
 input Modelica.SIunits.Length x "Layer thickness";
 input Modelica.SIunits.Density rho "Mass density";
 input Modelica.SIunits.SpecificHeatCapacity c_p "Specific heat capacity";
 input Modelica.SIunits.DynamicViscosity mu "Dynamic viscosity";
 input Modelica.SIunits.ThermalConductivity k "Thermal conductivity";
 input Modelica.SIunits.Temperature T_a "Temperature of surface a";
 input Modelica.SIunits.Temperature T_b "Temperature of surface b";
 input Real Ra_min "Minimum value for Rayleigh number";
 output Real Ra "Rayleigh number";
protected
 Modelica.SIunits.TemperatureDifference dT "Temperature difference";
algorithm
  dT :=abs(T_a - T_b);
  Ra := rho^2*x^3*Modelica.Constants.g_n*c_p*dT/((T_a+T_b)/2*mu*k);
  Ra := Buildings.Utilities.Math.Functions.smoothMax(x1=Ra, x2=Ra_min, deltaX=Ra_min/10);
annotation (smoothOrder=1,
Documentation(info="<html>
This function returns the Rayleigh number.
The parameter <code>RaMin</code> is used to transition
to a lower limit for the Rayleigh number.
This is helpful to avoid a Rayleigh number of zero or
to avoid an expression for a convection coefficient that
has an infinite derivative near zero, i.e., if <i>h=f(Ra<sup>(1/2)</sup>)</i>.
</html>",
revisions="<html>
<ul>
<li>
July 2, 2013, by Michael Wetter:<br/>
Renamed function from <code>raleigh</code> to <code>rayleigh</code>.
</li>
<li>
August 18 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end rayleigh;
