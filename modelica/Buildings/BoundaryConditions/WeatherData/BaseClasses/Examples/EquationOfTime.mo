within Buildings.BoundaryConditions.WeatherData.BaseClasses.Examples;
model EquationOfTime "Test model for equation of time"
  import Buildings;
  Utilities.SimulationTime simTim
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.EquationOfTime eqnTim
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  annotation (Diagram(graphics), Commands(file="EquationOfTime.mos" "run"));
equation
  connect(simTim.y, eqnTim.nDay) annotation (Line(
      points={{-19,10},{-2,10}},
      color={0,0,127},
      smooth=Smooth.None));
end EquationOfTime;
