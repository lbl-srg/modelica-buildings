within Buildings.Media.Refrigerants.R410A;
function specificIsochoricHeatCapacityVap_Tv
  "Function that calculates the specific isochoric heat capacity of R410A vapor
  based on temperature and specific volume"
  input Modelica.SIunits.Temperature T
    "Temperature of refrigerant";
  input Modelica.SIunits.SpecificVolume v
    "Specific volume of refrigerant";
  output Modelica.SIunits.SpecificHeatCapacity cv
    "Specific isochoric heat capacity";

protected
  Real a[:] = {2.676087e-1, 2.115353e-3, -9.848184e-7, 6.493781e-11}
    "Coefficients for ideal gas specific isobaric heat capacity";

  Real integral_of_d2pdT2
    "Integral over v of the second derivative w.r.t. temperature of the Martin-Hou equation";

  Modelica.SIunits.SpecificHeatCapacity cpo
    "Ideal gas specific isobaric heat capacity";

  Modelica.SIunits.SpecificHeatCapacity cvo
    "Ideal gas specific isochoric heat capacity";

algorithm
  // Ideal gas isobaric heat capacity from polynomial equation
  cpo := 1.0e3*Buildings.Utilities.Math.Functions.polynomial(a = a, x = T);
  cvo := cpo - R;

  // Integral of second derivative of pressure w.r.t. temperature
  integral_of_d2pdT2 := (k/TCri)^2 * Modelica.Math.exp(-k*T/TCri) * sum(C[i]/(i*(v - b)^(i)) for i in 1:size(C, 1));

  cv := cvo - T * integral_of_d2pdT2;

annotation (smoothOrder=1,
preferredView="info",Documentation(info="<HTML>
<p>
Function that calculates the specific isochoric heat capacity
(<i>c<sub>v</sub></i>) of R410A vapor based on temperature and specific volume.
</p>
<p>
The specific isochoric heat capacity is evaluated from the partial derivatives
of the Martin-Hou equation of state.
</p>
<h4>References</h4>
<p>
F. de Monte. (2002).
Calculation of thermodynamic properties of R407C and
R410A by the Martin-Hou equation of state, part I:
theoretical development.
<i>
International Journal of Refrigeration.
</i>
25. 306-313.
</p>
<p>
<p>
Thermodynamic properties of DuPont Suva 410A:
<a href=\"https://www.chemours.com/Refrigerants/en_US/assets/downloads/h64423_Suva410A_thermo_prop_si.pdf\">
https://www.chemours.com/Refrigerants/en_US/assets/downloads/h64423_Suva410A_thermo_prop_si.pdf
</a>
</p>
</html>", revisions="<html>
<ul>
<li>
November 8, 2020, by Michael Wetter:<br/>
Removed non-used parameters and reformulated integral as a sum, and multiplied sum with common factors.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1414\">#1414</a>.
</li>
<li>
October 31, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end specificIsochoricHeatCapacityVap_Tv;
