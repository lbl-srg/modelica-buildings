within Buildings.Utilities.Psychrometrics.Examples;
model Phi_pTX "Model to test the relative humidity computation"
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
  Buildings.Utilities.Psychrometrics.Phi_pTX phi "Relative humidity"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    Modelica.Blocks.Sources.Ramp TDryBul(
    duration=0.5,
    startTime=0.5,
    height=-10,
    offset=303.15) "Dry bulb temperature"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
equation
  connect(XDryBul.y, phi.X_w) annotation (Line(
      points={{-59,0},{-11,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(phi.p, p.y) annotation (Line(
      points={{-11,-8},{-40,-8},{-40,-50},{-59,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TDryBul.y, phi.T) annotation (Line(
      points={{-59,50},{-40,50},{-40,8},{-11,8}},
      color={0,0,127},
      smooth=Smooth.None));
    annotation (experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Psychrometrics/Examples/Phi_pTX.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This examples is a unit test for the relative humidity computation.
</p>
</html>", revisions="<html>
<ul>
<li>
November 13, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Phi_pTX;
