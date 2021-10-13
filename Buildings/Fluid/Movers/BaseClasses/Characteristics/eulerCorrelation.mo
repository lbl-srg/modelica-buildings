within Buildings.Fluid.Movers.BaseClasses.Characteristics;
function eulerCorrelation
  "Correlation of fan static efficiency ratio v. log of Euler number"
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
  y:=(exp(-0.5*Z1^2)
              *(1+Z2/abs(Z2)*Modelica.Math.Special.erf(u=abs(Z2)/sqrt(2))))
         /(exp(-0.5*Z3^2)
              *(1+Z3/abs(Z3)*Modelica.Math.Special.erf(u=abs(Z3)/sqrt(2))));
  annotation(Documentation(info="<html>
<p>
This function computes the following correlation:
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Movers/UsersGuide/eulerCorrelationEquation.svg\"/>
</p>
<p>
where
<i>&eta;</i> is the efficiency,
the subscript <i>p</i> denotes the condition where 
the mover is operating at peak efficiency, and 
</p>
<p align=\"center\">
<i>Z<sub>1</sub>=(x-a)/b</i>
</p>
<p align=\"center\">
<i>Z<sub>2</sub>=(e<sup>c&sdot;x</sup>&sdot;d&sdot;x-a)/b</i>
</p>
<p align=\"center\">
<i>Z<sub>3</sub>=-a/b</i>
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
For more information refer to 
<a href=\"https://energyplus.net/assets/nrel_custom/pdfs/pdfs_v9.6.0/EngineeringReference.pdf\">
EnergyPlus 9.6.0 Engineering Reference</a>
chapter 16.4 equations 16.209 through 16.218.
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
end eulerCorrelation;
