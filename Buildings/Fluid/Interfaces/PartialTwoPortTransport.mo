within Buildings.Fluid.Interfaces;
partial model PartialTwoPortTransport
  "Partial element transporting fluid between two ports without storage of mass or energy"
  extends Buildings.Fluid.Interfaces.PartialTwoPortTransportInterface;

equation
  // Pressure drop in design flow direction
  dp = port_a.p - port_b.p;

  // Design direction of mass flow rate
  m_flow = port_a.m_flow;
  assert(m_flow > -m_flow_small or allowFlowReversal,
      "Reverting flow occurs even though allowFlowReversal is false");

  // Mass balance (no storage)
  port_a.m_flow + port_b.m_flow = 0;

  // Transport of substances
  port_a.Xi_outflow = if allowFlowReversal then inStream(port_b.Xi_outflow) else Medium.X_default[1:Medium.nXi];
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);

  port_a.C_outflow = if allowFlowReversal then inStream(port_b.C_outflow) else zeros(Medium.nC);
  port_b.C_outflow = inStream(port_a.C_outflow);

  annotation (
    Documentation(info="<html>
<p>
This component transports fluid between its two ports, without storing mass or energy.
Energy may be exchanged with the environment though, e.g., in the form of work.
<code>PartialTwoPortTransport</code> is intended as base class for devices like orifices, valves and simple fluid machines.</p>
<p>
Three equations need to be added by an extending class using this component:
</p>
<ul>
<li>The momentum balance specifying the relationship between the pressure drop <code>dp</code> and the mass flow rate <code>m_flow</code>,</li>
<li><code>port_b.h_outflow</code> for flow in design direction, and</li>
<li><code>port_a.h_outflow</code> for flow in reverse direction.</li>
</ul>
<p>
Moreover appropriate values shall be assigned to the following parameters:
</p>
<ul>
<li><code>dp_start</code> for a guess of the pressure drop</li>
<li><code>m_flow_small</code> for regularization of zero flow.</li>
</ul>
<h4>Implementation</h4>
<p>
This is similar to
<a href=\"modelica://Modelica.Fluid.Interfaces.PartialTwoPortTransport\">
Modelica.Fluid.Interfaces.PartialTwoPortTransport</a>
except that it does not use the <code>outer system</code> declaration.
This declaration is omitted as in building energy simulation,
many models use multiple media, an in practice,
users have not used this global definition to assign parameters.
</p>
</html>", revisions="<html>
<ul>
<li>
September 15, 2016, by Michael Wetter:<br/>
Removed wrong annotation, which caused an error in the pedantic model check
of Dymola 2017 FD01.
This is
for <a href=\"https://github.com/ibpsa/modelica/issues/516\">#516</a>.
</li>
<li>
January 22, 2016, by Henning Francke:<br/>
Corrected type declaration of pressure.
This is
for <a href=\"https://github.com/ibpsa/modelica/issues/404\">#404</a>.
</li>
<li>
November 19, 2015, by Michael Wetter:<br/>
Removed assignments of parameters
<code>port_a_exposesState</code> and
<code>port_b_exposesState</code> in base class.
This is
for <a href=\"https://github.com/ibpsa/modelica/issues/351\">#351</a>.
</li>
<li>
August 15, 2015, by Filip Jorissen:<br/>
Implemented more efficient computation of <code>port_a.Xi_outflow</code>
and <code>port_a.C_outflow</code> when <code>allowFlowReversal=false</code>.
This is for
<a href=\"https://github.com/ibpsa/modelica/issues/305\">#305</a>.
</li>
<li>
June 6, 2015, by Michael Wetter:<br/>
Removed protected conditional variables <code>state_a</code> and <code>state_b</code>,
as they were used outside of a connect statement, which causes an
error during pedantic model check in Dymola 2016.
This fixes
<a href=\"https://github.com/ibpsa/modelica/issues/128\">#128</a>.
</li>
<li>
April 1, 2015, by Michael Wetter:<br/>
Made computation of <code>state_a</code> and <code>state_p</code>
conditional on <code>show_T</code> or <code>show_V_flow</code>.
This avoids computing temperature from enthalpy if temperature is
a state of the medium, and the result is not used.
</li>
<li>
October 21, 2014, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
October 20, 2014, by Filip Jorisson:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialTwoPortTransport;
