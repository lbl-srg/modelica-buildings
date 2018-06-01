within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block ConvertRelativeHumidity
  "Convert the relative humidity from percentage to real"
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Interfaces.RealInput relHumIn(unit="1")
    "Value of relative humidity in percentage"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput relHumOut(unit="1")
    "Relative humidity between 0 and 1"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  relHumOut = relHumIn/100;
  annotation (
    defaultComponentName="conRelHum",
    Documentation(info="<html>
<p>
This component converts the relative humidity from percentage to real.
Input is the relative humidity in percentage, as this is the data
format that is used in the Typical Meteorological Year weather data.
</p>
</html>", revisions="<html>
<ul>
<li>
October 27, 2011, by Wangda Zuo:<br/>
Separate the checking function to CheckRelativeHumidity.
</li>
<li>
July 14, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Bitmap(extent={{-74,-78},{76,74}}, fileName=
              "modelica://Buildings/Resources/Images/BoundaryConditions/WeatherData/BaseClasses/relativeHumidity.png")}));
end ConvertRelativeHumidity;
