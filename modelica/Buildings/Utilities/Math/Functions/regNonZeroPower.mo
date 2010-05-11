within Buildings.Utilities.Math.Functions;
function regNonZeroPower
  "Power function, regularized near zero, but nonzero value for x=0"

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
   assert(a5>0, "delta is too small for this exponent n");
  end if;
  annotation (
    Documentation(info="<html>
<p>
Function that approximates <tt>y=|x|^n</tt> where <tt>n>0</tt> so that
<ul>
<li><tt>y(0)</tt> is not equal to zero.
<li><tt>dy/dx</tt> is bounded and continuous everywhere.
</ul>
</p>
<p>
This function replaces <tt>y=|x|^n</tt> in the interval
<tt>-delta...+delta</tt> by a 4-th order polynomial that has the same
function value, first and second derivative at <tt>x=+/-delta</tt>.
</p>
<p>
A typical use of this function is to replace the 
function for the convective heat transfer
coefficient for forced or free convection that is of the form 
<tt>h=c * |dT|^n</tt> for some constant <tt>c</tt> and exponent 
<tt>0 &le; n &le; 1</tt>. 
By using this function, the original function
that has an infinite derivative near zero and that takes on zero
at the origin is replaced by a function with a bounded derivative and 
a non-zero value at the origin. Physically, 
the region <tt>-delta...+delta</tt> may be interpreted as the region
where heat conduction dominates convection in the boundary layer.
</p>
<p>
See the package <tt>Examples</tt> for the graph.
</p>
</html>", revisions="<html>
<ul>
<li>
April 14, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),  smoothOrder=2, derivative=BaseClasses.der_regNonZeroPower);
end regNonZeroPower;
