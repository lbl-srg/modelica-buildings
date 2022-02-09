within Buildings.Utilities.Math.Examples;
model VectorFunctions "Test model for functions that take a vector as argument"
  extends Modelica.Icons.Example;

  Buildings.Utilities.Math.Min minVec(
                   nin=3)
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Modelica.Blocks.Sources.Sine sine(f=6)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.Sine sine1(f=8)
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Sources.Sine sine2(f=10)
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Utilities.Math.Max maxVec(
                   nin=3)
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Buildings.Utilities.Math.Average aveVec(
                       nin=3)
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
equation
  connect(sine.y, minVec.u[1]) annotation (Line(
      points={{-59,30},{-40.5,30},{-40.5,28.6667},{-22,28.6667}},
      color={0,0,127}));
  connect(sine1.y, minVec.u[2]) annotation (Line(
      points={{-59,-10},{-40,-10},{-40,30},{-22,30}},
      color={0,0,127}));
  connect(sine2.y, minVec.u[3]) annotation (Line(
      points={{-59,-50},{-40,-50},{-40,31.3333},{-22,31.3333}},
      color={0,0,127}));
  connect(sine.y, maxVec.u[1]) annotation (Line(
      points={{-59,30},{-40.5,30},{-40.5,-51.3333},{-22,-51.3333}},
      color={0,0,127}));
  connect(sine1.y, maxVec.u[2]) annotation (Line(
      points={{-59,-10},{-42,-10},{-42,-50},{-22,-50}},
      color={0,0,127}));
  connect(sine2.y, maxVec.u[3]) annotation (Line(
      points={{-59,-50},{-40,-50},{-40,-48.6667},{-22,-48.6667}},
      color={0,0,127}));
  connect(sine.y, aveVec.u[1]) annotation (Line(
      points={{-59,30},{-40.5,30},{-40.5,-11.3333},{-22,-11.3333}},
      color={0,0,127}));
  connect(sine1.y, aveVec.u[2]) annotation (Line(
      points={{-59,-10},{-22,-10}},
      color={0,0,127}));
  connect(sine2.y, aveVec.u[3]) annotation (Line(
      points={{-59,-50},{-40,-50},{-40,-8.66667},{-22,-8.66667}},
      color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Examples/VectorFunctions.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests the implementation of functions that take a vector as an argument.
</p>
</html>", revisions="<html>
<ul>
<li>
August 15, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end VectorFunctions;
