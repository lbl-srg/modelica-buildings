within Buildings.Fluid.HeatExchangers.ActiveBeams.Validation;
model NumberOfBeamsDynamics
  "Validation model for the dynamic response for one and multiple beams"
  extends NumberOfBeams(
    nBeams = 2,
    beaCooHea(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      show_T=true,
      tau=120,
      TWatCoo_start=278.15,
      TWatHea_start=303.15),
    beaCooHea10(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      show_T=true,
      tau=120,
      TWatCoo_start=278.15,
      TWatHea_start=303.15),
    step(startTime=200),
    step1(startTime=300),
    step3(startTime=200),
    step2(startTime=300));
  annotation (
experiment(Tolerance=1e-6, StopTime=500),
   __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/ActiveBeams/Validation/NumberOfBeamsDynamics.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This model validates whether the transient response is indeed
independent of the number of beams.
The model is similar to
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ActiveBeams.Validation.NumberOfBeams\">
Buildings.Fluid.HeatExchangers.ActiveBeams.Validation.NumberOfBeams</a>,
except that it is configured with a dynamic balance and non-default initial conditions.
</p>
</html>", revisions="<html>
<ul>
<li>
June 24, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

end NumberOfBeamsDynamics;
