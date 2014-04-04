within Buildings.Electrical.Examples.Benchmarks;
model singleFeeder_50
  extends Modelica.Icons.Example;

  AC.ThreePhasesUnbalanced.Sources.FixedVoltageN                      source(
    f=50,
    Phi=0,
    V=230)                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-48,0})));
  Transmission.Benchmark.DataReader.DataSeries dataSeries(factorPV=0.0)
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  singleFeeder_50nodes feeder
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));
equation
  connect(source.terminal, feeder.terminal)                annotation (Line(
      points={{-38,0},{-20,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(dataSeries.pv, feeder.pv)                annotation (Line(
      points={{41,4},{30,4},{30,6},{18,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dataSeries.bldg, feeder.bldg)                annotation (Line(
      points={{41,-4},{30,-4},{30,-6},{18,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));

end singleFeeder_50;
