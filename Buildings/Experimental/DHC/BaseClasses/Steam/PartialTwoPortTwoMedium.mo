within Buildings.Experimental.DHC.BaseClasses.Steam;
partial model PartialTwoPortTwoMedium
  "Partial model with two ports with two separate medium models without storing mass or energy"

  replaceable package Medium_a =
      Modelica.Media.Interfaces.PartialMedium
    "Medium model for port_a (inlet)";
  replaceable package Medium_b =
      Modelica.Media.Interfaces.PartialMedium
    "Medium model for port_b (outlet)";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_small(min=0) = 1E-4*abs(m_flow_nominal)
    "Small mass flow rate for regularization of zero flow";

  // Diagnostics
   parameter Boolean show_T = false
    "= true, if actual temperature at port is computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));

  Modelica.Units.SI.MassFlowRate m_flow(start=_m_flow_start) = port_a.m_flow
    "Mass flow rate from port_a to port_b (m_flow > 0 is design flow direction)";

  Modelica.Units.SI.PressureDifference dp(start=_dp_start, displayUnit="Pa") = port_a.p - port_b.p
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
     m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
     h_outflow(start = Medium_a.h_default, nominal = Medium_a.h_default))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium = Medium_b,
     m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
     h_outflow(start = Medium_b.h_default, nominal = Medium_b.h_default))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,-10},{90,10}})));

  // Assumptions
  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal. Used only if model has two ports."
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

   //Dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

  // Initialization
  parameter Medium_b.AbsolutePressure p_start = Medium_b.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium_b.Temperature T_start=Medium_b.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization"));

protected
  final parameter Modelica.Units.SI.MassFlowRate _m_flow_start = 0
  "Start value for m_flow, used to avoid a warning if not set in m_flow, and to avoid m_flow.start in parameter window";
  final parameter Modelica.Units.SI.PressureDifference _dp_start(displayUnit="Pa") = 0
  "Start value for dp, used to avoid a warning if not set in dp, and to avoid dp.start in parameter window";

  annotation (Documentation(info="<html>
<p>
This partial model defines an interface for components
with two ports and separate medium definitions at each port.
The component transports fluid between two ports
without storing mass or energy. The treatment of the
design flow direction and of flow reversal are
predefined based on the parameter <code>allowFlowReversal</code>.
</p>
<p>
This model is intended for steam heating applications, where
phase change is inherently present. The split-medium approach
enables a numerically-efficient liquid water model (i.e.,
<a href=\"modelica://Buildings.Media.Specialized.Water.TemperatureDependentDensity\">
Buildings.Media.Specialized.Water.TemperatureDependentDensity</a>)
to be implemented alongside various water/steam models for other phases.
For most applications,
an efficient model (i.e., <a href=\"modelica://Modelica.Media.Water.StandardWater\">Modelica.Media.Water.StandardWater</a>
is suitable as it covers the largest range of pressure-temperature conditions through
its implementation of the IAPWS-IF97 water/steam formulation.
If a reduce pressure-temperature range is applicable,
<a href=\"modelica://Buildings.Media.Steam\">Buildings.Media.Steam</a>)
provides a more efficient implementation.
Through the split-medium approach, pressure and density calculations are decoupled,
eliminating costly nonlinear systems of equations.
This interface model also includes parameters for mass and
energy dynamics as well as initialization.
</p>
<h4>Reference</h4>
<p>
Hinkelman, Kathryn, Saranya Anbarasu, Michael Wetter,
Antoine Gautier, and Wangda Zuo. 2022. “A Fast and Accurate Modeling
Approach for Water and Steam Thermodynamics with Practical
Applications in District Heating System Simulation.” Preprint. February 24.
<a href=\"http://dx.doi.org/10.13140/RG.2.2.20710.29762\">doi:10.13140/RG.2.2.20710.29762</a>.
</p>
</html>", revisions="<html>
<ul>
<li>July 22, 2021 by Kathryn Hinkelman: </li>
<li>First implementation. </li>
</ul>
</html>"));
end PartialTwoPortTwoMedium;
