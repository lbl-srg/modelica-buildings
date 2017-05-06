within Buildings.Utilities.Math.Functions;
function biquadratic "Biquadratic function"
  extends Modelica.Icons.Function;
 input Real a[6] "Coefficients";
 input Real x1 "Independent variable";
 input Real x2 "Independent variable";
 output Real y "Result";
algorithm
  y :=a[1] + x1*(a[2] + a[3]*x1) + x2*(a[4]+ a[5]*x2) + a[6]*x1*x2;

  annotation (smoothOrder=999, Documentation(info="<html>
This function computes
<p align=\"center\" style=\"font-style:italic;\">
  y =   a<sub>1</sub> + a<sub>2</sub>  x<sub>1</sub>
        + a<sub>3</sub>  x<sub>1</sub><sup>2</sup>
        + a<sub>4</sub>  x<sub>2</sub> + a<sub>5</sub>  x<sub>2</sub><sup>2</sup>
        + a<sub>6</sub>  x<sub>1</sub>  x<sub>2</sub>
</p>
</html>", revisions="<html>
<ul>
<li>
Sep 8, 2010 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end biquadratic;
