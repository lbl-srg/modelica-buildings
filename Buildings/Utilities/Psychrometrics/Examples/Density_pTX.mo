within Buildings.Utilities.Psychrometrics.Examples;
model Density_pTX "Model to test the density computation"
  extends Modelica.Icons.Example;

 package Medium = Buildings.Media.Air "Medium model"
           annotation (choicesAllMatching = true);

  Modelica.Blocks.Sources.Constant p(k=101325) "Pressure"
    annotation (Placement(transformation(extent={{-80,-60},
            {-60,-40}})));
    Modelica.Blocks.Sources.Ramp XDryBul(
    height=0.014,
    offset=0,
    duration=0.5) "Dry bulb water vapor mass fraction"
                 annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Utilities.Psychrometrics.Density_pTX den "Density"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    Modelica.Blocks.Sources.Ramp TDryBul(
    duration=0.5,
    startTime=0.5,
    height=-10,
    offset=303.15) "Dry bulb temperature"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
equation
  connect(XDryBul.y, den.X_w) annotation (Line(
      points={{-59,0},{-11,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(den.p, p.y) annotation (Line(
      points={{-11,-8},{-40,-8},{-40,-50},{-59,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TDryBul.y, den.T) annotation (Line(
      points={{-59,50},{-40,50},{-40,8},{-11,8}},
      color={0,0,127},
      smooth=Smooth.None));
    annotation (experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Psychrometrics/Examples/Density_pTX.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This examples is a unit test for the density computation.
</p>
</html>", revisions="<html>
<ul>
<li>
February 24, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Density_pTX;
