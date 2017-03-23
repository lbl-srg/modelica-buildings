within Buildings.Utilities.Math.Functions;
function smoothMax
  "Once continuously differentiable approximation to the maximum function"
  input Real x1 "First argument";
  input Real x2 "Second argument";
  input Real deltaX "Width of transition interval";
  output Real y "Result";
algorithm
  y := Buildings.Utilities.Math.Functions.spliceFunction(
         pos=x1, neg=x2, x=x1-x2, deltax=deltaX);
  annotation (
Documentation(info="<html>
<p>
Once continuously differentiable approximation to the <code>max(.,.)</code> function.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 15, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end smoothMax;
