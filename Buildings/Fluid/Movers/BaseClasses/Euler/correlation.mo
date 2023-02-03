within Buildings.Fluid.Movers.BaseClasses.Euler;
function correlation
  "Correlation of static efficiency ratio vs log of Euler number ratio"
  extends Modelica.Icons.Function;
  input Real x "log10(Eu/Eu_peak)";
  output Real y "eta/eta_peak";

protected
  Real a "Polynomial coefficient";
  Real b "Polynomial coefficient";
  Real c "Polynomial coefficient";
  Real d "Polynomial coefficient";
  Real y1 "eta/eta_peak";
algorithm
  if x < -0.5 then
    a := 0.05687322707407;
    b := 0.493231336746;
    c := 1.433531254001;
    d := 1.407887300933;
  elseif x > 0.5 then
    a := -8.5494313567465000E-3;
    b := 1.2957001502368300E-1;
    c := -6.5997315029278200E-1;
    d := 1.13993003013131;
  else
    a := 0.37824577860088;
    b := -0.75988502317361;
    c := -0.060614519563716;
    d := 1.01426507307139;
  end if;
  y1 := (a*x^3 + b*x^2 + c*x + d) / 1.01545;
  // y1 is almost always bounded away from zero,
  // hence we make a test to see whether we indeed
  // need to call smoothMax or can avoid its overhead
  y := if y1 > 0.002 then y1 else
    Buildings.Utilities.Math.Functions.smoothMax(
      x1=y1,
      x2=0.001,
      deltaX=0.0005);

  annotation(smoothOrder = 1,
  Documentation(info="<html>
<p>
This function approximates the following correlation:
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Movers/BaseClasses/Euler/eulerCorrelation.svg\"/>
</p>
<p>
where <i>y=&eta; &frasl; &eta;<sub>p</sub></i> (note that <i>&eta;</i>
refers to the hydraulic efficiency instead of total efficiency),
<i>x=log<sub>10</sub>(Eu &frasl; Eu<sub>p</sub>)</i>,
with the subscript <i>p</i> denoting the condition where
the mover is operating at peak efficiency, and
</p>
<p align=\"center\">
<i>Z<sub>1</sub>=(x-a) &frasl; b</i>
</p>
<p align=\"center\">
<i>Z<sub>2</sub>=(e<sup>c&sdot;x</sup>&sdot;d&sdot;x-a) &frasl; b</i>
</p>
<p align=\"center\">
<i>Z<sub>3</sub>=-a &frasl; b</i>
</p>
<p align=\"center\">
<i>a=-2.732094</i>
</p>
<p align=\"center\">
<i>b=2.273014</i>
</p>
<p align=\"center\">
<i>c=0.196344</i>
</p>
<p align=\"center\">
<i>d=5.267518</i>
</p>
<p>
The approximation uses two simple polynomials stitched together by
a third one of the same order.
Care has been taken to ensure that, on the curve constructed by
<code>if</code> statements, the differences of <i>dy &frasl; dx</i>
evaluated by different groups of coefficients at the connecting points
(i.e. at <i>x = - 0.5</i> and <i>x = + 0.5</i>) are less than <i>1E-14</i>.
This way, the derivative is still continuous to the solver even if
the solver requires a precision of <i>1E-10</i> when there are nested loops.
</p>
<p>
The correlation and the approximation have the shape as shown below
(plotted by 
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Validation.EulerCurve\">
Buildings.Fluid.Movers.BaseClasses.Validation.EulerCurve</a>).
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Movers/BaseClasses/Euler/EulerCurve.png\"/>
</p>
<p>
The modified dimensionless Euler number is defined as
</p>
<p align=\"center\">
<i>Eu=(&Delta;p&sdot;D<sup>4</sup>) &frasl; (&rho;&sdot;V&#775;<sup>2</sup>)</i>
</p>
<p>
where <i>&Delta;p</i> is the fan pressure rise in Pa,
<i>D</i> is the fan wheel outer diameter in m,
<i>&rho;</i> is the inlet air density in kg/m<sup>3</sup>,
and <i>V&#775;</i> is the volumetric flow rate in m<sup>3</sup>/s.
Note that the units in the definition do not matter to this correlation
because it is the ratio of the Euler numbers that is used.
Since <i>D</i> is constant for the same mover
and <i>&rho;</i> is approximately constant for common HVAC applications,
the Euler number ratio can be simplified to
</p>
<p align=\"center\">
<i>Eu &frasl; Eu<sub>p</sub>=(&Delta;p&sdot;V&#775;<sub>p</sub><sup>2</sup>)
&frasl; (&Delta;p<sub>p</sub>&sdot;V&#775;<sup>2</sup>)</i>
</p>
<h4>References</h4>
<p>
For more information regarding the correlation curve refer to
<a href=\"https://energyplus.net/assets/nrel_custom/pdfs/pdfs_v9.6.0/EngineeringReference.pdf\">
EnergyPlus 9.6.0 Engineering Reference</a>
chapter 16.4 equations 16.209 through 16.218.
Note that the formula is simplified here from the source document.
</p>
<h4>Resources</h4>
<p>
The svg file for the correlation equation was generated on
<a href=\"https://viereck.ch/latex-to-svg/\">
https://viereck.ch/latex-to-svg</a>
using
<a href=\"modelica://Buildings/Resources/Images/Fluid/Movers/BaseClasses/Euler/eulerCorrelation.txt\">
this script</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 2, 2023, by Michael Wetter:<br/>
Rewrote to reduce number of <code>if-then</code> statements and to use
<code>smoothMax</code> rather than <code>max</code>.
</li>
<li>
December 12, 2022, by Hongxiang Fu and Filip Jorissen:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a> and
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1645\">#1645</a>.
</li>
</ul>
</html>"));
end correlation;
