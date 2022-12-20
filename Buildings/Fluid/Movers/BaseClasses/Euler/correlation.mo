within Buildings.Fluid.Movers.BaseClasses.Euler;
function correlation
  "Correlation of static efficiency ratio vs log of Euler number ratio"
  extends Modelica.Icons.Function;
  input Real x "log10(Eu/Eu_peak)";
  output Real y "eta/eta_peak";

protected
  constant Real pLef[4]={0.056873227,0.493231336746,1.433531254001,1.407887300933};
  constant Real pMid[4]={0.378246,-0.759885,-0.0606145,1.01427};
  constant Real pRig[4]={-0.0085494313567,0.12957001502,-0.65997315029,1.1399300301};
  constant Real p[4] = if x<-0.5 then pLef else if x>0.5 then pRig else pMid;
algorithm
  y:=max(0,p[1]*x^3+p[2]*x^2+p[3]*x+p[4])/pMid[end];

  annotation(smoothOrder = 1,
  Documentation(info="<html>
<p>
This function approximates the following correlation with two simple polynomials
stitched together by a third one of the same order:
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Movers/BaseClasses/Euler/eulerCorrelation.svg\"/>
</p>
<p>
where <i>y=&eta; &frasl; &eta;<sub>p</sub></i> (note that <i>&eta;</i>
refers to the hydraulic efficiency instead of total efficiency),
<i>x=log10(Eu &frasl; Eu<sub>p</sub>)</i>,
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
This correlation function has the shape as shown below
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
and <i>V&#775;</i> is the fan flow in m<sup>3</sup>/s.
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
<p>
Regarding the approximation polynominals, see the discussions in
<a href=\"https://github.com/ibpsa/modelica-ibpsa/pull/1646#issuecomment-1320920539\">
pull request #1646</a>.
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
December 12, 2022, by Hongxiang Fu and Filip Jorissen:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a> and
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1645\">#1645</a>.
</li>
</ul>
</html>"));
end correlation;
