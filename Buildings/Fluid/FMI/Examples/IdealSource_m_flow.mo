within Buildings.Fluid.FMI.Examples;
block IdealSource_m_flow "FMU declaration for a fixed resistance"
   extends Buildings.Fluid.FMI.TwoPort(
     redeclare package Medium =
        Buildings.Media.GasesConstantDensity.MoistAirUnsaturated);
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal(start=1) = 1
    "Nominal mass flow rate";

  Modelica.Blocks.Interfaces.RealInput m_flow_in(final unit="kg/s",
                                                 nominal=m_flow_nominal)
    "Prescribed mass flow rate"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120}),   iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-2,120})));

equation
  assert(abs(port_a.m_flow-port_b.m_flow) < 1E-2,
  "The mass flow rate of port_a and port_b is not conserved.
  This indicates a wrong configuration of your system model.");
  port_b.m_flow = m_flow_in;
  port_b.p = port_a.p;

  port_a.h_outflow = port_b.h_inflow;
  port_b.h_outflow = port_a.h_inflow;

  port_a.Xi_outflow = port_b.Xi_inflow;
  port_b.Xi_outflow = port_a.Xi_inflow;

  port_a.C_outflow = port_b.C_inflow;
  port_b.C_outflow = port_a.C_inflow;

  annotation (
  Documentation(info="<html>
<p>
This example demonstrates how to export an FMU with a fluid flow component.
The FMU has an instance of
<a href=\"modelica://Buildings.Fluid.Movers.IdealSource_m_flow\">
Buildings.Fluid.Movers.IdealSource_m_flow</a>.
</p>
<p>
In Dymola, to export the model as an FMU,
select from the pull down menu <code>Commands - Export FMU</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 3, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Examples/IdealSource_m_flow.mos"
        "Export FMU"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
                    graphics));
end IdealSource_m_flow;
