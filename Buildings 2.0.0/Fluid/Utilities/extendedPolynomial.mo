within Buildings.Fluid.Utilities;
function extendedPolynomial
  "Polynomial that is linearly extended at user specified values"
  extends Modelica.Icons.Function;
  input Real x "x value";
  input Real[:] c "Polynomial coefficients";
  input Real xMin "Minimum x value for polynomial";
  input Real xMax "Maximum x value for polynomial";
  output Real y "y value";
protected
 Integer N = size(c,1) "Number of coefficients";
algorithm
if x < xMin then
   y := c[1];
   for i in 2:N loop
     y := y + xMin^(i - 1)*c[i] + (x - xMin)*(i - 1)*xMin^(i - 2)*c[i];
   end for;
  elseif x < xMax then
   y := c[1];
   for i in 2:N loop
     y := y + x^(i - 1)*c[i];
  end for;
  else
     y := c[1];
     for i in 2:N loop
       y := y + xMax^(i - 1)*c[i] + (x - xMax)*(i - 1)*xMax^(i - 2)*c[i];
    end for;
  end if;
  annotation (Documentation(info="<html>
For <i>x</i> between the bounds <i>x<sub>min</sub> &lt; x &lt; x<sub>max</sub></i>,
this function defines a polynomial
<p align=\"center\" style=\"font-style:italic;\">
 y = &sum;<sub>i=1</sub><sup>n</sup> c<sub>i</sub> x<sup>i-1</sup>
</p>
where <i>n &gt; 1</i> and <i>x<sub>min</sub>, x<sub>max</sub></i>
are parameters.
For <i>x &lt; x<sub>min</sub></i> and <i>x &gt; x<sub>max</sub></i>,
the polynomial is replaced by a linear function
in such a way that the first derivative is continuous everywhere.
</html>", revisions="<html>
<ul>
<li>
September 28, 2012 by Michael Wetter:<br/>
Fixed typo in the documentation.
</li>
<li>
March 30, 2011 by Michael Wetter:<br/>
Added keyword <code>zeroDerivative</code>.
</li>
<li>
March 23, 2011 by Michael Wetter:<br/>
Changed order of argument list to make <code>x</code> the first argument.
</li>
<li>
September 11, 2007 by Michael Wetter:<br/>
Fixed error in computing the polynomial outside of <code>xMin</code> and <code>xMax</code>.
</li>
<li>
July 19, 2007 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
smoothOrder=1,
derivative(zeroDerivative=c, zeroDerivative=xMin, zeroDerivative=xMax)=BaseClasses.der_extendedPolynomial);
end extendedPolynomial;
