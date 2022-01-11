within Buildings.Media.Refrigerants.R410A;
function dPressureVap_dSpecificVolume_Tv
  "Derivative of the Martin-Hou equation of state with regards to specific volume"

  input Modelica.Units.SI.Temperature T "Temperature of refrigerant";
  input Modelica.Units.SI.SpecificVolume v "Specific volume of refrigerant";
  output Real dpdv(
    final unit="Pa.kg/m3")
     "Derivative of pressure with regards to specific volume";

protected
  Modelica.Units.SI.SpecificVolume v_abs "Smoothed specific volume";

algorithm

  v_abs := Buildings.Utilities.Math.Functions.smoothMax(v, 1.01*b, 0.01*b);

  dpdv := -R*T/(v_abs-b)^2;
  for i in 1:size(A, 1) loop
    dpdv := dpdv - (i+1)*(A[i] + B[i]*T + C[i]*Modelica.Math.exp(-k*T/TCri))/(v_abs - b)^(i+2);
  end for;

annotation (smoothOrder=1,
preferredView="info",Documentation(info="<HTML>
<p>
Function that calculates the derivative of the Martin-Hou equation of for R410A
state with regards to specific volume.
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
November 30, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end dPressureVap_dSpecificVolume_Tv;
