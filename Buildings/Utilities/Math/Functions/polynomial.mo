within Buildings.Utilities.Math.Functions;
function polynomial "Polynomial function"
 input Real x "Independent variable";
 input Real a[:] "Coefficients";
 output Real y "Result";
protected
 parameter Integer n = size(a, 1)-1;
 Real xp[n+1] "Powers of x";
algorithm
  xp[1] :=1;
  for i in 1:n loop
     xp[i+1] :=xp[i]*x;
  end for;
  y :=a*xp;
  annotation (Documentation(info="<html>
This function computes a polynomial of arbitrary order.
The polynomial has the form
<p align=\"center\" style=\"font-style:italic;\">
  y = a<sub>1</sub> + a<sub>2</sub> x + a<sub>3</sub> x<sup>2</sup> + ...
</p>
</html>"),
revisions="<html>
<ul>
<li>
March 30, 2011, by Michael Wetter:<br/>
Added <code>zeroDerivative</code> keyword.
</li>
<li>
March 2, by Michael Wetter:<br/>
Removed redundant <code>smoothOrder</code> annotation.
</li>
<li>
February 29, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>",
smoothOrder=999, 
derivative(zeroDerivative=a)=Buildings.Utilities.Math.Functions.BaseClasses.der_polynomial);
end polynomial;
