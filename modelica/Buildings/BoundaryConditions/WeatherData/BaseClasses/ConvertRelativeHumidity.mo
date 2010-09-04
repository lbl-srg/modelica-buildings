within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block ConvertRelativeHumidity
  "Converts the relative humidity from percentage to [0, 1] and constrains it to [0, 1]"
  extends Modelica.Blocks.Interfaces.BlockIcon;
public
  Modelica.Blocks.Interfaces.RealInput relHumIn
    "Input relative humidity data in percentage"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput relHumOut
    "Output relative humidity data in percentage"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  constant Real delta = 0.01 "Smoothing parameter";
protected
  constant Real relHumMin = delta "Lower bound";
  constant Real relHumMax = 1-delta "Upper bound";
equation
  relHumOut = Buildings.Utilities.Math.Functions.smoothLimit(
    relHumIn/100,
    relHumMin,
    relHumMax,
    delta/10);
  annotation (
    defaultComponentName="conHum",
    Documentation(info="<HTML>
<p>
This component converts the relative humidity to a range of [0, 1].
Input is the relative humidity in percentage, as this is the data
format that is used in the Typical Meteorological Year weather data.
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
            100}}), graphics={Bitmap(
          extent={{-56,52},{62,-42}},
          fileName="modelica://Buildings/Images/Utilities/IO/WeatherData/BaseClasses/RelativeHumidity.png")}));
end ConvertRelativeHumidity;
