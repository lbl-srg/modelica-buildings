within Buildings.Utilities.Math.Functions;
function smoothInterpolation
  "Interpolate using a cubic Hermite spline with linear extrapolation for a vector xSup[], ySup[] and independent variable x"
  extends Modelica.Icons.Function;
  input Real x "Abscissa value";
  input Real xSup[:] "Support points (strictly increasing)";
  input Real ySup[size(xSup,1)] "Function values at xSup";
  input Boolean ensureMonotonicity=isMonotonic(ySup, strict=false)
    "Set to true to ensure monotonicity of the cubic hermite";
  output Real yInt "Interpolated ordinate value";

protected
  Integer n = size(xSup,1) "Number of support points";
  Real dy_dx[size(xSup,1)] "Derivative at xSup";
  Integer i "Integer to select data interval";
algorithm
  if n > 2 then
    // Most common case with more than 2 data points.
    // Do cubic spline interpolation.
    dy_dx :=Buildings.Utilities.Math.Functions.splineDerivatives(
      x=xSup,
      y=ySup,
      ensureMonotonicity=ensureMonotonicity);

    // i is a counter that is used to pick the derivative
    // that corresponds to the interval that contains x
    i := 1;
    for j in 1:n-1 loop
      if x > xSup[j] then
        i := j;
       end if;
     end for;
     assert(xSup[i] < xSup[i+1], "Support points xSup must be increasing.");
     yInt:=cubicHermiteLinearExtrapolation(
        x=x,
        x1=xSup[i],
        x2=xSup[i+1],
        y1=ySup[i],
        y2=ySup[i+1],
        y1d=dy_dx[i],
        y2d=dy_dx[i+1]);
  elseif n == 2 then
    // Linear interpolation.
    yInt := ySup[1] + (x - xSup[1]) * (ySup[2] - ySup[1])/(xSup[2] - xSup[1]);
  else // n == 1
    yInt :=ySup[1];
  end if;
  annotation(smoothOrder=1,
      Documentation(info="<html>
<p>
For <i>xSup<sub>1</sub> &le; x &le; xSup<sub>n</sub></i>,
where <i>n</i> is the size of the support points <i>xSup</i>,
which must be strictly monotonically increasing,
this function interpolates
using cubic hermite spline. For <i>x</i> outside this interval, the function
linearly extrapolates.
</p>
<p>
If <i>n=2</i>, linear interpolation is used an if <i>n=1</i>, the
function value <i>y<sup>1</sup></i> is returned.
</p>
<p>
Note that if <code>xSup</code> and <code>ySup</code> only depend on parameters
or constants, then
<a href=\"modelica://Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation\">
Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation</a>
will be more efficient.
In contrast to the function
<a href=\"modelica://Modelica.Math.Vectors.interpolate\">
Modelica.Math.Vectors.interpolate</a>
which provides linear interpolation, this function does
not trigger events.
</p>
<p>
For how to use this function, see
<a href=\"modelica://Buildings.Utilities.Math.Functions.Examples.SmoothInterpolation\">
Buildings.Utilities.Math.Functions.Examples.SmoothInterpolation</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 1, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end smoothInterpolation;
