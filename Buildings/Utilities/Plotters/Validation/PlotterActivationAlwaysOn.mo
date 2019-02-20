within Buildings.Utilities.Plotters.Validation;
model PlotterActivationAlwaysOn
  "Validation model that checks whether the plotters are activated correctly"
  extends Modelica.Icons.Example;
  inner Configuration plotConfiguration(
    timeUnit=Buildings.Utilities.Plotters.Types.TimeUnit.seconds,
    samplePeriod=0.1)
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Time.ModelTime timeSignal "Signal that outputs time"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Scatter sca(
    legend={"x"}, n=1)
    "Scatter plot"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Scatter scaDel(
    activationDelay=0.2,
    legend={"x"},
    n=1)
    "Scatter plot with delayed on"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
equation
  connect(timeSignal.y, sca.x)
    annotation (Line(points={{-39,10},{-28,10},{-28,22},{-2,22}},
                                                        color={0,0,127}));
  connect(timeSignal.y, scaDel.x) annotation (Line(points={{-39,10},{-28,10},{
          -28,-18},{-2,-18}},      color={0,0,127}));
  connect(timeSignal.y, sca.y[1]) annotation (Line(points={{-39,10},{-20,10},{
          -20,30},{-2,30}}, color={0,0,127}));
  connect(timeSignal.y, scaDel.y[1]) annotation (Line(points={{-39,10},{-20,10},
          {-20,-10},{-2,-10}}, color={0,0,127}));
  annotation (
  experiment(Tolerance=1e-6, StopTime=10.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Plotters/Validation/PlotterActivationAlwaysOn.mos"
        "Simulate and plot"),
Documentation(
info="<html>
<p>
Validation model for plotter configuration that is always on.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 23, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PlotterActivationAlwaysOn;
