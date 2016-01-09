within Buildings.BoundaryConditions.SkyTemperature.Examples;
model BlackBody "Test model for black body sky temperature"
  extends Modelica.Icons.Example;

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.BoundaryConditions.SkyTemperature.BlackBody TBlaSky
    "Black body sky temperature"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
                       annotation (
      Placement(transformation(extent={{0,0},{20,20}}), iconTransformation(
          extent={{0,0},{2,2}})));
equation

  connect(weaBus, weaDat.weaBus) annotation (Line(
      points={{10,10},{-20,10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.TDewPoi, TBlaSky.TDewPoi) annotation (Line(
      points={{10,10},{24,10},{24,13},{38,13}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.nOpa, TBlaSky.nOpa) annotation (Line(
      points={{10,10},{24,10},{24,7},{38,7}},
      color={255,204,51},
      thickness=0.5));

  connect(weaBus.TDryBul, TBlaSky.TDryBul) annotation (Line(
      points={{10,10},{24,10},{24,18},{38,18}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.HHorIR, TBlaSky.HHorIR) annotation (Line(
      points={{10,10},{24,10},{24,2},{38,2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  annotation (
  Documentation(info="<html>
<p>
This example computes the black-body sky temperature
for Chicago.
</p>
</html>", revisions="<html>
<ul>
<li>
January 7, 2016, by Michael Wetter:<br/>
Changed <code>connect</code> statement for infrared radiation due renaming of the
variable. This is for
<a href=\"https://github.com/iea-annex60/modelica-annex60/issues/376\">issue 376</a>.
Added comments.
</li>
<li>
June 1, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(StopTime=86400),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/SkyTemperature/Examples/BlackBody.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end BlackBody;
