within Districts.BoundaryConditions.SolarIrradiation.BaseClasses.Examples;
model DiffuseIsotropic
  "Test model for diffuse solar irradiation on a tilted surface by using isotropic model"
  extends Modelica.Icons.Example;
  import Districts;
  Districts.BoundaryConditions.SolarIrradiation.BaseClasses.DiffuseIsotropic
    HDifTilIso(til=1.5707963267949)
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Districts.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "modelica://Districts/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Districts.BoundaryConditions.WeatherData.Bus weaBus
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
  annotation (Diagram(graphics),
             __Dymola_Commands(file="modelica://Districts/Resources/Scripts/Dymola/BoundaryConditions/SolarIrradiation/BaseClasses/Examples/DiffuseIsotropic.mos"
        "Simulate and plot"));
end DiffuseIsotropic;
