within Buildings.Fluid.HeatExchangers.Validation;
model PrescribedOutlet_dynamic
  "Model that demonstrates the ideal heater/cooler model for a prescribed outlet temperature, configured as dynamic"
  extends Buildings.Fluid.HeatExchangers.Validation.PrescribedOutlet(
    heaHigPow(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    cooLimPow(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    heaCooUnl(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{200,200}}),                                                                    graphics),
    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Validation/PrescribedOutlet_dynamic.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Model that demonstrates the use of an ideal heater and an ideal cooler, configured as dynamic models.
</p>
<p>
This example is identical to
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Validation.PrescribedOutlet\">
Buildings.Fluid.HeatExchangers.Validation.PrescribedOutlet</a>
except that the heater and cooler models are configured to have a
time constant of <i>60</i> seconds at nominal flow rate.
At lower flow rate, the time constant increases proportional to the mass flow rate.
</p>
</html>", revisions="<html>
<ul>
<li>
October 21, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=1200,
      Tolerance=1e-6));
end PrescribedOutlet_dynamic;
