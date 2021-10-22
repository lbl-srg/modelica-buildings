within Buildings.Templates.AirHandlersFans.Interfaces;
partial model OutdoorReliefReturnSection "Outdoor/relief/return air section"

  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";

  parameter AirHandlersFans.Types.OutdoorReliefReturnSection typ
    "Outdoor/relief/return air section type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_porPre
    "Set to true in case of fluid port for differential pressure sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Damper typDamOut
    "Outdoor air damper type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Damper typDamOutMin
    "Minimum outdoor air damper type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Damper typDamRel
    "Relief damper type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Fan typFanRet
    "Relief/return fan type"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  Modelica.Fluid.Interfaces.FluidPort_b port_Rel(
    redeclare final package Medium = MediumAir,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
    if typ <> AirHandlersFans.Types.OutdoorReliefReturnSection.NoRelief
    "Relief (exhaust) air"
    annotation (Placement(transformation(
      extent={{-190,70},{-170,90}}),iconTransformation(extent={{-190,90},{-170,
            110}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_Out(
    redeclare final package Medium = MediumAir,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
    "Outdoor air intake"
    annotation (Placement(transformation(
      extent={{-190,-90},{-170,-70}}),iconTransformation(extent={{-190,-110},{
            -170,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_Sup(
    redeclare final package Medium = MediumAir,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
    "Supply air"
    annotation (
      Placement(transformation(extent={{170,-90},{190,-70}}),
        iconTransformation(extent={{170,-110},{190,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_Ret(
    redeclare final package Medium =MediumAir,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
    "Return air"
    annotation (Placement(transformation(extent={{170,70},{190,90}}),
        iconTransformation(extent={{170,90},{190,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bPre(
    redeclare final package Medium = MediumAir) if have_porPre
    "Optional fluid connector for differential pressure sensor"
    annotation (Placement(transformation(extent={{90,130},{70,150}}),
        iconTransformation(extent={{90,130},{70,150}})));
  Interfaces.Bus bus "Control bus" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,140}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,140})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,
            -140},{180,140}}), graphics={
        Text(
          extent={{-149,-150},{151,-190}},
          lineColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},{180,
            140}})));
end OutdoorReliefReturnSection;
