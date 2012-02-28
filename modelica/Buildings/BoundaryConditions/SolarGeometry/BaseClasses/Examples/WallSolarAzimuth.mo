within Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Examples;
model WallSolarAzimuth "Test model for wall solar azimuth angle"
  import Buildings;
extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.SolarGeometry.IncidenceAngle incAng(
    azi=0,
    lat=lat,
    til=1.5707963267949) "solar incidence angle"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    "Weather data"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.ZenithAngle zen(lat=lat)
    "Zenith angle"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Declination decAng
    "Declination angle"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Utilities.SimulationTime simTim "Simulation time"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.SolarHourAngle
    solHouAng "Solar hour angle" annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather bus"
    annotation (Placement(transformation(extent={{-72,-2},{-48,22}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.WallSolarAzimuth
    walSolAzi "Vertical wall solar azimuth angle" annotation (Placement(transformation(extent={{70,0},{90,20}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.AltitudeAngle altAng
    "Altitude angle"
    annotation (Placement(transformation(extent={{32,20},{52,40}})));
  parameter Modelica.SIunits.Angle lat=41.98*Modelica.Constants.pi/180
    "Latitude";
equation
  connect(simTim.y, decAng.nDay) annotation (Line(
      points={{-59,50},{-42,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(decAng.decAng, zen.decAng) annotation (Line(
      points={{-19,50},{-10,50},{-10,35.4},{-2,35.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-80,10},{-60,10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(solHouAng.solHouAng, zen.solHouAng) annotation (Line(
      points={{-19,10},{-10,10},{-10,25.2},{-2,25.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaDat.weaBus, incAng.weaBus) annotation (Line(
      points={{-80,10},{-70,10},{-70,-29.6},{-60,-29.6}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaBus.solTim, solHouAng.solTim) annotation (Line(
      points={{-60,10},{-42,10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(incAng.y, walSolAzi.incAng) annotation (Line(
      points={{-39,-30},{14,-30},{14,5.2},{68,5.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zen.zen, altAng.zen) annotation (Line(
      points={{21,30},{30,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(altAng.alt, walSolAzi.alt) annotation (Line(
      points={{53,30},{60,30},{60,14.8},{68,14.8}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (                                                         Diagram(
        graphics), __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/SolarGeometry/BaseClasses/Examples/WallSolarAzimuth.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This example calculates the wall solar azimuth angle.
</p>
</html>",
revisions="<html>
<ul>
<li>
Feb 01, 2012, by Kaustubh Phalak<br>
First implementation.
</li>
</ul>
</html>"));
end WallSolarAzimuth;
