within Buildings.Fluid.Utilities;
function polynomial
  "Polynomial, used because OpenModelica 1.4.3 does not expand the sum() into a scalar"
  extends Modelica.Icons.Function;
  input Real[:] c "Coefficients";
  input Real x "Independent variable";
  output Real y "Dependent variable";
algorithm
 y := c[1];
 for i in 2 : size(c,1) loop
   y := y + x^(i-1) * c[i];
 end for;
annotation (smoothOrder=5,
Documentation(
info="<html>
<p>
Function that computes
<p align=\"center\" style=\"font-style:italic;\">
 y = &sum;<sub>i=1</sub><sup>n</sup> c<sub>i</sub> x<sup>i-1</sup>
</p>
<br/>
</html>",
revisions="<html>
<ul>
<li>
April 28, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end polynomial;
