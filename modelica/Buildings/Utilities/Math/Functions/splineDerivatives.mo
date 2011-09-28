within Buildings.Utilities.Math.Functions;
function splineDerivatives
  "Function to compute the derivatives for cubic hermite spline interpolation"
 input Real x[size(x,1)] "Support point, monotone increasing or decreasing";
 input Real y[size(x,1)] "Function values at x";
 input Boolean ensureMonotonicity
    "Set to true to ensure monotonicity of the cubic hermite";
 output Real d[size(x,1)] "Derivative at the support points";
protected
  Integer n = size(x,1) "Number of data points";
  Real delta[n-1] "Slope of secant line between data points";
  Real alpha "Coefficient to ensure monotonicity";
  Real beta "Coefficient to ensure monotonicity";
  Real tau "Coefficient to ensure monotonicity";

algorithm
  assert(n>1, "Need at least two data points.");
  // Check data
  if (x[1] > x[n]) then
      for i in 1:n-1 loop
          assert(x[i] > x[i+1], "x-values must be strictly monontone increasing or decreasing.");
      end for;
  else
      for i in 1:n-1 loop
          assert(x[i] < x[i+1], "x-values must be strictly monontone increasing or decreasing.");
      end for;
  end if;
  if ensureMonotonicity then
    if (y[1] > y[n]) then
      for i in 1:n-1 loop
          assert(y[i] >= y[i+1], "If ensureMonotonicity=true, y-values must be strictly monontone increasing or decreasing.");
      end for;
     else
      for i in 1:n-1 loop
          assert(y[i] <= y[i+1], "If ensureMonotonicity=true, y-values must be strictly monontone increasing or decreasing.");
      end for;
     end if;
  end if;

  // Compute derivatives at the support points
  if n==2 then // linear function
    d[1] := (y[2] - y[1])/(x[2] - x[1]);
    d[2] := d[n];
  else
    // Slopes of the secant lines between i and i+1
    for i in 1:n-1 loop
      delta[i] := (y[i+1]-y[i])/(x[i+1]-x[i]);
    end for;
    // Initial values for tangents at the support points.
    // End points use one-sided derivatives
    d[1] :=delta[1];
    d[n] :=delta[n-1];

    for i in 2:n-1 loop
      d[i] := (delta[i-1]+delta[i])/2;
    end for;

  end if;
  // Ensure monotonicity
  if ensureMonotonicity then
    for i in 1:n-1 loop
       if (abs(delta[i])<Modelica.Constants.small) then
          d[i]     := 0;
          d[i+1]   := 0;
        else
          alpha :=d[i]/delta[i];
          beta  :=d[i+1]/delta[i];
          Modelica.Utilities.Streams.print("alpha=" + String(alpha) + "  beta=" + String(beta));
          // Constrain derivative to ensure monotonicity in this interval
          if (alpha^2 + beta^2) > 9 then
            tau   :=3/(alpha^2 + beta^2)^(1/2);
            d[i]   :=delta[i]*alpha*tau;
            d[i+1] :=delta[i]*beta *tau;
            Modelica.Utilities.Streams.print("dl=" + String(d[i]) + "  du=" + String(d[i+1]));
          end if;
       end if;
   end for;
  end if;
 annotation (
      Documentation(info="<html>
<p>
This function computes the derivatives at the support points <i>x<sub>i</sub></i>
that can be used as input for evaluating a cubic hermite spline.
If <code>ensureMonotonicity=true</code>, then the support points <i>y<sub>i</sub></i>
need to be monotone increasing (or increasing), and the computed derivatives
<i>d<sub>i</sub></i> are such that the cubic hermite is monotone increasing (or decreasing).
The algorithm to ensure monotonicity is based on the method described in Fritsch and Carlson (1980) for
<i>&rho; = &rho;<sub>2</sub></i>.
</p>
<p>
This function is typically used with
<a href=\"modelica://Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation\">
Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation</a>
which is used to evaluate the cubic spline.
Because in many applications, the shape of the spline depends on parameters,
this function has been implemented in such a way that all derivatives can be 
computed at once and then stored for use during the time stepping,
in which the above function may be called.
</p>
<h4>References</h4>
<p>
F.N. Fritsch and R.E. Carlson, <a href=\"http://dx.doi.org/10.1137/0717021\">Monotone piecewise cubic interpolation</a>. 
<i>SIAM J. Numer. Anal.</i>, 17 (1980), pp. 238?246.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 27, 2011 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end splineDerivatives;
