within Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.Examples;
model DiffuseSolarIrradiationIsotropic
  "Test model for diffuse solar irradiation on a tilted surface by using isotropic model"
  import Buildings;
  Buildings.Utilities.SimulationTime simTim
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.DiffuseSolarIrradiationIsotropic
    HDifTilIso(tilAng=1.5707963267949)
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.Utilities.IO.WeatherData.ReadWeatherData weaDat(filNam=
        "Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Utilities.IO.WeatherData.WeatherBus weaBus
    annotation (Placement(transformation(extent={{1,-1},{21,21}})));
equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-20,10},{11,10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.HGloHor, HDifTilIso.HGloHor) annotation (Line(
      points={{11,10},{24,10},{24,14},{38,14}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.HDifHor, HDifTilIso.HDifHor) annotation (Line(
      points={{11,10},{24,10},{24,6},{38,6}},
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
  annotation (Diagram(graphics), Commands(file=
          "DiffuseSolarIrradiationIsotropic.mos" "run"));
end DiffuseSolarIrradiationIsotropic;
