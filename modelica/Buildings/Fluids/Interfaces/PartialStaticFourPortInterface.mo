within Buildings.Fluids.Interfaces;
partial model PartialStaticFourPortInterface
  "Partial element transporting fluid between two ports without storing mass or energy"
  import Modelica.Constants;
  extends Buildings.Fluids.Interfaces.PartialFourPort(
    port_a1(
      p(start=p_a1_start),
      m_flow(min = if allowFlowReversal_1 then -Constants.inf else 0)),
    port_b1(
      p(start=p_b1_start),
      m_flow(max = if allowFlowReversal_1 then +Constants.inf else 0)),
    port_a2(
      p(start=p_a2_start),
      m_flow(min = if allowFlowReversal_2 then -Constants.inf else 0)),
    port_b2(
      p(start=p_b2_start),
      m_flow(max = if allowFlowReversal_2 then +Constants.inf else 0)));

  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics),
    Documentation(info="<html>
<p>
This component defines the interface for models that 
transport two fluid streams between four ports. 
It is similar to 
<a href=\"Modelica:Buildings.Fluids.Interfaces.PartialTwoPortInterface\">,
but it has four ports instead of two.
<p>
The model is used by other models in this package that add heat transfer,
mass transfer and pressure drop equations.
</p>
</html>", revisions="<html>
<ul>
<li>
September 19, 2008 by Michael Wetter:<br>
Added equations for the mass balance of extra species flow,
i.e., <tt>C</tt> and <tt>mC_flow</tt>.
</li>
<li>
April 28, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

  parameter Medium_1.MassFlowRate m0_flow_1(min=0) "Nominal mass flow rate" 
    annotation(Dialog(group = "Nominal condition"));
  parameter Medium_2.MassFlowRate m0_flow_2(min=0) = m0_flow_1
    "Nominal mass flow rate" 
    annotation(Dialog(group = "Nominal condition"));

  parameter Medium_1.MassFlowRate m_flow_1_small(min=0) = 1E-4*m0_flow_1
    "Small mass flow rate for regularization of zero flow" 
    annotation(Dialog(tab = "Advanced"));
  parameter Medium_2.MassFlowRate m_flow_2_small(min=0) = 1E-4*m0_flow_2
    "Small mass flow rate for regularization of zero flow" 
    annotation(Dialog(tab = "Advanced"));

  // Initialization
  parameter Medium_1.AbsolutePressure p_a1_start=system.p_start
    "Guess value for inlet pressure" 
    annotation(Dialog(tab="Initialization"));
  parameter Medium_1.AbsolutePressure p_b1_start=p_a1_start
    "Guess value for outlet pressure" 
    annotation(Dialog(tab="Initialization"));
  parameter Medium_2.AbsolutePressure p_a2_start=system.p_start
    "Guess value for inlet pressure" 
    annotation(Dialog(tab="Initialization"));
  parameter Medium_2.AbsolutePressure p_b2_start=p_a2_start
    "Guess value for outlet pressure" 
    annotation(Dialog(tab="Initialization"));

  // Diagnostics
//  parameter Boolean show_T = true
//    "= true, if temperatures at port_a and port_b are computed" annotation 7;
  parameter Boolean show_V_flow = true
    "= true, if volume flow rate at inflowing port is computed" 
    annotation(Dialog(tab="Advanced",group="Diagnostics"));

  Modelica.SIunits.VolumeFlowRate V_flow_1=
      m_flow_1/Modelica_Fluid.Utilities.regStep(m_flow_1,
                  Medium_1.density(state_a1_inflow),
                  Medium_1.density(state_b1_inflow),
                  m_flow_1_small) if show_V_flow
    "Volume flow rate at inflowing port (positive when flow from port_a1 to port_b1)";
  Modelica.SIunits.VolumeFlowRate V_flow_2=
      m_flow_2/Modelica_Fluid.Utilities.regStep(m_flow_2,
                  Medium_2.density(state_a2_inflow),
                  Medium_2.density(state_b2_inflow),
                  m_flow_2_small) if show_V_flow
    "Volume flow rate at inflowing port (positive when flow from port_a2 to port_b2)";

/*
  Medium_1.Temperature port_a1_T=
      Modelica_Fluid.Utilities.regStep(port_a1.m_flow,
                  Medium_1.temperature(state_a1),
                  Medium_1.temperature(
                    Medium_1.setState_phX(port_a1.p,
                    port_a1.h_outflow, port_a1.Xi_outflow)),
                    m_flow_1_small) if show_T 
    "Temperature close to port_a1, if show_T = true";
  Medium_1.Temperature port_b1_T=
      Modelica_Fluid.Utilities.regStep(port_b1.m_flow,
                  Medium_1.temperature(state_b1),
                  Medium_1.temperature(
                     Medium_1.setState_phX(port_b1.p,
                     port_b1.h_outflow, port_b1.Xi_outflow)),
                  m_flow_1_small) if show_T 
    "Temperature close to port_b1, if show_T = true";
  Medium_2.Temperature port_a2_T=
      Modelica_Fluid.Utilities.regStep(port_a2.m_flow,
                  Medium_2.temperature(state_a2),
                  Medium_2.temperature(
                    Medium_2.setState_phX(port_a2.p,
                    port_a2.h_outflow, port_a2.Xi_outflow)),
                    m_flow_2_small) if show_T 
    "Temperature close to port_a2, if show_T = true";
  Medium_2.Temperature port_b2_T=
      Modelica_Fluid.Utilities.regStep(port_b2.m_flow,
                  Medium_2.temperature(state_b2),
                  Medium_2.temperature(
                     Medium_2.setState_phX(port_b2.p,
                     port_b2.h_outflow, port_b2.Xi_outflow)),
                  m_flow_2_small) if show_T 
    "Temperature close to port_b2, if show_T = true";
*/
  Medium_1.MassFlowRate m_flow_1(start=0)
    "Mass flow rate from port_a1 to port_b1 (m_flow_1 > 0 is design flow direction)";
  Modelica.SIunits.Pressure dp_1(start=0, displayUnit="Pa")
    "Pressure difference between port_a1 and port_b1";
  Medium_2.MassFlowRate m_flow_2(start=0)
    "Mass flow rate from port_a2 to port_b2 (m_flow_2 > 0 is design flow direction)";
  Modelica.SIunits.Pressure dp_2(start=0, displayUnit="Pa")
    "Pressure difference between port_a2 and port_b2";

  Medium_1.ThermodynamicState sta_a1=
      Medium_1.setState_phX(port_a1.p, actualStream(port_a1.h_outflow), actualStream(port_a1.Xi_outflow))
    "Medium properties in port_a1";
  Medium_1.ThermodynamicState sta_b1=
      Medium_1.setState_phX(port_b1.p, actualStream(port_b1.h_outflow), actualStream(port_b1.Xi_outflow))
    "Medium properties in port_b1";
  Medium_2.ThermodynamicState sta_a2=
      Medium_2.setState_phX(port_a2.p, actualStream(port_a2.h_outflow), actualStream(port_a2.Xi_outflow))
    "Medium properties in port_a2";
  Medium_2.ThermodynamicState sta_b2=
      Medium_2.setState_phX(port_b2.p, actualStream(port_b2.h_outflow), actualStream(port_b2.Xi_outflow))
    "Medium properties in port_b2";

protected
  Medium_1.ThermodynamicState state_a1_inflow=
    Medium_1.setState_phX(port_a1.p, inStream(port_a1.h_outflow), inStream(port_a1.Xi_outflow))
    "state for medium inflowing through port_a1";
  Medium_1.ThermodynamicState state_b1_inflow=
    Medium_1.setState_phX(port_b1.p, inStream(port_b1.h_outflow), inStream(port_b1.Xi_outflow))
    "state for medium inflowing through port_b1";
  Medium_2.ThermodynamicState state_a2_inflow=
    Medium_2.setState_phX(port_a2.p, inStream(port_a2.h_outflow), inStream(port_a2.Xi_outflow))
    "state for medium inflowing through port_a2";
  Medium_2.ThermodynamicState state_b2_inflow=
    Medium_2.setState_phX(port_b2.p, inStream(port_b2.h_outflow), inStream(port_b2.Xi_outflow))
    "state for medium inflowing through port_b2";

equation
  // Design direction of mass flow rate
  m_flow_1 = port_a1.m_flow;
  m_flow_2 = port_a2.m_flow;

  // Pressure difference between ports
  dp_1 = port_a1.p - port_b1.p;
  dp_2 = port_a2.p - port_b2.p;

end PartialStaticFourPortInterface;
