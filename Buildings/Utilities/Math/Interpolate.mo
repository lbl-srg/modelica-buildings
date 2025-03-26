within Buildings.Utilities.Math;
block Interpolate
  "Output the cubic hermite spline interpolation of the input signal on the given curve"
  extends Modelica.Blocks.Interfaces.SISO;

  parameter Real[:] xd "x-axis support points";
  parameter Real[size(xd, 1)] yd "y-axis support points";
  parameter Real[size(xd, 1)] d "Derivatives at the support points";
equation
  y = Buildings.Utilities.Math.Functions.interpolate(u=u, xd=xd, yd=yd, d=d);

annotation (
defaultComponentName="int",
    Documentation(info="<html>
<p>
This block outputs the value on a cubic hermite spline through the given
support points and their spline derivatives at these points, using the function
<a href=\"modelica://Buildings.Utilities.Math.Functions.interpolate\">
Buildings.Utilities.Math.Functions.interpolate</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 29, 2024, by Hongxiang Fu:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1844\">IBPSA, #1844</a>.
</li>
</ul>
</html>"),
    Icon(graphics={
        Ellipse(
          extent={{-58,-56},{-68,-46}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-64,-52},{-36,6},{8,40},{78,26}},
          color={28,108,200},
          smooth=Smooth.Bezier),
        Ellipse(
          extent={{82,20},{72,30}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-10,18},{-20,28}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid)}));
end Interpolate;
