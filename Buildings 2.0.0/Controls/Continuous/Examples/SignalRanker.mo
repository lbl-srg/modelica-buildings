within Buildings.Controls.Continuous.Examples;
model SignalRanker "Example model for signal ranker"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Sine sine(freqHz=2)
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Modelica.Blocks.Sources.Pulse pulse(period=0.25)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Controls.Continuous.SignalRanker sigRan(
                                                  nin=3)
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Modelica.Blocks.Sources.ExpSine expSine(freqHz=10, damping=1)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
equation
  connect(sine.y, sigRan.u[1])       annotation (Line(points={{-39,-10},{-32,
          -10},{-32,28.6667},{-22,28.6667}},
                                        color={0,0,127}));
  connect(pulse.y, sigRan.u[2])       annotation (Line(points={{-39,30},{-32,30},
          {-22,30}},               color={0,0,127}));
  connect(expSine.y, sigRan.u[3]) annotation (Line(points={{-39,70},{-30,70},{
          -30,31.3333},{-22,31.3333}}, color={0,0,127}));
 annotation (experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/Continuous/Examples/SignalRanker.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Example that demonstrates the use of the signal ranker model.
The figure below shows the input and output signals of the block.
Note that
<code>sigRan.y[1] &ge; sigRan.y[2] &ge; sigRan.y[3]</code>.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/Continuous/Examples/SignalRankerU.png\" border=\"1\" alt=\"Input to signal ranker.\"/><br/>
<img src=\"modelica://Buildings/Resources/Images/Controls/Continuous/Examples/SignalRankerY.png\" border=\"1\" alt=\"Output of signal ranker.\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
November 21, 2011, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end SignalRanker;
