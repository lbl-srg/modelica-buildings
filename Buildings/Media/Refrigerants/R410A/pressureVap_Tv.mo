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
  Modelica.SIunits.SpecificVolume v_abs
    "Smoothed specific volume";

algorithm
  v_abs := Buildings.Utilities.Math.Functions.smoothMax(v, 1.01*b, 0.01*b);

  p := R*T/(v_abs-b);
  for i in 1:size(A, 1) loop
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
November 8, 2020, by Michael Wetter:<br/>
Corrected use of dimension <code>n</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1414\">#1414</a>.
</li>
<li>
October 17, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end pressureVap_Tv;
