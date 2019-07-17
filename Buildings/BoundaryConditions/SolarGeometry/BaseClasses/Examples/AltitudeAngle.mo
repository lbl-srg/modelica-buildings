within Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Examples;
model AltitudeAngle "Test model for altitude angle"
  extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.ZenithAngle zen(lat=
        0.73268921998722) "Zenith angle"
    annotation (Placement(transformation(extent={{36,-10},{56,10}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Declination decAng
    "Declination angle"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.SolarHourAngle
    solHouAng "Solar hour angle"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather bus"
    annotation (Placement(transformation(extent={{-44,-10},{-24,10}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.AltitudeAngle altAng
    "Altitude angle: Angle between Sun ray and horizontal surface)"
    annotation (Placement(transformation(extent={{68,-10},{88,10}})));
equation
  connect(decAng.decAng, zen.decAng) annotation (Line(
      points={{21,30},{26,30},{26,5.4},{34,5.4}},
      color={0,0,127}));
  connect(solHouAng.solHouAng, zen.solHouAng) annotation (Line(
      points={{21,-30},{26,-30},{26,-4.8},{34,-4.8}},
      color={0,0,127}));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-60,5.82867e-16},{-53.5,5.82867e-16},{-53.5,1.13798e-15},{-47,
          1.13798e-15},{-47,5.55112e-16},{-34,5.55112e-16}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.cloTim, decAng.nDay) annotation (Line(
      points={{-34,5.55112e-16},{-20,5.55112e-16},{-20,30},{-2,30}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.solTim, solHouAng.solTim) annotation (Line(
      points={{-34,5.55112e-16},{-20,5.55112e-16},{-20,-30},{-2,-30}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(zen.zen, altAng.zen) annotation (Line(
      points={{57,6.10623e-16},{59.25,6.10623e-16},{59.25,1.27676e-15},{61.5,
          1.27676e-15},{61.5,6.66134e-16},{66,6.66134e-16}},
      color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=86400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/SolarGeometry/BaseClasses/Examples/AltitudeAngle.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This example calculates the altitude angle of the sun at a given time.
The altitude angle is the angle between the sun ray and the projection of the ray on a horizontal surface.
</p>
<p>
Components used in this model are:
</p>
<ul>
<li>
<a href=\"modelica://Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Declination\">Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Declination</a>
</li>
<li>
<a href=\"modelica://Buildings.BoundaryConditions.SolarGeometry.BaseClasses.SolarHourAngle\">Buildings.BoundaryConditions.SolarGeometry.BaseClasses.SolarHourAngle</a>
</li>
<li>
<a href=\"modelica://Buildings.BoundaryConditions.SolarGeometry.BaseClasses.ZenithAngle\">Buildings.BoundaryConditions.SolarGeometry.BaseClasses.ZenithAngle</a>
</li>
</ul>
<br/>
</html>",
revisions="<html>
<ul>
<li>
Feb 01, 2012, by Kaustubh Phalak<br/>
First implementation.
</li>
</ul>
</html>"));
end AltitudeAngle;
