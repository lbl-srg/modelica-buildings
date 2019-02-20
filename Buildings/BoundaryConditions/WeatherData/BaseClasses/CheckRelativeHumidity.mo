within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block CheckRelativeHumidity "Check the validity of relative humidity"
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Interfaces.RealInput relHumIn(final unit="1")
    "Input relative humidity"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput relHumOut(final unit="1")
    "Relative humidity"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  constant Real delta=0.01 "Smoothing parameter";
protected
  constant Real relHumMin=delta "Lower bound";
  constant Real relHumMax=1 - delta "Upper bound";

equation
  relHumOut = Buildings.Utilities.Math.Functions.smoothLimit(
    relHumIn,
    relHumMin,
    relHumMax,
    delta/10);
  annotation (
    defaultComponentName="cheRelHum",
    Documentation(info="<html>
<p>
This component constrains the value of relative humidity to a range of <i>[0, 1]</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 27, 2011, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Bitmap(extent={{-74,-78},{76,74}}, fileName=
              "modelica://Buildings/Resources/Images/BoundaryConditions/WeatherData/BaseClasses/relativeHumidity.png")}));
end CheckRelativeHumidity;
