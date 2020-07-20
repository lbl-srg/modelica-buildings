within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block LimiterWindSpeed "Block that limits the wind speed"
  extends PartialLimiterMin;

  Modelica.Blocks.Interfaces.RealOutput winSpe(
    final unit="m/s") "Wind speed"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  winSpe = max(0, u);

  annotation (
defaultComponentName="limMin",
Documentation(info="<html>
<p>
Block that limits the wind speed to be non-zero.
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
