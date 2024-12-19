within GED.DistrictElectrical.CHP.BaseClasses;
package Functions "This package contains functions for used in the blocks."
    extends Modelica.Icons.VariantsPackage;

  function SteamToExhaustMassFlowRatio
    "Correlation function used to calculate
   the ratio of steam to exhaust gas flow rates"
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
<p>This correlation function has the form</p>

<p align=\"center\">
<i>
y = a<sub>1</sub> + a<sub>2</sub> (T<sub>exh</sub> &frasl; 100 -11) - a<sub>3</sub> (T<sub>ste</sub> -1050)&frasl; 25 ,
</i>
</p>

<p>
where
<i>T<sub>exh</sub></i> is the exhaust gas temperature (in Fahrenheit) from the gas turbine in the topping cycle, 
<i>T<sub>ste</sub></i> is the superheated steam temperature (in Fahrenheit) in the outlet of HRSG. 
</p>

<h4>References</h4>
<p>
Gülen, S. (2019). <i> Gas Turbine Combined Cycle Power Plants (1st ed.) </i>. CRC Press.
<a href=\"https://doi.org/10.1201/9780429244360\">[Link]</a>
</p>

<p>
Gülen, S. (2019) <i> Gas Turbines for Electric Power Generation.</i> Cambridge University Press. 
<a href=\"https://doi.org/10.1017/9781108241625\">[Link]</a>
</p>

</html>",
  revisions="<html>
<ul>
<li>
February 8, 2023, by Zhanwei He:<br/>
First implementation.
</li>
</ul>
</html>"));
  end SteamToExhaustMassFlowRatio;

  function HRSGEffectiveness
    "Correlation function used to estimate the HRSG effectiveness"
    extends Modelica.Icons.Function;

    input Modelica.Units.NonSI.Temperature_degF TExh
      "Exhaust gas temperature";
    input Modelica.Units.NonSI.Temperature_degF TSta
      "Exhaust stack temperature";
    input Modelica.Units.NonSI.Temperature_degF TAmb
      "Ambient temperature";
    output Real y
      "Calculated HRSG effectiveness";

  algorithm
    if abs(TAmb -59) < abs(TAmb-77) then
    // The zero ethalpy reference tempeature is set at 59°F
    y:= 1- (0.2443*TSta- 13.571)/(0.3003*TExh - 55.576);
    else
    // The zero ethalpy reference tempeature is set at 77°F
    y:= 1- (0.2443*TSta -17.892)/(0.3003*TExh - 59.897);
    end if;
  annotation (Documentation(info="<html>
<p>
This correlation function calculates the effectiveness of the HRSG based on a zero ethalpy reference temperature
  of either 59 or 77 degrees of Fahrenheit. This correlation function has the form
</p>

<p align=\"center\">
<i>
&eta;<sub>HRSG</sub> = 1 - h<sub>sta</sub> &frasl; h<sub>exh</sub>,
</i>
</p>

<p>
where
<i>h<sub>exh</sub></i> is the exhaust gas specific enthalpy (in Btu/lb),
<i>and h<sub>sta</sub></i> is the exhaust stack specific enthalpy (in Btu/lb).
</p>

<p>
The specific enthalpy for both the exhaust gas and exhaust stack is estimated using a zero enthalpy reference temperature. 
When the reference temperature is set at 59°F, the corresponding correlation functions are:
</p>

<p align=\"center\">
<i>
h<sub>exh</sub> = 0.3003T<sub>exh</sub> - 55.576 [Btu/lb], 
<br/>
h<sub>sta</sub> = 0.2443T<sub>sta</sub> - 13.571 [Btu/lb].
</i>
</p>

<p>
When the reference temperature is set at 77°F, the corresponding correlation functions are:
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
Gülen, S. (2019). <i> Gas Turbine Combined Cycle Power Plants (1st ed.) </i>. CRC Press.
<a href=\"https://doi.org/10.1201/9780429244360\">[Link]</a>
</p>

<p>
Gülen, S. (2019) <i> Gas Turbines for Electric Power Generation.</i> Cambridge University Press. 
<a href=\"https://doi.org/10.1017/9781108241625\">[Link]</a>
</p>


</html>",
  revisions="<html>
<ul>
<li>
February 16, 2023, by Zhanwei He:<br/>
First implementation.
</li>
</ul>
</html>"));
  end HRSGEffectiveness;

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
y = a<sub>1</sub> + a<sub>2</sub> (T<sub>exh</sub> / 100) + a<sub>3</sub> (T<sub>exh</sub> / 100)<sup>2</sup> ,
</i>
</p>

<p>
where
<i>T<sub>exh</sub></i> is the exhaust gas temperature (in Fahrenheit) from the gas turbine in the topping cycle.
</p>

<h4>References</h4>
<p>
Gülen, S. (2019). <i> Gas Turbine Combined Cycle Power Plants (1st ed.) </i>. CRC Press.
<a href=\"https://doi.org/10.1201/9780429244360\">[Link]</a>
</p>

<p>
Gülen, S. (2019) <i> Gas Turbines for Electric Power Generation.</i> Cambridge University Press. 
<a href=\"https://doi.org/10.1017/9781108241625\">[Link]</a>
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
Gülen, S. (2019). <i> Gas Turbine Combined Cycle Power Plants (1st ed.) </i>. CRC Press.
<a href=\"https://doi.org/10.1201/9780429244360\">[Link]</a>
</p>
<p>
Gülen, S. (2019) <i> Gas Turbines for Electric Power Generation.</i> Cambridge University Press. 
<a href=\"https://doi.org/10.1017/9781108241625\">[Link]</a>
</p>

</html>",
  revisions="<html>
<ul>
<li>
February 18, 2024, by Zhanwei He:<br/>
First implementation.
</li>
</ul>
</html>"));
  end ExhaustSpecificExergy;
  annotation (Documentation(info="<html>
<p>
This package contains functions for used
in the blocks. 
</p>
</html>", revisions="<html>
<ul>
<li>
February 8, 2023, by Zhanwei He:<br/>
First implementation.
</li>
</ul>
</html>"));
end Functions;
