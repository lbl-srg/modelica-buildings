within Buildings.Fluid.CHPs.DistrictCHP.BaseClasses.Functions;
function SteamToExhaustMassFlowRatio
  "Ratio of mass flow rate between the steam and the exhaust"
  extends Modelica.Icons.Function;

  input Modelica.Units.NonSI.Temperature_degF TExh
    "Exhaust gas temperature in degrees Fahrenheit";
  input Modelica.Units.NonSI.Temperature_degF TSte
    "Superheated steam temperature in degrees Fahrenheit";
  input Real a[3]
    "Coefficients";
  output Real y
    "Calculated ratio of steam to exhaust gas flow rates";

algorithm
  y := a[1] + a[2]*(TExh/100-11)-a[3]*((TSte -1050)/25);

annotation (Documentation(info="<html>
<p>
This correlation function has the form
</p>
<p align=\"center\">
<i>
y = a<sub>1</sub> + a<sub>2</sub> (T<sub>exh</sub> &frasl; 100 -11) - a<sub>3</sub>
(T<sub>ste</sub> -1050)&frasl; 25 ,
</i>
</p>
<p>
where <i>T<sub>exh</sub></i> is the exhaust gas temperature (in &deg;F) from the
gas turbine in the topping cycle,
<i>T<sub>ste</sub></i> is the superheated steam temperature (in &deg;F) in
the outlet of HRSG. 
</p>
<h4>References</h4>
<p>
Gülen, S. (2019).
<a href=\"https://doi.org/10.1201/9780429244360\">
Gas Turbine Combined Cycle Power Plants (1st ed.)</a>.
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
February 8, 2023, by Zhanwei He:<br/>
First implementation.
</li>
</ul>
</html>"));
end SteamToExhaustMassFlowRatio;
