within Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Examples;
model SolarHourAngle "Test model for solar hour angle"
  extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.SolarHourAngle
    solHouAng "Solar hour Angle"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  WeatherData.ReaderTMY3 weaDat(
    filNam="modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    "Weather data"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  WeatherData.Bus weaBus "Weather bus"
    annotation (Placement(transformation(extent={{-54,-10},{-34,10}})));
equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-60,5.82867e-16},{-56,5.82867e-16},{-56,1.13798e-15},{-52,
          1.13798e-15},{-52,0},{-44,0}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.solTim, solHouAng.solTim) annotation (Line(
      points={{-44,5.55112e-16},{-33.5,5.55112e-16},{-33.5,1.22125e-15},{-23,
          1.22125e-15},{-23,6.66134e-16},{-2,6.66134e-16}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  annotation (Diagram(graphics), 
experiment(StopTime=86400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/SolarGeometry/BaseClasses/Examples/SolarHourAngle.mos"
        "Simulate and plot"));
end SolarHourAngle;
