within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block LimiterCeilingHeight "Block that limits the relative humidity"
  extends PartialLimiterMin;

  Modelica.Blocks.Interfaces.RealOutput ceiHei(
    final unit="m") = max(0, u) "Cloud cover ceiling height"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

annotation (
defaultComponentName="limMin",
Documentation(info="<html>
<p>
Block that limits the cloud cover ceiling height to be positive.
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
end LimiterCeilingHeight;
