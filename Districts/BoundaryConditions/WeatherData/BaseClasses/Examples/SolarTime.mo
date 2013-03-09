within Districts.BoundaryConditions.WeatherData.BaseClasses.Examples;
model SolarTime "Test model for solar time"
  extends Modelica.Icons.Example;
  import Districts;
  Districts.Utilities.SimulationTime simTim
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Districts.BoundaryConditions.WeatherData.BaseClasses.LocalCivilTime locTim(
      timZon=-21600, lon=-1.7039261675061)
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Districts.BoundaryConditions.WeatherData.BaseClasses.SolarTime solTim
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Districts.BoundaryConditions.WeatherData.BaseClasses.EquationOfTime eqnTim
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
equation
  connect(simTim.y, locTim.cloTim) annotation (Line(
      points={{-39,-10},{-30,-10},{-30,-30},{-22,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(locTim.locTim, solTim.locTim) annotation (Line(
      points={{1,-30},{8,-30},{8,-15.4},{18,-15.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(simTim.y, eqnTim.nDay) annotation (Line(
      points={{-39,-10},{-30,-10},{-30,10},{-22,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(eqnTim.eqnTim, solTim.equTim) annotation (Line(
      points={{1,10},{8,10},{8,-4},{18,-4}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), __Dymola_Commands(file="modelica://Districts/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/BaseClasses/Examples/SolarTime.mos"
        "Simulate and plot"));
end SolarTime;
