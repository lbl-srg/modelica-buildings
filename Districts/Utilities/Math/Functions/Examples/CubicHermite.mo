within Districts.Utilities.Math.Functions.Examples;
model CubicHermite "Test problem for cubic hermite splines"
  extends Modelica.Icons.Example;
  parameter Real[:] xd={-1,1,5,6} "Support points";
  parameter Real[size(xd, 1)] yd={-1,1,2,10} "Support points";
  parameter Real[size(xd, 1)] d(fixed=false)
    "Derivatives at the support points";
  parameter Real[size(xd, 1)] dMonotone(fixed=false)
    "Derivatives at the support points";
  parameter Boolean ensureMonotonicity=true;
  Real x "Independent variable";
  Real y "Dependent variable without monotone interpolation";
  Real yMonotone "Dependent variable with monotone interpolation";
  Integer i "Integer to select data interval";
initial algorithm
  // Get the derivative values at the support points
  d := Districts.Utilities.Math.Functions.splineDerivatives(
    x=xd,
    y=yd,
    ensureMonotonicity=false);
  dMonotone := Districts.Utilities.Math.Functions.splineDerivatives(x=xd, y=yd);
algorithm
  x := xd[1] + time*1.2*(xd[size(xd, 1)] - xd[1]) - 0.5;
  // i is a counter that is used to pick the derivative of d or dMonotonic
  // that correspond to the interval that contains x
  i := 1;
  for j in 1:size(xd, 1) - 1 loop
    if x > xd[j] then
      i := j;
    end if;
  end for;
  // Extrapolate or interpolate the data
  y := Districts.Utilities.Math.Functions.cubicHermiteLinearExtrapolation(
    x=x,
    x1=xd[i],
    x2=xd[i + 1],
    y1=yd[i],
    y2=yd[i + 1],
    y1d=d[i],
    y2d=d[i + 1]);
  yMonotone :=
    Districts.Utilities.Math.Functions.cubicHermiteLinearExtrapolation(
    x=x,
    x1=xd[i],
    x2=xd[i + 1],
    y1=yd[i],
    y2=yd[i + 1],
    y1d=dMonotone[i],
    y2d=dMonotone[i + 1]);
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    __Dymola_Commands(file=
          "modelica://Districts/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/CubicHermite.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example demonstrates the use of the function for cubic hermite interpolation
and linear extrapolation.
The example use interpolation with two different settings: One settings
produces a monotone cubic hermite, whereas the other setting
does not enforce monotonicity.
The resulting plot should look as shown below, where for better visibility, the support points have been marked with black dots.
Notice that the red curve is monotone increasing.
</p>
<p align=\"center\"><img src=\"modelica://Districts/Resources/Images/Utilities/Math/Functions/Examples/cubicHermite.png\"/></p>
</html>"));
end CubicHermite;
