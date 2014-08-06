within Buildings.Utilities.Psychrometrics.Functions.BaseClasses;
function der_saturationPressureLiquid
  "Derivative of the function saturationPressureLiquid"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature Tsat "Saturation temperature";
  input Real dTsat(unit="K/s") "Saturation temperature derivative";
  output Real psat_der(unit="Pa/s") "Differential of saturation pressure";

algorithm
  psat_der:=611.657*Modelica.Math.exp(17.2799 - 4102.99
            /(Tsat - 35.719))*4102.99*dTsat/(Tsat - 35.719)^2;

  annotation(Inline=false,
    smoothOrder=5,
    Documentation(info="<html>
<p>
Derivative of function
<a href=\"modelica://Buildings.Utilities.Psychrometrics.Functions.saturationPressureLiquid\">
Buildings.Utilities.Psychrometrics.Functions.saturationPressureLiquid</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
November 20, 2013 by Michael Wetter:<br/>
First implementation, moved from <code>Buildings.Media</code>.
</li>
</ul>
</html>"));
end der_saturationPressureLiquid;
