within Buildings.Utilities.Plotters.Validation;
model PlotterActivationLocalInputFirstOff
  "Validation for plotter activation based on local input, plotter is first off"
  extends PlotterActivationLocalInput(booPul(startTime=2));
  annotation (
  experiment(Tolerance=1e-6, StopTime=10.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Plotters/Validation/PlotterActivationLocalInputFirstOff.mos"
        "Simulate and plot"),
Documentation(
info="<html>
<p>
Validation model for plotter configuration based on local activation
that is first off.
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
end PlotterActivationLocalInputFirstOff;
