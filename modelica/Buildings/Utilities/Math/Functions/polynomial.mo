within Buildings.Utilities.Math.Functions;
function polynomial "Polynomial function"
  annotation (Documentation(info="<html>
This function computes a polynomial of arbitrary order.
The polynomial has the form
<pre>
  y = a1 + a2 * x + a3 * x^2 + ...
</pre>
</html>"),
revisions="<html>
<ul>
<li>
February 29, 2009 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>");
 input Real a[:] "Coefficients";
 input Real x "Independent variable";
 output Real y "Result";
protected
 parameter Integer n = size(a, 1)-1;
 Real xp[n+1] "Powers of x";
 annotation(smoothOrder=2, derivative=BaseClasses.der_polynomial);
algorithm
  xp[1] :=1;
  for i in 1:n loop
     xp[i+1] :=xp[i]*x;
  end for;
  y :=a*xp;
end polynomial;
