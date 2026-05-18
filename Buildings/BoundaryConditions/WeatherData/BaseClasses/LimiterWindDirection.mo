within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block LimiterWindDirection "Block that limits the wind direction"
  extends Modelica.Blocks.Icons.Block;
  constant Real uMax = 2*Modelica.Constants.pi "Maximum value";

  Modelica.Blocks.Interfaces.RealInput u
    "Wind direction" annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput winDir(
    final unit="rad") "Wind direction between 0 and 2 pi"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  // Use noEvent as we don't need a support point at the exact switching point
  winDir = noEvent(mod(u, uMax));

  annotation (
defaultComponentName="lim",
Documentation(info="<html>
<p>
Block that limits the wind direction.
</p>
<p>
This block is used because the weather data from file can have
values for wind direction below 0 and above 360 degrees.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 1, 2026, by Michael Wetter:<br/>
Changed implementation to restrict output to <code>[0, 360)</code> degrees.
This changes the range of the output to be the same as in the original implementation,
but makes the block valid for any input value.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2068\">IBPSA, #2068</a>.
</li>
<li>
April 7, 2026, by Ettore Zanetti:<br/>
Updated limit from [0,360] to [-720,720].<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2068\">IBPSA, #2068</a>.
</li>
<li>
April 14, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end LimiterWindDirection;
