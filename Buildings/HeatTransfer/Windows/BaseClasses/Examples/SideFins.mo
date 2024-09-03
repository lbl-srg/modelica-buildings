within Buildings.HeatTransfer.Windows.BaseClasses.Examples;
model SideFins "Test model for side fins"
  extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.SolarGeometry.ZenithAngle zen
    "Zenith angle: angle between the earth surface normal and the sun's beam"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.BoundaryConditions.SolarGeometry.IncidenceAngle incAng(
    azi=0,
    til=1.5707963267949) "Solar incidence angle on a tilted surface"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.HeatTransfer.Windows.BaseClasses.SideFins fin(
    gap=0.1,
    h=0.7,
    dep=1.0,
    hWin=1.5,
    wWin=2.0) "Calculates fraction of window area shaded by the side fins"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.AltitudeAngle
    altAng "Altitude angle: Angle between Sun ray and horizontal surface"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.WallSolarAzimuth walSolAzi
    "Angle measured in horizontal plane between projection of sun's rays and normal to vertical surface"
     annotation (Placement(transformation(extent={{20,20},{40,40}})));
equation
  connect(weaDat.weaBus, zen.weaBus) annotation (Line(
      points={{-80,30},{-70,30},{-70,50},{-60.2,50}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, incAng.weaBus) annotation (Line(
      points={{-80,30},{-70,30},{-70,10.4},{-40,10.4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(zen.y, altAng.zen) annotation (Line(
      points={{-39,50},{-22,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(altAng.alt, fin.alt)    annotation (Line(
      points={{1,50},{8,50},{8,6},{58,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(walSolAzi.verAzi, fin.verAzi)     annotation (Line(
      points={{41,30},{50,30},{50,14},{58,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(altAng.alt, walSolAzi.alt)  annotation (Line(
      points={{1,50},{8,50},{8,34.8},{18,34.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(incAng.y, walSolAzi.incAng)  annotation (Line(
      points={{-19,10},{0,10},{0,25.2},{18,25.2}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (experiment(Tolerance=1e-6, StopTime=86400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Windows/BaseClasses/Examples/SideFins.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This example uses the basic side fins model with solar angles as input and calculates the fraction of total window area that is exposed to the sun.
For a detailed description of the solar angles used in the model,
see to documentation in the package
<a href=\"modelica://Buildings.BoundaryConditions.SolarGeometry\">Buildings.BoundaryConditions.SolarGeometry</a>.
For a detail description of side fin model, see
<a href=\"modelica://Buildings.HeatTransfer.Windows.BaseClasses.SideFins\">
Buildings.HeatTransfer.Windows.BaseClasses.SideFins</a>.
The required data for the solar angle calculations are obtained from the weather data.
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

<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/HeatTransfer/Windows/BaseClasses/SideFins.png\" border=\"1\" />
</p>
</html>",
revisions="<html>
<ul>
<li>
September 16, 2021, by Michael Wetter:<br/>
Removed assignment of parameter <code>lat</code> as this is now obtained from the weather data reader.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
<li>
July 5, 2012, by Michael Wetter:<br/>
Changed definitions of side fin height <code>h</code> to be
measured from the top of the window.
</li>
<li>
Feb 01, 2012, by Kaustubh Phalak<br/>
First implementation.
</li>
</ul>
</html>"));
end SideFins;
