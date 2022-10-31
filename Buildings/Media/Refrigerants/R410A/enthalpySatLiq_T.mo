within Buildings.Media.Refrigerants.R410A;
function enthalpySatLiq_T
  "Function that calculates the enthalpy of saturated liquid R410A based on temperature"
  input Modelica.Units.SI.Temperature T "Temperature of refrigerant";
  output Modelica.Units.SI.SpecificEnthalpy h
    "Specific enthalpy of saturated liquid refrigerant";

protected
  final constant Real a[:] = {221.1749, -514.9668, -631.625, -262.2749, 1052.0, 1596.0}
    "Coefficients for polynomial equation";

  final constant Real x0 = 0.5541498
    "x0 for saturation pressure of liquid refrigerant";

  Real x
    "Independent variable";

algorithm
  // Independent variable
  x := Buildings.Utilities.Math.Functions.smoothMax(1-T/TCri, 1e-4, 5e-3)^(1/3) - x0;
  // Pressure of saturated liquid refrigerant
  h := 1000*Buildings.Utilities.Math.Functions.polynomial(a = a, x = x);

annotation (smoothOrder=1,
preferredView="info",Documentation(info="<HTML>
<p>
Function that calculates the enthalpy of saturated liquid R410A based on
temperature.
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
end enthalpySatLiq_T;
