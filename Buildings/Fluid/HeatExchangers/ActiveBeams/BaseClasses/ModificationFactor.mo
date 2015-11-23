within Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses;
model ModificationFactor "Modification factor"

  parameter Real[:] xd={0,0.5,1};
  parameter Real[size(xd, 1)] yd={0,0.5,0.7};

  parameter Real[size(xd, 1)] dMonotone(each fixed=false);
  parameter Boolean ensureMonotonicity=true;
  Real x;
  Real yMonotone;
  Integer i;
  Modelica.Blocks.Interfaces.RealInput u
    annotation (Placement(transformation(extent={{-126,-22},{-86,18}})));
  Modelica.Blocks.Interfaces.RealOutput y=yMonotone
    annotation (Placement(transformation(extent={{96,-10},{116,10}})));
initial algorithm
  // Get the derivative values at the support points

  dMonotone := Buildings.Utilities.Math.Functions.splineDerivatives(x=xd, y=yd,
      ensureMonotonicity=true);
algorithm
  x:=u;
  // i is a counter that is used to pick the derivative of d or dMonotonic
  // that correspond to the interval that contains x
  i := 1;
  for j in 1:size(xd, 1) - 1 loop
    if x > xd[j] then
      i := j;
    end if;
  end for;
  // Extrapolate or interpolate the data
  yMonotone :=
    Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation(
    x=x,
    x1=xd[i],
    x2=xd[i + 1],
    y1=yd[i],
    y2=yd[i + 1],
    y1d=dMonotone[i],
    y2d=dMonotone[i + 1]);
  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/CubicHermite.mos"
        "Simulate and plot"),
    experiment(StopTime=1.0),
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
<p align=\"center\"><img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Utilities/Math/Functions/Examples/cubicHermite.png\"/></p>
</html>", revisions="<html>
<ul>
<li>
March 8, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})));
end ModificationFactor;
