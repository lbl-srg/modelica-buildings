within Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Examples;
model Declination "Test model for declination"
  import Buildings;
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Declination decAng
    "Declination angle"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.Utilities.SimulationTime simTim
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
equation
  connect(simTim.y, decAng.nDay) annotation (Line(
      points={{1,10},{18,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Commands(file="Declination.mos" "run"));
end Declination;
