within Buildings.Utilities.Math.Functions;
function polynomial "Polynomial function"
  extends Modelica.Icons.Function;
 input Real x "Independent variable";
 input Real a[:] "Coefficients";
 output Real y "Result";
algorithm
  y := 0;
  for i in size(a, 1):-1:1 loop
    y := y*x + a[i];
  end for;
  annotation (Documentation(info="<html>
This function computes a polynomial of arbitrary order.
The polynomial has the form
<p align=\"center\" style=\"font-style:italic;\">
  y = a<sub>1</sub> + a<sub>2</sub> x + a<sub>3</sub> x<sup>2</sup> + ...
</p>
</html>",
revisions="<html>
<ul>
<li>
June 3, 2025, by Michael Wetter:<br/>
Updated implementation using Horner's method.<br/>
Removed derivative annotation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2022\">IBPSA, issue 2022</a>.
</li>
<li>
December 14, 2016, by Michael Wetter:<br/>
Removed derivative annotation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/602\">IBPSA, issue 602</a>.
</li>
<li>
March 30, 2011, by Michael Wetter:<br/>
Added <code>zeroDerivative</code> keyword.
</li>
<li>
March 2, by Michael Wetter:<br/>
Removed redundant <code>smoothOrder</code> annotation.
</li>
<li>
February 29, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
smoothOrder=999);
end polynomial;
