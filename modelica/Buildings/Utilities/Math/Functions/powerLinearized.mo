within Buildings.Utilities.Math.Functions;
function powerLinearized
  "Power function that is linearized below a user-defined threshold"

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
<p>
Function that approximates <tt>y=x^n</tt> where <tt>0 &lt; n</tt> so that
<ul>
<li>the function is defined and monotone increasing for all <tt>x</tt>.
<li><tt>dy/dx</tt> is bounded and continuous everywhere (for <tt>n &lt; 1</tt>).
</ul>
</p>
<p>
For <tt>x &lt; x0</tt>, this function replaces <tt>y=x^n</tt> by 
a linear function that is continuously differentiable everywhere.
</p>
<p>
A typical use of this function is to replace 
<tt>T = T4^(1/4)</tt> in a radiation balance to ensure that the 
function is defined everywhere. This can help solving the initialization problem
when a solver may be far from a solution and hence <tt>T4 &lt; 0</tt>.
</p>
<p>
See the package <tt>Examples</tt> for the graph.
</p>
</html>", revisions="<html>
<ul>
<li>
February 3, 2011, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),  smoothOrder=1, Inline=true);
end powerLinearized;
