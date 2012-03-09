within Buildings.HeatTransfer.Windows.BaseClasses.Examples;
model Overhang "Test model for the overhang"
  import Buildings;
  extends Modelica.Icons.Example;
  BoundaryConditions.SolarGeometry.BaseClasses.AltitudeAngle altAng
    "Altitude angle: Angle between Sun ray and horizontal surface"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.BoundaryConditions.SolarGeometry.ZenithAngle zen(lat=0.73129295658562)
    "Zenith angle: angle between the earth surface normal and the sun's beam"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.BoundaryConditions.SolarGeometry.IncidenceAngle incAng(
    lat=0.73129295658562,
    azi=0,
    til=1.5707963267949) "Solar incidence angle on a tilted surface"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam="Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    "Weather data"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.HeatTransfer.Windows.BaseClasses.Overhang ove(
    w = 1.2,
    dep=0.5,
    gap=0.1,
    hWin=1.0,
    wWin=1.0) "Calculates fraction of window area shaded by the overhang"
     annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.WallSolarAzimuth walSolAzi
    "Angle measured in horizontal plane between projection of sun's rays and normal to vertical surface"
     annotation (Placement(transformation(extent={{20,20},{40,40}})));
equation
  connect(zen.y, altAng.zen)        annotation (Line(
      points={{-39,50},{-22,50}},
      color={0,0,127},
      smooth=Smooth.None));
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
  connect(altAng.alt, ove.alt)        annotation (Line(
      points={{1,50},{10,50},{10,6},{58,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(incAng.y, walSolAzi.incAng)  annotation (Line(
      points={{-19,10},{-2,10},{-2,25.2},{18,25.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(altAng.alt, walSolAzi.alt)  annotation (Line(
      points={{1,50},{10,50},{10,34.8},{18,34.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(walSolAzi.verAzi, ove.verAzi)         annotation (Line(
      points={{41,30},{48,30},{48,14},{58,14}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Windows/BaseClasses/Examples/Overhang.mos"
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
<p>
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
</p>

<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/HeatTransfer/Windows/BaseClasses/Overhang.png\" border=\"1\">
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
end Overhang;
