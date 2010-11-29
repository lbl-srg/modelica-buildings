within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block CheckWindDirection "Constrains the wind direction to [0, 360] degree"
  extends Modelica.Blocks.Interfaces.BlockIcon;
public
  Modelica.Blocks.Interfaces.RealInput nIn(
    final quantity="Angle",
    final unit="deg",
    displayUnit="deg") "Input wind direction"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput nOut(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg") "Wind direction"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  constant Real delta=0.01 "Smoothing parameter";
protected
  constant Real nMin=0 "Lower bound";
  constant Real nMax=2*Modelica.Constants.pi "Upper bound";
equation

  nOut = Buildings.Utilities.Math.Functions.smoothLimit(
    nIn/360*nMax,
    nMin,
    nMax,
    delta/10);
  annotation (
    defaultComponentName="cheWinDir",
    Documentation(info="<HTML>
<p>
This component constrains the interpolated wind direction between 0 and 360 degree.
</p>
</HTML>
", revisions="<html>
<ul>
<li>
July 14, 2010, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,
            100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics));
end CheckWindDirection;
