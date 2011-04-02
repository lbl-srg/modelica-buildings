within Buildings.Fluid.Interfaces;
partial model PartialStaticFourPortInterface
  "Partial model transporting fluid between two ports without storing mass or energy"
  import Modelica.Constants;
  extends Buildings.Fluid.Interfaces.PartialFourPort(
    port_a1(
      m_flow(min = if allowFlowReversal1 then -Constants.inf else 0)),
    port_b1(
      m_flow(max = if allowFlowReversal1 then +Constants.inf else 0)),
    port_a2(
      m_flow(min = if allowFlowReversal2 then -Constants.inf else 0)),
    port_b2(
      m_flow(max = if allowFlowReversal2 then +Constants.inf else 0)));

  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal(min=0)
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal(min=0)
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));

  parameter Medium1.MassFlowRate m1_flow_small(min=0) = 1E-4*m1_flow_nominal
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));
  parameter Medium2.MassFlowRate m2_flow_small(min=0) = 1E-4*m2_flow_nominal
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

public
  Modelica.SIunits.VolumeFlowRate V1_flow=m1_flow/Medium.density(sta_a1) 
     if show_V_flow
    "Volume flow rate at inflowing port (positive when flow from port_a1 to port_b1)";
  Modelica.SIunits.VolumeFlowRate V2_flow=m2_flow/Medium.density(sta_a2) 
     if show_V_flow
    "Volume flow rate at inflowing port (positive when flow from port_a2 to port_b2)";

  Medium1.MassFlowRate m1_flow(start=0)
    "Mass flow rate from port_a1 to port_b1 (m1_flow > 0 is design flow direction)";
  Modelica.SIunits.Pressure dp1(start=0, displayUnit="Pa")
    "Pressure difference between port_a1 and port_b1";
  Medium2.MassFlowRate m2_flow(start=0)
    "Mass flow rate from port_a2 to port_b2 (m2_flow > 0 is design flow direction)";
  Modelica.SIunits.Pressure dp2(start=0, displayUnit="Pa")
    "Pressure difference between port_a2 and port_b2";


  Medium1.ThermodynamicState sta_a1=if homotopyInitialization then
      Medium1.setState_phX(port_a1.p, 
         homotopy(actual=actualStream(port_a1.h_outflow),
                  simplified=inStream(port_a1.h_outflow)),
         homotopy(actual=actualStream(port_a1.Xi_outflow),
                  simplified=inStream(port_a1.Xi_outflow)))
    else
      Medium1.setState_phX(port_a1.p, 
                           actualStream(port_a1.h_outflow), 
                           actualStream(port_a1.Xi_outflow)) if
         show_T "Medium properties in port_a1";

  Medium1.ThermodynamicState sta_b1=if homotopyInitialization then
      Medium1.setState_phX(port_b1.p, 
          homotopy(actual=actualStream(port_b1.h_outflow),
                   simplified=port_b1.h_outflow),
          homotopy(actual=actualStream(port_b1.Xi_outflow),
                   simplified=port_b1.Xi_outflow))
    else
      Medium1.setState_phX(port_b1.p, actualStream(port_b1.h_outflow), actualStream(port_b1.Xi_outflow)) if
         show_T "Medium properties in port_b1";

  Medium2.ThermodynamicState sta_a2=if homotopyInitialization then
      Medium2.setState_phX(port_b2.p, 
          homotopy(actual=actualStream(port_b2.h_outflow),
                   simplified=port_b2.h_outflow),
          homotopy(actual=actualStream(port_b2.Xi_outflow),
                   simplified=port_b2.Xi_outflow))
    else
      Medium2.setState_phX(port_a2.p, 
                           actualStream(port_a2.h_outflow), 
                           actualStream(port_a2.Xi_outflow)) if
         show_T "Medium properties in port_a2";

  Medium2.ThermodynamicState sta_b2=if homotopyInitialization then
      Medium2.setState_phX(port_b2.p, 
          homotopy(actual=actualStream(port_b2.h_outflow),
                   simplified=port_b2.h_outflow),
          homotopy(actual=actualStream(port_b2.Xi_outflow),
                   simplified=port_b2.Xi_outflow))
    else
      Medium2.setState_phX(port_b2.p, 
                           actualStream(port_b2.h_outflow), 
                           actualStream(port_b2.Xi_outflow)) if
         show_T "Medium properties in port_b2";

protected
  Medium1.ThermodynamicState state_a1_inflow=
    Medium1.setState_phX(port_a1.p, inStream(port_a1.h_outflow), inStream(port_a1.Xi_outflow))
    "state for medium inflowing through port_a1";
  Medium1.ThermodynamicState state_b1_inflow=
    Medium1.setState_phX(port_b1.p, inStream(port_b1.h_outflow), inStream(port_b1.Xi_outflow))
    "state for medium inflowing through port_b1";
  Medium2.ThermodynamicState state_a2_inflow=
    Medium2.setState_phX(port_a2.p, inStream(port_a2.h_outflow), inStream(port_a2.Xi_outflow))
    "state for medium inflowing through port_a2";
  Medium2.ThermodynamicState state_b2_inflow=
    Medium2.setState_phX(port_b2.p, inStream(port_b2.h_outflow), inStream(port_b2.Xi_outflow))
    "state for medium inflowing through port_b2";

equation
  // Design direction of mass flow rate
  m1_flow = port_a1.m_flow;
  m2_flow = port_a2.m_flow;

  // Pressure difference between ports
  dp1 = port_a1.p - port_b1.p;
  dp2 = port_a2.p - port_b2.p;

  annotation (
  preferedView="info",
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics),
    Documentation(info="<html>
<p>
This component defines the interface for models that 
transport two fluid streams between four ports. 
It is similar to 
<a href=\"modelica://Buildings.Fluid.Interfaces.PartialStaticTwoPortInterface\">
Buildings.Fluid.Interfaces.PartialStaticTwoPortInterface</a>,
but it has four ports instead of two.
<p>
The model is used by other models in this package that add heat transfer,
mass transfer and pressure drop equations.
</p>
</html>", revisions="<html>
<ul>
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
April 28, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end PartialStaticFourPortInterface;
