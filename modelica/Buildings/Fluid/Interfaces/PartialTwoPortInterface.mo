within Buildings.Fluid.Interfaces;
partial model PartialTwoPortInterface
  "Partial model transporting fluid between two ports without storing mass or energy"
  import Modelica.Constants;
  extends Modelica.Fluid.Interfaces.PartialTwoPort(
    port_a(p(start=Medium.p_default,
             nominal=Medium.p_default)),
    port_b(p(start=Medium.p_default,
           nominal=Medium.p_default)));

  parameter Medium.MassFlowRate m_flow_nominal "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Medium.MassFlowRate m_flow_small(min=0) = 1E-4*abs(m_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));
  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  // Diagnostics
   parameter Boolean show_V_flow = false
    "= true, if volume flow rate at inflowing port is computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));
   parameter Boolean show_T = false
    "= true, if actual temperature at port is computed (may lead to events)"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));

  Modelica.SIunits.VolumeFlowRate V_flow=
      m_flow/Medium.density(sta_a) if show_V_flow
    "Volume flow rate at inflowing port (positive when flow from port_a to port_b)";

  Medium.MassFlowRate m_flow(start=0) = port_a.m_flow
    "Mass flow rate from port_a to port_b (m_flow > 0 is design flow direction)";
  Modelica.SIunits.Pressure dp(start=0, displayUnit="Pa") = port_a.p - port_b.p
    "Pressure difference between port_a and port_b";

  Medium.ThermodynamicState sta_a=if homotopyInitialization then
      Medium.setState_phX(port_a.p,
                          homotopy(actual=actualStream(port_a.h_outflow),
                                   simplified=inStream(port_a.h_outflow)),
                          homotopy(actual=actualStream(port_a.Xi_outflow),
                                   simplified=inStream(port_a.Xi_outflow)))
    else
      Medium.setState_phX(port_a.p,
                          actualStream(port_a.h_outflow),
                          actualStream(port_a.Xi_outflow)) if
         show_T or show_V_flow "Medium properties in port_a";

  Medium.ThermodynamicState sta_b=if homotopyInitialization then
      Medium.setState_phX(port_b.p,
                          homotopy(actual=actualStream(port_b.h_outflow),
                                   simplified=port_b.h_outflow),
                          homotopy(actual=actualStream(port_b.Xi_outflow),
                            simplified=port_b.Xi_outflow))
    else
      Medium.setState_phX(port_b.p,
                          actualStream(port_b.h_outflow),
                          actualStream(port_b.Xi_outflow)) if
          show_T "Medium properties in port_b";

  annotation (
    preferredView="info",
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics),
    Documentation(info="<html>
<p>
This component defines the interface for models that 
transports a fluid between two ports. It is similar to 
<a href=\"Modelica://Modelica.Fluid.Interfaces.PartialTwoPortTransport\">
Modelica.Fluid.Interfaces.PartialTwoPortTransport</a>, but it does not 
include the species balance 
<pre>
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);
</pre>
Thus, it can be used as a base class for a heat <i>and</i> mass transfer component
</p>
<p>
The model is used by other models in this package that add heat transfer,
mass transfer and pressure drop equations. See for example
<a href=\"modelica://Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger\">
Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 27, 2012 by Michael Wetter:<br>
Changed condition to remove <code>sta_a</code> to also
compute the state at the inlet port if <code>show_V_flow=true</code>. 
The previous implementation resulted in a translation error
if <code>show_V_flow=true</code>, but worked correctly otherwise
because the erroneous function call is removed if  <code>show_V_flow=false</code>.
</li>
<li>
March 27, 2011 by Michael Wetter:<br>
Added <code>homotopy</code> operator.
</li>
<li>
March 21, 2010 by Michael Wetter:<br>
Changed pressure start value from <code>system.p_start</code>
to <code>Medium.p_default</code> since HVAC models may have water and 
air, which are typically at different pressures.
</li>
<li>
September 19, 2008 by Michael Wetter:<br>
Added equations for the mass balance of extra species flow,
i.e., <code>C</code> and <code>mC_flow</code>.
</li>
<li>
March 11, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end PartialTwoPortInterface;
