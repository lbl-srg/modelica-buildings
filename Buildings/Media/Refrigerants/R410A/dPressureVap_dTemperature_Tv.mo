within Buildings.Media.Refrigerants.R410A;
function dPressureVap_dTemperature_Tv
  "Derivative of the Martin-Hou equation of state with regards to temperature"

  input Modelica.SIunits.Temperature T
    "Temperature of refrigerant";
  input Modelica.SIunits.SpecificVolume v
    "Specific volume of refrigerant";
  output Real dpdT(
    final unit="Pa/K")
     "Derivative of pressure with regards to temperature";

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

  Modelica.SIunits.Temperature TCri = 345.25
    "Critical temperature of refrigerant";

  Modelica.SIunits.SpecificVolume v_abs
    "Smoothed specific volume";

  parameter Integer n = size(A, 1);

algorithm

  v_abs := Buildings.Utilities.Math.Functions.smoothMax(v, 1.01*b, 0.01*b);

  dpdT := R/(v_abs-b);
  for i in 1:n loop
    dpdT := dpdT + (B[i] - C[i]*k/TCri*Modelica.Math.exp(-k*T/TCri))/(v_abs - b)^(i+1);
  end for;

annotation (smoothOrder=1,
preferredView="info",Documentation(info="<HTML>
<p>
Function that calculates the derivative of the Martin-Hou equation of for R410A
state with regards to temperature.
</p>
<h4>References</h4>
<p>
Thermodynamic properties of DuPont Suva 410A:
<a href=\"https://www.chemours.com/Refrigerants/en_US/assets/downloads/h64423_Suva410A_thermo_prop_si.pdf\">
https://www.chemours.com/Refrigerants/en_US/assets/downloads/h64423_Suva410A_thermo_prop_si.pdf
</a>
</p>
</html>",   revisions="<html>
<ul>
<li>
November 30, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end dPressureVap_dTemperature_Tv;
