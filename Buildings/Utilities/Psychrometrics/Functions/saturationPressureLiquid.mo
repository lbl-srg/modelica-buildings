within Buildings.Utilities.Psychrometrics.Functions;
function saturationPressureLiquid
  "Return saturation pressure of water as a function of temperature T in the range of 273.16 to 373.16 K"
  extends Modelica.Icons.Function;
  input Modelica.Units.SI.Temperature TSat(displayUnit="degC", nominal=300)
    "Saturation temperature";
  output Modelica.Units.SI.AbsolutePressure pSat(displayUnit="Pa", nominal=1000)
    "Saturation pressure";
algorithm
  pSat := 611.657*Modelica.Math.exp(17.2799 - 4102.99/(TSat - 35.719));

  annotation (
    smoothOrder=99,
    derivative=Buildings.Utilities.Psychrometrics.Functions.BaseClasses.der_saturationPressureLiquid,
    Inline=true,
    Documentation(info="<html>
<p>
Saturation pressure of water above the triple point temperature computed from temperature
according to Wagner <i>et al.</i> (1993). The range of validity is between
<i>273.16</i> and <i>373.16</i> Kelvin.
</p>
<h4>References</h4>
<p>
Wagner W., A. Saul, A. Pruss.
 <i>International equations for the pressure along the melting and along the sublimation curve of ordinary water substance</i>,
equation 3.5. 1993.
<a href=\"http://aip.scitation.org/doi/pdf/10.1063/1.555947?class=pdf\">
http://aip.scitation.org/doi/pdf/10.1063/1.555947?class=pdf</a>.
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
end saturationPressureLiquid;
