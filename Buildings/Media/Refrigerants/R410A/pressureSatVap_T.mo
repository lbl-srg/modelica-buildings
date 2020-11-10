within Buildings.Media.Refrigerants.R410A;
function pressureSatVap_T
  "Function that calculates the pressure of saturated R410A vapor based on temperature"
  input Modelica.SIunits.Temperature T
    "Temperature of refrigerant";
  output Modelica.SIunits.AbsolutePressure p
    "Pressure of saturated refrigerant vapor";

protected
  final Real a[:] = {-1.440004, -6.865265, -0.5354309, -3.749023, -3.521484, -7.75}
    "Coefficients for polynomial equation";

  final Real x0 = 0.2086902
    "x0 for saturation pressure of refrigerant vapor";

  Real x
    "Independent variable";

algorithm
  // Independent variable
  x := Buildings.Utilities.Math.Functions.smoothMax(1-T/TCri, 1e-4, 5e-3) - x0;
  // Pressure of saturated refrigerant vapor
  p := pCri*Modelica.Math.exp(TCri/T*Buildings.Utilities.Math.Functions.polynomial(a = a, x = x));

annotation (smoothOrder=1,
preferredView="info",Documentation(info="<HTML>
<p>
Function that calculates the pressure of saturated R410A vapor based on temperature.
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
end pressureSatVap_T;
