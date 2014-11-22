within Buildings.Utilities.Psychrometrics.Examples;
model WetBul_pTX "Model to test the wet bulb temperature computation"
  extends Modelica.Icons.Example;

 package Medium = Buildings.Media.PerfectGases.MoistAirUnsaturated
           annotation (choicesAllMatching = true);

  Modelica.Blocks.Sources.Constant p(k=101325) "Pressure"
                                    annotation (Placement(transformation(extent={{-80,-20},
            {-60,0}})));
    Modelica.Blocks.Sources.Ramp XDryBul(
    duration=1,
    height=0.014,
    offset=0) "Dry bulb water vapor mass fraction"
                 annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.Constant TDryBul(k=293.15) "Dry bulb temperature"
                                    annotation (Placement(transformation(extent={{-80,60},
            {-60,80}})));
  Buildings.Utilities.Psychrometrics.WetBul_pTX wetBul_TDryBulX
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
equation
  connect(TDryBul.y, wetBul_TDryBulX.TDryBul) annotation (Line(
      points={{-59,70},{-40,70},{-40,58},{-21,58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XDryBul.y, wetBul_TDryBulX.XDryBul) annotation (Line(
      points={{-59,30},{-52,30},{-52,50},{-21,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p.y, wetBul_TDryBulX.p) annotation (Line(
      points={{-59,-10},{-40,-10},{-40,42},{-21,42}},
      color={0,0,127},
      smooth=Smooth.None));
    annotation (experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Psychrometrics/Examples/WetBul_pTX.mos"
        "Simulate and plot"),
    Documentation(info="<html>
This examples is a unit test for the wet bulb computation.
</html>", revisions="<html>
<ul>
<li>
November 20, 2013 by Michael Wetter:<br/>
Removed medium declaration in instance <code>wetBul_TDryBulX</code>.
</li>
<li>
October 2, 2012 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end WetBul_pTX;
