within Buildings.Utilities.Math.Functions;
function inverseXRegularized
  "Function that approximates 1/x by a twice continuously differentiable function"
  extends Modelica.Icons.Function;
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

algorithm
  y :=if (x > delta or x < -delta) then 1/x elseif (x < delta/2 and x > -delta/2) then x/(delta*delta) else
    Buildings.Utilities.Math.Functions.BaseClasses.smoothTransition(
       x=x,
       delta=delta, deltaInv=deltaInv,
       a=a, b=b, c=c, d=d, e=e, f=f);

  annotation (smoothOrder=2,
  derivative(order=1,
          zeroDerivative=delta,
          zeroDerivative=deltaInv,
          zeroDerivative=a,
          zeroDerivative=b,
          zeroDerivative=c,
          zeroDerivative=d,
          zeroDerivative=e,
          zeroDerivative=f)=Buildings.Utilities.Math.Functions.BaseClasses.der_inverseXRegularized,
              Inline=true,
Documentation(info="<html>
<p>
Function that approximates <i>y=1 &frasl; x</i>
inside the interval <i>-&delta; &le; x &le; &delta;</i>.
The approximation is twice continuously differentiable with a bounded derivative on the whole
real line.
</p>
<p>
See the plot of
<a href=\"modelica://Buildings.Utilities.Math.Functions.Examples.InverseXRegularized\">
Buildings.Utilities.Math.Functions.Examples.InverseXRegularized</a>
for the graph.
</p>
<p>
For efficiency, the polynomial coefficients
<code>a, b, c, d, e, f</code> and
the inverse of the smoothing parameter <code>deltaInv</code>
are exposed as arguments to this function.
Typically, these coefficients only depend on parameters and hence
can be computed once.
They must be equal to their default values, otherwise the function
is not twice continuously differentiable.
By exposing these coefficients as function arguments, models
that call this function can compute them as parameters, and
assign these parameter values in the function call.
This avoids that the coefficients are evaluated for each time step,
as they would otherwise be if they were to be computed inside the
body of the function. However, assigning the values is optional
as otherwise, at the expense of efficiency, the values will be
computed each time the function is invoked.
See
<a href=\"modelica://Buildings.Utilities.Math.Functions.Examples.InverseXRegularized\">
Buildings.Utilities.Math.Functions.Examples.InverseXRegularized</a>
for how to efficiently call this function.
</p>
</html>", revisions="<html>
<ul>
<li>
August 10, 2015, by Michael Wetter:<br/>
Removed dublicate entry <code>smoothOrder = 1</code>
and reimplmented the function so it is twice continuously differentiable.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/302\">issue 302</a>.
</li>
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
</html>"));
end inverseXRegularized;
