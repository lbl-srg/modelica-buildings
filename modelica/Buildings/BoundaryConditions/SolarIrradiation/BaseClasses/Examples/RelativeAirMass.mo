within Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.Examples;
model RelativeAirMass "Test model for relative air mass"
  import Buildings;
  Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.RelativeAirMass
    relAirMas annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.BoundaryConditions.SolarGeometry.ZenithAngle zenAng(lat=
        0.34906585039887)
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Buildings.Utilities.SimulationTime simTim
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
equation
  connect(zenAng.y, relAirMas.zenAng) annotation (Line(
      points={{1,10},{18,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(simTim.y, zenAng.cloTim) annotation (Line(
      points={{-39,10},{-22,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Commands(file="RelativeAirMass.mos" "run"));
end RelativeAirMass;
