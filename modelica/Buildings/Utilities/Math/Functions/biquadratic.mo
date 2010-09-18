within Buildings.Utilities.Math.Functions;
function biquadratic "Biquadratic function"
 input Real a[6] "Coefficients";
 input Real x1 "Independent variable";
 input Real x2 "Independent variable";
 output Real y "Result";
algorithm
  y :=a[1] + x1*(a[2] + a[3]*x1) + x2*(a[4]+ a[5]*x2) + a[6]*x1*x2;

  annotation (smoothOrder=999, Documentation(info="<html>
This function computes
<pre>
  y =   a1 + a2 * x1 + a3 * x1^2 
           + a4 * x2 + a5 * x2^2 + a6 * x1 * x2
</pre>
</html>", revisions="<html>
<ul>
<li>
Sep 8, 2010 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end biquadratic;
