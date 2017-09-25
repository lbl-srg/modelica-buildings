within Buildings.BoundaryConditions.WeatherData.BaseClasses.Examples;
model CheckBlackBodySkyTemperature
  "Test model for CheckBlackBodySkyTemperature"
  extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.WeatherData.BaseClasses.CheckBlackBodySkyTemperature
    cheSkyBlaBodTem "Check for the black body sky temperature"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Sources.Ramp TBlaBod(
    height=140-0.02,
    duration=1,
    offset=273.15 - 69.99) "Black body sky temperature"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
equation
  connect(TBlaBod.y, cheSkyBlaBodTem.TIn)
    annotation (Line(points={{-19,0},{0,0},{18,0}}, color={0,0,127}));
  annotation (
Documentation(info="<html>
<p>
This example tests the model that checks the black-body sky temperature.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 5, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
  experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/BaseClasses/Examples/CheckBlackBodySkyTemperature.mos"
        "Simulate and plot"));
end CheckBlackBodySkyTemperature;
