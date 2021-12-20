within Buildings.BoundaryConditions.WeatherData.BaseClasses;
partial block PartialLimiterMin
  "Partial block to limit a signal"
  extends Modelica.Blocks.Icons.Block;

  Modelica.Blocks.Interfaces.RealInput u "Connector of Real input signal"
  annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}})));

annotation (
defaultComponentName="limMin",
Documentation(info="<html>
<p>
Partial block that is used to limit a signal by a minimum value.
</p>
<p>
This block is used because interpolation of weather data can lead to slightly
negative values. This block is extended by other blocks
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
    Icon(
      graphics={
        Text(
          extent={{-100,30},{98,-16}},
          textColor={0,0,0},
          textString="0 <= u")}));
end PartialLimiterMin;
