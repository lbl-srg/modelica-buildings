within Buildings.BoundaryConditions.SolarGeometry.Examples;
model IncidenceAngle "Test model for solar incidence angle"
  import Buildings;
  Buildings.BoundaryConditions.SolarGeometry.IncidenceAngle incAng(lat=0.2, aziAng = 0.3, tilAng = 0.5)
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Utilities.SimulationTime simTim
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
equation
  connect(simTim.y, incAng.cloTim) annotation (Line(
      points={{-19,10},{-1.8,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Commands(file="IncidenceAngle.mos" "run"));
end IncidenceAngle;
