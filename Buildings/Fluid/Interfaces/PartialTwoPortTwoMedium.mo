within Buildings.Fluid.Interfaces;
partial model PartialTwoPortTwoMedium
  "Partial model with two ports with two separate medium models without storing mass or energy"

  replaceable package Medium_a =
      Modelica.Media.Interfaces.PartialMedium
    "Medium model for port_a (inlet)";
  replaceable package Medium_b =
      Modelica.Media.Interfaces.PartialMedium
    "Medium model for port_b (outlet)";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(m_flow_nominal)
    "Small mass flow rate for regularization of zero flow";

  // Diagnostics
   parameter Boolean show_T = false
    "= true, if actual temperature at port is computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));

  Modelica.SIunits.MassFlowRate m_flow(start=_m_flow_start) = port_a.m_flow
    "Mass flow rate from port_a to port_b (m_flow > 0 is design flow direction)";

  Modelica.SIunits.PressureDifference dp(start=_dp_start, displayUnit="Pa") = port_a.p - port_b.p
    "Pressure difference between port_a and port_b";

  Medium_a.ThermodynamicState sta_a=
      Medium_a.setState_phX(port_a.p,
                          noEvent(actualStream(port_a.h_outflow)),
                          noEvent(actualStream(port_a.Xi_outflow))) if show_T
    "Medium properties in port_a";

  Medium_b.ThermodynamicState sta_b=
      Medium_b.setState_phX(port_b.p,
                          noEvent(actualStream(port_b.h_outflow)),
                          noEvent(actualStream(port_b.Xi_outflow))) if show_T
    "Medium properties in port_b";

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium = Medium_a,
     m_flow(min=0),
     h_outflow(start = Medium_a.h_default, nominal = Medium_a.h_default))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium = Medium_b,
     m_flow(max=0),
     h_outflow(start = Medium_b.h_default, nominal = Medium_b.h_default))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,-10},{90,10}})));

protected
  final parameter Modelica.SIunits.MassFlowRate _m_flow_start = 0
  "Start value for m_flow, used to avoid a warning if not set in m_flow, and to avoid m_flow.start in parameter window";
  final parameter Modelica.SIunits.PressureDifference _dp_start(displayUnit="Pa") = 0
  "Start value for dp, used to avoid a warning if not set in dp, and to avoid dp.start in parameter window";
end PartialTwoPortTwoMedium;
