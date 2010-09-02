within Buildings.BoundaryConditions.SkyTemperature.Examples;
model BlackBodySkyTemperature "Test model for black body sky temperature"
  import Buildings;
  Buildings.Utilities.SimulationTime simTim
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));

  Buildings.BoundaryConditions.SkyTemperature.BlackBodySkyTemperature TBlaSky
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.Utilities.IO.WeatherData.ReadWeatherData weaDat(filNam=
        "Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
equation

  connect(weaDat.weaBus, TBlaSky.weaBus) annotation (Line(
      points={{5.55112e-16,10},{22,10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));

  connect(simTim.y, weaDat.cloTim) annotation (Line(
      points={{-39,10},{-22,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Commands(file="BlackBodySkyTemperature.mos" "run"));
end BlackBodySkyTemperature;
