within Buildings.Fluid.Movers.Examples;
model ControlledFlowMachineDynamic
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Movers.Examples.BaseClasses.ControlledFlowMachine(
    fan4(dynamicBalance=true),
    fan1(dynamicBalance=true),
    fan2(dynamicBalance=true),
    fan3(dynamicBalance=true));
  annotation (
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/Examples/ControlledFlowMachineDynamic.mos" "Simulate and plot"),
    Documentation(info="<html>
This example demonstrates the use of the flow model with four different configurations.
At steady-state, all flow models have the same mass flow rate and pressure difference.
</html>"),
Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-160,-100},{160, 160}}), graphics));

end ControlledFlowMachineDynamic;
