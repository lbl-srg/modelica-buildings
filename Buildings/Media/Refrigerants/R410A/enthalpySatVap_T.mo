within Buildings.Media.Refrigerants.R410A;
function enthalpySatVap_T
  "Function that calculates the specific enthalpy of saturated R410A vapor based on temperature"
  input Modelica.SIunits.Temperature T
    "Temperature of refrigerant";
  output Modelica.SIunits.SpecificEnthalpy h
    "Specific enthalpy of saturated liquid refrigerant";

protected
  final constant Real a[:] = {406.0598, -34.78156, 262.8079, 223.8549, -1162.627, 570.6635}
    "Coefficients for polynomial equation";

  Real x
    "Independent variable";

algorithm
  // Independent variable
  x := Buildings.Utilities.Math.Functions.smoothMax(1-T/TCri, 1e-4, 5e-3)^(1/3);
  // Pressure of saturated liquid refrigerant
  h := 1000*Buildings.Utilities.Math.Functions.polynomial(a = a, x = x);

annotation (smoothOrder=1,
preferredView="info",Documentation(info="<HTML>
<p>
Function that calculates the specific enthalpy of saturated R410A vapor based
on temperature.
</p>
<h4>References</h4>
<p>
Thermodynamic properties of DuPont Suva 410A:
<a href=\"https://www.chemours.com/Refrigerants/en_US/assets/downloads/h64423_Suva410A_thermo_prop_si.pdf\">
https://www.chemours.com/Refrigerants/en_US/assets/downloads/h64423_Suva410A_thermo_prop_si.pdf
</a>
</p>
</html>", revisions="<html>
<ul>
<li>
October 17, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end enthalpySatVap_T;
