within Buildings.Templates.AirHandlersFans.Components.OutdoorReliefReturnSection.Interfaces;
partial model PartialOutdoorReliefReturnSection
  "Outdoor/relief/return air section"

  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";

  parameter Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection typ
    "Outdoor/relief/return air section type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.AirHandlersFans.Types.OutdoorSection typSecOut
    "Outdoor air section type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection typSecRel
    "Relief/return air section type"
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
    if typ <> Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.EconomizerNoRelief
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
    redeclare final package Medium = MediumAir)
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
        extent={{420,520},{360,680}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Fans/MultipleVariable.svg"),
                Bitmap(
        visible=typFanRet==Buildings.Templates.Components.Types.Fan.SingleVariable,
        extent={{540,520},{360,680}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Fans/SingleVariable.svg"),
      Bitmap(
        visible=typDamRel==Buildings.Templates.Components.Types.Damper.TwoPosition,
        extent={{-680,400},{-600,480}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Dampers/ActuatorTwoPosition.svg"),
      Bitmap(
        visible=typDamRel==Buildings.Templates.Components.Types.Damper.Modulated,
        extent={{-680,400},{-600,480}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Dampers/ActuatorModulated.svg"),
              Bitmap(
        extent={{-600,480},{-680,680}},
        visible=typDamRel<>Buildings.Templates.Components.Types.Damper.None,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Dampers/BladesOpposed.svg"),
              Bitmap(
        visible=typFanRel==Buildings.Templates.Components.Types.Fan.MultipleVariable,
        extent={{-260,520},{-320,680}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Fans/MultipleVariable.svg"),
                Bitmap(
        visible=typFanRel==Buildings.Templates.Components.Types.Fan.SingleVariable,
        extent={{-138,520},{-320,680}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Fans/SingleVariable.svg"),
      Bitmap(
        visible=typ<>Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.NoEconomizer,
        extent={{-200,-40},{-120,40}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Dampers/ActuatorModulated.svg"),
      Bitmap(
        extent={{-40,-100},{40,100}},
        visible=typ<>Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.NoEconomizer,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Dampers/BladesParallel.svg",
          origin={-20,0},
          rotation=-90),
      Bitmap(
        extent={{-680,-720},{-600,-520}},
        visible=typDamOut<>Buildings.Templates.Components.Types.Damper.None,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Dampers/BladesParallel.svg"),
      Bitmap(
        visible=typDamOut==Buildings.Templates.Components.Types.Damper.TwoPosition,
        extent={{-680,-800},{-600,-720}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Dampers/ActuatorTwoPosition.svg"),
      Bitmap(
        visible=typDamOut==Buildings.Templates.Components.Types.Damper.Modulated,
        extent={{-680,-800},{-600,-720}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Dampers/ActuatorModulated.svg"),
      Bitmap(
        extent={{-600,-320},{-680,-520}},
        visible=typDamOutMin<>Buildings.Templates.Components.Types.Damper.None,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Dampers/BladesParallel.svg"),
      Bitmap(
        visible=typDamOutMin==Buildings.Templates.Components.Types.Damper.TwoPosition,
        extent={{-680,-320},{-600,-240}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Dampers/ActuatorTwoPosition.svg"),
      Bitmap(
        visible=typDamOutMin==Buildings.Templates.Components.Types.Damper.Modulated,
        extent={{-680,-320},{-600,-240}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Dampers/ActuatorModulated.svg"),
      Line(points={{-80,680},{800,680}},  color={28,108,200}),
      Line(
        points={{-800,520},{-80,520}},
        color={28,108,200},
        visible=typ <> Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.EconomizerNoRelief),
      Line(points={{80,520},{800,520}}, color={28,108,200}),
      Line(points={{80,-520},{800,-520}}, color={28,108,200}),
      Line(points={{-800,-520},{-80,-520}}, color={28,108,200}),
      Line(points={{-800,-680},{800,-680}}, color={28,108,200}),
      Line(
        visible=typ <> Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.NoEconomizer,
        points={{80,520},{80,-520}},
        color={28,108,200}),
      Line(
        visible=typ <> Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.NoEconomizer,
        points={{-80,520},{-80,-360}},
        color={28,108,200}),
      Line(
        points={{-800,680},{-80,680}},
        color={28,108,200},
        visible=typ <> Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.EconomizerNoRelief),
      Line(
          points={{-80,520},{80,520}},
          color={28,108,200},
          visible=typ == Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.NoEconomizer),
      Line(
          points={{-80,-520},{80,-520}},
          color={28,108,200},
          visible=typ == Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.NoEconomizer),
      Line(
        points={{-800,-360},{-80,-360}},
        color={28,108,200},
        visible=typDamOutMin <> Buildings.Templates.Components.Types.Damper.None),
      Line(
        points={{-80,-360},{-80,-520}},
        color={28,108,200},
        visible=typDamOutMin == Buildings.Templates.Components.Types.Damper.None and
          typ <> Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.NoEconomizer),
      Bitmap(
        extent={{-546,-194},{-626,-394}},
        visible=typSecOut==Buildings.Templates.AirHandlersFans.Types.OutdoorSection.DedicatedDamperPressure,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/DifferentialPressureStatic.svg"),
      Bitmap(
        visible=typSecOut==Buildings.Templates.AirHandlersFans.Types.OutdoorSection.DedicatedDamperPressure,
        extent={{-680,-230},{-600,-150}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/DifferentialPressure.svg"),
      Bitmap(
        extent={{-734,-194},{-654,-394}},
        visible=typSecOut==Buildings.Templates.AirHandlersFans.Types.OutdoorSection.DedicatedDamperPressure,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/DifferentialPressureStatic.svg"),
      Bitmap(
        visible=typSecOut==Buildings.Templates.AirHandlersFans.Types.OutdoorSection.DedicatedDamperAirflow,
        extent={{-80,-41},{80,41}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/VolumeFlowRateAFMS.svg",
          origin={-121,-440},
          rotation=90)}),
   Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},{180,140}})));
end PartialOutdoorReliefReturnSection;
