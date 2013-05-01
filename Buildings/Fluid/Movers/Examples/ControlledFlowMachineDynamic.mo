within Buildings.Fluid.Movers.Examples;
model ControlledFlowMachineDynamic
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Movers.Examples.BaseClasses.ControlledFlowMachine(
    fan4(dynamicBalance=true, energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    fan1(dynamicBalance=true, energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    fan2(dynamicBalance=true, energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    fan3(dynamicBalance=true, energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial));
  annotation (
experiment(StopTime=600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/Examples/ControlledFlowMachineDynamic.mos"
        "Simulate and plot"),
    Documentation(info="<html>
This example demonstrates the use of the flow model with four different configurations.
At steady-state, all flow models have the same mass flow rate and pressure difference.
</html>"),
Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-160,-100},{160, 160}})));

end ControlledFlowMachineDynamic;
