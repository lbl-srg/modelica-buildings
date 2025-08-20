within Buildings.Utilities.Psychrometrics.Examples;
model XW_TDryBulTWetBul
  "Validation the calculation of the water vapor mass fraction"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air "Medium model"
     annotation (choicesAllMatching = true);

  Buildings.Utilities.Psychrometrics.XW_TDryBulTWetBul watVap(
    redeclare package Medium = Medium)
    "Model for calculating water vapor mass fraction"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Utilities.Psychrometrics.XW_TDryBulTWetBul watVapApp(
    redeclare package Medium = Medium,
    approximateWetBulb=true)
    "Model for calculating water vapor mass fraction"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));

  Modelica.Blocks.Sources.Ramp TDryBul(
    height=10,
    duration=1,
    offset=273.15 + 30) "Dry bulb temperature"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Constant p(
    k=101325)
    "Pressure"
    annotation (Placement(transformation(extent={{-80,-20}, {-60,0}})));
  Modelica.Blocks.Sources.Ramp TWetBul(
    height=8,
    duration=1,
    offset=273.15 + 27)
    "Wet bulb temperature"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

equation
  connect(p.y,watVap. p) annotation (Line(points={{-59,-10},{-40,-10},{-40,23},{
          -2,23}}, color={0,0,127}));
  connect(TDryBul.y,watVap. TDryBul) annotation (Line(points={{-59,70},{-20,70},
          {-20,37},{-2,37}}, color={0,0,127}));
  connect(p.y,watVapApp. p) annotation (Line(points={{-59,-10},{-40,-10},{-40,-10},
          {-40,-10},{-40,-17},{-2,-17}}, color={0,0,127}));
  connect(TDryBul.y,watVapApp. TDryBul) annotation (Line(points={{-59,70},{-20,70},
          {-20,-3},{-2,-3}}, color={0,0,127}));
  connect(TWetBul.y, watVap.TWetBul) annotation (Line(points={{-59,30},{-2,30}},
          color={0,0,127}));
  connect(TWetBul.y, watVapApp.TWetBul) annotation (Line(points={{-59,30},{-30,30},
          {-30,-10},{-2,-10}}, color={0,0,127}));

annotation (experiment(Tolerance=1e-6, StopTime=1.0),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Psychrometrics/Examples/XW_TDryBulTWetBul.mos"
        "Simulate and plot"),
Documentation(info="<html>
This examples is a unit test for the water vapor mass fraction.
The model on the top uses the accurate computation of the
wet bulb temperature, whereas the model below uses the approximate
computation of the wet bulb temperature.
</html>", revisions="<html>
<ul>
<li>
August 20, 2025 by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end XW_TDryBulTWetBul;
