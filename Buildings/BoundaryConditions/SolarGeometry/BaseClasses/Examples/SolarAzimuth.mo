within Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Examples;
model SolarAzimuth "Test model for zenith angle"
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Angle lat= 41.98*Modelica.Constants.pi/180
    "Latitude";
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.SolarHourAngle
    solHouAng "Solar hour angle"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.ZenithAngle zen(lat=lat)
    "Zenith angle"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Declination decAng
    "Declination angle"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.SolarAzimuth solAzi(lat=lat)
    "Solar azimuth"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));
  WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  WeatherData.Bus weaBus "Weather bus"
    annotation (Placement(transformation(extent={{-54,0},{-34,20}})));
equation
  connect(zen.zen, solAzi.zen) annotation (Line(
      points={{81,50},{90,50},{90,26},{98,26}},
      color={0,0,127}));
  connect(solHouAng.solHouAng, zen.solHouAng) annotation (Line(
      points={{41,-10},{48,-10},{48,45.2},{58,45.2}},
      color={0,0,127}));
  connect(decAng.decAng, solAzi.decAng) annotation (Line(
      points={{1,50},{20,50},{20,20},{98,20}},
      color={0,0,127}));
  connect(decAng.decAng, zen.decAng) annotation (Line(
      points={{1,50},{20,50},{20,55.4},{58,55.4}},
      color={0,0,127}));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-60,10},{-44,10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.cloTim, decAng.nDay) annotation (Line(
      points={{-44,10},{-28,10},{-28,50},{-22,50}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.solTim, solHouAng.solTim) annotation (Line(
      points={{-44,10},{-28,10},{-28,-10},{18,-10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.solTim, solAzi.solTim) annotation (Line(
      points={{-44,10},{-28,10},{-28,-28},{92,-28},{92,14},{98,14}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{150,
            100}})),
Documentation(info="<html>
<p>
This example computes the solar azimuth angle.
</p>
</html>", revisions="<html>
<ul>
<li>
May 18, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(Tolerance=1e-6, StopTime=864000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/SolarGeometry/BaseClasses/Examples/SolarAzimuth.mos"
        "Simulate and plot"));
end SolarAzimuth;
