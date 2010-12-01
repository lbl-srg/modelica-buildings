within Buildings.BoundaryConditions.SolarGeometry.Examples;
model ZenithAngle "Test model for zenith angle"
  import Buildings;
  Buildings.BoundaryConditions.SolarGeometry.ZenithAngle zen(lat = 0.2)
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.Utilities.SimulationTime simTim
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
equation
  connect(simTim.y, zen.cloTim) annotation (Line(
      points={{1,10},{18,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Commands(file="ZenithAngle.mos" "run"));
end ZenithAngle;
