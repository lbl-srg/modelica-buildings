within Buildings.Fluid.HeatExchangers.Examples;
model WetCoilCounterFlowPIDControlAutoTuning
  "Model that demonstrates the use of a heat exchanger with condensation and with autotuning PID feedback control"
  extends WetCoilCounterFlowPControlAutoTuning(con(controllerType=Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Types.SimpleController.PID));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{200,200}})),
experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Examples/WetCoilCounterFlowPIDControlAutoTuning.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This example is identical to 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Examples.WetCoilCounterFlowPIControlAutoTuning\">
Buildings.Fluid.HeatExchangers.Examples.WetCoilCounterFlowPIControlAutoTuning</a> except that
the controller is configured as a PID rather than a PI controller.
</html>",
revisions="<html>
<ul>
<li>
February 10, 2025, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end WetCoilCounterFlowPIDControlAutoTuning;
