within Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Examples;
model ZenithAngle "Test model for zenith angle"
  extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.ZenithAngle zen
    "Zenith angle"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Declination decAng
    "Declination angle"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.SolarHourAngle
    solHouAng "Solar hour angle"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather bus"
    annotation (Placement(transformation(extent={{-44,-10},{-24,10}})));
equation
  connect(decAng.decAng, zen.decAng) annotation (Line(
      points={{41,30},{50,30},{50,5.4},{58,5.4}},
      color={0,0,127}));
  connect(solHouAng.solHouAng, zen.solHouAng) annotation (Line(
      points={{41,-30},{50,-30},{50,-4.8},{58,-4.8}},
      color={0,0,127}));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-60,5.82867e-16},{-53.5,5.82867e-16},{-53.5,1.13798e-15},{-47,
          1.13798e-15},{-47,5.55112e-16},{-34,5.55112e-16}},
      color={255,204,51},
      thickness=0.5), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.cloTim, decAng.nDay) annotation (Line(
      points={{-34,5.55112e-16},{-18,5.55112e-16},{-18,30},{18,30}},
      color={255,204,51},
      thickness=0.5), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.solTim, solHouAng.solTim) annotation (Line(
      points={{-34,5.55112e-16},{-18,5.55112e-16},{-18,-30},{18,-30}},
      color={255,204,51},
      thickness=0.5), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.lat, zen.lat) annotation (Line(
      points={{-34,0},{58,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (
  Documentation(info="<html>
<p>
This example computes the zenith angle,
which is the angle between the earth surface normal and the sun's beam.
</p>
</html>", revisions="<html>
<ul>
<li>
May 17, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(StartTime=100000, Tolerance=1e-6, StopTime=300000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/SolarGeometry/BaseClasses/Examples/ZenithAngle.mos"
        "Simulate and plot"));
end ZenithAngle;
