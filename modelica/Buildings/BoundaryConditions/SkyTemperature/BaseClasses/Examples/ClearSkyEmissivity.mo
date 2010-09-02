within Buildings.BoundaryConditions.SkyTemperature.BaseClasses.Examples;
model ClearSkyEmissivity "Test model for sky emissivity"
  import Buildings;
  Buildings.BoundaryConditions.SkyTemperature.BaseClasses.DiurnalCorrection_t
    diuCor_t annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.BoundaryConditions.SkyTemperature.BaseClasses.ClearSkyEmissivity
    skyEmi annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Buildings.BoundaryConditions.SkyTemperature.BaseClasses.ElevationCorrection
    eleCor annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.BoundaryConditions.SkyTemperature.BaseClasses.BaseEmissivity basEmi
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Utilities.SimulationTime simTim
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.Utilities.IO.WeatherData.WeatherBus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-22,20},{-2,40}}),
        iconTransformation(extent={{-22,20},{-22,20}})));
  Buildings.Utilities.IO.WeatherData.ReadWeatherData weaDat(filNam=
        "Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
equation
  connect(eleCor.eleCor, skyEmi.eleCor) annotation (Line(
      points={{41,10},{58,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(skyEmi.diuCor, diuCor_t.y) annotation (Line(
      points={{58,4},{50,4},{50,-30},{41,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaBus.pAtm, eleCor.p) annotation (Line(
      points={{-12,30},{4,30},{4,10},{18,10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(basEmi.basEmi, skyEmi.basEmi) annotation (Line(
      points={{41,50},{50,50},{50,16},{58,16}},
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
      points={{-12,30},{4,30},{4,50},{18,50}},
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
      points={{-12,30},{-10,30},{-10,-30},{18,-30}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  annotation (
    Diagram(graphics),
    Commands(file="ClearSkyEmissivity.mos" "run"),
    Icon(graphics));
end ClearSkyEmissivity;
