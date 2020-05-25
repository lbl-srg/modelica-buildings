within Buildings.Fluid.Interfaces;
partial model PartialFourPortFourMediumParallel
  "Partial model with four ports,  four separate medium models, and parallel flow without storing mass or energy"

  replaceable package Medium_a1 =
      Modelica.Media.Interfaces.PartialMedium
    "Medium model for port_a1 (inlet)";
  replaceable package Medium_b1 =
      Modelica.Media.Interfaces.PartialMedium
    "Medium model for port_b1 (outlet)";
  replaceable package Medium_a2 =
      Modelica.Media.Interfaces.PartialMedium
    "Medium model for port_a2 (inlet)";
  replaceable package Medium_b2 =
      Modelica.Media.Interfaces.PartialMedium
    "Medium model for port_b2 (outlet)";

  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal
    "Nominal mass flow rate (flow 1)"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal
    "Nominal mass flow rate (flow 2)"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m1_flow_small(min=0) = 1E-4*abs(m1_flow_nominal)
    "Small mass flow rate for regularization of zero flow (flow 1)";
  parameter Modelica.SIunits.MassFlowRate m2_flow_small(min=0) = 1E-4*abs(m2_flow_nominal)
    "Small mass flow rate for regularization of zero flow (flow 2)";

  // Diagnostics
   parameter Boolean show_T = false
    "= true, if actual temperature at port is computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));

  Modelica.SIunits.MassFlowRate m1_flow(start=_m1_flow_start) = port_a1.m_flow
    "Mass flow rate from port_a1 to port_b1 (m_flow > 0 is design flow direction)";
  Modelica.SIunits.MassFlowRate m2_flow(start=_m2_flow_start) = port_a2.m_flow
    "Mass flow rate from port_a2 to port_b2 (m_flow > 0 is design flow direction)";

  Modelica.SIunits.PressureDifference dp1(
    start=_dp1_start,
    displayUnit="Pa") = port_a1.p - port_b1.p
    "Pressure difference between port_a1 and port_b1";
  Modelica.SIunits.PressureDifference dp2(
    start=_dp2_start,
    displayUnit="Pa") = port_a2.p - port_b2.p
    "Pressure difference between port_a2 and port_b2";

//  parameter Boolean allowFlowReversal = false
//    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
//    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  Medium_a1.ThermodynamicState sta_a1=Medium_a1.setState_phX(
      port_a1.p,
      noEvent(actualStream(port_a1.h_outflow)),
      noEvent(actualStream(port_a1.Xi_outflow))) if show_T
    "Medium properties in port_a1";
  Medium_b1.ThermodynamicState sta_b1=Medium_b1.setState_phX(
      port_b1.p,
      noEvent(actualStream(port_b1.h_outflow)),
      noEvent(actualStream(port_b1.Xi_outflow))) if show_T
    "Medium properties in port_b1";
  Medium_a2.ThermodynamicState sta_a2=Medium_a2.setState_phX(
      port_a2.p,
      noEvent(actualStream(port_a2.h_outflow)),
      noEvent(actualStream(port_a2.Xi_outflow))) if show_T
    "Medium properties in port_a2";
  Medium_b2.ThermodynamicState sta_b2=Medium_b2.setState_phX(
      port_b2.p,
      noEvent(actualStream(port_b2.h_outflow)),
      noEvent(actualStream(port_b2.Xi_outflow))) if show_T
    "Medium properties in port_b2";

  Modelica.Fluid.Interfaces.FluidPort_a port_a1(
    redeclare final package Medium = Medium_a1,
    m_flow(min=0),
    h_outflow(start=Medium_a1.h_default, nominal=Medium_a1.h_default))
    "Fluid connector a1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(
    redeclare final package Medium = Medium_b1,
    m_flow(max=0),
    h_outflow(start=Medium_b1.h_default, nominal=Medium_b1.h_default))
    "Fluid connector b1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{110,-10},{90,10}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a2(
    redeclare final package Medium = Medium_a2,
    m_flow(min=0),
    h_outflow(start=Medium_a2.h_default, nominal=Medium_a2.h_default))
    "Fluid connector a2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(
    redeclare final package Medium = Medium_b2,
    m_flow(max=0),
    h_outflow(start=Medium_b2.h_default, nominal=Medium_b2.h_default))
    "Fluid connector b2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{110,-90},{90,-70}})));
protected
  final parameter Modelica.SIunits.MassFlowRate _m1_flow_start = 0
  "Start value for m1_flow, used to avoid a warning if not set in m_flow, and to avoid m_flow.start in parameter window";
  final parameter Modelica.SIunits.PressureDifference _dp1_start(displayUnit="Pa") = 0
  "Start value for dp1, used to avoid a warning if not set in dp, and to avoid dp.start in parameter window";
  final parameter Modelica.SIunits.MassFlowRate _m2_flow_start = 0
  "Start value for m2_flow, used to avoid a warning if not set in m_flow, and to avoid m_flow.start in parameter window";
  final parameter Modelica.SIunits.PressureDifference _dp2_start(displayUnit="Pa") = 0
  "Start value for dp2, used to avoid a warning if not set in dp, and to avoid dp.start in parameter window";

end PartialFourPortFourMediumParallel;
