within Buildings.Fluids.Interfaces;
partial model PartialStaticTwoPortInterface
  "Partial model transporting fluid between two ports without storing mass or energy"
  import Modelica.Constants;
  extends Modelica_Fluid.Interfaces.PartialTwoPort(
    port_a(
      p(start=p_a_start),
      m_flow(min = if allowFlowReversal then -Constants.inf else 0)),
    port_b(
      p(start=p_b_start),
      m_flow(max = if allowFlowReversal then +Constants.inf else 0)));

  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics),
    Documentation(info="<html>
<p>
This component defines the interface for models that 
transports a fluid between two ports. It is similar to 
<a href=\"Modelica:Modelica_Fluid.Interfaces.PartialTwoPortTransport\">
Modelica_Fluid.Interfaces.PartialTwoPortTransport</a>, but it does not 
include the species balance 
<pre>
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);
</pre>.
Thus, it can be used as a base class for a heat <i>and</i> mass transfer component
</p>
<p>
The model is used by other models in this package that add heat transfer,
mass transfer and pressure drop equations. See for example
<a href=\"Modelica:Buildings.Fluids.Interfaces.PartialStaticTwoPortHeatMassTransfer\">
Buildings.Fluids.Interfaces.PartialStaticTwoPortHeatMassTransfer</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 19, 2008 by Michael Wetter:<br>
Added equations for the mass balance of extra species flow,
i.e., <tt>C</tt> and <tt>mC_flow</tt>.
</li>
<li>
March 11, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

  parameter Medium.MassFlowRate m_flow_nominal(min=0) "Nominal mass flow rate" 
    annotation(Dialog(group = "Nominal condition"));
  parameter Medium.MassFlowRate m_flow_small(min=0) = 1E-4*m_flow_nominal
    "Small mass flow rate for regularization of zero flow" 
    annotation(Dialog(tab = "Advanced"));

  // Initialization
  parameter Medium.AbsolutePressure p_a_start=system.p_start
    "Guess value for inlet pressure" 
    annotation(Dialog(tab="Initialization"));
  parameter Medium.AbsolutePressure p_b_start=p_a_start
    "Guess value for outlet pressure" 
    annotation(Dialog(tab="Initialization"));

  // Diagnostics
//  parameter Boolean show_T = true
//    "= true, if temperatures at port_a and port_b are computed" annotation 4;
   parameter Boolean show_V_flow = true
    "= true, if volume flow rate at inflowing port is computed" 
    annotation(Dialog(tab="Advanced",group="Diagnostics"));

  Modelica.SIunits.VolumeFlowRate V_flow=
      m_flow/Modelica_Fluid.Utilities.regStep(m_flow,
                  Medium.density(state_a_inflow),
                  Medium.density(state_b_inflow),
                  m_flow_small) if show_V_flow
    "Volume flow rate at inflowing port (positive when flow from port_a to port_b)";

/*
  Medium.Temperature port_a_T=
      Modelica_Fluid.Utilities.regStep(port_a.m_flow,
                  Medium.temperature(state_a),
                  Medium.temperature(Medium.setState_phX(port_a.p, port_a.h_outflow, port_a.Xi_outflow)),
                  m_flow_small) if show_T 
    "Temperature close to port_a, if show_T = true";
  Medium.Temperature port_b_T=
      Modelica_Fluid.Utilities.regStep(port_b.m_flow,
                  Medium.temperature(state_b),
                  Medium.temperature(Medium.setState_phX(port_b.p, port_b.h_outflow, port_b.Xi_outflow)),
                  m_flow_small) if show_T 
    "Temperature close to port_b, if show_T = true";
*/
  Medium.MassFlowRate m_flow(start=0)
    "Mass flow rate from port_a to port_b (m_flow > 0 is design flow direction)";
  Modelica.SIunits.Pressure dp(start=0, displayUnit="Pa")
    "Pressure difference between port_a and port_b";

  Medium.ThermodynamicState sta_a=
      Medium.setState_phX(port_a.p, actualStream(port_a.h_outflow), actualStream(port_a.Xi_outflow))
    "Medium properties in port_a";
  Medium.ThermodynamicState sta_b=
      Medium.setState_phX(port_b.p, actualStream(port_b.h_outflow), actualStream(port_b.Xi_outflow))
    "Medium properties in port_b";

protected
  Medium.ThermodynamicState state_a_inflow=
    Medium.setState_phX(port_a.p, inStream(port_a.h_outflow), inStream(port_a.Xi_outflow))
    "state for medium inflowing through port_a";
  Medium.ThermodynamicState state_b_inflow=
    Medium.setState_phX(port_b.p, inStream(port_b.h_outflow), inStream(port_b.Xi_outflow))
    "state for medium inflowing through port_b";

equation
//   medium_a.state=sta_a;
 //  medium_a.Xi = actualStream(port_a.Xi_outflow);
  // Design direction of mass flow rate
  m_flow = port_a.m_flow;

  // Pressure difference between ports
  dp = port_a.p - port_b.p;

end PartialStaticTwoPortInterface;
