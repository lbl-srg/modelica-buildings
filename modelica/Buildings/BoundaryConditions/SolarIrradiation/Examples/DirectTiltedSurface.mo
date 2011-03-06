within Buildings.BoundaryConditions.SolarIrradiation.Examples;
model DirectTiltedSurface
  "Test model for direct solar irradiation on a tilted surface"
  import Buildings;
  parameter Modelica.SIunits.Angle lat=37/180*Modelica.Constants.pi "Latitude";
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus annotation (
      Placement(transformation(extent={{1,-1},{21,21}}), iconTransformation(
          extent={{20,20},{21,21}})));
  Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil(
    til=1.5707963267949,
    lat=0.72483523835325,
    azi=0.78539816339745)
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
  connect(weaBus, HDirTil.weaBus) annotation (Line(
      points={{11,10},{26,10},{26,10},{40,10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  annotation (
    Diagram(graphics),
    Commands(file="DirectTiltedSurface.mos" "run"),
    Icon(graphics));
end DirectTiltedSurface;
