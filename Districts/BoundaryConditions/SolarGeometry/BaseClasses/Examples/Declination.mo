within Districts.BoundaryConditions.SolarGeometry.BaseClasses.Examples;
model Declination "Test model for declination"
  extends Modelica.Icons.Example;
  import Districts;
  Districts.BoundaryConditions.SolarGeometry.BaseClasses.Declination decAng
    "Declination angle"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Districts.Utilities.SimulationTime simTim "Simulation time"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
equation
  connect(simTim.y, decAng.nDay) annotation (Line(
      points={{1,10},{18,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), __Dymola_Commands(file="modelica://Districts/Resources/Scripts/Dymola/BoundaryConditions/SolarGeometry/BaseClasses/Examples/Declination.mos"
        "Simulate and plot"));
end Declination;
