within Buildings.Media.Refrigerants.R410A;
function isentropicExponentVap_Tv
  "Function that calculates the isentropic exponent of R410A vapor based on temperature and specific volume"
  input Modelica.Units.SI.Temperature T "Temperature of refrigerant";
  input Modelica.Units.SI.SpecificVolume v "Specific volume of refrigerant";
  output Modelica.Units.SI.IsentropicExponent k
    "Specific isobaric heat capacity";

protected
  Modelica.Units.SI.SpecificHeatCapacity cp "Specific isobaric heat capacity";

  Modelica.Units.SI.SpecificHeatCapacity cv "Specific isochoric heat capacity";

algorithm
  // Evaluate the specific isobaric and isochoric heat capacities
  cp := Buildings.Media.Refrigerants.R410A.specificIsobaricHeatCapacityVap_Tv(T, v);
  cv := Buildings.Media.Refrigerants.R410A.specificIsochoricHeatCapacityVap_Tv(T, v);

  k := cp / cv;

annotation (smoothOrder=1,
preferredView="info",Documentation(info="<HTML>
<p>
Function that calculates the isentropic exponent of R410A vapor based on temperature and specific volume. The isentropic exponent is equal to the ratio of specific heat capacities:
</p>
<p align=\"center\" style=\"font-style:italic;\">
k = c<sub>p</sub>/c<sub>v</sub>
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
end isentropicExponentVap_Tv;
