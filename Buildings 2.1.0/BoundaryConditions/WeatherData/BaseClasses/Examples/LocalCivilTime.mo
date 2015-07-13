within Buildings.BoundaryConditions.WeatherData.BaseClasses.Examples;
model LocalCivilTime "Test model for calculate local civil time"
  extends Modelica.Icons.Example;
  Buildings.Utilities.Time.ModelTime modTim
    "Block that outputs the model time"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.LocalCivilTime locTim(
      timZon=-21600, lon=-1.5293932423067)
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation
  connect(modTim.y, locTim.cloTim) annotation (Line(
      points={{-19,10},{-2,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
  Documentation(info="<html>
<p>
This example tests the model that computes the local civil time.
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
  experiment(StopTime=172800),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/BaseClasses/Examples/LocalCivilTime.mos"
        "Simulate and plot"));
end LocalCivilTime;
