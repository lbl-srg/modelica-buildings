within Buildings.Utilities.Math.Functions;
function bicubic "Bicubic function"
 input Real a[10] "Coefficients";
 input Real x1 "Independent variable";
 input Real x2 "Independent variable";
 output Real y "Result";
protected
 Real x1Sq "= x1^2";
 Real x2Sq "= x2^2";
algorithm
  x1Sq :=x1*x1;
  x2Sq :=x2*x2;
  y := a[1] + a[2] * x1 + a[3] * x1^2
            + a[4] * x2 + a[5] * x2^2
            + a[6] * x1 * x2
            + a[7] * x1Sq * x1
            + a[8] * x2Sq * x2
            + a[9] * x1Sq * x2
            + a[10] * x1 * x2Sq;

  annotation (smoothOrder=999, Documentation(info="<html>
This function computes
<pre>
 y = a1 + a2 * x1 + a3 * x1^2 
        + a4 * x2 + a5 * x2^2 
        + a6 * x1 * x2 
        + a7 * x1^3
        + a8 * x2^3 
        + a9 * x1^2 * x2 + a10 * x1 * x2^2
</pre>
</html>", revisions="<html>
<ul>
<li>
Sep 17, 2010 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end bicubic;
