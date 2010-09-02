within Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Examples;
model LocalTime "Test model for local time"
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.LocalTime locTim
    "Local time"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Utilities.SimulationTime simTim
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
equation
  connect(simTim.y, locTim.cloTim) annotation (Line(
      points={{1,10},{18,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Commands(file="LocalTime.mos" "run"));
end LocalTime;
