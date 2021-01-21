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
  Modelica.SIunits.SpecificEntropy R = 114.55
    "Refrigerant gas constant for Martin-Hou equation of state";

  Real A[:] = {-1.721781e2, 2.381558e-1, -4.329207e-4, -6.241072e-7}
    "Coefficients A for Martin-Hou equation of state";

  Real B[:] = {1.646288e-1, -1.462803e-5, 0, 1.380469e-9}
    "Coefficients B for Martin-Hou equation of state";

  Real C[:] = {-6.293665e3, 1.532461e1, 0, 1.604125e-4}
    "Coefficients C for Martin-Hou equation of state";

  Real b = 4.355134e-4
    "Coefficient b for Martin-Hou equation of state";

  Real k = 5.75
    "Coefficient K for Martin-Hou equation of state";

  Real a[:] = {2.676087e-1, 2.115353e-3, -9.848184e-7, 6.493781e-11}
    "Coefficients for ideal gas specific isobaric heat capacity";

  Real integral_of_d2pdT2
    "Integral over v of the second derivative w.r.t. temperature of the Martin-Hou equation";

  Modelica.SIunits.SpecificHeatCapacity cpo
    "Ideal gas specific isobaric heat capacity";

  Modelica.SIunits.SpecificHeatCapacity cvo
    "Ideal gas specific isochoric heat capacity";

  Modelica.SIunits.Temperature TCri = 345.25
    "Critical temperature of refrigerant";

  parameter Integer n = size(A, 1);

algorithm
  // Ideal gas isobaric heat capacity from polynomial equation
  cpo := 1.0e3*Buildings.Utilities.Math.Functions.polynomial(a = a, x = T);
  cvo := cpo - R;

  // Integral of second derivative of pressure w.r.t. temperature
  integral_of_d2pdT2 := 0.0;
  for i in 1:n loop
    integral_of_d2pdT2 := integral_of_d2pdT2 + C[i]*Modelica.Math.exp(-k*T/TCri)/(i*(v - b)^(i));
  end for;
  integral_of_d2pdT2 := integral_of_d2pdT2 * (k/TCri)^2;

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
October 31, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end specificIsochoricHeatCapacityVap_Tv;
