within Buildings.Utilities.Psychrometrics.Functions;
function saturationPressure
  "Saturation curve valid for 223.16 <= T <= 373.16 (and slightly outside with less accuracy)"
  extends Modelica.Icons.Function;
  input Modelica.Units.SI.Temperature TSat(displayUnit="degC", nominal=300)
    "Saturation temperature";
  output Modelica.Units.SI.AbsolutePressure pSat(displayUnit="Pa", nominal=1000)
    "Saturation pressure";

algorithm
  pSat := Buildings.Utilities.Math.Functions.regStep(
             y1=Buildings.Utilities.Psychrometrics.Functions.saturationPressureLiquid(TSat),
             y2=Buildings.Utilities.Psychrometrics.Functions.sublimationPressureIce(TSat),
             x=TSat-273.16,
             x_small=1.0);
  annotation(Inline=true,
    smoothOrder=1,
    Documentation(info="<html>
<p>
Saturation pressure of water, computed from temperature,
according to Wagner <i>et al.</i> (1993).
The range of validity is between
<i>190</i> and <i>373.16</i> Kelvin.
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
March 15, 2016, by Michael Wetter:<br/>
Replaced <code>spliceFunction</code> with <code>regStep</code>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/300\">issue 300</a>.
</li>
<li>
August 19, 2015 by Michael Wetter:<br/>
Changed <code>smoothOrder</code> from <i>5</i> to <i>1</i> as
<a href=\"modelica://Buildings.Utilities.Math.Functions.spliceFunction\">
Buildings.Utilities.Math.Functions.spliceFunction</a> is only once
continuously differentiable.
Inlined the function.
</li>
<li>
November 20, 2013 by Michael Wetter:<br/>
First implementation, moved from <code>Buildings.Media</code>.
</li>
</ul>
</html>"));
end saturationPressure;
