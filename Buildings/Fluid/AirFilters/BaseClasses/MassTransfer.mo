within Buildings.Fluid.AirFilters.BaseClasses;
model MassTransfer
  "Component that sets the trace substance at port_b based on an input trace substance mass flow rate and an input mass transfer efficiency"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;
  Buildings.Controls.OBC.CDL.Interfaces.RealInput C_inflow[Medium.nC]
    "Input trace substance rate"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
      rotation=-90, origin={0,120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput eps(
    final unit = "1",
    final min = 0,
    final max= 1)
    "Mass transfer coefficient"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));

equation
  if allowFlowReversal then
    port_b.C_outflow =inStream(port_a.C_outflow) - eps*C_inflow;
    port_a.C_outflow = inStream(port_a.C_outflow);
  else
    port_b.C_outflow = inStream(port_a.C_outflow);
    port_a.C_outflow = inStream(port_b.C_outflow);
  end if;
  // Mass balance (no storage).
  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);
  port_a.m_flow = -port_b.m_flow;
  // Pressure balance (no pressure drop).
  port_a.p = port_b.p;
  // Energy balance (no heat exchange).
  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);

  if not allowFlowReversal then
    assert(m_flow > -m_flow_small,
      "In " + getInstanceName() + ": Reverting flow occurs even though allowFlowReversal is false.",
      level=AssertionLevel.error);
  end if;

annotation (defaultComponentName="masTra",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
    Rectangle(extent={{-100,100},{100,-100}}, fillColor={255,255,255},
              fillPattern=FillPattern.Solid, pattern=LinePattern.None)}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
Documentation(info="<html>
<p>
This model sets the trace substance
of the medium that leaves <code>port_b</code> by
</p>
<pre>
port_b.C_outflow = inStream(port_a.C_outflow) - eps * C_inflow;
</pre>
<p>
where <code>eps</code> is an input mass transfer efficiency and
<code>C_inflow</code> is an input trace substance rate.
</p>
<p>
This model has no pressure drop. In the case of reverse flow,
the fluid that leaves <code>port_a</code> has the same
properties as the fluid that enters <code>port_b</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
December 22, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end MassTransfer;
