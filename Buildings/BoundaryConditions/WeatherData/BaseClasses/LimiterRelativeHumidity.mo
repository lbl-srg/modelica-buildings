within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block LimiterRelativeHumidity "Block that limits the relative humidity"
  extends PartialLimiter;

  Modelica.Blocks.Interfaces.RealOutput relHum(
    final unit="1") "Relative humidity"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  relHum = min(uMax, max(uMin, u));

  annotation (
defaultComponentName="lim",
Documentation(info="<html>
<p>
Block that limits the relative humidity.
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
end LimiterRelativeHumidity;
