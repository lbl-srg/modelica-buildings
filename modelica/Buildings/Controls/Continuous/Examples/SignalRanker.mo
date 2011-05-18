within Buildings.Controls.Continuous.Examples;
model SignalRanker "Example model"
  extends Modelica.Icons.Example; 
  Modelica.Blocks.Sources.Sine sine(freqHz=2)
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}}, rotation=0)));
  Modelica.Blocks.Sources.Pulse pulse(period=0.25)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}}, rotation=0)));
  Buildings.Controls.Continuous.SignalRanker sigRan(
                                                  nin=3)
    annotation (Placement(transformation(extent={{-20,20},{0,40}}, rotation=0)));
  Modelica.Blocks.Sources.ExpSine expSine(freqHz=10)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}}, rotation=0)));
equation
  connect(sine.y, sigRan.u[1])       annotation (Line(points={{-39,-10},{-32,
          -10},{-32,28.6667},{-22,28.6667}},
                                        color={0,0,127}));
  connect(pulse.y, sigRan.u[2])       annotation (Line(points={{-39,30},{-32,30},
          {-22,30}},               color={0,0,127}));
  connect(expSine.y, sigRan.u[3]) annotation (Line(points={{-39,70},{-30,70},{
          -30,31.3333},{-22,31.3333}}, color={0,0,127}));
 annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                     graphics),
                      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/Continuous/Examples/SignalRanker.mos" "Simulate and plot"),
              Diagram);
end SignalRanker;
