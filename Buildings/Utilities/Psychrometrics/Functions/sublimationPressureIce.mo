within Buildings.Utilities.Psychrometrics.Functions;
function sublimationPressureIce
  "Return sublimation pressure of water as a function of temperature T between 190 and 273.16 K"
  extends Modelica.Icons.Function;
  input Modelica.Units.SI.Temperature TSat(displayUnit="degC", nominal=300)
    "Saturation temperature";
  output Modelica.Units.SI.AbsolutePressure pSat(displayUnit="Pa", nominal=1000)
    "Saturation pressure";
protected
  Modelica.Units.SI.Temperature TTriple=273.16 "Triple point temperature";
  Modelica.Units.SI.AbsolutePressure pTriple=611.657 "Triple point pressure";
  Real r1=TSat/TTriple "Common subexpression";
  Real a[2]={-13.9281690,34.7078238} "Coefficients a[:]";
  Real n[2]={-1.5,-1.25} "Coefficients n[:]";
algorithm
  pSat := exp(a[1] - a[1]*r1^n[1] + a[2] - a[2]*r1^n[2])*pTriple;
  annotation (
    Inline=false,
    smoothOrder=5,
    derivative=Buildings.Utilities.Psychrometrics.Functions.BaseClasses.der_sublimationPressureIce,
    Documentation(info="<html>
<p>
Sublimation pressure of water below the triple point temperature, computed from temperature,
according to Wagner <i>et al.</i> (1993).
The range of validity is between
<i>190</i> and <i>273.16</i> Kelvin.
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
end sublimationPressureIce;
