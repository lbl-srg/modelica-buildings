within Buildings.Utilities.Math.Functions.BaseClasses;
function der_2_smoothTransition
  "Second order derivative of smoothTransition with respect to x"
  extends Modelica.Icons.Function;
  input Real x "Abscissa value";
  input Real delta(min=Modelica.Constants.eps)
    "Abscissa value below which approximation occurs";

  input Real deltaInv "Inverse value of delta";
  input Real a "Polynomial coefficient";
  input Real b "Polynomial coefficient";
  input Real c "Polynomial coefficient";
  input Real d "Polynomial coefficient";
  input Real e "Polynomial coefficient";
  input Real f "Polynomial coefficient";

  input Real x_der "Derivative of x";
  input Real x_der2 "Second order derivative of x";
  output Real y_der2 "Second order derivative of function value";
protected
  Real aX "Absolute value of x";
  Real ex "Intermediate expression";
algorithm
 aX:= abs(x);
 ex     := 2*c + aX*(6*d + aX*(12*e + aX*20*f));
 y_der2 := (b + aX*(2*c + aX*(3*d + aX*(4*e + aX*5*f))))*x_der2
         + x_der*x_der*( if x > 0 then ex else -ex);

annotation (
Documentation(info="<html>
<p>
This function is the 2nd order derivative of
<a href=\"modelica://Buildings.Utilities.Math.Functions.BaseClasses.smoothTransition\">
Buildings.Utilities.Math.Functions.BaseClasses.smoothTransition</a>.
</p>
<h4>Implementation</h4>
<p>
For efficiency, the polynomial coefficients
<code>a, b, c, d, e, f</code> and
the inverse of the smoothing parameter <code>deltaInv</code>
are exposed as arguments to this function.
</p>
</html>", revisions="<html>
<ul>
<li>
August 11, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end der_2_smoothTransition;
