within Buildings.Utilities.Psychrometrics.Functions.BaseClasses;
function der_sublimationPressureIce
  "Derivative of function sublimationPressureIce"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.Temperature TSat(displayUnit="degC",
                                            nominal=300)
    "Saturation temperature";
    input Real dTSat(unit="K/s") "Sublimation temperature derivative";
    output Real psat_der(unit="Pa/s") "Sublimation pressure derivative";
protected
    Modelica.SIunits.Temperature TTriple=273.16 "Triple point temperature";
    Modelica.SIunits.AbsolutePressure pTriple=611.657 "Triple point pressure";
    Real r1=TSat/TTriple "Common subexpression 1";
    Real r1_der=dTSat/TTriple "Derivative of common subexpression 1";
    Real a[2]={-13.9281690,34.7078238} "Coefficients a[:]";
    Real n[2]={-1.5,-1.25} "Coefficients n[:]";
algorithm
    psat_der := exp(a[1] - a[1]*r1^n[1] + a[2] - a[2]*r1^n[2])*pTriple*(-(a[1]
      *(r1^(n[1] - 1)*n[1]*r1_der)) - (a[2]*(r1^(n[2] - 1)*n[2]*r1_der)));
    annotation (
      Inline=false,
      smoothOrder=5,
      Documentation(info="<html>
<p>
Derivative of function
<a href=\"modelica://Buildings.Utilities.Psychrometrics.Functions.sublimationPressureIce\">
Buildings.Utilities.Psychrometrics.Functions.sublimationPressureIce</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 12, 2020, by Michael Wetter:<br/>
Change name of argument <code>dTsat</code> to <code>dTSat</code> for consistency
with
<a href=\"modelica://Buildings.Utilities.Psychrometrics.Functions.BaseClasses.der_saturationPressureLiquid\">
Buildings.Utilities.Psychrometrics.Functions.BaseClasses.der_saturationPressureLiquid</a>.
</li>
<li>
November 20, 2013 by Michael Wetter:<br/>
First implementation, moved from <code>Buildings.Media</code>.
</li>
</ul>
</html>"));
end der_sublimationPressureIce;
