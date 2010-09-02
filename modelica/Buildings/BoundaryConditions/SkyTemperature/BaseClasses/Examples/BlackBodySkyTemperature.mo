within Buildings.BoundaryConditions.SkyTemperature.BaseClasses.Examples;
model BlackBodySkyTemperature "Test model for black body sky temperature"
  import Buildings;
  Buildings.Utilities.SimulationTime simTim
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.Utilities.IO.WeatherData.WeatherBus weaBus annotation (Placement(
        transformation(extent={{-22,20},{-2,40}}), iconTransformation(extent={{
            -22,20},{-22,20}})));
  Buildings.BoundaryConditions.SkyTemperature.BaseClasses.BlackBodySkyTemperature
    TBlaSky annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.BoundaryConditions.SkyTemperature.BaseClasses.DiurnalCorrection_t
    diuCor_t
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.BoundaryConditions.SkyTemperature.BaseClasses.ClearSkyEmissivity
    skyEmi annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.BoundaryConditions.SkyTemperature.BaseClasses.ElevationCorrection
    eleCor annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Buildings.BoundaryConditions.SkyTemperature.BaseClasses.BaseEmissivity basEmi
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Buildings.Utilities.IO.WeatherData.ReadWeatherData weaDat(filNam=
        "Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    "Weather data bus"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.BoundaryConditions.SkyTemperature.BaseClasses.InfraredCloudAmount
    infClo annotation (Placement(transformation(extent={{20,20},{40,40}})));
equation
  connect(eleCor.eleCor, skyEmi.eleCor) annotation (Line(
      points={{1,-50},{8,-50},{8,-30},{18,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(skyEmi.diuCor, diuCor_t.y) annotation (Line(
      points={{18,-36},{12,-36},{12,-70},{-39,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(basEmi.basEmi, skyEmi.basEmi) annotation (Line(
      points={{1,-10},{12,-10},{12,-24},{18,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(skyEmi.skyEmi, TBlaSky.cleSkyEmi) annotation (Line(
      points={{41,-30},{50,-30},{50,24},{58,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-40,30},{-12,30}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.TDew, basEmi.TDew) annotation (Line(
      points={{-12,30},{-30,30},{-30,-10},{-22,-10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.pAtm, eleCor.p) annotation (Line(
      points={{-12,30},{-30,30},{-30,-50},{-22,-50}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.TDryBul, TBlaSky.TDry) annotation (Line(
      points={{-12,30},{4,30},{4,58},{46,58},{46,36},{58,36}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(infClo.infCloAmo, TBlaSky.infCloAmo) annotation (Line(
      points={{41,30},{58,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaBus.nTol, infClo.nTol) annotation (Line(
      points={{-12,30},{4,30},{4,36},{18,36}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.celHei, infClo.celHei) annotation (Line(
      points={{-12,30},{18,30}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.nOpa, infClo.nOpa) annotation (Line(
      points={{-12,30},{4,30},{4,24},{18,24}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(simTim.y, weaDat.cloTim) annotation (Line(
      points={{-79,30},{-62,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaBus.cloTim, diuCor_t.cloTim) annotation (Line(
      points={{-12,30},{-30,30},{-30,-30},{-70,-30},{-70,-70},{-62,-70}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  annotation (
    Diagram(graphics={Text(
          extent={{-72,92},{76,58}},
          lineColor={0,0,255},
          textString="fixme: Check TBlaSky.TBlaSky. It is very high.")}),
    Commands(file="BlackBodySkyTemperature.mos" "run"),
    Icon(graphics));
end BlackBodySkyTemperature;
