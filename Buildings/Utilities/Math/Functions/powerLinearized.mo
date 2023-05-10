within Buildings.Utilities.Math.Functions;
function powerLinearized
  "Power function that is linearized below a user-defined threshold"
  extends Modelica.Icons.Function;

 input Real x "Abscissa value";
 input Real n "Exponent";
 input Real x0 "Abscissa value below which linearization occurs";
 output Real y "Function value";
algorithm
  if x > x0 then
   y := x^n;
  else
   y := x0^n * (1-n) + n * x0^(n-1) * x;
  end if;
  annotation (
    Documentation(info="<html>
Function that approximates <i>y=x<sup>n</sup></i>
where <i>0 &lt; n</i> so that
<ul>
<li>the function is defined and monotonically increasing for all <i>x</i>.</li>
<li><i>dy/dx</i> is bounded and continuous everywhere (for <i>n &lt; 1</i>).</li>
</ul>
<p>
For <i>x &lt; x<sub>0</sub></i>, this function replaces
<i>y=x<sup>n</sup></i> by
a linear function that is continuously differentiable everywhere.
</p>
<p>
A typical use of this function is to replace
<i>T = T4<sup>(1/4)</sup></i> in a radiation balance to ensure that the
function is defined everywhere. This can help solving the initialization problem
when a solver may be far from a solution and hence <i>T4 &lt; 0</i>.
</p>
<p>
See the package <code>Examples</code> for the graph.
</p>
</html>", revisions="<html>
<ul>
<li>
February 3, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),  smoothOrder=1, Inline=true);
end powerLinearized;
