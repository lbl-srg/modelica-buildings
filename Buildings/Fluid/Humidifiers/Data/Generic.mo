within Buildings.Fluid.Humidifiers.Data;
record Generic "Base classes for DX dehumidifier model"
  extends Modelica.Icons.Record;

  constant Integer nWatRem = 6 "Number of coefficients for watRem"
    annotation (Dialog(group="Performance curves"));
  constant Integer nEneFac = 6 "Number of coefficients for eneFac"
    annotation (Dialog(group="Performance curves"));
  parameter Real watRem[nWatRem] = {-2.72487866408,0.100711983591,-9.90538285E-04,0.050053043874,-2.03629282E-04,-3.41750531E-04} "Biquadratic coefficients for water removal modifier curve"
    annotation (Dialog(group="Performance curves"));
  parameter Real eneFac[nEneFac] = {-2.38831907E+00,0.093047739452,-1.36970033E-03,0.066533716758,-3.43198063E-04,-5.62490295E-04} "Biquadratic coefficients for energy factor modifier curve"
    annotation (Dialog(group="Performance curves"));

  annotation (preferredView="info",
  Documentation(info="<html>
<p>This is the base record for the DX dehumidifier which has the following data. </p>
<ul>
<li><span style=\"font-family: Courier New;\">watRem - Coefficients of biquadratic polynomial for water removal flow rate as a function of temperature and relative humidity.</span></li>
<li><span style=\"font-family: Courier New;\">eneFac - Coefficients of biquadratic polynomial for energy factor as a function of temperature and relative humidity.</span></li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
July 27, 2016, by Michael Wetter:<br/>
Corrected wrong documentation for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/545\">issue 545</a>.
</li>
<li>
September 15, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Text(
          extent={{-91,1},{-8,-54}},
          textColor={0,0,255},
          fontSize=16,
          textString="watRem"),
        Text(
          extent={{2,-16},{94,-38}},
          textColor={0,0,255},
          textString="eneFac",
          fontSize=16)}));
end Generic;
