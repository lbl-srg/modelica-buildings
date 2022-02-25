within Buildings.Fluid.Sources.Examples;
model Outside_CpData
  "Test model for source and sink with outside weather data and wind pressure using user-defined Cp values"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air "Medium model for air";
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));

  parameter Modelica.Units.SI.Angle incAngSurNor[:]=
    {0, 45, 90, 135, 180, 225, 270, 315}*2*Modelica.Constants.pi/360
    "Wind incidence angles";
  parameter Real Cp[:] = {0.4, 0.1, -0.3, -0.35, -0.2, -0.35, -0.3, 0.1}
    "Cp values";
  Buildings.Fluid.Sources.Outside_CpData west(
    redeclare package Medium = Medium,
    incAngSurNor=incAngSurNor,
    Cp=Cp,
    azi=Buildings.Types.Azimuth.W) "Model with outside conditions"
    annotation (Placement(transformation(extent={{-42,0},{-22,20}})));
  Buildings.Fluid.Sources.Outside_CpData north(
    redeclare package Medium = Medium,
    incAngSurNor=incAngSurNor,
    Cp=Cp,
    azi=Buildings.Types.Azimuth.N) "Model with outside conditions"
    annotation (Placement(transformation(extent={{-4,40},{16,60}})));
  Buildings.Fluid.Sources.Outside_CpData south(
    redeclare package Medium = Medium,
    incAngSurNor=incAngSurNor,
    Cp=Cp,
    azi=Buildings.Types.Azimuth.S) "Model with outside conditions"
    annotation (Placement(transformation(extent={{-6,-40},{14,-20}})));
  Buildings.Fluid.Sources.Outside_CpData east(
    redeclare package Medium = Medium,
    incAngSurNor=incAngSurNor,
    Cp=Cp,
    azi=Buildings.Types.Azimuth.E) "Model with outside conditions"
    annotation (Placement(transformation(extent={{40,-2},{60,18}})));
equation
  connect(weaDat.weaBus, west.weaBus)     annotation (Line(
      points={{-60,10},{-42,10},{-42,10.2}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, north.weaBus) annotation (Line(
      points={{-60,10},{-50,10},{-50,50.2},{-4,50.2}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, south.weaBus) annotation (Line(
      points={{-60,10},{-50,10},{-50,-29.8},{-6,-29.8}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, east.weaBus) annotation (Line(
      points={{-60,10},{-50,10},{-50,-10},{30,-10},{30,8.2},{40,8.2}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Sources/Examples/Outside_CpData.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model demonstrates the use of a source for ambient conditions that computes
the wind pressure on a facade of a building using a user-defined wind pressure profile.
Weather data are used for San Francisco, for a period of a week
where the wind blows primarily from North-West.
The plot shows that the wind pressure on the north- and west-facing
facade is positive,
whereas it is negative for the south- and east-facing facades.
</p>
</html>", revisions="<html>
<ul>
<li>
February 2, 2022, by Michael Wetter:<br/>
Revised implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1436\">IBPSA, #1436</a>.
</li>
<li>
Jun 28, 2021 by Klaas De Jonge:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StartTime=1.728e+07,
      StopTime=1.78848e+07,
      Tolerance=1e-6));
end Outside_CpData;
