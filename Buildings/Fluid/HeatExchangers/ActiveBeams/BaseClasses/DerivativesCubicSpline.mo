within Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses;
model DerivativesCubicSpline "Cubic Spline for interpolation"
  extends Modelica.Blocks.Icons.Block;
  parameter Real[:] xd={0,0.5,1};
  parameter Real[size(xd, 1)] yd={0,0.75,1};

  parameter Real[size(xd, 1)] dMonotone(each fixed=false);
 // parameter Boolean ensureMonotonicity=true;
  Real x;
  Real yMonotone;
  Integer i;
  Modelica.Blocks.Interfaces.RealInput u
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y=yMonotone
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

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
    experiment(StopTime=1.0),defaultComponentName="cubSpl",
    Documentation(info="<html>
<p>
This model calculates the output based on the cubic hermite interpolation
and linear extrapolation of predefined values. The predefined values must create a monotone curve.

</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    Icon(graphics={
    Line(points={{46,-76},{46,58}},
                                  color={192,192,192}),
        Line(
          points={{-82,-72},{-40,-72},{-18,-56},{-6,-32},{0,-8},{14,26},{32,46},
              {46,50},{80,50}}),
    Line(points={{-84,-72},{84,-72}},  color={192,192,192}),
    Line(points={{-40,-78},{-40,-66}},
                                  color={192,192,192}),
    Line(points={{0,-88},{0,86}}, color={192,192,192}),
    Polygon(
      points={{0,90},{-6,74},{6,74},{0,90}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid)}));
end DerivativesCubicSpline;
