within Buildings.Fluid.Interfaces;
partial model PartialTwoPortTransport
  "Partial element transporting fluid between two ports without storage of mass or energy"
  extends Buildings.Fluid.Interfaces.PartialTwoPort;

  // Advanced
  // Note: value of dp_start shall be refined by derived model,
  // based on local dp_nominal
  parameter Modelica.SIunits.PressureDifference dp_start(displayUnit="Pa") = 0
    "Guess value of dp = port_a.p - port_b.p"
    annotation(Dialog(tab = "Advanced"));
  parameter Medium.MassFlowRate m_flow_start = 0
    "Guess value of m_flow = port_a.m_flow"
    annotation(Dialog(tab = "Advanced"));
  // Note: value of m_flow_small shall be refined by derived model,
  // based on local m_flow_nominal
  parameter Medium.MassFlowRate m_flow_small
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));

  // Diagnostics
  parameter Boolean show_T = true
    "= true, if temperatures at port_a and port_b are computed"
    annotation(
      Dialog(tab="Advanced", group="Diagnostics"),
      HideResult=true);
  parameter Boolean show_V_flow = true
    "= true, if volume flow rate at inflowing port is computed"
    annotation(
      Dialog(tab="Advanced", group="Diagnostics"),
      HideResult=true);

  // Variables
  Medium.MassFlowRate m_flow(
     min=if allowFlowReversal then -Modelica.Constants.inf else 0,
     start = m_flow_start) "Mass flow rate in design flow direction";
  Modelica.SIunits.PressureDifference dp(start=dp_start,
                                         displayUnit="Pa")
    "Pressure difference between port_a and port_b (= port_a.p - port_b.p)";

  Modelica.SIunits.VolumeFlowRate V_flow=
      m_flow/Modelica.Fluid.Utilities.regStep(m_flow,
                  Medium.density(
                    Medium.setState_phX(
                      p = port_a.p,
                      h = inStream(port_a.h_outflow),
                      X = inStream(port_a.Xi_outflow))),
                  Medium.density(
                       Medium.setState_phX(
                         p = port_b.p,
                         h = inStream(port_b.h_outflow),
                         X = inStream(port_b.Xi_outflow))),
                  m_flow_small) if show_V_flow
    "Volume flow rate at inflowing port (positive when flow from port_a to port_b)";

  Medium.Temperature port_a_T=
      Modelica.Fluid.Utilities.regStep(port_a.m_flow,
                  Medium.temperature(
                    Medium.setState_phX(
                      p = port_a.p,
                      h = inStream(port_a.h_outflow),
                      X = inStream(port_a.Xi_outflow))),
                  Medium.temperature(Medium.setState_phX(port_a.p, port_a.h_outflow, port_a.Xi_outflow)),
                  m_flow_small) if show_T
    "Temperature close to port_a, if show_T = true";
  Medium.Temperature port_b_T=
      Modelica.Fluid.Utilities.regStep(port_b.m_flow,
                  Medium.temperature(
                    Medium.setState_phX(
                      p = port_b.p,
                      h = inStream(port_b.h_outflow),
                      X = inStream(port_b.Xi_outflow))),
                  Medium.temperature(Medium.setState_phX(port_b.p, port_b.h_outflow, port_b.Xi_outflow)),
                  m_flow_small) if show_T
    "Temperature close to port_b, if show_T = true";
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
March 30, 2021, by Michael Wetter:<br/>
Added annotation <code>HideResult=true</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1459\">IBPSA, #1459</a>.
</li>
<li>
September 15, 2016, by Michael Wetter:<br/>
Removed wrong annotation, which caused an error in the pedantic model check
of Dymola 2017 FD01.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/516\">#516</a>.
</li>
<li>
January 22, 2016, by Henning Francke:<br/>
Corrected type declaration of pressure.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
November 19, 2015, by Michael Wetter:<br/>
Removed assignments of parameters
<code>port_a_exposesState</code> and
<code>port_b_exposesState</code> in base class.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/351\">#351</a>.
</li>
<li>
August 15, 2015, by Filip Jorissen:<br/>
Implemented more efficient computation of <code>port_a.Xi_outflow</code>
and <code>port_a.C_outflow</code> when <code>allowFlowReversal=false</code>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/305\">#305</a>.
</li>
<li>
June 6, 2015, by Michael Wetter:<br/>
Removed protected conditional variables <code>state_a</code> and <code>state_b</code>,
as they were used outside of a connect statement, which causes an
error during pedantic model check in Dymola 2016.
This fixes
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/128\">#128</a>.
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
