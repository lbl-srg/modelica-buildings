within Buildings.BoundaryConditions.WeatherData.BaseClasses.Examples;
model ConvertTime "Test model for converting time"
  extends Modelica.Icons.Example;
  Buildings.Utilities.SimulationTime simTim
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
public
  Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertTime conTim
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation
  connect(simTim.y, conTim.simTim) annotation (Line(
      points={{-19,10},{-2,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), 
experiment(StopTime=86400*900),
__Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/BaseClasses/Examples/ConvertTime.mos"
        "Simulate and plot"));
end ConvertTime;
