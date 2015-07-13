within Buildings.BoundaryConditions.WeatherData.BaseClasses.Examples;
model CheckRelativeHumidity "Test model for CheckRelativeHumidity"
  extends
    Buildings.BoundaryConditions.WeatherData.BaseClasses.Examples.ConvertRelativeHumidity;

  Buildings.BoundaryConditions.WeatherData.BaseClasses.CheckRelativeHumidity cheRelHum
    "Block that constrains the relative humidity"
  annotation (Placement(transformation(extent={{60,0},{80,20}})));
equation
  connect(conRelHum.relHumOut, cheRelHum.relHumIn) annotation (Line(
      points={{41,10},{58,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
  Documentation(info="<html>
<p>
This example tests the model that constrains the relative humidity.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 14, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
  experiment(StopTime=8640000),
__Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/BaseClasses/Examples/CheckRelativeHumidity.mos"
        "Simulate and plot"));
end CheckRelativeHumidity;
