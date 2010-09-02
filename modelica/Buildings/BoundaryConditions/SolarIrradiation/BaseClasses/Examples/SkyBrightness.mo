within Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.Examples;
model SkyBrightness "Test model for sky brightness"
  import Buildings;
  Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.RelativeAirMass
    relAirMas annotation (Placement(transformation(extent={{10,20},{30,40}})));
  Buildings.BoundaryConditions.SolarGeometry.ZenithAngle zenAng(lat=
        0.34906585039887)
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));
  Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.SkyBrightness
    skyBri annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Buildings.Utilities.IO.WeatherData.ReadWeatherData weaDat(filNam=
        "Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.Utilities.IO.WeatherData.WeatherBus weaBus annotation (Placement(
        transformation(extent={{-22,-20},{-2,0}}), iconTransformation(extent={{
            -22,-20},{-22,-20}})));
  Buildings.Utilities.SimulationTime simTim
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
equation
  connect(zenAng.y, relAirMas.zenAng) annotation (Line(
      points={{-9,30},{8,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(relAirMas.relAirMas, skyBri.relAirMas) annotation (Line(
      points={{31,30},{40,30},{40,14},{58,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-40,-10},{-12,-10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.HDifHor, skyBri.HDifHor) annotation (Line(
      points={{-12,-10},{10,-10},{10,6},{58,6}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(simTim.y, weaDat.cloTim) annotation (Line(
      points={{-79,10},{-72,10},{-72,-10},{-62,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaBus.cloTim, zenAng.cloTim) annotation (Line(
      points={{-12,-10},{-12,12},{-40,12},{-40,30},{-32,30}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  annotation (
    Diagram(graphics),
    Commands(file="SkyBrightness.mos" "run"),
    Icon(graphics));
end SkyBrightness;
