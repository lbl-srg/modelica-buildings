within Buildings.Examples.VAVReheat.Utilities;
model PressureDecoupler
  "Fictitious model that decouples the pressure at its ports through a differential equationPartial model transporting fluid between two ports without storing mass or energy"
  import Modelica.Constants;
  extends Modelica.Fluid.Interfaces.PartialTwoPort(
    port_a(
      p(start=p_a_start),
      m_flow(min = if allowFlowReversal then -Constants.inf else 0)),
    port_b(
      p(start=p_b_start),
      m_flow(max = if allowFlowReversal then +Constants.inf else 0)));

  // Initialization
  parameter Medium.AbsolutePressure p_a_start=Medium.p_default
    "Guess value for inlet pressure";
  parameter Medium.AbsolutePressure p_b_start=p_a_start
    "Guess value for outlet pressure";

  Medium.MassFlowRate m_flow(start=0)
    "Mass flow rate from port_a to port_b (m_flow > 0 is design flow direction)";
  Modelica.SIunits.Pressure dp(start=0, displayUnit="Pa")
    "Pressure difference between port_a and port_b";
  parameter Modelica.SIunits.Pressure dp_nominal
    "Order of magnitude of pressure drop in flow path (used for scaling)";
  parameter Modelica.SIunits.Time tau = 10
    "Time constant for dp^2/dp_nominal to decay to zero";
equation
//   medium_a.state=sta_a;
 //  medium_a.Xi = actualStream(port_a.Xi_outflow);
  // Design direction of mass flow rate
  m_flow = port_a.m_flow;
  port_b.m_flow = - port_a.m_flow;

  // Pressure difference between ports
  dp = port_a.p - port_b.p;
  tau*der(dp) = - dp^2/dp_nominal;

  // Transport of enthalpy
  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);

  // Transport of species
  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);
  // Transport of trace substances
  port_a.C_outflow = inStream(port_b.C_outflow);
  port_b.C_outflow = inStream(port_a.C_outflow);
  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,56},{100,-64}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,46},{100,-52}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Text(
          extent={{-80,52},{68,-46}},
          lineColor={255,255,255},
          textString="d dp2/ dt")}));
end PressureDecoupler;
