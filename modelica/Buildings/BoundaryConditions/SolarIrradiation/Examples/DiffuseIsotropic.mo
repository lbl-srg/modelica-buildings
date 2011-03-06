within Buildings.BoundaryConditions.SolarIrradiation.Examples;
model DiffuseIsotropic
  "Test model for diffuse solar irradiation on a tilted surface using the isotropic model"
  import Buildings;
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{1,-1},{21,21}}), iconTransformation(extent={{1,
            -1},{2,-2}})));
  Buildings.BoundaryConditions.SolarIrradiation.DiffuseIsotropic HDifTilIso(
               til=1.5707963267949)
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-20,10},{11,10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));

  connect(weaBus, HDifTilIso.weaBus) annotation (Line(
      points={{11,10},{40,10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));

  annotation (
    Diagram(graphics),
    Commands(file="DiffuseIsotropic.mos" "run"),
    Icon(graphics));
end DiffuseIsotropic;
