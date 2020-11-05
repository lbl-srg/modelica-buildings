within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block LimiterHorizontalInfraredIrradiation
  "Block that limits the horizontal infrared irradiation"
  extends PartialLimiterMin;

  Modelica.Blocks.Interfaces.RealOutput HHorIR(
    final unit="W/m2") "Horizontal infrared irradiation"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  HHorIR = max(0, u);

  annotation (
defaultComponentName="limMin",
Documentation(info="<html>
<p>
Block that limits the horizontal infrared irradiation to be non-zero.
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
end LimiterHorizontalInfraredIrradiation;
