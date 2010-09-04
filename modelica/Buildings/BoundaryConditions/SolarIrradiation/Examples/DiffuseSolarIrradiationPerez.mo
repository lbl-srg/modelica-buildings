within Buildings.BoundaryConditions.SolarIrradiation.Examples;
model DiffuseSolarIrradiationPerez
  "Test model for diffuse solar irradiation on a tilted surface by using Perez model"
  import Buildings;
  parameter Modelica.SIunits.Angle lat=37/180*Modelica.Constants.pi "Latitude";
  parameter Modelica.SIunits.Angle aziAng=0.3 "Azi angle";
  parameter Modelica.SIunits.Angle tilAng=0.5 "Tilted angle";
  Buildings.BoundaryConditions.WeatherData.ReadWeatherData weaDat(filNam=
        "Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.BoundaryConditions.WeatherData.WeatherBus weaBus annotation (Placement(
        transformation(extent={{1,-1},{21,21}}), iconTransformation(extent={{20,
            20},{21,21}})));
  Buildings.BoundaryConditions.SolarIrradiation.DiffuseSolarIrradiationPerez
    HDifTil(
    tilAng=1.5707963267949,
    lat=0.6457718232379,
    aziAng=0.78539816339745)
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.Utilities.SimulationTime simTim
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-20,10},{11,10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus, HDifTil.weaBus) annotation (Line(
      points={{11,10},{26,10},{26,10},{40,10}},
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
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics),
    Commands(file="DiffuseSolarIrradiationPerez.mos" "run"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics));
end DiffuseSolarIrradiationPerez;
