within Buildings.Fluid.Examples.FlowSystem;
model Simplified5 "Removed most mass/energy dynamics"
  extends Simplified4(
    spl1(energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState),
    spl(energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState),
    spl2(energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState),
    spl3(energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState),
    pumpCoo(energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState),
    pumpHea(energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState),
    heater(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial));
  annotation (Documentation(info="<html>
<p>
The model is further simplified by setting the mass dynamics and energy dynamics
of most models to be steady state.
Note that by default, the mass dynamics is set to the same configuration
as the energy dynamics.
</p>
</html>", revisions="<html>
<ul>
<li>
December 14, 2016, by Michael Wetter:<br/>
Removed superfluous assignment of mass dynamics.
</li>
<li>
October 7, 2016, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(Tolerance=1e-6, StopTime=1000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Examples/FlowSystem/Simplified5.mos"
        "Simulate and plot"));
end Simplified5;
