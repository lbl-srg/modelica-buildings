within Buildings.BoundaryConditions.WeatherData.BaseClasses.Examples;
model SolarTime "Test model for solar time"
  extends Modelica.Icons.Example;
  Utilities.Time.ModelTime modTim "Block that outputs simulation time"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.LocalCivilTime locTim(
      timZon=-21600,
      lon=-1.7039261675061) "Block that computes the local civil time"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.SolarTime solTim
    "Block that computes the solar time"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.EquationOfTime eqnTim
    "Block that computes the equation of time"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
equation
  connect(modTim.y, locTim.cloTim) annotation (Line(
      points={{-39,-10},{-30,-10},{-30,-30},{-22,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(locTim.locTim, solTim.locTim) annotation (Line(
      points={{1,-30},{8,-30},{8,-15.4},{18,-15.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(modTim.y, eqnTim.nDay) annotation (Line(
      points={{-39,-10},{-30,-10},{-30,10},{-22,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(eqnTim.eqnTim, solTim.equTim) annotation (Line(
      points={{1,10},{8,10},{8,-4},{18,-4}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
  Documentation(info="<html>
<p>
This example tests the model that computes the solar time.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 14, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),  experiment(StopTime=864000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/BaseClasses/Examples/SolarTime.mos"
        "Simulate and plot"));
end SolarTime;
