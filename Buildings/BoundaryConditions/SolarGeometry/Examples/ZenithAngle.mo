within Buildings.BoundaryConditions.SolarGeometry.Examples;
model ZenithAngle "Test model for zenith angle"
  extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.SolarGeometry.ZenithAngle zen(lat=0.2)
    "Zenith angle"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
equation
  connect(weaDat.weaBus, zen.weaBus) annotation (Line(
      points={{-20,10},{20,10}},
      color={255,204,51},
      thickness=0.5));
  annotation (
  Documentation(info="<html>
<p>
This example computes the zenith angle,
which is the angle between the earth surface normal and the sun beam.
</p>
</html>", revisions="<html>
<ul>
<li>
February 25, 2012, by Michael Wetter:<br/>
Changed model to get declination angle and
solar hour angle from weather bus.
</li>
<li>
May 17, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
  experiment(StartTime=100000, Tolerance=1e-6, StopTime=300000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/SolarGeometry/Examples/ZenithAngle.mos"
        "Simulate and plot"));
end ZenithAngle;
