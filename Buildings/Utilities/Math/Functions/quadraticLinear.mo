within Buildings.Utilities.Math.Functions;
function quadraticLinear
  "Function that is quadratic in first argument and linear in second argument"
  extends Modelica.Icons.Function;
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
<p align=\"center\" style=\"font-style:italic;\">
  y =   a<sub>1</sub> + a<sub>2</sub>  x<sub>1</sub>
        + a<sub>3</sub> x<sub>1</sub><sup>2</sup>
        + (a<sub>4</sub> + a<sub>5</sub>  x<sub>1</sub>
        + a<sub>6</sub> x<sub>1</sub><sup>2</sup>)  x<sub>2</sub>
</p>
</html>", revisions="<html>
<ul>
<li>
February 29, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end quadraticLinear;
