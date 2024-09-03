within Buildings.HeatTransfer.Convection.Functions.HeatFlux;
function rayleigh "Rayleigh number with smooth transition to lower limit"
  extends Modelica.Icons.Function;
  input Modelica.Units.SI.Length x "Layer thickness";
  input Modelica.Units.SI.Density rho "Mass density";
  input Modelica.Units.SI.SpecificHeatCapacity c_p "Specific heat capacity";
  input Modelica.Units.SI.DynamicViscosity mu "Dynamic viscosity";
  input Modelica.Units.SI.ThermalConductivity k "Thermal conductivity";
  input Modelica.Units.SI.Temperature T_a "Temperature of surface a";
  input Modelica.Units.SI.Temperature T_b "Temperature of surface b";
 input Real Ra_min "Minimum value for Rayleigh number";
 output Real Ra "Rayleigh number";
protected
  Modelica.Units.SI.TemperatureDifference dT "Temperature difference";
algorithm
  Ra := Buildings.Utilities.Math.Functions.smoothMax(
    x1=rho^2*x^3*Modelica.Constants.g_n*c_p*abs(T_a - T_b)/((T_a+T_b)/2*mu*k),
    x2=Ra_min,
    deltaX=Ra_min/10);
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
May 21, 2015, by Michael Wetter:<br/>
Reformulated to reduce use of the division macro
in Dymola.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/417\">issue 417</a>.
</li>
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
