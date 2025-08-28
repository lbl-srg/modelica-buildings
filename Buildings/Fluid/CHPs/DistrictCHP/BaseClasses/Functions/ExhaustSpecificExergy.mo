within Buildings.Fluid.CHPs.DistrictCHP.BaseClasses.Functions;
function ExhaustSpecificExergy
  "Correlation function used to calculate the exhaust specific exergy"
  extends Modelica.Icons.Function;

  input Modelica.Units.NonSI.Temperature_degF TExh
    "Exhaust gas temperature in degrees Fahrenheit";
  output Real a_Exh
    "Exhaust gas specific exergy (Btu/lb)";

algorithm
  a_Exh:=0.196*(TExh)-86.918
  "The correlation function to calculate the specific exergy in unit of Btu/lb";
annotation (Documentation(info="<html>
<p>
This function calculates the specific exergy for exhaust gas
</p>
<p align=\"center\">
<i>
a<sub>exh</sub> = 0.196 T<sub>exh</sub> - 86.918 [Btu/lb],
</i>
</p>
<p>
where
<i>a<sub>exh</sub></i> is the exhaust specific exergy (in Btu/lb),
and <i>T<sub>exh</sub></i> is the exhaust temperature in Fahrenheit.
</p>
<h4>References</h4>
<p>
Gülen, S. (2019).
<a href=\"https://doi.org/10.1201/9780429244360\">
Gas Turbine Combined Cycle Power Plants (1st ed.)</a>
CRC Press.
</p>
<p>
Gülen, S. (2019).
<a href=\"https://doi.org/10.1017/9781108241625\">
Gas Turbines for Electric Power Generation.</a>
Cambridge University Press. 
</p>
</html>", revisions="<html>
<ul>
<li>
February 18, 2024, by Zhanwei He:<br/>
First implementation.
</li>
</ul>
</html>"));
end ExhaustSpecificExergy;
