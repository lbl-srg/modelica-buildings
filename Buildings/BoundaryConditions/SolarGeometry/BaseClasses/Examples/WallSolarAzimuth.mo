within Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Examples;
model WallSolarAzimuth "Test model for wall solar azimuth angle"
extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.SolarGeometry.IncidenceAngle incAng(
    azi=0,
    lat=lat,
    til=1.5707963267949) "solar incidence angle"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather bus"
    annotation (Placement(transformation(extent={{-72,-2},{-48,22}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.WallSolarAzimuth
    walSolAzi "Vertical wall solar azimuth angle" annotation (Placement(transformation(extent={{70,0},{90,20}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.AltitudeAngle altAng
    "Altitude angle"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  parameter Modelica.SIunits.Angle lat=41.98*Modelica.Constants.pi/180
    "Latitude";
equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-80,10},{-60,10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaDat.weaBus, incAng.weaBus) annotation (Line(
      points={{-80,10},{-72,10},{-72,-30},{-20,-30}},
      color={255,204,51},
      thickness=0.5));
  connect(incAng.y, walSolAzi.incAng) annotation (Line(
      points={{1,-30},{14,-30},{14,5.2},{68,5.2}},
      color={0,0,127}));
  connect(altAng.alt, walSolAzi.alt) annotation (Line(
      points={{1,30},{60,30},{60,14.8},{68,14.8}},
      color={0,0,127}));
  connect(weaBus.solZen, altAng.zen) annotation (Line(
      points={{-60,10},{-40,10},{-40,30},{-22,30}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  annotation (experiment(Tolerance=1e-6, StopTime=86400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/SolarGeometry/BaseClasses/Examples/WallSolarAzimuth.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This example calculates the wall solar azimuth angle.
</p>
</html>",
revisions="<html>
<ul>
<li>
Feb 27, 2012, by Michael Wetter:<br/>
Simplified example by using zenith angle from weather data bus.
</li>
<li>
Feb 01, 2012, by Kaustubh Phalak<br/>
First implementation.
</li>
</ul>
</html>"));
end WallSolarAzimuth;
