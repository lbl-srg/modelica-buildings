within Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Examples;
model EquationOfTime "Test model for equation of time"
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.EquationOfTime eqnTim
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Utilities.SimulationTime simTim
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
equation
  connect(simTim.y, eqnTim.nDay) annotation (Line(
      points={{-19,10},{-2,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Commands(file="EquationOfTime.mos" "run"));
end EquationOfTime;
