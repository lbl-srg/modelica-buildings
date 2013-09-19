within Buildings.BoundaryConditions.WeatherData.BaseClasses.Examples;
model EquationOfTime "Test model for equation of time"
  extends Modelica.Icons.Example;
  Utilities.SimulationTime simTim
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.EquationOfTime eqnTim
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation
  connect(simTim.y, eqnTim.nDay) annotation (Line(
      points={{-19,10},{-2,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), 
experiment(StopTime=86400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/BaseClasses/Examples/EquationOfTime.mos"
        "Simulate and plot"));
end EquationOfTime;
