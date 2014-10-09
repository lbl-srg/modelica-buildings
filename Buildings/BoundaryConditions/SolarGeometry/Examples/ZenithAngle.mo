within Buildings.BoundaryConditions.SolarGeometry.Examples;
model ZenithAngle "Test model for zenith angle"
  extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.SolarGeometry.ZenithAngle zen(lat = 0.2)
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam="modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
equation
  connect(weaDat.weaBus, zen.weaBus) annotation (Line(
      points={{-20,10},{19.8,10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Diagram(graphics), 
experiment(StartTime=100000, StopTime=300000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/SolarGeometry/Examples/ZenithAngle.mos" "Simulate and plot"));
end ZenithAngle;
