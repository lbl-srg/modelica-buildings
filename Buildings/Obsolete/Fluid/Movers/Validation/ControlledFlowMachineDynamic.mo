within Buildings.Obsolete.Fluid.Movers.Validation;
model ControlledFlowMachineDynamic
  "Fans with different control signals as input and a dynamic speed signal"
  extends Modelica.Icons.Example;
  extends Buildings.Obsolete.Fluid.Movers.Validation.BaseClasses.ControlledFlowMachine(
    fan4(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    fan1(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    fan2(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    fan3(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial));
  annotation (
experiment(Tolerance=1e-6, StopTime=600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Fluid/Movers/Validation/ControlledFlowMachineDynamic.mos"
        "Simulate and plot"),
    Documentation(info="<html>
This example demonstrates the use of the flow model with four different configurations.
At steady-state, all flow models have the same mass flow rate and pressure difference.
</html>", revisions="<html>
<ul>
<li>
March 21, 2023, by Hongxiang Fu:<br/>
Copied this model to the Obsolete package.
Revised its original version to remove the <code>Nrpm</code> mover.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1704\">#1704</a>.
</li>
</ul>
</html>"),
Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-160,-100},{160, 160}})));

end ControlledFlowMachineDynamic;
