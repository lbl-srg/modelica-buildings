within Buildings.Fluid.Sources.Validation;
model Outside_CpData_Directions
  "Test model for wind pressure using a wind pressure profile that is 1 for normal angle of attack, and goes to zero otherwise"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air "Medium model for air";

  parameter Modelica.Units.SI.Angle incAngSurNor[:]=
    {0,1,5,90,180,315,355,359}*2*Modelica.Constants.pi/360
    "Wind incidence angles";
  parameter Real Cp[:]={1,0.01,0,0,0,0,0,0.01}
    "Cp values at the relative surface wind incidence angles";
  Buildings.Fluid.Sources.Outside_CpData nor(
    redeclare package Medium = Medium,
    incAngSurNor=incAngSurNor,
    Cp=Cp,
    azi=Buildings.Types.Azimuth.N)
    "Model to compute wind pressure on North-facing surface"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Fluid.Sources.Outside_CpData eas(
    redeclare package Medium = Medium,
    incAngSurNor=incAngSurNor,
    Cp=Cp,
    azi=Buildings.Types.Azimuth.E)
    "Model to compute wind pressure on East-facing surface"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Fluid.Sources.Outside_CpData sou(
    redeclare package Medium = Medium,
    incAngSurNor=incAngSurNor,
    Cp=Cp,
    azi=Buildings.Types.Azimuth.S)
    "Model to compute wind pressure on South-facing surface"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Buildings.Fluid.Sources.Outside_CpData wes(
    redeclare package Medium = Medium,
    incAngSurNor=incAngSurNor,
    Cp=Cp,
    azi=Buildings.Types.Azimuth.W)
    "Model to compute wind pressure on West-facing surface"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"),
    winSpeSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    winSpe=1,
    winDirSou=Buildings.BoundaryConditions.Types.DataSource.Input)
    "Weather data"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

  Modelica.Blocks.Sources.Ramp winDir(
    height=2*Modelica.Constants.pi,
    duration=24*3600)
    "Wind direction"
    annotation (Placement(transformation(extent={{-80,34},{-60,54}})));

equation
  connect(weaDat.winDir_in, winDir.y)
    annotation (Line(points={{-41,44},{-59,44}}, color={0,0,127}));
  connect(weaDat.weaBus, nor.weaBus) annotation (Line(
      points={{-20,50},{-10,50},{-10,50.2},{0,50.2}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, eas.weaBus) annotation (Line(
      points={{-20,50},{-10,50},{-10,10.2},{0,10.2}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, sou.weaBus) annotation (Line(
      points={{-20,50},{-10,50},{-10,-29.8},{0,-29.8}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, wes.weaBus) annotation (Line(
      points={{-20,50},{-10,50},{-10,-69.8},{0,-69.8}},
      color={255,204,51},
      thickness=0.5));
  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Sources/Validation/Outside_CpData_Directions.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model demonstrates the use of a source for ambient conditions that computes
the wind pressure on a facade of a building using a user-defined wind pressure profile.
In this model, the wind pressure profile is not realistic, but rather it is set to <i>1</i>
if the wind strikes the surface perpendicular, and otherwise it goes back to <i>0</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 11, 2022, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1436\">IBPSA, #1436</a>.
</li>
</ul>
</html>"),
    experiment(
      StopTime=86400,
      Tolerance=1e-06));
end Outside_CpData_Directions;
