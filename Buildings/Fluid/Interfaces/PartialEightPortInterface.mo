within Buildings.Fluid.Interfaces;
partial model PartialEightPortInterface
  "Partial model transporting fluid between eight ports without storing mass or energy"
  extends Buildings.Fluid.Interfaces.EightPort;
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal(min=0)
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal(min=0)
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
    parameter Modelica.SIunits.MassFlowRate m3_flow_nominal(min=0)
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m4_flow_nominal(min=0)
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));

  parameter Medium1.MassFlowRate m1_flow_small(min=0) = 1E-4*abs(m1_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));
  parameter Medium2.MassFlowRate m2_flow_small(min=0) = 1E-4*abs(m2_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));
  parameter Medium3.MassFlowRate m3_flow_small(min=0) = 1E-4*abs(m3_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));
  parameter Medium4.MassFlowRate m4_flow_small(min=0) = 1E-4*abs(m4_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));

  // Diagnostics
  parameter Boolean show_T = false
    "= true, if actual temperature at port is computed"
    annotation(
      Dialog(tab="Advanced", group="Diagnostics"),
      HideResult=true);
  Medium1.MassFlowRate m1_flow = port_a1.m_flow
    "Mass flow rate from port_a1 to port_b1 (m1_flow > 0 is design flow direction)";
  Modelica.SIunits.Pressure dp1(displayUnit="Pa")
    "Pressure difference between port_a1 and port_b1";
  Medium2.MassFlowRate m2_flow = port_a2.m_flow
    "Mass flow rate from port_a2 to port_b2 (m2_flow > 0 is design flow direction)";
  Modelica.SIunits.Pressure dp2(displayUnit="Pa")
    "Pressure difference between port_a2 and port_b2";

  Medium3.MassFlowRate m3_flow = port_a3.m_flow
    "Mass flow rate from port_a3 to port_b3 (m3_flow > 0 is design flow direction)";
  Modelica.SIunits.Pressure dp3(displayUnit="Pa")
    "Pressure difference between port_a3 and port_b3";
  Medium4.MassFlowRate m4_flow = port_a4.m_flow
    "Mass flow rate from port_a4 to port_b4 (m4_flow > 0 is design flow direction)";
  Modelica.SIunits.Pressure dp4(displayUnit="Pa")
    "Pressure difference between port_a4 and port_b4";

  Medium1.ThermodynamicState sta_a1=
      Medium1.setState_phX(port_a1.p,
                           noEvent(actualStream(port_a1.h_outflow)),
                           noEvent(actualStream(port_a1.Xi_outflow))) if
         show_T "Medium properties in port_a1";
  Medium1.ThermodynamicState sta_b1=
      Medium1.setState_phX(port_b1.p,
                           noEvent(actualStream(port_b1.h_outflow)),
                           noEvent(actualStream(port_b1.Xi_outflow))) if
         show_T "Medium properties in port_b1";
  Medium2.ThermodynamicState sta_a2=
      Medium2.setState_phX(port_a2.p,
                           noEvent(actualStream(port_a2.h_outflow)),
                           noEvent(actualStream(port_a2.Xi_outflow))) if
         show_T "Medium properties in port_a2";
  Medium2.ThermodynamicState sta_b2=
      Medium2.setState_phX(port_b2.p,
                           noEvent(actualStream(port_b2.h_outflow)),
                           noEvent(actualStream(port_b2.Xi_outflow))) if
         show_T "Medium properties in port_b2";

 Medium3.ThermodynamicState sta_a3=
      Medium3.setState_phX(port_a3.p,
                           noEvent(actualStream(port_a3.h_outflow)),
                           noEvent(actualStream(port_a3.Xi_outflow))) if
         show_T "Medium properties in port_a3";
  Medium3.ThermodynamicState sta_b3=
      Medium3.setState_phX(port_b3.p,
                           noEvent(actualStream(port_b3.h_outflow)),
                           noEvent(actualStream(port_b3.Xi_outflow))) if
         show_T "Medium properties in port_b3";
  Medium4.ThermodynamicState sta_a4=
      Medium4.setState_phX(port_a4.p,
                           noEvent(actualStream(port_a4.h_outflow)),
                           noEvent(actualStream(port_a4.Xi_outflow))) if
         show_T "Medium properties in port_a4";
  Medium4.ThermodynamicState sta_b4=
      Medium4.setState_phX(port_b4.p,
                           noEvent(actualStream(port_b4.h_outflow)),
                           noEvent(actualStream(port_b4.Xi_outflow))) if
         show_T "Medium properties in port_b4";
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
  Medium3.ThermodynamicState state_a3_inflow=
    Medium3.setState_phX(port_a3.p, inStream(port_a3.h_outflow), inStream(port_a3.Xi_outflow))
    "state for medium inflowing through port_a3";
  Medium3.ThermodynamicState state_b3_inflow=
    Medium3.setState_phX(port_b3.p, inStream(port_b3.h_outflow), inStream(port_b3.Xi_outflow))
    "state for medium inflowing through port_b3";
  Medium4.ThermodynamicState state_a4_inflow=
    Medium4.setState_phX(port_a4.p, inStream(port_a4.h_outflow), inStream(port_a4.Xi_outflow))
    "state for medium inflowing through port_a4";
  Medium4.ThermodynamicState state_b4_inflow=
    Medium4.setState_phX(port_b4.p, inStream(port_b4.h_outflow), inStream(port_b4.Xi_outflow))
    "state for medium inflowing through port_b4";
equation
  dp1 = port_a1.p - port_b1.p;
  dp2 = port_a2.p - port_b2.p;
  dp3 = port_a3.p - port_b3.p;
  dp4 = port_a4.p - port_b4.p;
  annotation (
  preferredView="info",
    Documentation(info="<html>
<p>
This component defines the interface for models that transport four fluid streams between eight ports.
It is similar to <a href=\"modelica://Buildings.Fluid.Interfaces.PartialTwoPortInterface\">Buildings.Fluid.Interfaces.PartialTwoPortInterface</a>,
but it has eight ports instead of two. </p>
<p>
The model is used by other models in this package that add heat transfer,
mass transfer and pressure drop equations.
</p>
</html>", revisions="<html>
<ul>
<li>
March 30, 2021, by Michael Wetter:<br/>
Added annotation <code>HideResult=true</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1459\">IBPSA, #1459</a>.
</li>
<li>
July 12, 2019, by Michael Wetter:<br/>
Corrected wrong medium in declaration of <code>m4_flow</code>.
</li>
<li>
July 2014, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
                    graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end PartialEightPortInterface;
