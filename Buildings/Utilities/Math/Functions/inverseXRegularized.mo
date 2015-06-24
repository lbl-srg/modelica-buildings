within Buildings.Utilities.Math.Functions;
function inverseXRegularized
  "Function that approximates 1/x by a twice continuously differentiable function"
 input Real x "Abscissa value";
 input Real delta(min=0) "Abscissa value below which approximation occurs";
 output Real y "Function value";
protected
 Real delta2 "Delta^2";
 Real x2_d2 "=x^2/delta^2";
algorithm
  if (abs(x) > delta) then
    y := 1/x;
  else
    delta2 :=delta*delta;
    x2_d2  := x*x/delta2;
    y      := x/delta2 + x*abs(x/delta2/delta*(2 - x2_d2*(3 - x2_d2)));
  end if;

  annotation (smoothOrder = 1,
    Documentation(info="<html>
<p>
Function that approximates <i>y=1 &frasl; x</i>
inside the interval <i>-&delta; &le; x &le; &delta;</i>.
The approximation is twice continuously differentiable with a bounded derivative on the whole
real line.
</p>
<p>
See the package <code>Examples</code> for the graph.
</p>
</html>", revisions="<html>
<ul>
<li>
February 5, 2015, by Filip Jorissen:<br/>
Added <code>smoothOrder = 1</code>.
</li>
<li>
May 10, 2013, by Michael Wetter:<br/>
Reformulated implementation to avoid unrequired computations.
</li>
<li>
April 18, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),  smoothOrder=2, Inline=true);
end inverseXRegularized;
