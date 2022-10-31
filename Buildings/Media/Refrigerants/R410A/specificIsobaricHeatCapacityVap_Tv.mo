within Buildings.Media.Refrigerants.R410A;
function specificIsobaricHeatCapacityVap_Tv
  "Function that calculates the specific isobaric heat capacity of R410A vapor based on temperature and specific volume"
  input Modelica.Units.SI.Temperature T "Temperature of refrigerant";
  input Modelica.Units.SI.SpecificVolume v "Specific volume of refrigerant";
  output Modelica.Units.SI.SpecificHeatCapacity cp
    "Specific isobaric heat capacity";

protected
  Real dpdT
    "First derivative w.r.t. temperature of the Martin-Hou equation";

  Real dpdv
    "First derivative w.r.t. specific volume of the Martin-Hou equation";

  Modelica.Units.SI.SpecificHeatCapacity cv "Specific isochoric heat capacity";

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
November 8, 2020, by Michael Wetter:<br/>
Removed non-used parameters.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1414\">#1414</a>.
</li>
<li>
October 31, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end specificIsobaricHeatCapacityVap_Tv;
