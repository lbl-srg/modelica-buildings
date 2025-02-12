within Buildings.Utilities.Math.Functions;
function splineDerivatives
  "Function to compute the derivatives for cubic hermite spline interpolation"
  extends Modelica.Icons.Function;
  input Real x[:] "Support point, strictly increasing";
  input Real y[size(x, 1)] "Function values at x";
  input Boolean ensureMonotonicity=isMonotonic(y, strict=false)
    "Set to true to ensure monotonicity of the cubic hermite";
  output Real d[size(x, 1)] "Derivative at the support points";
protected
  Integer n=size(x, 1) "Number of data points";
  Real delta[n - 1] "Slope of secant line between data points";
  Real alpha "Coefficient to ensure monotonicity";
  Real beta "Coefficient to ensure monotonicity";
  Real tau "Coefficient to ensure monotonicity";

algorithm
  if (n>1) then
    assert(x[1] < x[n], "x must be strictly increasing.
  Received x[1] = " + String(x[1]) + "
           x[" + String(n) + "] = " + String(x[n]));
  // Check data
    assert(isMonotonic(x, strict=true),
      "x-values must be strictly increasing or decreasing.");
    if ensureMonotonicity then
      assert(isMonotonic(y, strict=false),
        "If ensureMonotonicity=true, y-values must be strictly increasing or decreasing.");
    end if;
  end if;

  // Compute derivatives at the support points
  if n == 1 then
    // only one data point
    d[1] :=0;
  elseif n == 2 then
    // linear function
    d[1] := (y[2] - y[1])/(x[2] - x[1]);
    d[2] := d[1];
  else
    // Slopes of the secant lines between i and i+1
    for i in 1:n - 1 loop
      delta[i] := (y[i + 1] - y[i])/(x[i + 1] - x[i]);
    end for;
    // Initial values for tangents at the support points.
    // End points use one-sided derivatives
    d[1] := delta[1];
    d[n] := delta[n - 1];

    for i in 2:n - 1 loop
      d[i] := (delta[i - 1] + delta[i])/2;
    end for;

  end if;
  // Ensure monotonicity
  if n > 2 and ensureMonotonicity then
    for i in 1:n - 1 loop
      if (abs(delta[i]) < Modelica.Constants.small) then
        d[i] := 0;
        d[i + 1] := 0;
      else
        alpha := d[i]/delta[i];
        beta := d[i + 1]/delta[i];
        // Constrain derivative to ensure monotonicity in this interval
        if (alpha^2 + beta^2) > 9 then
          tau := 3/(alpha^2 + beta^2)^(1/2);
          d[i] := delta[i]*alpha*tau;
          d[i + 1] := delta[i]*beta*tau;
        end if;
      end if;
    end for;
  end if;
  annotation (Documentation(info="<html>
<p>
This function computes the derivatives at the support points <i>x<sub>i</sub></i>
that can be used as input for evaluating a cubic hermite spline.
</p>
<p>
If <code>ensureMonotonicity=true</code>, then the support points <i>y<sub>i</sub></i>
need to be monotone increasing (or decreasing), and the computed derivatives
<i>d<sub>i</sub></i> are such that the cubic hermite is monotone increasing (or decreasing).
The algorithm to ensure monotonicity is based on the method described in Fritsch and Carlson (1980) for
<i>&rho; = &rho;<sub>2</sub></i>.
</p>
<p>
This function is typically used with
<a href=\"modelica://Buildings.Utilities.Math.Functions.interpolate\">
Buildings.Utilities.Math.Functions.interpolate</a>
which is used to evaluate the cubic spline.
Because in many applications, the shape of the spline depends on parameters
which will no longer change once the initialisation is complete,
this function computes and returns the derivatives so that they can be stored by the calling
model to avoid repetitive computations.
</p>
<h4>References</h4>
<p>
F.N. Fritsch and R.E. Carlson, <a href=\"http://dx.doi.org/10.1137/0717021\">Monotone piecewise cubic interpolation</a>.
<i>SIAM J. Numer. Anal.</i>, 17 (1980), pp. 238-246.
</p>
</html>", revisions="<html>
<ul>
<li>
January 26, 2016 by Michael Wetter:<br/>
Corrected documentation.
</li>
<li>
September 29, 2011 by Michael Wetter:<br/>
Added special case for one data point and two data points.
</li>
<li>
September 27, 2011 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end splineDerivatives;
