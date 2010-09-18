within Buildings.Utilities.Math.Functions;
function quadraticLinear
  "Function that is quadratic in first argument and linear in second argument"
 input Real a[6] "Coefficients";
 input Real x1 "Independent variable for quadratic part";
 input Real x2 "Independent variable for linear part";
 output Real y "Result";
protected
 Real x1Sq;
algorithm
  x1Sq :=x1*x1;
  y :=a[1] + a[2]*x1 + a[3]*x1Sq + (a[4] + a[5]*x1 + a[6]*x1Sq)*x2;

  annotation (smoothOrder=999, Documentation(info="<html>
This function computes
<pre>
  y =   a1 + a2 * x1 + a3 *x1^2 
     + (a4 + a5 * x1 + a6 *x1^2) * x2
</pre>
</html>", revisions="<html>
<ul>
<li>
February 29, 2009 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end quadraticLinear;
