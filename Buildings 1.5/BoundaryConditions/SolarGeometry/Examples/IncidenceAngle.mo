within Buildings.BoundaryConditions.SolarGeometry.Examples;
model IncidenceAngle "Test model for solar incidence angle"
  extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.SolarGeometry.IncidenceAngle incAng(
    lat=0.73097781993588,
    azi=0.3,
    til=0.5) "Incidence angle"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam="modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    "Weather data (Chicago)"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
equation
  connect(weaDat.weaBus, incAng.weaBus) annotation (Line(
      points={{-40,10},{-20,10},{-20,10.4},{0,10.4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Diagram(graphics), 
experiment(StopTime=86400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/SolarGeometry/Examples/IncidenceAngle.mos"
        "Simulate and plot"));
end IncidenceAngle;
