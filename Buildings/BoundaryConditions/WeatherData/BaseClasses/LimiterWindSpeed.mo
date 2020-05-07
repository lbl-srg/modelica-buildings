within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block LimiterWindSpeed "Block that limits the wind speed"
  extends PartialLimiterMin;

  Modelica.Blocks.Interfaces.RealOutput winSpe(
    final unit="m/s") = max(0, u) "Wind speed"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  annotation (
defaultComponentName="limMin",
Documentation(info="<html>
<p>
Block that limits the wind speed to be positive.
</p>
<p>
This block is used because interpolation of weather data can lead to slightly
negative values.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 14, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end LimiterWindSpeed;
