within Buildings.Fluid.FMI.Examples;
model SpaceCooling
  "Example of a thermal zone with cooling in which the HVAC system is encapsulated for FMU export"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air "Medium model";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=0.1
    "Nominal mass flow rate";

  parameter Boolean use_p_in = false
    "= true to use a pressure from connector, false to output Medium.p_default"
    annotation(Evaluate=true);
  parameter Boolean allowFlowReversal = false
    "= true to allow flow reversal, false restricts to design direction (inlet -> outlet)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  FMUs.HVACCoolingOnlyConvective hvac "HVAC system"
    annotation (Placement(transformation(extent={{-72,-20},{-40,12}})));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -100},{140,100}}), graphics), Documentation(info="<html>
<p>
This example demonstrates how to configure a model with a flow splitter.
</p>
<p>
For this example, the model is not exported as an FMU. However, the
thermofluid flow models are wrapped using input/output blocks.
</p>
</html>", revisions="<html>
<ul>
<li>
July 28, 2015, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Examples/FlowSplitter_u.mos"
        "Simulate and plot"),
    experiment(StopTime=1));
end SpaceCooling;
