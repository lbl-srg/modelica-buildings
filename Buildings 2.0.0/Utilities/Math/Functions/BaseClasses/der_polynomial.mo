within Buildings.Utilities.Math.Functions.BaseClasses;
function der_polynomial "Derivative for polynomial function"
    input Real x;
    input Real a[:];
    input Real dx;
    output Real y;
protected
 parameter Integer n = size(a, 1)-1;
 Real b[n] "Coefficients of derivative polynomial";
algorithm
  for i in 1:n loop
     b[i] :=a[i+1]*i;
  end for;
  y := Buildings.Utilities.Math.Functions.polynomial(
                                           a=b, x=x);
  annotation (Documentation(info="<html>
This function computes the first derivative of a polynomial of arbitrary order.
The original polynomial has the form<br/>
<p align=\"center\" style=\"font-style:italic;\">
  y = a<sub>1</sub> + a<sub>2</sub> x + a<sub>3</sub> x<sup>2</sup> + ...
</p>
<p>
This function computes new coefficients
</p>
<p align=\"center\" style=\"font-style:italic;\">
   b<sub>1</sub> = a<sub>2</sub>, b<sub>2</sub> = 2 a<sub>3</sub>, ...
</p>
<p>
and then calls recursively
<a href=\"modelica://Buildings.Utilities.Math.Functions.polynomial\">
Buildings.Utilities.Math.polynomial</a>
</p>
</html>",
revisions="<html>
<ul>
<li>
April 5, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end der_polynomial;
