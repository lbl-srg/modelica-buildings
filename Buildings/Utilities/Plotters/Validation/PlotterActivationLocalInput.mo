within Buildings.Utilities.Plotters.Validation;
model PlotterActivationLocalInput
  "Validation for plotter activation based on local input"
  extends PlotterActivationAlwaysOn(sca(activation=Buildings.Utilities.Plotters.Types.LocalActivation.use_input),
      scaDel(activation=Buildings.Utilities.Plotters.Types.LocalActivation.use_input));
  Modelica.Blocks.Sources.BooleanPulse booPul(period=2) "Boolean pulse signal"
    annotation (Placement(transformation(extent={{-80,66},{-60,86}})));
equation
  connect(booPul.y, sca.activate) annotation (Line(points={{-59,76},{-50,76},{
          -50,38},{-2,38}},
                        color={255,0,255}));
  connect(booPul.y, scaDel.activate) annotation (Line(points={{-59,76},{-50,76},
          {-50,38},{-12,38},{-12,-2},{-2,-2}}, color={255,0,255}));
  annotation (
  experiment(Tolerance=1e-6, StopTime=10.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Plotters/Validation/PlotterActivationLocalInput.mos"
        "Simulate and plot"),
Documentation(
info="<html>
<p>
Validation model for plotter configuration based on local activation.
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
end PlotterActivationLocalInput;
