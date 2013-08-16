within Districts.Utilities.Math.Functions;
function inverseXRegularized
  "Function that approximates 1/x by a twice continuously differentiable function"
 input Real x "Abscissa value";
 input Real delta(min=0) "Abscissa value below which approximation occurs";
 output Real y "Function value";
protected
 Real delta2 "Delta^2";
 Real x2_d2 "=x^2/delta^2";
algorithm
  delta2 :=delta*delta;
  x2_d2  := x*x/delta2;
  y :=smooth(2, if (abs(x) > delta) then 1/x else
    x/delta2 + x*abs(x/delta2/delta*(2 - x2_d2*(3 - x2_d2))));
  annotation (
    Documentation(info="<html>
<p>
Function that approximates <i>y=1 &frasl; x</i> 
inside the interval <i>-&delta; &le; x &le; &delta;</i>.
The approximation is twice continuously differentiable with a bounded derivative on the whole 
real line.
<p>
See the package <code>Examples</code> for the graph.
</p>
</html>", revisions="<html>
<ul>
<li>
April 18, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),  smoothOrder=2, Inline=true);
end inverseXRegularized;
