within Buildings.Fluid.Geothermal.ZonedThermalStorage.Interfaces;
partial model PartialTwoNPortsInterface
  "Partial model with two vectors of ports and declaration of quantities for bore field models"
  extends
    Buildings.Fluid.Geothermal.ZonedThermalStorage.Interfaces.PartialTwoNPorts;

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal[nPorts]
    "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_small[nPorts](each min=0) = 1E-4*abs(
    m_flow_nominal) "Small mass flow rate for regularization of zero flow"
    annotation (Dialog(tab="Advanced"));
  // Diagnostics
   parameter Boolean show_T = false
    "= true, if actual temperature at port is computed"
    annotation (
      Dialog(tab="Advanced", group="Diagnostics"),
      HideResult=true);

  Modelica.Units.SI.MassFlowRate m_flow[nPorts](each start=_m_flow_start) = port_a[:].m_flow
    "Mass flow rate from port_a to port_b (m_flow > 0 is design flow direction)";

  Modelica.Units.SI.PressureDifference dp[nPorts](
    each start=_dp_start,
    each displayUnit="Pa") = port_a[:].p - port_b[:].p
    "Pressure difference between port_a and port_b";

  Medium.ThermodynamicState sta_a[nPorts]=
    {if allowFlowReversal then
      Medium.setState_phX(port_a_i.p,
                          noEvent(actualStream(port_a_i.h_outflow)),
                          noEvent(actualStream(port_a_i.Xi_outflow)))
    else
      Medium.setState_phX(port_a_i.p,
                          noEvent(inStream(port_a_i.h_outflow)),
                          noEvent(inStream(port_a_i.Xi_outflow))) for port_a_i in port_a}
      if show_T "Medium properties in port_a";

  Medium.ThermodynamicState sta_b[nPorts]=
    {if allowFlowReversal then
      Medium.setState_phX(port_b_i.p,
                          noEvent(actualStream(port_b_i.h_outflow)),
                          noEvent(actualStream(port_b_i.Xi_outflow)))
    else
      Medium.setState_phX(port_b_i.p,
                          noEvent(port_b_i.h_outflow),
                          noEvent(port_b_i.Xi_outflow)) for port_b_i in port_b}
       if show_T "Medium properties in port_b";

protected
  final parameter Modelica.Units.SI.MassFlowRate _m_flow_start=0
    "Start value for m_flow, used to avoid a warning if not set in m_flow, and to avoid m_flow.start in parameter window";
  final parameter Modelica.Units.SI.PressureDifference _dp_start(displayUnit=
        "Pa") = 0
    "Start value for dp, used to avoid a warning if not set in dp, and to avoid dp.start in parameter window";

  annotation (
    preferredView="info",
    Documentation(info="<html>
<p>
This component defines the interface for models with multiple pairs of
inlet and outlet ports, here implemented as two vectors of ports.
It is similar to
<a href=\"Modelica://Modelica.Fluid.Interfaces.PartialTwoPortTransport\">
Modelica.Fluid.Interfaces.PartialTwoPortTransport</a>, but it does not
include the species balance
</p>
<pre>
  port_b[i].Xi_outflow = inStream(port_a[i].Xi_outflow);
</pre>
<p>
Thus, it can be used as a base class for a heat <i>and</i> mass transfer component
</p>
<p>
The partial model extends
<a href=\"modelica://Buildings.Fluid.Geothermal.ZonedThermalStorage.Interfaces.PartialTwoNPorts\">
Buildings.Fluid.Geothermal.ZonedThermalStorage.Interfaces.PartialTwoNPorts</a>
and adds quantities that are used by many models such as
<code>m_flow_nominal</code>, <code>m_flow</code> and <code>dp</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
February, 2024, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));


end PartialTwoNPortsInterface;
