within Buildings.Templates.AirHandlersFans.Components.OutdoorReliefReturnSection.Interfaces;
partial model PartialOutdoorReliefReturnSection
  "Outdoor/relief/return air section"

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
  parameter Buildings.Templates.Components.Types.Fan typFanRel
    "Relief fan type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Fan typFanRet
    "Return fan type"
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
    if typ <> AirHandlersFans.Types.OutdoorReliefReturnSection.EconomizerNoRelief
    "Relief (exhaust) air"
    annotation (Placement(transformation(
      extent={{-190,70},{-170,90}}),iconTransformation(extent={{-810,590},{-790,
            610}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_Out(
    redeclare final package Medium = MediumAir,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
    "Outdoor air intake"
    annotation (Placement(transformation(
      extent={{-190,-90},{-170,-70}}),iconTransformation(extent={{-810,-610},{-790,
            -590}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_Sup(
    redeclare final package Medium = MediumAir,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
    "Supply air"
    annotation (
      Placement(transformation(extent={{170,-90},{190,-70}}),
        iconTransformation(extent={{790,-610},{810,-590}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_Ret(
    redeclare final package Medium =MediumAir,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
    "Return air"
    annotation (Placement(transformation(extent={{170,70},{190,90}}),
        iconTransformation(extent={{790,588},{810,608}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bPre(
    redeclare final package Medium = MediumAir) if have_porPre
    "Optional fluid connector for differential pressure sensor"
    annotation (Placement(transformation(extent={{90,130},{70,150}}),
        iconTransformation(extent={{390,790},{370,810}})));
  Buildings.Templates.AirHandlersFans.Interfaces.Bus bus "Control bus"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,140}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,800})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-800,-800}, {800,800}}),
    graphics={
        Text(
          extent={{-149,-834},{151,-874}},
          lineColor={0,0,255},
          textString="%name"),
              Bitmap(
        visible=typFanRet==Buildings.Templates.Components.Types.Fan.MultipleVariable,
        extent={{396,520},{236,680}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Fans/MultipleVariable.svg"),
                Bitmap(
        visible=typFanRet==Buildings.Templates.Components.Types.Fan.SingleVariable,
        extent={{544,510},{360,690}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Fans/SingleVariable.svg"),
        Rectangle(extent={{800,680},{-800,520}}, lineColor={28,108,200}),
      Bitmap(
        visible=typDamRel==Buildings.Templates.Components.Types.Damper.TwoPosition,
        extent={{-620,400},{-540,480}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Dampers/TwoPosition.svg"),
      Bitmap(
        visible=typDamRel==Buildings.Templates.Components.Types.Damper.Modulated,
        extent={{-700,400},{-620,480}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Dampers/Modulated.svg"),
              Bitmap(
        extent={{-620,480},{-700,680}},
        visible=typDamRel==Buildings.Templates.Components.Types.Damper.Modulated,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Dampers/OpposedBlade.svg"),
              Bitmap(
        extent={{-540,480},{-620,680}},
        visible=typDamRel==Buildings.Templates.Components.Types.Damper.TwoPosition,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Dampers/OpposedBlade.svg"),
              Bitmap(
        visible=typFanRel==Buildings.Templates.Components.Types.Fan.MultipleVariable,
        extent={{-344,520},{-504,680}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Fans/MultipleVariable.svg"),
                Bitmap(
        visible=typFanRel==Buildings.Templates.Components.Types.Fan.SingleVariable,
        extent={{-198,510},{-382,690}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Fans/SingleVariable.svg")}),
   Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},{180,140}})));
end PartialOutdoorReliefReturnSection;
