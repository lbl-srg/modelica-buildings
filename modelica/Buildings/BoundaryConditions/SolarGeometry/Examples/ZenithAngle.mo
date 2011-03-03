within Buildings.BoundaryConditions.SolarGeometry.Examples;
model ZenithAngle "Test model for zenith angle"
  import Buildings;
  Buildings.BoundaryConditions.SolarGeometry.ZenithAngle zen(lat = 0.2)
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.BoundaryConditions.WeatherData.Reader weaDat(
    filNam="Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos",
    lon=-1.5293932423067,
    timZon=-21600)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  annotation (Diagram(graphics), Commands(file="ZenithAngle.mos" "run"));
equation
  connect(weaDat.weaBus, zen.weaBus) annotation (Line(
      points={{-20,10},{19.8,10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
end ZenithAngle;
