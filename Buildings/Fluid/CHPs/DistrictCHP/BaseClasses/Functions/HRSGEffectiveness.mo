within Buildings.Fluid.CHPs.DistrictCHP.BaseClasses.Functions;
function HRSGEffectiveness
  "Correlation function used to estimate the HRSG effectiveness"
  extends Modelica.Icons.Function;

  input Modelica.Units.NonSI.Temperature_degF TExh
    "Exhaust gas temperature in degrees Fahrenheit";
  input Modelica.Units.NonSI.Temperature_degF TSta
    "Exhaust stack temperature in degrees Fahrenheit";
  input Modelica.Units.NonSI.Temperature_degF TAmb
    "Ambient temperature in degrees Fahrenheit";
  output Real y
    "Calculated HRSG effectiveness";

algorithm
  if abs(TAmb -59) < abs(TAmb-77) then
  // The zero ethalpy reference tempeature is set at 59 degF
  y:= 1- (0.2443*TSta- 13.571)/(0.3003*TExh - 55.576);
  else
  // The zero ethalpy reference tempeature is set at 77 degF
  y:= 1- (0.2443*TSta -17.892)/(0.3003*TExh - 59.897);
  end if;
annotation (Documentation(info="<html>
<p>
This correlation function calculates the effectiveness of the HRSG based on a zero
ethalpy reference temperature of either 59 or 77 degrees of Fahrenheit.
This correlation function has the form
</p>
<p align=\"center\">
<i>
&eta;<sub>HRSG</sub> = 1 - h<sub>sta</sub> &frasl; h<sub>exh</sub>,
</i>
</p>
<p>
where <i>h<sub>exh</sub></i> is the exhaust gas specific enthalpy (in Btu/lb),
<i>and h<sub>sta</sub></i> is the exhaust stack specific enthalpy (in Btu/lb).
</p>
<p>
The specific enthalpy for both the exhaust gas and exhaust stack is estimated
using a zero enthalpy reference temperature.
When the reference temperature is set at 59 &deg;F, the corresponding correlation
functions are:
</p>
<p align=\"center\">
<i>
h<sub>exh</sub> = 0.3003T<sub>exh</sub> - 55.576 [Btu/lb], 
<br/>
h<sub>sta</sub> = 0.2443T<sub>sta</sub> - 13.571 [Btu/lb].
</i>
</p>

<p>
When the reference temperature is set at 77 &deg;F, the corresponding correlation
functions are:
</p>
<p align=\"center\">
<i>
h<sub>exh</sub> = 0.3003T<sub>exh</sub> - 59.897 [Btu/lb],
<br/>
h<sub>sta</sub> = 0.2443T<sub>sta</sub> - 17.892 [Btu/lb],
</i>
</p>
<p>
where
<i>T<sub>exh</sub></i> is the exhaust gas temperature (in Fahrenheit) from the gas turbine,
<i>T<sub>sta</sub></i> is the exhaust stack temperature (in Fahrenheit).
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
February 16, 2023, by Zhanwei He:<br/>
First implementation.
</li>
</ul>
</html>"));
end HRSGEffectiveness;
