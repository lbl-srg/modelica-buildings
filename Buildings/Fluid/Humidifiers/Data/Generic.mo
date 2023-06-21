within Buildings.Fluid.Humidifiers.Data;
record Generic
  "Base data record for DX dehumidifier model"

  extends Modelica.Icons.Record;

  constant Integer nWatRem
    "Number of coefficients for water removal modifier curve"
    annotation (Dialog(group="Performance curves"));

  constant Integer nEneFac
    "Number of coefficients for energy factor modifier curve"
    annotation (Dialog(group="Performance curves"));

  parameter Real watRem[nWatRem]
    "Biquadratic coefficients for water removal modifier curve"
    annotation (Dialog(group="Performance curves"));

  parameter Real eneFac[nEneFac]
    "Biquadratic coefficients for energy factor modifier curve"
    annotation (Dialog(group="Performance curves"));

  annotation (defaultComponentName="dxDehRec",
  preferredView="info",
  Documentation(info="<html>
<p>This is the base record for the DX dehumidifier which has the following data. </p>
<ul>
<li>
<code>watRem</code> - Coefficients of biquadratic polynomial for water 
removal flow rate as a function of temperature and relative humidity.
</li>
<li>
<code>eneFac</code> - Coefficients of biquadratic polynomial for energy factor 
as a function of temperature and relative humidity.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
June 20, 2023, by Xing Lu:<br/>
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
