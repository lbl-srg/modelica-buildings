within Buildings.BoundaryConditions.SolarGeometry.Examples;
model IncidenceAngle "Test model for solar incidence angle"
  extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.SolarGeometry.IncidenceAngle incAngHor(
    til=Buildings.Types.Tilt.Ceiling,
    lat=0.73097781993588,
    azi=0.3) "Incidence angle on horizontal surface"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data (Chicago)"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.BoundaryConditions.SolarGeometry.IncidenceAngle incAngNor(
    lat=0.73097781993588,
    azi=Buildings.Types.Azimuth.N,
    til=Buildings.Types.Tilt.Wall) "Incidence angle on North-facing surface"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.BoundaryConditions.SolarGeometry.IncidenceAngle incAngWes(
    lat=0.73097781993588,
    azi=Buildings.Types.Azimuth.W,
    til=Buildings.Types.Tilt.Wall) "Incidence angle on West-facing surface"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.BoundaryConditions.SolarGeometry.IncidenceAngle incAngSou(
    lat=0.73097781993588,
    azi=Buildings.Types.Azimuth.S,
    til=Buildings.Types.Tilt.Wall) "Incidence angle on South-facing surface"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.BoundaryConditions.SolarGeometry.IncidenceAngle incAngEas(
    lat=0.73097781993588,
    azi=Buildings.Types.Azimuth.E,
    til=Buildings.Types.Tilt.Wall) "Incidence angle on East-facing surface"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
equation
  connect(weaDat.weaBus, incAngHor.weaBus) annotation (Line(
      points={{-40,0},{-20,0},{-20,80},{0,80}},
      color={255,204,51},
      thickness=0.5));
  connect(incAngNor.weaBus, weaDat.weaBus) annotation (Line(
      points={{0,40},{-20,40},{-20,0},{-40,0}},
      color={255,204,51},
      thickness=0.5));
  connect(incAngWes.weaBus, weaDat.weaBus) annotation (Line(
      points={{0,0},{-40,0}},
      color={255,204,51},
      thickness=0.5));
  connect(incAngSou.weaBus, weaDat.weaBus) annotation (Line(
      points={{0,-40},{-20,-40},{-20,0},{-40,0}},
      color={255,204,51},
      thickness=0.5));
  connect(incAngEas.weaBus, weaDat.weaBus) annotation (Line(
      points={{0,-80},{-20,-80},{-20,0},{-40,0}},
      color={255,204,51},
      thickness=0.5));
  annotation (
  Documentation(info="<html>
<p>
This example computes the solar incidence angle on tilted surfaces.
There are fives surfaces, a horizontal surface and a surface
that faces Norths, East, South and West.
</p>
</html>", revisions="<html>
<ul>
<li>
March 24, 2015, by Michael Wetter:<br/>
Assigned azimuth and tilt using the types from
<a href=\"modelica://Buildings.Types.Tilt\">
Buildings.Types.Tilt</a>.
</li>
<li>
January 16, 2015, by Michael Wetter:<br/>
Added surfaces for each orientation.
</li>
<li>
May 19, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(Tolerance=1e-6, StopTime=86400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/SolarGeometry/Examples/IncidenceAngle.mos"
        "Simulate and plot"));
end IncidenceAngle;
