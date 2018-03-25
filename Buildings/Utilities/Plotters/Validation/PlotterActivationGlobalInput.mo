within Buildings.Utilities.Plotters.Validation;
model PlotterActivationGlobalInput
  "Validation for plotter activation based on global input"
  extends PlotterActivationAlwaysOn(plotConfiguration(activation=
          Buildings.Utilities.Plotters.Types.GlobalActivation.use_input));
  Modelica.Blocks.Sources.BooleanPulse booPul(period=2) "Boolean pulse signal"
    annotation (Placement(transformation(extent={{-80,68},{-60,88}})));
equation
  connect(booPul.y, plotConfiguration.activate)
    annotation (Line(points={{-59,78},{-42,78}}, color={255,0,255}));
  annotation (
  experiment(Tolerance=1e-6, StopTime=10.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Plotters/Validation/PlotterActivationGlobalInput.mos"
        "Simulate and plot"),
Documentation(
info="<html>
<p>
Validation model for plotter configuration based on global activation.
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
end PlotterActivationGlobalInput;
