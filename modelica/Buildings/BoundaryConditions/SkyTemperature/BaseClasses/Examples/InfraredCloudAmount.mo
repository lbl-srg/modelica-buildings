within Buildings.BoundaryConditions.SkyTemperature.BaseClasses.Examples;
model InfraredCloudAmount "Test model for infrared cloud amount"
  import Buildings;
  Buildings.BoundaryConditions.SkyTemperature.BaseClasses.InfraredCloudAmount
    infClo annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.Utilities.SimulationTime simTim
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Utilities.IO.WeatherData.WeatherBus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-2,0},{18,20}}),
        iconTransformation(extent={{-2,0},{-2,0}})));
  Buildings.Utilities.IO.WeatherData.ReadWeatherData weaDat(filNam=
        "Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
equation
  connect(weaBus.nTol, infClo.nTol) annotation (Line(
      points={{8,10},{24,10},{24,16},{38,16}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.nOpa, infClo.nOpa) annotation (Line(
      points={{8,10},{24,10},{24,4},{38,4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-20,10},{8,10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.celHei, infClo.celHei) annotation (Line(
      points={{8,10},{38,10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(simTim.y, weaDat.cloTim) annotation (Line(
      points={{-59,10},{-42,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(graphics),
    Commands(file="InfraredCloudAmount.mos" "run"),
    Icon(graphics));
end InfraredCloudAmount;
