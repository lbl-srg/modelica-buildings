within Buildings.BoundaryConditions.SkyTemperature.Examples;
model BlackBody "Test model for black body sky temperature"
  extends Modelica.Icons.Example;

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.BoundaryConditions.SkyTemperature.BlackBody TBlaSky
    "Black body sky temperature computed from temperature and sky cover"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
                       annotation (
      Placement(transformation(extent={{0,0},{20,20}}), iconTransformation(
          extent={{0,0},{2,2}})));
  Buildings.BoundaryConditions.SkyTemperature.BlackBody TBlaSkyIrr(calTSky=
        Buildings.BoundaryConditions.Types.SkyTemperatureCalculation.HorizontalRadiation)
    "Black body sky temperature computation compued from horizontal infrared radiation"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
equation

  connect(weaBus, weaDat.weaBus) annotation (Line(
      points={{10,10},{-20,10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.TDewPoi, TBlaSky.TDewPoi) annotation (Line(
      points={{10,10},{24,10},{24,33},{38,33}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.nOpa, TBlaSky.nOpa) annotation (Line(
      points={{10,10},{24,10},{24,27},{38,27}},
      color={255,204,51},
      thickness=0.5));

  connect(weaBus.TDryBul, TBlaSky.TDryBul) annotation (Line(
      points={{10,10},{24,10},{24,38},{38,38}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.HHorIR, TBlaSky.HHorIR) annotation (Line(
      points={{10,10},{24,10},{24,22},{38,22}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.TDewPoi, TBlaSkyIrr.TDewPoi) annotation (Line(
      points={{10,10},{24,10},{24,-7},{38,-7}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.nOpa, TBlaSkyIrr.nOpa) annotation (Line(
      points={{10,10},{24,10},{24,-13},{38,-13}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.TDryBul, TBlaSkyIrr.TDryBul) annotation (Line(
      points={{10,10},{24,10},{24,-2},{38,-2}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.HHorIR, TBlaSkyIrr.HHorIR) annotation (Line(
      points={{10,10},{24,10},{24,-18},{38,-18}},
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
February 18, 2017, by Filip Jorissen:<br/>
Now computing both options of <code>TBlaSky</code>.
This verifies the consistency of the two computation methods.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/648\">#648</a>.
</li>
<li>
January 7, 2016, by Michael Wetter:<br/>
Changed <code>connect</code> statement for infrared radiation due renaming of the
variable. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/376\">issue 376</a>.
Added comments.
</li>
<li>
June 1, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(Tolerance=1e-6, StartTime=0, StopTime=86400),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/SkyTemperature/Examples/BlackBody.mos"
        "Simulate and plot"));
end BlackBody;
