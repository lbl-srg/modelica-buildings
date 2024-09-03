within Buildings.Fluid.Sources.Examples;
model Outside_CpData_Angles
  "Test model for source and sink with outside weather data and wind pressure using user-defined Cp values"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air "Medium model for air";

  parameter Modelica.Units.SI.Angle incAngSurNor[:]=
    {0, 45, 90, 135, 180, 225, 270, 315}*2*Modelica.Constants.pi/360
    "Wind incidence angles";
  parameter Real CpSym[:]={0.4, 0.1, -0.3, -0.35, -0.2, -0.35, -0.3, 0.1}
    "Cp values that are symmetric";
  parameter Real CpAsy[:]={0.4, 0.1, -0.3, -0.35, -0.2, -0.6, -0.9, -0.1}
    "Cp values that are asymmetric";
  Buildings.Fluid.Sources.Outside_CpData symNor(
    redeclare package Medium = Medium,
    incAngSurNor=incAngSurNor,
    Cp=CpSym,
    azi=Buildings.Types.Azimuth.N)
    "Model to compute wind pressure on North-facing surface"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Buildings.Fluid.Sources.Outside_CpData asyNor(
    redeclare package Medium = Medium,
    incAngSurNor=incAngSurNor,
    Cp=CpAsy,
    azi=Buildings.Types.Azimuth.N)
    "Model to compute wind pressure on North-facing surface"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Fluid.Sources.Outside_CpData asyWes(
    redeclare package Medium = Medium,
    incAngSurNor=incAngSurNor,
    Cp=CpAsy,
    azi=Buildings.Types.Azimuth.W)
    "Model to compute wind pressure on West-facing surface"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.Fluid.Sources.Outside_CpData symWes(
    redeclare package Medium = Medium,
    incAngSurNor=incAngSurNor,
    Cp=CpSym,
    azi=Buildings.Types.Azimuth.W)
    "Model to compute wind pressure on West-facing surface"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));

  Modelica.Blocks.Sources.Ramp winDir(
    height=2*Modelica.Constants.pi,
    duration=10,
    startTime=5) "Wind direction"
    annotation (Placement(transformation(extent={{-80,-6},{-60,14}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"),
    winSpeSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    winSpe=1,
    winDirSou=Buildings.BoundaryConditions.Types.DataSource.Input)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));

equation
  connect(weaDat.weaBus, symNor.weaBus) annotation (Line(
      points={{-20,10},{-10,10},{-10,-10},{-6,-10},{-6,-9.8},{0,-9.8}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, asyNor.weaBus) annotation (Line(
      points={{-20,10},{-10,10},{-10,30.2},{0,30.2}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(winDir.y, weaDat.winDir_in)
    annotation (Line(points={{-59,4},{-41,4}}, color={0,0,127}));
  connect(asyWes.weaBus, weaDat.weaBus) annotation (Line(
      points={{0,70.2},{-10,70.2},{-10,10},{-20,10}},
      color={255,204,51},
      thickness=0.5));
  connect(symWes.weaBus, weaDat.weaBus) annotation (Line(
      points={{0,-49.8},{-10,-49.8},{-10,10},{-20,10}},
      color={255,204,51},
      thickness=0.5));
  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Sources/Examples/Outside_CpData_Angles.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model demonstrates the use of a source for ambient conditions that computes
the wind pressure on a facade of a building using a user-defined wind pressure profile.
</p>
<p>
The model showcases the possibility to use asymmetrical wind pressure profiles.
It also shows how <i>C<sub>p,act</sub></i> shifts with regards to the wind direction and azimuth
based on the <i>C<sub>p</sub></i> values which are defined relative to the surface normal.
</p>
<p>
The plot shows <i>C<sub>p,act</sub></i> of each boundary for each wind direction.
Notice how the profile is shifted based on the surface azimuth.
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
      StopTime=20,
      Tolerance=1e-06));
end Outside_CpData_Angles;
