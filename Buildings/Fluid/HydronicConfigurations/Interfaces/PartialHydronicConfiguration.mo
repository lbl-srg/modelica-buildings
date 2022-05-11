within Buildings.Fluid.HydronicConfigurations.Interfaces;
model PartialHydronicConfiguration
  replaceable package Medium =
    Buildings.Media.Water "Medium in the component"
    annotation (choices(
      choice(redeclare package Medium = Buildings.Media.Water "Water"),
      choice(redeclare package Medium =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15,
          X_a=0.40)
        "Propylene glycol water, 40% mass fraction")));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal(final min=0)
    "Mass flow rate at design conditions" annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.PressureDifference dpSec_nominal(final min=0)
    "Secondary pressure differential at design conditions"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(final min=0)
    "Control valve pressure drop at design conditions"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.PressureDifference dpBal1_nominal(final min=0)
    "Primary balancing valve pressure drop at design conditions "
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.PressureDifference dpBal2_nominal(final min=0)
    "Secondary balancing valve pressure drop at design conditions "
    annotation (Dialog(group="Nominal condition"));

  parameter Medium.MassFlowRate m_flow_small(min=0) = 1E-4*abs(m_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));


  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for medium 1"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  // Diagnostics
  parameter Boolean show_T = false
    "= true, if actual temperature at port is computed"
    annotation (
      Dialog(tab="Advanced", group="Diagnostics"),
      HideResult=true);

  Modelica.Fluid.Interfaces.FluidPort_a port_a1(
    redeclare final package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start = Medium.h_default, nominal = Medium.h_default))
    "Primary supply port"
    annotation (Placement(transformation(extent={{-70,-110},{-50,-90}}),
        iconTransformation(extent={{-70,-110},{-50,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(
    redeclare final package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start = Medium.h_default, nominal = Medium.h_default))
    "Primary return port"
    annotation (Placement(transformation(extent={{70,-110},{50,-90}}),
        iconTransformation(extent={{70,-110},{50,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(
    redeclare final package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start = Medium.h_default, nominal = Medium.h_default))
    "Secondary return port"
    annotation (Placement(transformation(extent={{50,90},{70,110}}),
        iconTransformation(extent={{50,88},{70,108}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(
    redeclare final package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start = Medium.h_default, nominal = Medium.h_default))
    "Secondary return port"
    annotation (Placement(transformation(extent={{-50,90},{-70,110}}),
        iconTransformation(extent={{-50,90},{-70,110}})));
  Bus bus
    "Control bus"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-100,0}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-100,0})));


  Medium.MassFlowRate m1_flow = port_a1.m_flow
    "Mass flow rate from port_a1 to port_b1 (m1_flow > 0 is design flow direction)";
  Modelica.Units.SI.PressureDifference dp1(displayUnit="Pa") = port_a1.p - port_b1.p
    "Pressure difference between port_a1 and port_b1";

  Medium.MassFlowRate m2_flow = port_a2.m_flow
    "Mass flow rate from port_a2 to port_b2 (m2_flow > 0 is design flow direction)";
  Modelica.Units.SI.PressureDifference dp2(displayUnit="Pa") = port_a2.p - port_b2.p
    "Pressure difference between port_a2 and port_b2";

  Medium.ThermodynamicState sta_a1=
    if allowFlowReversal1 then
      Medium.setState_phX(port_a1.p,
                          noEvent(actualStream(port_a1.h_outflow)),
                          noEvent(actualStream(port_a1.Xi_outflow)))
    else
      Medium.setState_phX(port_a1.p,
                          inStream(port_a1.h_outflow),
                          inStream(port_a1.Xi_outflow))
      if show_T "Medium properties in port_a1";
  Medium.ThermodynamicState sta_b1=
    if allowFlowReversal1 then
      Medium.setState_phX(port_b1.p,
                          noEvent(actualStream(port_b1.h_outflow)),
                          noEvent(actualStream(port_b1.Xi_outflow)))
    else
      Medium.setState_phX(port_b1.p,
                          port_b1.h_outflow,
                          port_b1.Xi_outflow)
       if show_T "Medium properties in port_b1";

  Medium.ThermodynamicState sta_a2=
    if allowFlowReversal2 then
      Medium.setState_phX(port_a2.p,
                          noEvent(actualStream(port_a2.h_outflow)),
                          noEvent(actualStream(port_a2.Xi_outflow)))
    else
      Medium.setState_phX(port_a2.p,
                          inStream(port_a2.h_outflow),
                          inStream(port_a2.Xi_outflow))
      if show_T "Medium properties in port_a2";
  Medium.ThermodynamicState sta_b2=
    if allowFlowReversal2 then
      Medium.setState_phX(port_b2.p,
                          noEvent(actualStream(port_b2.h_outflow)),
                          noEvent(actualStream(port_b2.Xi_outflow)))
    else
      Medium.setState_phX(port_b2.p,
                          port_b2.h_outflow,
                          port_b2.Xi_outflow)
       if show_T "Medium properties in port_b2";

protected
  Medium.ThermodynamicState state_a1_inflow=
    Medium.setState_phX(port_a1.p, inStream(port_a1.h_outflow), inStream(port_a1.Xi_outflow))
    "state for medium inflowing through port_a1";
  Medium.ThermodynamicState state_b1_inflow=
    Medium.setState_phX(port_b1.p, inStream(port_b1.h_outflow), inStream(port_b1.Xi_outflow))
    "state for medium inflowing through port_b1";
  Medium.ThermodynamicState state_a2_inflow=
    Medium.setState_phX(port_a2.p, inStream(port_a2.h_outflow), inStream(port_a2.Xi_outflow))
    "state for medium inflowing through port_a2";
  Medium.ThermodynamicState state_b2_inflow=
    Medium.setState_phX(port_b2.p, inStream(port_b2.h_outflow), inStream(port_b2.Xi_outflow))
    "state for medium inflowing through port_b2";


end PartialHydronicConfiguration;
