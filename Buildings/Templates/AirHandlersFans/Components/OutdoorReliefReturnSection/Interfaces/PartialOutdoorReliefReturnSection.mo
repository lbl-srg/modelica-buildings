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
  parameter Buildings.Templates.Components.Types.Damper typDamRet
    "Return damper type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Fan typFanRel
    "Relief fan type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Fan typFanRet
    "Return fan type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  inner parameter Boolean have_recHea = false
    "Set to true in case of heat recovery"
    annotation (Evaluate=true,
      Dialog(group="Configuration",
        enable=typ<>Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.EconomizerNoRelief));
  /* Those parameters are not declared without outer as Dymola does not interpret
  inner/outer references to evaluate the visible annotation for graphical elements.
  */
  inner parameter Buildings.Templates.AirHandlersFans.Types.ControlFanReturn typCtrFanRet=
    Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.Airflow
    "Return fan control type"
    annotation (Evaluate=true,
      Dialog(
        group="Configuration",
        enable=typFanRet <> Buildings.Templates.Components.Types.Fan.None));
  inner parameter Buildings.Templates.AirHandlersFans.Types.ControlEconomizer typCtrEco=
    Buildings.Templates.AirHandlersFans.Types.ControlEconomizer.FixedDryBulb
    "Economizer control type"
    annotation (Evaluate=true,
      Dialog(
        group="Configuration",
        enable=typ <> Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.NoEconomizer));

  parameter Modelica.SIunits.MassFlowRate mSup_flow_nominal
    "Supply air mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mRet_flow_nominal
    "Return air mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mOutMin_flow_nominal=
    if typDamOutMin <> Buildings.Templates.Components.Types.Damper.None then
      dat.getReal(varName=id + ".Mechanical.Economizer/dampers.Minimum outdoor air mass flow rate.value")
    else 0
    "Minimum outdoor air mass flow rate"
    annotation (
      Dialog(group="Nominal condition",
        enable=typDamOutMin <> Buildings.Templates.Components.Types.Damper.None));

  parameter Modelica.SIunits.PressureDifference dpFan_nominal=
    if typFanRel <> Buildings.Templates.Components.Types.Fan.None or
      typFanRet <> Buildings.Templates.Components.Types.Fan.None then
      dat.getReal(varName=id + ".Mechanical.Relief/return fan.Total pressure rise.value")
    else 0
    "Relief/return fan total pressure rise"
    annotation (
      Dialog(group="Nominal condition",
        enable=typFanRel <> Buildings.Templates.Components.Types.Fan.None or
          typFanRet <> Buildings.Templates.Components.Types.Fan.None));
  parameter Modelica.SIunits.PressureDifference dpDamOut_nominal=
    dat.getReal(varName=id + ".Mechanical.Economizer/dampers.Outdoor air damper pressure drop.value")
    "Outdoor air damper pressure drop"
    annotation (
      Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpDamOutMin_nominal=
    if typDamOutMin <> Buildings.Templates.Components.Types.Damper.None then
      dat.getReal(varName=id + ".Mechanical.Economizer/dampers.Minimum outdoor air damper pressure drop.value")
    else 0
    "Minimum outdoor air damper pressure drop"
    annotation (
      Dialog(group="Nominal condition",
        enable=typDamOutMin <> Buildings.Templates.Components.Types.Damper.None));
  parameter Modelica.SIunits.PressureDifference dpDamRet_nominal=
    if typDamRet <> Buildings.Templates.Components.Types.Damper.None then
      dat.getReal(varName=id + ".Mechanical.Economizer/dampers.Return air damper pressure drop.value")
    else 0
    "Return air damper pressure drop"
    annotation (
      Dialog(group="Nominal condition",
        enable=typDamRet <> Buildings.Templates.Components.Types.Damper.None));
  parameter Modelica.SIunits.PressureDifference dpDamRel_nominal=
    if typDamRel<>Buildings.Templates.Components.Types.Damper.None then
      dat.getReal(varName=id + ".Mechanical.Economizer/dampers.Relief air damper pressure drop.value")
    else 0
    "Relief air damper pressure drop"
    annotation (
      Dialog(group="Nominal condition",
        enable=typDamRel<>Buildings.Templates.Components.Types.Damper.None));

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
        visible=typFanRet==Buildings.Templates.Components.Types.Fan.SingleVariable,
        extent={{540,500},{310,700}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Fans/SingleVariable.svg"),
              Bitmap(
        visible=typFanRet==Buildings.Templates.Components.Types.Fan.MultipleVariable,
        extent={{490,500},{402,700}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Fans/MultipleVariable.svg"),
      Bitmap(
        visible=typDamRel==Buildings.Templates.Components.Types.Damper.TwoPosition,
        extent={{-680,380},{-600,460}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
      Bitmap(
        visible=typDamRel==Buildings.Templates.Components.Types.Damper.Modulated,
        extent={{-680,380},{-600,460}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulated.svg"),
              Bitmap(
        extent={{-600,460},{-680,700}},
        visible=typDamRel<>Buildings.Templates.Components.Types.Damper.None,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Dampers/BladesOpposed.svg"),
                Bitmap(
        visible=typFanRel==Buildings.Templates.Components.Types.Fan.SingleVariable,
        extent={{-140,500},{-368,700}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Fans/SingleVariable.svg"),
              Bitmap(
        visible=typFanRel==Buildings.Templates.Components.Types.Fan.MultipleVariable,
        extent={{-200,500},{-270,700}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Fans/MultipleVariable.svg"),
      Bitmap(
        visible=typ<>Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.NoEconomizer,
        extent={{-218,-40},{-138,40}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulated.svg"),
      Bitmap(
        extent={{-40,-120},{40,120}},
        visible=typ<>Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.NoEconomizer,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Dampers/BladesParallel.svg",
          origin={-20,7.10543e-15},
          rotation=-90),
      Bitmap(
        extent={{-680,-740},{-600,-500}},
        visible=typDamOut<>Buildings.Templates.Components.Types.Damper.None,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Dampers/BladesParallel.svg"),
      Bitmap(
        visible=typDamOut==Buildings.Templates.Components.Types.Damper.TwoPosition,
        extent={{-680,-820},{-600,-740}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
      Bitmap(
        visible=typDamOut==Buildings.Templates.Components.Types.Damper.Modulated,
        extent={{-680,-820},{-600,-740}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulated.svg"),
      Bitmap(
        extent={{-600,-260},{-680,-500}},
        visible=typDamOutMin<>Buildings.Templates.Components.Types.Damper.None,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Dampers/BladesParallel.svg"),
      Bitmap(
        visible=typDamOutMin==Buildings.Templates.Components.Types.Damper.TwoPosition,
        extent={{-680,-260},{-600,-180}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
      Bitmap(
        visible=typDamOutMin==Buildings.Templates.Components.Types.Damper.Modulated,
        extent={{-680,-260},{-600,-180}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulated.svg"),
      Line(points={{-100,700},{800,700}}, color={28,108,200}),
      Line(
        points={{-800,500},{-100,500}},
        color={28,108,200},
        visible=typ <> Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.EconomizerNoRelief),
      Line(
        points={{-100,700},{-100,500}},
        color={28,108,200},
        visible=typ==Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.EconomizerNoRelief),
      Line(points={{100,500},{800,500}},color={28,108,200}),
      Line(points={{100,-500},{800,-500}},color={28,108,200}),
      Line(points={{-800,-500},{-100,-500}},color={28,108,200}),
      Line(points={{-800,-700},{800,-700}}, color={28,108,200}),
      Line(
        visible=typ <> Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.NoEconomizer,
        points={{100,500},{100,-500}},
        color={28,108,200}),
      Line(
        visible=typ <> Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.NoEconomizer,
        points={{-100,500},{-100,-300}},
        color={28,108,200}),
      Line(
        points={{-800,700},{-100,700}},
        color={28,108,200},
        visible=typ <> Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.EconomizerNoRelief),
      Line(
          points={{-100,500},{100,500}},
          color={28,108,200},
          visible=typ == Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.NoEconomizer),
      Line(
          points={{-100,-500},{100,-500}},
          color={28,108,200},
          visible=typ == Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.NoEconomizer),
      Line(
        points={{-800,-300},{-100,-300}},
        color={28,108,200},
        visible=typDamOutMin <> Buildings.Templates.Components.Types.Damper.None),
      Line(
        points={{-100,-300},{-100,-500}},
        color={28,108,200},
        visible=typDamOutMin == Buildings.Templates.Components.Types.Damper.None and
          typ <> Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.NoEconomizer),
      Bitmap(
        visible=typSecOut==Buildings.Templates.AirHandlersFans.Types.OutdoorSection.DedicatedDamperPressure,
        extent={{-680,-162},{-600,-82}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/DifferentialPressure.svg"),
      Line(
          visible=typSecOut==Buildings.Templates.AirHandlersFans.Types.OutdoorSection.DedicatedDamperPressure,
          points={{-600,-120},{-560,-120},{-560,-340}},
          color={0,0,0},
          thickness=1),
      Line(
          visible=typSecOut==Buildings.Templates.AirHandlersFans.Types.OutdoorSection.DedicatedDamperPressure,
          points={{-680,-120},{-720,-120},{-720,-340}},
          color={0,0,0},
          thickness=1),
      Bitmap(
        visible=typSecOut==Buildings.Templates.AirHandlersFans.Types.OutdoorSection.DedicatedDamperAirflow,
        extent={{-102,-50},{102,50}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/VolumeFlowRateAFMS.svg",
          origin={-150,-400},
          rotation=90),
      Bitmap(
        visible=typFanRet<>Buildings.Templates.Components.Types.Fan.None and
          typCtrFanRet==Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.Airflow,
        extent={{396,582},{490,616}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Fans/AirflowSensor.svg"),
      Bitmap(
        visible=typDamOutMin<>Buildings.Templates.Components.Types.Damper.None,
        extent={{-360,-460},{-280,-180}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/TemperatureStandardUp.svg"),
      Bitmap(
        visible=typDamOutMin<>Buildings.Templates.Components.Types.Damper.None and
          (typCtrEco==Buildings.Templates.AirHandlersFans.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb or
          typCtrEco==Buildings.Templates.AirHandlersFans.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb),
        extent={{-480,-180},{-400,-460}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/SpecificEnthalpy.svg"),
      Bitmap(
        visible=typDamOutMin==Buildings.Templates.Components.Types.Damper.None,
        extent={{-360,-820},{-280,-540}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/TemperatureStandard.svg"),
      Bitmap(
        visible=typDamOutMin==Buildings.Templates.Components.Types.Damper.None and
          (typCtrEco==Buildings.Templates.AirHandlersFans.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb or
          typCtrEco==Buildings.Templates.AirHandlersFans.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb),
        extent={{-480,-820},{-400,-540}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/SpecificEnthalpy.svg")}),
   Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},{180,140}})));
end PartialOutdoorReliefReturnSection;
