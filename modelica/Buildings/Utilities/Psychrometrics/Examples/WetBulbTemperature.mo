within Buildings.Utilities.Psychrometrics.Examples;
model WetBulbTemperature

    annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                        graphics),
                         Commands(file=
            "WetBulbTemperature.mos" "run"),
    Documentation(info="<html>
This examples is a unit test for the wet bulb computation.
The problem setup is such that the moisture concentration and
the dry bulb temperature are varied simultaneously so 
that the wet bulb temperature remains constant.
This wet bulb temperature is checked against a constant value with
an assert statement.
If this assert is triggered, then the model for the wet bulb computation
is broken (assuming that the inputs remained unchanged).
</html>", revisions="<html>
<ul>
<li>
May 7, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

 package Medium = Buildings.Media.PerfectGases.MoistAir "Medium model" 
           annotation (choicesAllMatching = true);

    Modelica.Blocks.Sources.Ramp TDB(
    height=10,
    duration=1,
    offset=273.15 + 30) "Dry bulb temperature" 
                 annotation (Placement(transformation(extent={{-100,60},{-80,80}},
          rotation=0)));
  Buildings.Utilities.Diagnostics.AssertEquality assertEquality(startTime=0,
      threShold=0.05) 
    annotation (Placement(transformation(extent={{60,20},{80,40}}, rotation=0)));
  Modelica.Blocks.Sources.Constant TWBExp(k=273.15 + 25)
    "Expected wet bulb temperature" annotation (Placement(transformation(extent=
           {{20,-20},{40,0}}, rotation=0)));
  Buildings.Utilities.Psychrometrics.WetBulbTemperature wetBul(redeclare
      package Medium = Medium) "Model for wet bulb temperature" 
    annotation (Placement(transformation(extent={{0,20},{20,40}}, rotation=0)));
  Modelica.Blocks.Sources.Constant p(k=101325) "Pressure" 
                                    annotation (Placement(transformation(extent=
           {{-100,20},{-80,40}}, rotation=0)));
    Modelica.Blocks.Sources.Ramp XHum(
    duration=1,
    height=(0.0133 - 0.0175),
    offset=0.0175) "Humidity concentration" 
                 annotation (Placement(transformation(extent={{-100,-20},{-80,0}},
                   rotation=0)));
equation
  connect(TWBExp.y, assertEquality.u2) 
    annotation (Line(points={{41,-10},{48,-10},{48,24},{58,24}}, color={0,0,127}));
  connect(TDB.y, wetBul.TDryBul) annotation (Line(points={{-79,70},{-39.5,70},{
          -39.5,38},{1,38}}, color={0,0,127}));
  connect(p.y, wetBul.p) annotation (Line(points={{-79,30},{1,30}}, color={0,0,
          127}));
  connect(wetBul.TWetBul, assertEquality.u1) 
    annotation (Line(points={{19,30},{40,30},{40,36},{58,36}}, color={0,0,255}));
  connect(XHum.y, wetBul.Xi[1]) annotation (Line(
      points={{-79,-10},{-38,-10},{-38,22},{1,22}},
      color={0,0,127},
      smooth=Smooth.None));
end WetBulbTemperature;
