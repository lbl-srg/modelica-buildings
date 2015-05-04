within Buildings.Utilities.Psychrometrics.Examples;
model TWetBul_TDryBulXi
  extends Modelica.Icons.Example;

 package Medium = Buildings.Media.Air "Medium model"
           annotation (choicesAllMatching = true);

    Modelica.Blocks.Sources.Ramp TDryBul(
    height=10,
    duration=1,
    offset=273.15 + 30) "Dry bulb temperature"
                 annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi wetBul(         redeclare
      package Medium = Medium) "Model for wet bulb temperature"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Modelica.Blocks.Sources.Constant p(k=101325) "Pressure"
                                    annotation (Placement(transformation(extent={{-100,
            -20},{-80,0}})));
    Modelica.Blocks.Sources.Ramp XHum(
    duration=1,
    height=(0.0133 - 0.0175),
    offset=0.0175) "Humidity concentration"
                 annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi wetBulApp(redeclare
      package Medium = Medium, approximateWetBulb=true)
    "Model for wet bulb temperature"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
equation
  connect(p.y, wetBul.p) annotation (Line(points={{-79,-10},{-60,-10},{-60,22},
          {-1,22}},                                                 color={0,0,
          127}));
  connect(XHum.y, wetBul.Xi[1]) annotation (Line(
      points={{-79,30},{-1,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TDryBul.y, wetBul.TDryBul) annotation (Line(
      points={{-79,70},{-48,70},{-48,38},{-1,38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p.y, wetBulApp.p)
                         annotation (Line(points={{-79,-10},{-60,-10},{-60,-18},
          {-1,-18}},                                                color={0,0,
          127}));
  connect(XHum.y, wetBulApp.Xi[1])
                                annotation (Line(
      points={{-79,30},{-55,30},{-55,-10},{-1,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TDryBul.y, wetBulApp.TDryBul)
                                     annotation (Line(
      points={{-79,70},{-48,70},{-48,-2},{-1,-2}},
      color={0,0,127},
      smooth=Smooth.None));
    annotation (experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Psychrometrics/Examples/TWetBul_TDryBulXi.mos"
        "Simulate and plot"),
    Documentation(info="<html>
This examples is a unit test for the wet bulb computation.
The model on the top uses the accurate computation of the
wet bulb temperature, whereas the model below uses the approximate
computation of the wet bulb temperature.
</html>", revisions="<html>
<ul>
<li>
October 1, 2012 by Michael Wetter:<br/>
Revised implementation to add approximate computation of wet bulb temperature.
</li>
<li>
May 7, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end TWetBul_TDryBulXi;
