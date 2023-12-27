within Buildings.Fluid.AirFilters.BaseClasses;
model MassTransfer
  "Component that sets the trace substance at port_b based on an input trace substance mass flow rate and an input mass transfer efficiency"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;
  Modelica.Blocks.Interfaces.RealInput m_flow_in[Medium.nC]
    "Input trace substance rate" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120})));
  Modelica.Blocks.Interfaces.RealInput eps(
   final min = 0,
   final max= 1)
   "mass tranfer coefficient"
    annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-120,60}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,60})));
equation
  if allowFlowReversal then
    port_b.C_outflow = inStream(port_a.C_outflow) - eps * m_flow_in;
    port_a.C_outflow = inStream(port_b.C_outflow) + eps * m_flow_in;
  else
    port_b.C_outflow = inStream(port_a.C_outflow);
    port_a.C_outflow = inStream(port_b.C_outflow);
  end if;
  // Mass balance (no storage).
  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);
  port_a.m_flow = -port_b.m_flow;
  // Pressure balance (no pressure drop).
  port_a. p = port_b.p;
  // Energy balance (no heat exchange).
  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);

  if not allowFlowReversal then
    assert(m_flow > -m_flow_small,
      "*** Error in " + getInstanceName() + ":Reverting flow occurs even though allowFlowReversal is false",
      level=AssertionLevel.error);
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    defaultComponentName="masTra",
    Documentation(info="<html>
<p>
This model sets the trace substance
of the medium that leaves <code>port_a</code> by
</p>
<pre>
  port_b.C_outflow = inStream(port_a.C_outflow) - eps * m_flow_in;
</pre>
<p>
where <code>eps</code> is an input mass transfer efficiency and 
<code>m_flow_in</code> is an input trace substance mass flow rate.
</p>
<p>
This model has no pressure drop.
In case of reverse flow,
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
