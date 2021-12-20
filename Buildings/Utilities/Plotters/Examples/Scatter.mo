within Buildings.Utilities.Plotters.Examples;
model Scatter "Simple scatter plots"
  extends Modelica.Icons.Example;
  inner Buildings.Utilities.Plotters.Configuration plotConfiguration(
      samplePeriod=0.1) "Configuration for the plotters"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Utilities.Plotters.Scatter sca(
    samplePeriod=0.1,
    n=1,
    title="Sine vs cosine",
    xlabel="sine",
    legend={"cos"},
    introduction="This plot shows a scatter plot of sine vs cosine.")
    "Scatter plot"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Sources.RealExpression sine(y=sin(time))
  "Sine signal"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Modelica.Blocks.Sources.RealExpression cosine(y=cos(time))
  "Cosine signal"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Utilities.Plotters.Scatter sca1(
    samplePeriod=0.1,
    n=2,
    title="Sine vs cosine and sine vs cosine^2",
    legend={"sin vs cos","sin vs cos^2"},
    xlabel="sine",
    introduction=
        "This plot shows a scatter plot of sine vs cosine and of sine vs cosine^2.")
    "Scatter plot"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  Modelica.Blocks.Math.Product product
    "Product to compute the square of cos(time)"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
equation
  connect(sca.x, sine.y)
    annotation (Line(points={{58,-8},{52,-8},{52,-20},{-19,-20}},
                                                           color={0,0,127}));
  connect(cosine.y, sca.y[1])
    annotation (Line(points={{-19,0},{58,0}}, color={0,0,127}));
  connect(sca1.x, sine.y)
    annotation (Line(points={{58,32},{52,32},{52,-20},{-19,-20}},
                                                           color={0,0,127}));
  connect(cosine.y, sca1.y[1]) annotation (Line(points={{-19,0},{0,0},{0,41},{
          58,41}},            color={0,0,127}));
  connect(cosine.y, product.u1)
    annotation (Line(points={{-19,0},{0,0},{0,26},{18,26}}, color={0,0,127}));
  connect(cosine.y, product.u2)
    annotation (Line(points={{-19,0},{0,0},{0,14},{18,14}}, color={0,0,127}));
  connect(product.y, sca1.y[2]) annotation (Line(points={{41,20},{50,20},{50,39},
          {58,39}}, color={0,0,127}));
  annotation ( experiment(Tolerance=1e-6, StopTime=10.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Plotters/Examples/Scatter.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example demonstrates the use of a scatter plotter
that plots <i>(sin(t), cos(t))</i>, which will be a circle
with radius <i>1</i>,
and <i>(sin(t), cos<sup>2</sup>(t))</i>, which will be an arc
above the x-axis.
The plots will be in the file specified
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
end Scatter;
