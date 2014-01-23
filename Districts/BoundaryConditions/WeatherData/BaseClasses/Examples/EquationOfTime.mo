within Districts.BoundaryConditions.WeatherData.BaseClasses.Examples;
model EquationOfTime "Test model for equation of time"
  extends Modelica.Icons.Example;
  import Districts;
  Districts.Utilities.SimulationTime simTim
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Districts.BoundaryConditions.WeatherData.BaseClasses.EquationOfTime eqnTim
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation
  connect(simTim.y, eqnTim.nDay) annotation (Line(
      points={{-19,10},{-2,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), __Dymola_Commands(file="modelica://Districts/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/BaseClasses/Examples/EquationOfTime.mos"
        "Simulate and plot"));
end EquationOfTime;
