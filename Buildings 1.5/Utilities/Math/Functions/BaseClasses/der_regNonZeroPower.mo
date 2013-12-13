within Buildings.Utilities.Math.Functions.BaseClasses;
function der_regNonZeroPower
  "Power function, regularized near zero, but nonzero value for x=0"
 input Real x "Abscissa value";
 input Real n "Exponent";
 input Real delta = 0.01 "Abscissa value where transition occurs";
 input Real der_x;
 output Real der_y "Function value";
protected
  Real a1;
  Real a3;
  Real delta2;
  Real x2;
  Real y_d "=y(delta)";
  Real yP_d "=dy(delta)/dx";
  Real yPP_d "=d^2y(delta)/dx^2";
algorithm
  if abs(x) > delta then
   der_y := sign(x)*n*abs(x)^(n-1);
  else
   delta2 :=delta*delta;
   x2 :=x*x;
   y_d :=delta^n;
   yP_d :=n*delta^(n - 1);
   yPP_d :=n*(n - 1)*delta^(n - 2);
   a1 := -(yP_d/delta - yPP_d)/delta2/8;
   a3 := (yPP_d - 12 * a1 * delta2)/2;
   der_y := x * ( 4 * a1 * x * x + 2 * a3);
  end if;
 annotation(derivative(zeroDerivative=n, zeroDerivative=delta)=der_2_regNonZeroPower,
Documentation(
info="<html>
<p>
Implementation of the first derivative of the function
<a href=\"modelica://Buildings.Utilities.Math.Functions.regNonZeroPower\">
Buildings.Utilities.Math.Functions.regNonZeroPower</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 30, 2011, by Michael Wetter:<br/>
Added <code>zeroDerivative</code> keyword.
</li>
<li>
April 9, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end der_regNonZeroPower;
