within Buildings.BoundaryConditions.WeatherData.BaseClasses;
partial block PartialLimiter
  "Partial block to limit a signal"
  extends Modelica.Blocks.Icons.Block;

  constant Real uMin = 0 "Minimum value";
  constant Real uMax = 1 "Maximum value";

  Modelica.Blocks.Interfaces.RealInput u "Connector of Real input signal" annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}})));

annotation (
defaultComponentName="lim",
Documentation(info="<html>
<p>
Block that computes <i>y_internal=min(uMax, max(uMin, u))</i>,
where <code>y_internal</code> is a protected connector.
</p>
<p>
This block is used because interpolation of weather data can lead to
a slight overshoot of values. This block is extended by other blocks
that then provide the output connector.
Extending this block is needed for the output connector to have the correct
comment string in the weather data bus, because the weather
data bus displays the comment string of the output signal
that is connected to the weather data bus.
Without this construct, the weather data bus would simply show
\"Connector of Real output signal\".
</p>
</html>",
revisions="<html>
<ul>
<li>
April 14, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
     Icon(coordinateSystem(
    preserveAspectRatio=true,
    extent={{-100,-100},{100,100}}), graphics={
    Line(points={{0,-90},{0,68}}, color={192,192,192}),
    Polygon(
      points={{0,90},{-8,68},{8,68},{0,90}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Line(points={{-90,0},{68,0}}, color={192,192,192}),
    Polygon(
      points={{90,0},{68,-8},{68,8},{90,0}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Line(points={{-80,-70},{-50,-70},{50,70},{80,70}}),
    Text(
      extent={{-150,-150},{150,-110}},
          textString="%uMin <= u <= %uMax",
          lineColor={0,0,0})}),
    Diagram(coordinateSystem(
    preserveAspectRatio=true,
    extent={{-100,-100},{100,100}})));
end PartialLimiter;
