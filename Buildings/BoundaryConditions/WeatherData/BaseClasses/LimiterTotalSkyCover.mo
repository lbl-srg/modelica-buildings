within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block LimiterTotalSkyCover "Block that limits the total sky cover"
  extends PartialLimiter;

  Modelica.Blocks.Interfaces.RealOutput nTot(
    final unit="1") "Total sky cover"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  nTot = min(uMax, max(uMin, u));

  annotation (
defaultComponentName="lim",
Documentation(info="<html>
<p>
Block that limits the total sky cover.
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
end LimiterTotalSkyCover;
