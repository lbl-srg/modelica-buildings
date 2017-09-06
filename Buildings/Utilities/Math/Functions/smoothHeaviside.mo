within Buildings.Utilities.Math.Functions;
function smoothHeaviside
  "Once continuously differentiable approximation to the Heaviside function"
  extends Modelica.Icons.Function;
  input Real x "Argument";
  input Real delta "Parameter used for scaling";
  output Real y "Result";
algorithm
 y := Buildings.Utilities.Math.Functions.regStep(
   y1=  1,
   y2=  0,
   x=  x,
   x_small=  delta);
 annotation (smoothOrder = 1,
 Documentation(info="<html>
<p>
Once Lipschitz continuously differentiable approximation to the
<code>Heaviside(.,.)</code> function.
See Example <a href=\"modelica://Buildings.Utilities.Math.Examples.SmoothHeaviside\">
Buildings.Utilities.Math.Examples.SmoothHeaviside</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 15, 2016, by Michael Wetter:<br/>
Replaced <code>spliceFunction</code> with <code>regStep</code>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/300\">issue 300</a>.
</li>
<li>
July 17, 2015, by Marcus Fuchs:<br/>
Add link to example.
</li>
<li>
February 5, 2015, by Filip Jorissen:<br/>
Added <code>smoothOrder = 1</code>.
</li>
<li>
July 14, 2010, by Wangda Zuo, Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end smoothHeaviside;
