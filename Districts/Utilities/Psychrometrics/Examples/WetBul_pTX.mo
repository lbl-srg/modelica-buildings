within Districts.Utilities.Psychrometrics.Examples;
model WetBul_pTX "Model to test the wet bulb temperature computation"
  import Districts;
  extends Modelica.Icons.Example;

 package Medium = Buildings.Media.PerfectGases.MoistAirUnsaturated
    "Medium model"
           annotation (choicesAllMatching = true);

  Modelica.Blocks.Sources.Constant p(k=101325) "Pressure"
                                    annotation (Placement(transformation(extent={{-80,-20},
            {-60,0}},            rotation=0)));
    Modelica.Blocks.Sources.Ramp XDryBul(
    duration=1,
    height=0.014,
    offset=0) "Dry bulb water vapor mass fraction"
                 annotation (Placement(transformation(extent={{-80,20},{-60,40}},
                   rotation=0)));
  Modelica.Blocks.Sources.Constant TDryBul(k=293.15) "Dry bulb temperature"
                                    annotation (Placement(transformation(extent={{-80,60},
            {-60,80}},           rotation=0)));
  Districts.Utilities.Psychrometrics.WetBul_pTX      wetBul_TDryBulX(redeclare
      package Medium = Medium)
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
    annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                        graphics),
    __Dymola_Commands(file="modelica://Districts/Resources/Scripts/Dymola/Utilities/Psychrometrics/Examples/WetBul_pTX.mos"
        "Simulate and plot"),
    Documentation(info="<html>
This examples is a unit test for the wet bulb computation.
</html>", revisions="<html>
<ul>
<li>
October 2, 2012 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end WetBul_pTX;
