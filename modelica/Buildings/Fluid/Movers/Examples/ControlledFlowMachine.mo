within Buildings.Fluid.Movers.Examples;
model ControlledFlowMachine
  import Buildings;
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Movers.Examples.BaseClasses.ControlledFlowMachine(
    fan4(addPowerToMedium=false),
    fan1(addPowerToMedium=false),
    fan2(addPowerToMedium=false),
    fan3(addPowerToMedium=false));

  annotation (
    Commands(file="ControlledFlowMachine.mos" "run"),
    Documentation(info="<html>
This example demonstrates the use of the flow model with four different configurations.
At steady-state, all flow models have the same mass flow rate and pressure difference.
Note that <code>addPowerToMedium=false</code> since otherwise, 
Dymola computes the enthalpy change of the component as a fraction <code>(k*m_flow+P_internal)/m_flow</code>
which leads to an error because of <code>0/0</code> at zero flow rate.
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-160,-100},{160,
            160}}), graphics),
              Diagram);
end ControlledFlowMachine;
