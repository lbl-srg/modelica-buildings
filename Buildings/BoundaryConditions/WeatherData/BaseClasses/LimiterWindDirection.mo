within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block LimiterWindDirection "Block that limits the wind direction"
  extends PartialLimiter(
    final uMax=2*Modelica.Constants.pi);

  Modelica.Blocks.Interfaces.RealOutput winDir(
    final unit="rad") "Wind direction"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  winDir = min(uMax, max(uMin, u));

  annotation (
defaultComponentName="lim",
Documentation(info="<html>
<p>
Block that limits the wind direction.
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
end LimiterWindDirection;
