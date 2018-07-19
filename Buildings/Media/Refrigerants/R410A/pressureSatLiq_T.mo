within Buildings.Media.Refrigerants.R410A;
function pressureSatLiq_T
  "Function that calculates the pressure of saturated liquid R410A based on temperature"
  input Modelica.SIunits.Temperature T
    "Temperature of  refrigerant";
  output Modelica.SIunits.AbsolutePressure p
    "Pressure of saturated liquid refrigerant";

protected
  final Real a[:] = {-1.4376, -6.8715, -0.53623, -3.82642, -4.06875, -1.2333}
    "Coefficients for polynomial equation";

  final Real x0 = 0.2086902
    "x0 for saturation pressure of liquid refrigerant";

  final Modelica.SIunits.Temperature TCri = 345.25
    "Critical temperature of refrigerant";

  final Modelica.SIunits.AbsolutePressure pCri = 4925.1e3
    "Critical pressure of refrigerant";

  Real x
    "Independent variable";

algorithm
  // Independent variable
  x := Buildings.Utilities.Math.Functions.smoothMax(1-T/TCri, 1e-4, 5e-3) - x0;
  // Pressure of saturated liquid refrigerant
  p := pCri*Modelica.Math.exp(TCri/T*Buildings.Utilities.Math.Functions.polynomial(a = a, x = x));

annotation (smoothOrder=1,
preferredView="info",Documentation(info="<HTML>
<p>
Function that calculates the pressure of saturated liquid R410A based on temperature.
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
end pressureSatLiq_T;
