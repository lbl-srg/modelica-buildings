within Buildings.Fluid.Movers.BaseClasses;
model IdealSource
  "Base class for pressure and mass flow source with optional power input"
  extends Buildings.Fluid.Interfaces.PartialTwoPortTransport(show_T=false);

  // Quantity to control
  parameter Boolean control_m_flow
    "if true, then the mass flow rate is equal to the value of m_flow_in"
    annotation(Evaluate = true);
  parameter Boolean control_dp = not control_m_flow
    "if true, then the head is equal to the value of dp_in"
    annotation(Evaluate = true);

  Modelica.Blocks.Interfaces.RealInput m_flow_in(unit="kg/s") if control_m_flow
    "Prescribed mass flow rate"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-50,82}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-60,80})));
  Modelica.Blocks.Interfaces.RealInput dp_in(unit="Pa") if control_dp
    "Prescribed pressure difference port_a.p-port_b.p"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={50,82}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={60,80})));

protected
  Modelica.Blocks.Interfaces.RealInput m_flow_internal(unit="kg/s")
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput dp_internal(unit="Pa")
    "Needed to connect to conditional connector";

equation
  // Ideal control
  if control_m_flow then
    m_flow = m_flow_internal;
  else
    m_flow_internal = 0;
  end if;
  if control_dp then
    dp = dp_internal;
  else
    dp_internal = 0;
  end if;

  connect(dp_internal, dp_in);
  connect(m_flow_internal, m_flow_in);

  // Energy balance (no storage)
  port_a.h_outflow = if allowFlowReversal then inStream(port_b.h_outflow) else Medium.h_default;
  port_b.h_outflow = inStream(port_a.h_outflow);

  annotation (Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,60},{100,-60}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,50},{100,-48}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Text(
          visible=not control_m_flow,
          extent={{24,44},{80,24}},
          textColor={255,255,255},
          textString="dp"),
        Text(
          visible=control_m_flow,
          extent={{-80,44},{-24,24}},
          textColor={255,255,255},
          textString="m")}),
    Documentation(info="<html>
<p>
Model of a fictitious pipe that is used as a base class
for a pressure source or to prescribe a mass flow rate.
</p>
<p>
Note that for fans and pumps with dynamic balance,
both the heat and the flow work are added to the volume of
air or water. This simplifies the equations compared to
adding heat to the volume, and flow work to this model.
</p>
<p>
Typically either <code>control_m_flow</code> or
<code>control_dp</code> should be <code>true</code> to avoid a
singular system.
If <code>control_m_flow = true</code>, then the mass flow rate
is set to the value of the input connector <code>m_flow_in</code>.
Otherwise, this model does not specify the mass flow rate.
Similarly, if <code>control_dp = true</code>, the head is equal to the
value of the input connector <code>dp_in</code>.
Otherwise, this model does not specify the head.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 4, 2017, by Filip Jorissen:<br/>
Implemented option to set <code>control_dp</code>
independently from <code>control_m_flow</code>.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/770\">#770</a>.
</li>
<li>
March 2, 2017, by Filip Jorissen:<br/>
Implemented simplification when <code>allowFlowReversal=false</code>.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/673\">#673</a>.
</li>
<li>
March 20, 2016, by Michael Wetter:<br/>
Corrected documentation for <code>dp_in</code>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Added units to the signal connectors.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
October 8, 2013, by Michael Wetter:<br/>
Removed parameter <code>show_V_flow</code>.
</li>
<li>
May 25, 2011 by Michael Wetter:<br/>
Removed the option to add power to the medium, as this is dealt with in the volume
that is used in the mover model.
</li>
<li>
July 27, 2010 by Michael Wetter:<br/>
Redesigned model to fix bug in medium balance.
</li>
<li>
April 13, 2010 by Michael Wetter:<br/>
Made heat connector optional.
</li>
<li>
March 23, 2010 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end IdealSource;
