within Buildings.HeatTransfer.Windows.BaseClasses.Examples;
model Overhang "Test model for the overhang"
  extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.SolarGeometry.IncidenceAngle incAng(
    lat=weaDat.lat,
    azi=Buildings.Types.Azimuth.S,
    til=Buildings.Types.Tilt.Wall) "Solar incidence angle on a tilted surface"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.HeatTransfer.Windows.BaseClasses.Overhang ove(
    gap=0.1,
    azi=Buildings.Types.Azimuth.S,
    lat=weaDat.lat,
    wL=0,
    wR=0.95,
    dep=0.5,
    hWin=2,
    wWin=0.1) "Calculates fraction of window area shaded by the overhang"
     annotation (Placement(transformation(extent={{68,6},{88,26}})));

  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.WallSolarAzimuth walSolAzi
    "Angle measured in horizontal plane between projection of sun's rays and normal to vertical surface"
     annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus
   annotation (Placement(transformation(extent={{-44,24},{-24,44}})));
equation
  connect(weaDat.weaBus, incAng.weaBus) annotation (Line(
      points={{-80,30},{-70,30},{-70,10.4},{-40,10.4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(incAng.y, walSolAzi.incAng)  annotation (Line(
      points={{-19,10},{-10,10},{-10,25.2},{-2,25.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(walSolAzi.verAzi, ove.verAzi)         annotation (Line(
      points={{21,30},{48,30},{48,20},{66,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaDat.weaBus, ove.weaBus) annotation (Line(
      points={{-80,30},{-70,30},{-70,-20},{50,-20},{50,16},{67.8,16}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-80,30},{-70,30},{-70,34},{-34,34}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.solAlt, walSolAzi.alt) annotation (Line(
      points={{-34,34},{-32,34},{-32,34.8},{-2,34.8}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.solAlt, ove.alt) annotation (Line(
      points={{-34,34},{-70,34},{-70,-20},{60,-20},{60,12},{66,12}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  annotation (
experiment(Tolerance=1e-6, StopTime=86400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Windows/BaseClasses/Examples/Overhang.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This example uses the basic overhang model with solar angles as input and calculates the fraction of total window area that is exposed to the sun.
For a detail description of the solar angles used in the model, see
<a href=\"modelica://Buildings.BoundaryConditions.SolarGeometry\">Buildings.BoundaryConditions.SolarGeometry</a>.
For a detailed description of the overhang block, see
<a href=\"modelica://Buildings.HeatTransfer.Windows.BaseClasses.Overhang\">Buildings.HeatTransfer.Windows.BaseClasses.Overhang</a>.
The required data for the solar angle calculations is obtained from weather data.
</p>

Solar angles used in this model are:
<ul>
<li>
<a href=\"modelica://Buildings.BoundaryConditions.SolarGeometry.ZenithAngle\">Buildings.BoundaryConditions.SolarGeometry.ZenithAngle</a>:
Angle between sun ray and normal to horizontal surface
</li>
<li>
<a href=\"modelica://Buildings.BoundaryConditions.SolarGeometry.IncidenceAngle\">Buildings.BoundaryConditions.SolarGeometry.IncidenceAngle</a>:
Solar incidence angle on a tilted surface
</li>
<li>
<a href=\"modelica://Buildings.BoundaryConditions.SolarGeometry.BaseClasses.AltitudeAngle\">Buildings.BoundaryConditions.SolarGeometry.BaseClasses.AltitudeAngle</a>:
Angle between Sun ray and horizontal surface
</li>
<li>
<a href=\"modelica://Buildings.BoundaryConditions.SolarGeometry.BaseClasses.WallSolarAzimuth\">Buildings.BoundaryConditions.SolarGeometry.BaseClasses.WallSolarAzimuth</a>:
Angle measured in horizontal plane between projection of sun's rays and normal to vertical surface
</li>
</ul>

<p>
The values of the parameters of the overhang model have been set in such
a way that the overhang in non-symmetric with respect to the window center-line.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 5, 2012, by Michael Wetter<br/>
Changed parameters to test non-symmetric overhang.
</li>
<li>
Feb 01, 2012, by Kaustubh Phalak<br/>
First implementation.
</li>
</ul>
</html>"));
end Overhang;
