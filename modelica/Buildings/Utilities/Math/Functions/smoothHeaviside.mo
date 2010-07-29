within Buildings.Utilities.Math.Functions;
function smoothHeaviside
  "Once continuously differentiable approximation to the Heaviside function"
  input Real x "Argument";
  input Real delta "Parameter used for scaling";
  output Real y "Result";
algorithm
 y := spliceFunction(1, 0, x, delta);
 annotation (Documentation(info="<html>
<p>
Once Lipschitz continuously differentiable approximation to the <tt>Heaviside(.,.)</tt> function.
</p>
</html>", revisions="<html>
<ul>
<li>
July 14, 2010, by Wangda Zuo, Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end smoothHeaviside;
