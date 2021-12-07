within Buildings.Templates.AirHandlersFans.Components.OutdoorSection.Interfaces;
partial model PartialOutdoorSection "Outdoor air section"

  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";

  parameter AirHandlersFans.Types.OutdoorSection typ "Outdoor air section type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Damper typDamOut
    "Outdoor air damper type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Damper typDamOutMin
    "Minimum outdoor air damper type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  outer parameter Boolean have_recHea
    "Set to true in case of heat recovery";
  outer parameter Buildings.Templates.AirHandlersFans.Types.ControlEconomizer typCtrEco
    "Economizer control type";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Air mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mOutMin_flow_nominal
    "Minimum outdoor air mass flow rate"
    annotation (
      Dialog(group="Nominal condition",
        enable=typDamOutMin <> Buildings.Templates.Components.Types.Damper.None));
  parameter Modelica.SIunits.PressureDifference dpDamOut_nominal
    "Outdoor air damper pressure drop"
    annotation (
      Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpDamOutMin_nominal
    "Minimum outdoor air damper pressure drop"
    annotation (
      Dialog(group="Nominal condition",
        enable=typDamOutMin <> Buildings.Templates.Components.Types.Damper.None));

  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

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

  Buildings.Templates.BaseClasses.PassThroughFluid pas(
    redeclare final package Medium = MediumAir) if not have_recHea
    "Direct pass through (conditional)"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));

protected
  Modelica.Fluid.Interfaces.FluidPort_a port_aIns(
    redeclare final package Medium = MediumAir,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
    "Inside fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
equation
  connect(pas.port_b, port_aIns)
    annotation (Line(points={{-50,0},{-40,0}}, color={0,127,255}));
  connect(port_aHeaRec, port_aIns)
    annotation (Line(points={{-40,140},{-40,0}},         color={0,127,255}));
  connect(port_bHeaRec, pas.port_a) annotation (Line(points={{-80,140},{-80,0},{
          -70,0}},   color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},
            {180,140}}), graphics={
        Text(
          extent={{-149,-150},{151,-190}},
          lineColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},{180,140}})));
end PartialOutdoorSection;
