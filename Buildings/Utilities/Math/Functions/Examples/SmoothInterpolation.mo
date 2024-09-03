within Buildings.Utilities.Math.Functions.Examples;
model SmoothInterpolation
  "Test problem for cubic hermite splines that takes a vector of values as an argument"
  extends Modelica.Icons.Example;
  parameter Real[:] xSup={-1,1,5,6} "Support points";
  parameter Real[size(xSup, 1)] ySup={-1,1,2,10} "Support points";

  Real x "Independent variable";
  Real y "Dependent variable without monotone interpolation";
  Real yMonotone "Dependent variable with monotone interpolation";

  Real y2 "Dependent variable without monotone interpolation for n=2";
  Real y2Monotone "Dependent variable with monotone interpolation for n=2";

  Real y1 "Dependent variable without monotone interpolation for n=1";
  Real y1Monotone "Dependent variable with monotone interpolation for n=1";

algorithm
  x := xSup[1] + time*1.2*(xSup[size(xSup, 1)] - xSup[1]) - 0.5;
  // Extrapolate or interpolate the data
  y := Buildings.Utilities.Math.Functions.smoothInterpolation(
    x=x,
    xSup=xSup,
    ySup=ySup,
    ensureMonotonicity=false);
  yMonotone := Buildings.Utilities.Math.Functions.smoothInterpolation(
    x=x,
    xSup=xSup,
    ySup=ySup,
    ensureMonotonicity=true);
  // Case with n = 2
  y2 := Buildings.Utilities.Math.Functions.smoothInterpolation(
    x=x,
    xSup=xSup[1:2],
    ySup=ySup[1:2],
    ensureMonotonicity=false);
  y2Monotone := Buildings.Utilities.Math.Functions.smoothInterpolation(
    x=x,
    xSup=xSup[1:2],
    ySup=ySup[1:2],
    ensureMonotonicity=true);
  // Case with n = 1
  y1 := Buildings.Utilities.Math.Functions.smoothInterpolation(
    x=x,
    xSup={xSup[1]},
    ySup={ySup[1]},
    ensureMonotonicity=false);
  y1Monotone := Buildings.Utilities.Math.Functions.smoothInterpolation(
    x=x,
    xSup={xSup[1]},
    ySup={ySup[1]},
    ensureMonotonicity=true);
  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/SmoothInterpolation.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=1.0),
    Documentation(info="<html>
<p>
This example demonstrates the use of the function for cubic hermite interpolation
and linear extrapolation.
The example use interpolation with two different settings: One settings
produces a monotone cubic hermite, whereas the other setting
does not enforce monotonicity.
The resulting plot should look as shown below, where for better visibility, the support points have been marked with black dots.
Notice that the red curve is monotonically increasing.
</p>
<p align=\"center\"><img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Utilities/Math/Functions/Examples/cubicHermite.png\"/></p>
<p>
This example also tests the function for the situation where only <i>2</i> or
only <i>1</i> support points are provided.
In the first case, the result will be linear function and in the second case,
a constant value.
</p>
</html>", revisions="<html>
<ul>
<li>
October 1, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SmoothInterpolation;
