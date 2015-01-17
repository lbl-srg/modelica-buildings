within Buildings.BoundaryConditions.WeatherData.BaseClasses.Examples;
model EquationOfTime "Test model for equation of time"
  extends Modelica.Icons.Example;
  Utilities.Time.ModelTime modTim "Block that outputs simulation time"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.EquationOfTime eqnTim
    "Block that computes the equation of time"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation
  connect(modTim.y, eqnTim.nDay) annotation (Line(
      points={{-19,10},{-2,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
  Documentation(info="<html>
<p>
This example tests the model that computes the equation of time.
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
  experiment(StopTime=86400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/BaseClasses/Examples/EquationOfTime.mos"
        "Simulate and plot"));
end EquationOfTime;
