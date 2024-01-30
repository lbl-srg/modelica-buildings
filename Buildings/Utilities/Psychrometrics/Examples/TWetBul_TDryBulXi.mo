within Buildings.Utilities.Psychrometrics.Examples;
model TWetBul_TDryBulXi
  extends Modelica.Icons.Example;

 package Medium = Buildings.Media.Air "Medium model"
           annotation (choicesAllMatching = true);

    Modelica.Blocks.Sources.Ramp TDryBul(
    height=10,
    duration=1,
    offset=273.15 + 30) "Dry bulb temperature"
                 annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi wetBul(         redeclare
      package Medium = Medium) "Model for wet bulb temperature"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Modelica.Blocks.Sources.Constant p(k=101325) "Pressure"
                                    annotation (Placement(transformation(extent={{-80,-20},
            {-60,0}})));
    Modelica.Blocks.Sources.Ramp XHum(
    duration=1,
    height=(0.0133 - 0.0175),
    offset=0.0175) "Humidity concentration"
                 annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi wetBulApp(redeclare
      package Medium = Medium, approximateWetBulb=true)
    "Model for wet bulb temperature"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
equation
  connect(p.y, wetBul.p) annotation (Line(points={{-59,-10},{-40,-10},{-40,22},{
          -1,22}},                                                  color={0,0,
          127}));
  connect(XHum.y, wetBul.Xi[1]) annotation (Line(
      points={{-59,30},{-30,30},{-1,30}},
      color={0,0,127}));
  connect(TDryBul.y, wetBul.TDryBul) annotation (Line(
      points={{-59,70},{-20,70},{-20,38},{-1,38}},
      color={0,0,127}));
  connect(p.y, wetBulApp.p)
                         annotation (Line(points={{-59,-10},{-40,-10},{-40,-10},
          {-40,-10},{-40,-18},{-1,-18}},                            color={0,0,
          127}));
  connect(XHum.y, wetBulApp.Xi[1])
                                annotation (Line(
      points={{-59,30},{-29,30},{-29,-10},{-1,-10}},
      color={0,0,127}));
  connect(TDryBul.y, wetBulApp.TDryBul)
                                     annotation (Line(
      points={{-59,70},{-20,70},{-20,-2},{-1,-2}},
      color={0,0,127}));
    annotation (experiment(Tolerance=1e-6, StopTime=1.0),
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
June 23, 2016, by Michael Wetter:<br/>
Changed graphical annotation.
</li>
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
