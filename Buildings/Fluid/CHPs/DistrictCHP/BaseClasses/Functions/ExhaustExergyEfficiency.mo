within Buildings.Fluid.CHPs.DistrictCHP.BaseClasses.Functions;
function ExhaustExergyEfficiency
  "Correlation function used to calculate the exhaust exergy efficiency"
  extends Modelica.Icons.Function;

  input Modelica.Units.NonSI.Temperature_degF TExh
    "Exhaust gas temperature in degrees Fahrenheit";
  input Real a[3]={0.2441, 0.0746, -0.00279}
    "Coefficients";
  output Real y
    "Exhaust exergy efficiency";

protected
  Real x = TExh/100;
  Real xSq = x^2;

algorithm
  y := a[1] + a[2]*x + a[3]*xSq;

  annotation (Documentation(info="<html>
<p>
This function calculates the exhaust exergy efficiency
</p>
<p align=\"center\">
<i>
y = a<sub>1</sub> + a<sub>2</sub> (T<sub>exh</sub> / 100) + a<sub>3</sub>
(T<sub>exh</sub> / 100)<sup>2</sup> ,
</i>
</p>
<p>
where
<i>T<sub>exh</sub></i> is the exhaust gas temperature (in &deg;F) from the
gas turbine in the topping cycle.
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
end ExhaustExergyEfficiency;
