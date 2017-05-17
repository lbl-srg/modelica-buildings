within Buildings.Utilities.Math.Functions.BaseClasses;
function smoothTransition
  "Twice continuously differentiable transition between the regions"
  extends Modelica.Icons.Function;

  // The function that transitions between the regions is implemented
  // using its own function. This allows Dymola 2016 to inline the function
  // inverseXRegularized.

input Real x "Abscissa value";
input Real delta(min=Modelica.Constants.eps)
    "Abscissa value below which approximation occurs";
input Real deltaInv = 1/delta "Inverse value of delta";

input Real a = -15*deltaInv "Polynomial coefficient";
input Real b = 119*deltaInv^2 "Polynomial coefficient";
input Real c = -361*deltaInv^3 "Polynomial coefficient";
input Real d = 534*deltaInv^4 "Polynomial coefficient";
input Real e = -380*deltaInv^5 "Polynomial coefficient";
input Real f = 104*deltaInv^6 "Polynomial coefficient";
output Real y "Function value";
protected
  Real aX "Absolute value of x";

algorithm
 aX:= abs(x);
 y := a + aX*(b + aX*(c + aX*(d + aX*(e + aX*f))));
 if x < 0 then
    y := -y;
 end if;
annotation(smoothOrder=2,
  derivative(order=1,
          zeroDerivative=delta,
          zeroDerivative=deltaInv,
          zeroDerivative=a,
          zeroDerivative=b,
          zeroDerivative=c,
          zeroDerivative=d,
          zeroDerivative=e,
          zeroDerivative=f)=Buildings.Utilities.Math.Functions.BaseClasses.der_smoothTransition,
    Documentation(info="<html>
<p>
This function is used by
<a href=\"modelica://Buildings.Utilities.Math.Functions.inverseXRegularized\">
Buildings.Utilities.Math.Functions.inverseXRegularized</a>
to provide a twice continuously differentiable transition between
the different regions.
The code has been implemented in a function as this allows
to implement the function
<a href=\"modelica://Buildings.Utilities.Math.Functions.inverseXRegularized\">
Buildings.Utilities.Math.Functions.inverseXRegularized</a>
in such a way that Dymola inlines it.
However, this function will not be inlined as its body is too large.
</p>
<h4>Implementation</h4>
<p>
For efficiency, the polynomial coefficients
<code>a, b, c, d, e, f</code> and
the inverse of the smoothing parameter <code>deltaInv</code>
are exposed as arguments to this function.
Also,
derivatives are provided in
<a href=\"modelica://Buildings.Utilities.Math.Functions.BaseClasses.der_smoothTransition\">
Buildings.Utilities.Math.Functions.BaseClasses.der_smoothTransition</a>
and in
<a href=\"modelica://Buildings.Utilities.Math.Functions.BaseClasses.der_2_smoothTransition\">
Buildings.Utilities.Math.Functions.BaseClasses.der_2__smoothTransition</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 11, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end smoothTransition;
