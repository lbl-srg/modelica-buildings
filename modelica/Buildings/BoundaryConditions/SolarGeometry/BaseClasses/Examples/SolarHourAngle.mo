within Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Examples;
model SolarHourAngle "Test model for solar hour angle"
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.SolarHourAngle
    solHouAng "Solar hour Angle"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  WeatherData.Reader weaDat(
    filNam="Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos",
    lon=-1.5293932423067,
    timZon=-21600)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{-54,-10},{-34,10}})));
  annotation (Diagram(graphics), Commands(file="SolarHourAngle.mos" "run"));
equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-60,5.82867e-16},{-56,5.82867e-16},{-56,0},{-52,0},{-52,
          5.55112e-16},{-44,5.55112e-16}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.solTim, solHouAng.solTim) annotation (Line(
      points={{-44,5.55112e-16},{-28,5.55112e-16},{-28,6.66134e-16},{-2,
          6.66134e-16}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
end SolarHourAngle;
