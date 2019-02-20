within Buildings.Utilities.Plotters.Examples;
model TimeSeries "Simple time series plots"
  extends Modelica.Icons.Example;
  inner Buildings.Utilities.Plotters.Configuration plotConfiguration(
      samplePeriod=0.1,
      timeUnit=Buildings.Utilities.Plotters.Types.TimeUnit.seconds)
      "Configuration for the plotters"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Utilities.Plotters.TimeSeries timSer(
    samplePeriod=0.1,
    n=3,
    title="Sine, cosine and sine*cosine",
    legend={"sin","cos","sin*cos"})
     "Plotter"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Sources.RealExpression sine(y=sin(time)) "Sine output signal"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Modelica.Blocks.Sources.RealExpression cosine(y=cos(time))
    "Cosine output signal"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Utilities.Plotters.TimeSeries timSer1(
    samplePeriod=0.1,
    n=2,
    title="Sine, cosine",
    legend={"sin","cos"})
    "Plotter"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Modelica.Blocks.Math.Product pro "Product of sine times cosine"
    annotation (Placement(transformation(extent={{-40,-12},{-20,8}})));
equation
  connect(sine.y, timSer.y[1]) annotation (Line(points={{-59,20},{2,20},{2,
          1.33333},{18,1.33333}}, color={0,0,127}));
  connect(cosine.y, timSer.y[2]) annotation (Line(points={{-59,-20},{-8,-20},{-8,
          -1.11022e-16},{18,-1.11022e-16}}, color={0,0,127}));
  connect(sine.y, timSer1.y[1]) annotation (Line(points={{-59,20},{2,20},{2,-49},
          {18,-49}}, color={0,0,127}));
  connect(cosine.y, timSer1.y[2]) annotation (Line(points={{-59,-20},{-8,-20},{
          -8,-51},{18,-51}}, color={0,0,127}));
  connect(sine.y, pro.u1) annotation (Line(points={{-59,20},{-52,20},{-52,4},{-42,
          4}}, color={0,0,127}));
  connect(cosine.y, pro.u2) annotation (Line(points={{-59,-20},{-52,-20},{-52,-8},
          {-42,-8}}, color={0,0,127}));
  connect(pro.y, timSer.y[3]) annotation (Line(points={{-19,-2},{0,-2},{0,-1.33333},
          {18,-1.33333}}, color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=10.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Plotters/Examples/TimeSeries.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example demonstrates the use of a plotter
that plots <i>(t, sin(t), cos(t), sin(t)*cos(t)</i> in
one plot, and
<i>(t, sin(t), cos(t)</i> 
in another plot.
Both plots will be in the file specified
in the plot configuration <code>plotConfiguration</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 23, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end TimeSeries;
