within Buildings.Fluid.Storage.BaseClasses;
partial model PartialTwoPortInterface
  "Partial model transporting fluid between two ports without storing mass or energy"

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Air "Moist air"),
        choice(redeclare package Medium = Buildings.Media.Water "Water"),
        choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
              property_T=293.15,
              X_a=0.40)
              "Propylene glycol water, 40% mass fraction")));

  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    p(start=Medium.p_default),
    h_outflow(start = Medium.h_default, nominal = Medium.h_default))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    p(start=Medium.p_default),
    h_outflow(start = Medium.h_default, nominal = Medium.h_default))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{10,-110},{-10,-90}})));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_small(min=0) = 1E-4*abs(
    m_flow_nominal) "Small mass flow rate for regularization of zero flow"
    annotation (Dialog(tab="Advanced"));
  // Diagnostics
   parameter Boolean show_T = false
    "= true, if actual temperature at port is computed"
    annotation (
      Dialog(tab="Advanced", group="Diagnostics"),
      HideResult=true);

  Modelica.Units.SI.MassFlowRate m_flow(start=_m_flow_start) = port_a.m_flow
    "Mass flow rate from port_a to port_b (m_flow > 0 is design flow direction)";

  Modelica.Units.SI.PressureDifference dp(
    start=_dp_start,
    displayUnit="Pa") = port_a.p - port_b.p
    "Pressure difference between port_a and port_b";

  Medium.ThermodynamicState sta_a=
    if allowFlowReversal then
      Medium.setState_phX(port_a.p,
                          noEvent(actualStream(port_a.h_outflow)),
                          noEvent(actualStream(port_a.Xi_outflow)))
    else
      Medium.setState_phX(port_a.p,
                          noEvent(inStream(port_a.h_outflow)),
                          noEvent(inStream(port_a.Xi_outflow)))
      if show_T "Medium properties in port_a";

  Medium.ThermodynamicState sta_b=
    if allowFlowReversal then
      Medium.setState_phX(port_b.p,
                          noEvent(actualStream(port_b.h_outflow)),
                          noEvent(actualStream(port_b.Xi_outflow)))
    else
      Medium.setState_phX(port_b.p,
                          noEvent(port_b.h_outflow),
                          noEvent(port_b.Xi_outflow))
       if show_T "Medium properties in port_b";

protected
  final parameter Modelica.Units.SI.MassFlowRate _m_flow_start=0
    "Start value for m_flow, used to avoid a warning if not set in m_flow, and to avoid m_flow.start in parameter window";
  final parameter Modelica.Units.SI.PressureDifference _dp_start(displayUnit=
        "Pa") = 0
    "Start value for dp, used to avoid a warning if not set in dp, and to avoid dp.start in parameter window";

  annotation (
    preferredView="info",
    Documentation(info="<html>
<p>
This partial class implements the same functionality as 
<a href=\"modelica://Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger\">
Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger</a>,
except that <code>port_a</code> and <code>port_b</code> are placed at the top and bottom
of the component.
</p>
<h4>Implementation</h4>
<p>
The implementation is done in this package as opposed to
<a href=\"modelica://Buildings.Fluid.Interfaces\">
Buildings.Fluid.Interfaces</a>
as it is only used by the storage model, and may be removed when the tool limitations
that are discussed in
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1794\">IBPSA, #1794</a>.
are removed.
</p>
</html>", revisions="<html>
<ul>
<li>
September 20, 2023, by Michael Wetter:<br/>
First implementation to address
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1794\">IBPSA, #1794</a>.
</li>
</ul>
</html>"));
end PartialTwoPortInterface;
