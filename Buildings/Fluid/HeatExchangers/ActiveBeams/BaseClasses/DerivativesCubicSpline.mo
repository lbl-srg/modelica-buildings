within Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses;
model DerivativesCubicSpline "Cubic spline for interpolation"
  extends Modelica.Blocks.Icons.Block;
  parameter Real[:] xd={0,0.5,1};
  parameter Real[size(xd, 1)] yd={0,0.75,1};

  Modelica.Blocks.Interfaces.RealInput u
    "Independent variable for interpolation"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y "Interpolated value"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
protected
  parameter Real[size(xd, 1)] dMonotone(each fixed=false) "Derivatives";
  Integer i "Counter to pick the interpolation interval";

initial algorithm
  // Get the derivative values at the support points

  dMonotone := Buildings.Utilities.Math.Functions.splineDerivatives(
    x=xd,
    y=yd,
    ensureMonotonicity=true);

algorithm
  i := 1;
  for j in 1:size(xd, 1) - 1 loop
    if u > xd[j] then
      i := j;
    end if;
  end for;
  // Extrapolate or interpolate the data
  y :=
    Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation(
    x=u,
    x1=xd[i],
    x2=xd[i + 1],
    y1=yd[i],
    y2=yd[i + 1],
    y1d=dMonotone[i],
    y2d=dMonotone[i + 1]);
annotation (
  defaultComponentName="cubSpl",
  Documentation(info="<html>
<p>
This model calculates the output based on the cubic hermite interpolation
and linear extrapolation of predefined values. The predefined values must create a monotone curve.
</p>
</html>", revisions="<html>
<ul>
<li>
December 15, 2016, by Michael Wetter:<br/>
Removed wrong annotations.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/629\">#629</a>.
</li>
<li>
June 13, 2016, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
May 20, 2016, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
    Line(points={{46,-76},{46,58}},
                                  color={192,192,192}),
    Line(points={{-84,-72},{84,-72}},  color={192,192,192}),
    Line(points={{-40,-78},{-40,-66}},
                                  color={192,192,192}),
    Line(points={{0,-88},{0,86}}, color={192,192,192}),
    Polygon(
      points={{0,90},{-6,74},{6,74},{0,90}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
        Line(
          points={{-82,-72},{-40,-72},{-18,-56},{-6,-32},{0,-8},{14,26},{32,46},
              {46,50},{80,50}},
          color={0,0,0},
          smooth=Smooth.Bezier)}));
end DerivativesCubicSpline;
