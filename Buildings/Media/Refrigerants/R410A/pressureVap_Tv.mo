within Buildings.Media.Refrigerants.R410A;
function pressureVap_Tv
"Function that calculates the pressure R410A vapor based on temperature and specific volume"
input Modelica.SIunits.Temperature T
   "Temperature of refrigerant";
input Modelica.SIunits.SpecificVolume v
   "Specific volume of refrigerant";
output Modelica.SIunits.AbsolutePressure p
   "Pressure of refrigerant vapor";

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

  p := R*T/(v_abs-b);
  for i in 1:n loop
    p := p + (A[i] + B[i]*T + C[i]*Modelica.Math.exp(-k*T/TCri))/(v_abs - b)^(i+1);
  end for;

annotation (smoothOrder=1,
preferredView="info",Documentation(info="<HTML>
<p>
Function that calculates the pressure R410A vapor based on temperature and
specific volume. The pressure is calculated from the Martin-Hou equation of
state.
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
October 17, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end pressureVap_Tv;
