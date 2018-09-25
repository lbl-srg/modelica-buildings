within Buildings.Media.Refrigerants.R410A;
function specificIsobaricHeatCapacityVap_Tv
  "Function that calculates the specific isobaric heat capacity of R410A vapor based on temperature and specific volume"
  input Modelica.SIunits.Temperature T
    "Temperature of refrigerant";
  input Modelica.SIunits.SpecificVolume v
    "Specific volume of refrigerant";
  output Modelica.SIunits.SpecificHeatCapacity cp
    "Specific isobaric heat capacity";

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

  Real dpdT
    "First derivative w.r.t. temperature of the Martin-Hou equation";

  Real dpdv
    "First derivative w.r.t. specific volume of the Martin-Hou equation";

  Modelica.SIunits.SpecificHeatCapacity cv
    "Specific isochoric heat capacity";

  Modelica.SIunits.Temperature TCri = 345.25
    "Critical temperature of refrigerant";

  parameter Integer n = size(A, 1);

algorithm

  cv := Buildings.Media.Refrigerants.R410A.specificIsochoricHeatCapacityVap_Tv(T, v);
  dpdT := Buildings.Media.Refrigerants.R410A.dPressureVap_dTemperature_Tv(T, v);
  dpdv := Buildings.Media.Refrigerants.R410A.dPressureVap_dSpecificVolume_Tv(T, v);

  cp := cv - T * dpdT^2 / dpdv;

annotation (smoothOrder=1,
preferredView="info",Documentation(info="<HTML>
<p>
Function that calculates the specific isobaric heat capacity (<i>c<sub>p</sub></i>) of R410A vapor based on temperature and specific volume.
</p>
<p>
The specific isobaric heat capacity is evaluated from the partial derivatives of the Martin-Hou equation of state.
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
end specificIsobaricHeatCapacityVap_Tv;
