within Buildings.Fluid.Sensors.BaseClasses;
partial model PartialFlowSensor
  "Partial component to model sensors that measure flow properties"
  extends Buildings.Fluid.Interfaces.PartialTwoPort;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal(min=0)
    "Nominal mass flow rate, used for regularization near zero flow"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*m_flow_nominal
    "For bi-directional flow, temperature is regularized in the region |m_flow| < m_flow_small (m_flow_small > 0 required)"
    annotation(Dialog(tab="Advanced"));
equation
  // mass balance
  port_b.m_flow = -port_a.m_flow;
  // momentum equation (no pressure loss)
  port_a.p = port_b.p;
  // isenthalpic state transformation (no storage and no loss of energy)
  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);
  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);
  port_a.C_outflow = inStream(port_b.C_outflow);
  port_b.C_outflow = inStream(port_a.C_outflow);
  annotation (Documentation(info="<html>
<p>
Partial component to model a sensor.
The sensor is ideal. It does not influence mass, energy,
species or substance balance, and it has no flow friction.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 19, 2015, by Michael Wetter:<br/>
Moved <code>m_flow_small</code> to the <code>Advanced</code> tab
as it usually need not be changed by the user.
Other models such as heat exchangers also have this parameter
on the <code>Advanced</code> tab.
</li>
<li>
February 12, 2011, by Michael Wetter:<br/>
First implementation.
Implementation is based on <code>Modelica.Fluid</code>.
</li>
</ul>
</html>"));
end PartialFlowSensor;
