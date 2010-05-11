within Buildings.Fluid.Movers.Examples;
model ControlledFlowMachineDynamic
extends Buildings.Fluid.Movers.Examples.BaseClasses.ControlledFlowMachine(
    fan4(dynamicBalance=true),
    fan1(dynamicBalance=true),
    fan2(dynamicBalance=true),
    fan3(dynamicBalance=true),
    limiter(uMin=0.03));
  annotation (
    Commands(file="ControlledFlowMachineDynamic.mos" "run"),
    Documentation(info="<html>
This example demonstrates the use of the flow model with four different configuration.
At steady-state, all flow models have the same mass flow rate and pressure difference.
</html>"));

end ControlledFlowMachineDynamic;
