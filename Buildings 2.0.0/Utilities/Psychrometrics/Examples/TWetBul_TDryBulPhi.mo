within Buildings.Utilities.Psychrometrics.Examples;
model TWetBul_TDryBulPhi "Model to test the wet bulb temperature computation"
  extends Modelica.Icons.Example;

 package Medium = Buildings.Media.Air "Medium model"
           annotation (choicesAllMatching = true);

  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulPhi wetBulPhi(redeclare
      package Medium = Medium) "Model for wet bulb temperature"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Modelica.Blocks.Sources.Constant p(k=101325) "Pressure"
                                    annotation (Placement(transformation(extent={{-100,
            -20},{-80,0}})));
    Modelica.Blocks.Sources.Ramp phi(
    duration=1,
    height=0.98,
    offset=0.01) "Relative humidity"
                 annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Sources.Constant TDryBul(k=283.15) "Dry bulb temperature"
                                    annotation (Placement(transformation(extent={{-100,60},
            {-80,80}})));
  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulPhi wetBulPhiApp(redeclare
      package Medium = Medium, approximateWetBulb=true)
    "Model for wet bulb temperature"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation
  connect(p.y, wetBulPhi.p)
                         annotation (Line(points={{-79,-10},{-40,-10},{-40,42},{
          -1,42}},                                                  color={0,0,
          127}));
  connect(TDryBul.y, wetBulPhi.TDryBul) annotation (Line(
      points={{-79,70},{-32,70},{-32,58},{-1,58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(phi.y, wetBulPhi.phi) annotation (Line(
      points={{-79,30},{-46,30},{-46,50},{-1,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p.y, wetBulPhiApp.p)
                         annotation (Line(points={{-79,-10},{-40,-10},{-40,2},{
          -1,2}},                                                   color={0,0,
          127}));
  connect(TDryBul.y, wetBulPhiApp.TDryBul)
                                        annotation (Line(
      points={{-79,70},{-32,70},{-32,18},{-1,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(phi.y, wetBulPhiApp.phi)
                                annotation (Line(
      points={{-79,30},{-46,30},{-46,10},{-1,10}},
      color={0,0,127},
      smooth=Smooth.None));
    annotation (experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Psychrometrics/Examples/TWetBul_TDryBulPhi.mos"
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
First implementation.
</li>
</ul>
</html>"));
end TWetBul_TDryBulPhi;
