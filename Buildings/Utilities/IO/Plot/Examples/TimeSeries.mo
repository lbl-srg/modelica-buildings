within Buildings.Utilities.IO.Plot.Examples;
model TimeSeries "Example that plots time series"
  import Buildings;
  extends Modelica.Icons.Example;
  Buildings.Utilities.IO.Plot.TimeSeries timSer(
    samplePeriod=0.1,
    n=2,
    legend={"x1","x222"},
    title="Sine and cosine") "Plotter"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=sin(time))
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=cos(time))
    annotation (Placement(transformation(extent={{-40,-22},{-20,-2}})));
  Buildings.Utilities.IO.Plot.TimeSeries timSer1(
    samplePeriod=0.1,
    n=2,
    title="AAASine and cosine",
    legend={"x1","x2"})      "Plotter"
    annotation (Placement(transformation(extent={{24,-56},{44,-36}})));
equation
  connect(realExpression.y, timSer.u[1]) annotation (Line(points={{-19,20},{0,
          20},{0,-1},{18,-1}}, color={0,0,127}));
  connect(realExpression1.y, timSer.u[2]) annotation (Line(points={{-19,-12},{0,
          -12},{0,1},{18,1}}, color={0,0,127}));
  connect(realExpression.y, timSer1.u[1]) annotation (Line(points={{-19,20},{4,
          20},{4,-47},{22,-47}}, color={0,0,127}));
  connect(realExpression1.y, timSer1.u[2]) annotation (Line(points={{-19,-12},{
          4,-12},{4,-45},{22,-45}}, color={0,0,127}));
end TimeSeries;
