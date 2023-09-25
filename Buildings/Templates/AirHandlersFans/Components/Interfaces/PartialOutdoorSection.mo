within Buildings.Templates.AirHandlersFans.Components.Interfaces;
partial model PartialOutdoorSection "Interface class for outdoor air section"

  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium"
    annotation(__ctrlFlow(enable=false));

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection typ
    "Outdoor air section type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Damper typDamOut
    "Outdoor air damper type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Damper typDamOutMin
    "Minimum outdoor air damper type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_recHea
    "Set to true in case of heat recovery";
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer typCtlEco
    "Economizer control type";

  parameter
    Buildings.Templates.AirHandlersFans.Components.Data.OutdoorReliefReturnSection
    dat "Design and operating parameters";

  final parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=
    dat.damOut.m_flow_nominal
    "Air mass flow rate";
  final parameter Modelica.Units.SI.MassFlowRate mOutMin_flow_nominal=
    dat.mOutMin_flow_nominal
    "Minimum outdoor air mass flow rate";

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"),
      __ctrlFlow(enable=false));

  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true, __ctrlFlow(enable=false));

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium = MediumAir,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-190,-10},{-170,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium = MediumAir,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{190,-10},{170,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aHeaRec(
    redeclare final package Medium = MediumAir,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default)) if have_recHea
    "Optional fluid connector for heat recovery"
    annotation (Placement(transformation(extent={{-50,130},{-30,150}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bHeaRec(
    redeclare final package Medium = MediumAir,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default)) if have_recHea
    "Optional fluid connector for heat recovery"
    annotation (Placement(transformation(extent={{-70,130},{-90,150}})));
  Buildings.Templates.AirHandlersFans.Interfaces.Bus bus
    "Control bus"
    annotation (Placement(
      transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,140}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,140})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},
            {180,140}}), graphics={
        Text(
          extent={{-149,-150},{151,-190}},
          textColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},{180,140}})),
    Documentation(info="<html>
<p>
This class provides a standard interface for the outdoor
air section of an air handler.
Typical components in that section include
</p>
<ul>
<li>
shut off OA dampers,
</li>
<li>
the OA side of the heat recovery unit,
</li>
<li>
the OA dampers of the air economizer.
</li>
</ul>
</html>"));
end PartialOutdoorSection;
