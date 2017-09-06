within Buildings.Utilities.Math.Functions;
function regNonZeroPower
  "Power function, regularized near zero, but nonzero value for x=0"
  extends Modelica.Icons.Function;

 input Real x "Abscissa value";
 input Real n "Exponent";
 input Real delta = 0.01 "Abscissa value where transition occurs";
 output Real y "Function value";
protected
  Real a1;
  Real a3;
  Real a5;
  Real delta2;
  Real x2;
  Real y_d "=y(delta)";
  Real yP_d "=dy(delta)/dx";
  Real yPP_d "=d^2y(delta)/dx^2";
algorithm
  if abs(x) > delta then
   y := abs(x)^n;
  else
   delta2 :=delta*delta;
   x2 :=x*x;
   y_d :=delta^n;
   yP_d :=n*delta^(n - 1);
   yPP_d :=n*(n - 1)*delta^(n - 2);
   a1 := -(yP_d/delta - yPP_d)/delta2/8;
   a3 := (yPP_d - 12 * a1 * delta2)/2;
   a5 := (y_d - delta2 * (a3 + delta2 * a1));
   y := a5 + x2 * (a3 + x2 * a1);
   assert(a5>0, "Delta is too small for this exponent.");
  end if;
  annotation (
    Documentation(info="<html>

Function that approximates <i>y=|x|<sup>n</sup></i> where <i>n &gt; 0</i>
so that
<ul>
<li><i>y(0)</i> is not equal to zero.</li>
<li><i>dy/dx</i> is bounded and continuous everywhere.</li>
</ul>

<p>
This function replaces <i>y=|x|<sup>n</sup></i> in the interval
<i>-&delta;...+&delta;</i> by a 4-th order polynomial that has the same
function value and the first and second derivative at <i>x=&plusmn; &delta;</i>.
</p>
<p>
A typical use of this function is to replace the
function for the convective heat transfer
coefficient for forced or free convection that is of the form
<i>h=c |dT|<sup>n</sup></i> for some constant <i>c</i> and exponent
<i>0 &le; n &le; 1</i>.
By using this function, the original function
that has an infinite derivative near zero and that takes on zero
at the origin is replaced by a function with a bounded derivative and
a non-zero value at the origin. Physically,
the region <i>-&delta;...+&delta;</i> may be interpreted as the region
where heat conduction dominates convection in the boundary layer.
</p>
See the package <code>Examples</code> for the graph.
</html>", revisions="<html>
<ul>
<li>
March 30, 2011, by Michael Wetter:<br/>
Added <code>zeroDerivative</code> keyword.
</li>
<li>
April 14, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), Inline=true,
           smoothOrder=2,
           derivative(zeroDerivative=n, zeroDerivative=delta)=BaseClasses.der_regNonZeroPower);
end regNonZeroPower;
