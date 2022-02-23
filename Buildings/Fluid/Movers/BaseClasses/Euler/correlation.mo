within Buildings.Fluid.Movers.BaseClasses.Euler;
function correlation
  "Correlation of static efficiency ratio vs log of Euler number ratio"
  extends Modelica.Icons.Function;
  input Real x "log10(Eu/Eu_peak)";
  output Real y "eta/eta_peak";

protected
  constant Real a=-2.732094, b=2.273014, c=0.196344, d=5.267518;
  Real Z1, Z2, Z3;

algorithm
  Z1:=(x-a)/b;
  Z2:=((exp(c*x)*d*x)-a)/b;
  Z3:=-a/b;

  y:=(exp(-0.5*Z1^2)*(1+sign(Z2)*Modelica.Math.Special.erf(u=abs(Z2)/sqrt(2))))
    /(exp(-0.5*Z3^2)*(1+Modelica.Math.Special.erf(u=Z3/sqrt(2))));

  annotation(Documentation(info="<html>
<p>
This function computes the following correlation:
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
<p>
Although it may appear that this ratio could be further simplified
by applying affinity laws, since the affinity laws assume constant efficiency,
this would contradict the definition of <i>y</i> where the efficiency varies.
</p>
<p>
For more information refer to
<a href=\"https://energyplus.net/assets/nrel_custom/pdfs/pdfs_v9.6.0/EngineeringReference.pdf\">
EnergyPlus 9.6.0 Engineering Reference</a>
chapter 16.4 equations 16.209 through 16.218.
Note that the formula is simplified here from the source document.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 13, 2021, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
</ul>
</html>"));
end correlation;
