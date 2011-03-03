within Buildings.BoundaryConditions.SkyTemperature.Examples;
model BlackBody "Test model for black body sky temperature"
  import Buildings;

  Buildings.BoundaryConditions.WeatherData.Reader weaDat(filNam=
        "Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos",
    lon=-1.4421267797069,
    timZon=-21600)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.BoundaryConditions.SkyTemperature.BlackBody TBlaSky
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus annotation (
      Placement(transformation(extent={{0,0},{20,20}}), iconTransformation(
          extent={{0,0},{2,2}})));
equation

  connect(weaBus, weaDat.weaBus) annotation (Line(
      points={{10,10},{-20,10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.TDewPoi, TBlaSky.TDewPoi) annotation (Line(
      points={{10,10},{24,10},{24,13},{38,13}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaBus.radHor, TBlaSky.radHor) annotation (Line(
      points={{10,10},{24,10},{24,2},{38,2}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaBus.nOpa, TBlaSky.nOpa) annotation (Line(
      points={{10,10},{24,10},{24,7},{38,7}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));

  connect(weaBus.TDryBul, TBlaSky.TDryBul) annotation (Line(
      points={{10,10},{24,10},{24,18},{38,18}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (
    Diagram(graphics),
    Commands(file="BlackBody.mos" "run"),
    Icon(graphics));
end BlackBody;
