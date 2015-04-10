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
  annotation (smoothOrder = 1,
Documentation(info="<html>
<p>
Once continuously differentiable approximation to the <code>max(.,.)</code> function.
</p>
<p>
Note that the maximum need not be respected, such as illustrated in
<a href=\"modelica://Buildings.Utilities.Math.Examples.SmoothMin\">
Buildings.Utilities.Math.Examples.SmoothMin</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 12, 2015, by Filip Jorissen:<br/>
Added documentation reference demonstrating overshoot.
</li>
<li>
February 5, 2015, by Filip Jorissen:<br/>
Added <code>smoothOrder = 1</code>.
</li>
<li>
August 15, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end smoothMax;
