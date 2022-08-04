within Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses;
partial model PartialChillerWSEInterface
  "Partial model that defines the interface for chiller and WSE package"
  extends Buildings.Fluid.Interfaces.PartialFourPort;

  // Nominal conditions
  parameter Modelica.Units.SI.MassFlowRate m1_flow_chi_nominal(min=0)
    "Nominal mass flow rate on the medium 1 side in the chiller"
    annotation (Dialog(group="Chiller"));
  parameter Modelica.Units.SI.MassFlowRate m2_flow_chi_nominal(min=0)
    "Nominal mass flow rate on the medium 2 side in the chiller"
    annotation (Dialog(group="Chiller"));
  parameter Modelica.Units.SI.MassFlowRate m1_flow_wse_nominal(min=0)
    "Nominal mass flow rate on the medium 1 side in the waterside economizer"
    annotation (Dialog(group="Waterside economizer"));
  parameter Modelica.Units.SI.MassFlowRate m2_flow_wse_nominal(min=0)
    "Nominal mass flow rate on the medium 2 side in the waterside economizer"
    annotation (Dialog(group="Waterside economizer"));

  // Advanced
  parameter Medium1.MassFlowRate m1_flow_small(min=0) = 1E-4*abs(m1_flow_chi_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));
  parameter Medium2.MassFlowRate m2_flow_small(min=0) = 1E-4*abs(m2_flow_chi_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));
  // Diagnostics
  parameter Boolean show_T = false
    "= true, if actual temperature at port is computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));
  parameter Integer num(min=1)=2 "Total number of chillers and waterside economizer";

  Modelica.Blocks.Interfaces.RealInput TSet(
    final unit="K",
    final quantity="ThermodynamicTemperature",
    displayUnit="degC")
    "Set point for leaving water temperature"
    annotation (Placement(transformation(extent={{-140,84},{-100,124}}),
        iconTransformation(extent={{-132,92},{-100,124}})));
  Modelica.Blocks.Interfaces.BooleanInput on[num]
    "Set to true to enable equipment, or false to disable equipment"
    annotation (Placement(transformation(extent={{-140,52},{-100,92}}),
        iconTransformation(extent={{-132,60},{-100,92}})));
  Medium1.MassFlowRate m1_flow = port_a1.m_flow
    "Mass flow rate from port_a1 to port_b1 (m1_flow > 0 is design flow direction)";
  Modelica.Units.SI.PressureDifference dp1(displayUnit="Pa") = port_a1.p -
    port_b1.p "Pressure difference between port_a1 and port_b1";

  Medium2.MassFlowRate m2_flow = port_a2.m_flow
    "Mass flow rate from port_a2 to port_b2 (m2_flow > 0 is design flow direction)";
  Modelica.Units.SI.PressureDifference dp2(displayUnit="Pa") = port_a2.p -
    port_b2.p "Pressure difference between port_a2 and port_b2";

  Medium1.ThermodynamicState sta_a1=
      Medium1.setState_phX(port_a1.p,
                           noEvent(actualStream(port_a1.h_outflow)),
                           noEvent(actualStream(port_a1.Xi_outflow)))
      if show_T "Medium properties in port_a1";
  Medium1.ThermodynamicState sta_b1=
      Medium1.setState_phX(port_b1.p,
                           noEvent(actualStream(port_b1.h_outflow)),
                           noEvent(actualStream(port_b1.Xi_outflow)))
      if show_T "Medium properties in port_b1";
  Medium2.ThermodynamicState sta_a2=
      Medium2.setState_phX(port_a2.p,
                           noEvent(actualStream(port_a2.h_outflow)),
                           noEvent(actualStream(port_a2.Xi_outflow)))
      if show_T "Medium properties in port_a2";
  Medium2.ThermodynamicState sta_b2=
      Medium2.setState_phX(port_b2.p,
                           noEvent(actualStream(port_b2.h_outflow)),
                           noEvent(actualStream(port_b2.Xi_outflow)))
      if show_T "Medium properties in port_b2";
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
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(extent={{-100,100},{100,-100}}, pattern=LinePattern.None),
          Rectangle(
          extent={{-80,80},{80,-80}},
          lineColor={255,255,255},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid)}),    Documentation(info="<html>
<p>
This model implements an interface for chillers and integrated/nonitegrated water-side economizers.
</p>
</html>",
        revisions="<html>
<ul>
<li>
June 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));

end PartialChillerWSEInterface;
