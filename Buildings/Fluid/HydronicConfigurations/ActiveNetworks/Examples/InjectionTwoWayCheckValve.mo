within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples;
model InjectionTwoWayCheckValve
  "Model illustrating the operation of an inversion circuit with two-way valve and check valve and variable secondary"
  extends InjectionTwoWayVariable(
    T2Set_nominal=3.2+273.15,
    redeclare ActiveNetworks.InjectionTwoWayCheckValve con(k=0.1, Ti=500));
annotation (experiment(
    StopTime=86400,
    Tolerance=1e-6),
    __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HydronicConfigurations/ActiveNetworks/Examples/InjectionTwoWayCheckValve.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This model is nearly similar to 
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.InjectionTwoWayVariable\">
Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.InjectionTwoWayVariable</a>
except that
</p>
<ul>
<li>
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.InjectionTwoWayCheckValve\">
Buildings.Fluid.HydronicConfigurations.ActiveNetworks.InjectionTwoWayCheckValve</a>
is used to connect the consumer circuit in place of
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.InjectionTwoWay\">
Buildings.Fluid.HydronicConfigurations.ActiveNetworks.InjectionTwoWay</a>,
</li>
<li>
the consumer circuit set point is modified, together with the gain
and the time constant of the PI controller to simulate a loose control 
and trigger the check valve closing at around <i>8</i>&nbsp;h in model
time.
</ul>
</html>", revisions="<html>
<ul>
<li>
June 30, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end InjectionTwoWayCheckValve;
