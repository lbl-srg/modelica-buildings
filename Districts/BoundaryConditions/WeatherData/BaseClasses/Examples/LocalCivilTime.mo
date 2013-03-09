within Districts.BoundaryConditions.WeatherData.BaseClasses.Examples;
model LocalCivilTime "Test model for calculate local civil time"
  extends Modelica.Icons.Example;
  import Districts;
  Districts.Utilities.SimulationTime simTim
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Districts.BoundaryConditions.WeatherData.BaseClasses.LocalCivilTime locTim(
      timZon=-21600, lon=-1.5293932423067)
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation
  connect(simTim.y, locTim.cloTim) annotation (Line(
      points={{-19,10},{-2,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), __Dymola_Commands(file="modelica://Districts/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/BaseClasses/Examples/LocalCivilTime.mos"
        "Simulate and plot"));
end LocalCivilTime;
