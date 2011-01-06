within Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.Examples;
model SkyClearness "Test model for sky clearness"
  import Buildings;

  Buildings.BoundaryConditions.SolarGeometry.ZenithAngle zen(lat=
        0.34906585039887)
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.SkyClearness skyCle
    annotation (Placement(transformation(extent={{40,0},{60,20}})));

  Buildings.BoundaryConditions.WeatherData.ReadWeatherData weaDat(filNam=
        "Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.BoundaryConditions.WeatherData.WeatherBus weaBus
    annotation (Placement(transformation(extent={{-2,20},{18,40}})));
equation
  connect(zen.y, skyCle.zen) annotation (Line(
      points={{-19,-10},{10,-10},{10,4},{38,4}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-20,30},{8,30}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.HGloHor, skyCle.HGloHor) annotation (Line(
      points={{8,30},{24,30},{24,16},{38,16}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.HDifHor, skyCle.HDifHor) annotation (Line(
      points={{8,30},{24,30},{24,10},{38,10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));

  connect(weaBus.cloTim, zen.cloTim) annotation (Line(
      points={{8,30},{8,10},{-48,10},{-48,-10},{-42,-10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  annotation (
    Diagram(graphics),
    Commands(file="SkyClearness.mos" "run"),
    Icon(graphics));
end SkyClearness;
