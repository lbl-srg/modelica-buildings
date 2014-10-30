within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block CheckWindSpeed "Ensures that the wind speed is non-negative"
  extends Modelica.Blocks.Icons.Block;
public
  Modelica.Blocks.Interfaces.RealInput winSpeIn(final quantity="Velocity",
      final unit="m/s") "Input wind speed"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput winSpeOut(final quantity="Velocity",
      final unit="m/s") "Wind speed"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  constant Modelica.SIunits.Velocity winSpeMin=1e-6
    "Minimum allowed wind speed";

equation
  // Modelica Table will interpolate data when it reads the weather data file.
  // It can generate negative values due to the interpolation.
  winSpeOut = Buildings.Utilities.Math.Functions.smoothMax(
    x1=winSpeIn,
    x2=winSpeMin,
    deltaX=winSpeMin/10);

  annotation (
    defaultComponentName="cheWinSpe",
    Documentation(info="<html>
<p>
This component ensures that the wind speed is non-negative.
</p>
</html>", revisions="<html>
<ul>
<li>
July 14, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-28,42},{26,-34}},
          lineColor={0,0,255},
          textString="m/s")}));
end CheckWindSpeed;
