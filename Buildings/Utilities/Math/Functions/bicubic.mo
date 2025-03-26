within Buildings.Utilities.Math.Functions;
function bicubic "Bicubic function"
  extends Modelica.Icons.Function;
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
<p>
This function computes
</p>
<p align=\"center\" style=\"font-style:italic;\">
 y = a<sub>1</sub>
    + a<sub>2</sub>  x<sub>1</sub> + a<sub>3</sub>  x<sub>1</sub><sup>2</sup>
    + a<sub>4</sub>  x<sub>2</sub> + a<sub>5</sub>  x<sub>2</sub><sup>2</sup>
    + a<sub>6</sub>  x<sub>1</sub>  x<sub>2</sub>
    + a<sub>7</sub>  x<sub>1</sub>^3
    + a<sub>8</sub>  x<sub>2</sub>^3
    + a<sub>9</sub>  x<sub>1</sub><sup>2</sup>  x<sub>2</sub>
    + a<sub>1</sub>0  x<sub>1</sub>  x<sub>2</sub><sup>2</sup>
</p>
</html>", revisions="<html>
<ul>
<li>
June 25, 2023, by Michael Wetter:<br/>
Corrected html formatting.
</li>
<li>
Sep 17, 2010 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end bicubic;
