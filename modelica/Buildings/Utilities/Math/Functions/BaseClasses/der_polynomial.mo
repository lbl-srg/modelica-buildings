within Buildings.Utilities.Math.Functions.BaseClasses;
function der_polynomial "Derivative for polynomial function"

  annotation (Documentation(info="<html>
This function computes the first derivative of a polynomial of arbitrary order.
The original polynomial has the form
<pre>
  y = a1 + a2 * x + a3 * x^2 + ...
</pre>
This function computes new coefficients
<pre>
   b1 = a2, b2 = 2*a3, ...
</pre>
and then calls recursively
<a href=\"Modelica:Buildings.Utilities.Math.polynomial\">
Buildings.Utilities.Math.polynomial</a>
</html>"),
revisions="<html>
<ul>
<li>
April 5, 2009 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>");
    input Real a[:];
    input Real x;
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
end der_polynomial;
