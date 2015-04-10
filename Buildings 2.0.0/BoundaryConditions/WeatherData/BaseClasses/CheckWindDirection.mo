within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block CheckWindDirection "Constrains the wind direction to [0, 2*pi] degree"
  extends Modelica.Blocks.Icons.Block;
public
  Modelica.Blocks.Interfaces.RealInput nIn(
    final quantity="Angle",
    final unit="rad",
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
    nIn,
    nMin,
    nMax,
    delta/10);
  annotation (
    defaultComponentName="cheWinDir",
    Documentation(info="<html>
<p>
This component constrains the interpolated wind direction between <i>0</i> and <i>360</i> degree.
</p>
</html>", revisions="<html>
<ul>
<li>
October 27, 2011, by Wangda Zuo:<br/>
Delete the unit convertion part since it will be done outside.
</li>
<li>
July 14, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end CheckWindDirection;
