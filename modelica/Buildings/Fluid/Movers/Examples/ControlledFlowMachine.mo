within Buildings.Fluid.Movers.Examples;
model ControlledFlowMachine
  import Buildings;
extends Buildings.Fluid.Movers.Examples.BaseClasses.ControlledFlowMachine;

  annotation (
    Commands(file="ControlledFlowMachine.mos" "run"),
    Documentation(info="<html>
This example demonstrates the use of the flow model with four different configuration.
At steady-state, all flow models have the same mass flow rate and pressure difference.
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-160,-100},{160,
            160}}), graphics),
              Diagram);
end ControlledFlowMachine;
