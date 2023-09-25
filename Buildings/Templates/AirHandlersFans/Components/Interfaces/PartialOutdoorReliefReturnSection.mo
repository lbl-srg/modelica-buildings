within Buildings.Templates.AirHandlersFans.Components.Interfaces;
partial model PartialOutdoorReliefReturnSection
  "Interface class for outdoor/relief/return air section"

  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium"
    annotation(__ctrlFlow(enable=false));

  parameter Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection typ
    "Outdoor/relief/return air section type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection typSecOut
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
  parameter Integer nFanRel
    "Number of relief fans"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Integer nFanRet
    "Number of return fans"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_eco
    "Set to true in case of economizer function"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  inner parameter Boolean have_recHea = false
    "Set to true in case of heat recovery"
    annotation (Evaluate=true,
      Dialog(group="Configuration"));
  inner parameter Buildings.Templates.AirHandlersFans.Types.ControlFanReturn typCtlFanRet=
    Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.AirflowMeasured
    "Return fan control type"
    annotation (Evaluate=true,
      Dialog(
        group="Configuration",
        enable=typFanRet<>Buildings.Templates.Components.Types.Fan.None));
  inner parameter Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer typCtlEco=
    Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedDryBulb
    "Economizer control type"
    annotation (Evaluate=true,
      Dialog(
        group="Configuration",
        enable=have_eco));

  parameter
    Buildings.Templates.AirHandlersFans.Components.Data.OutdoorReliefReturnSection
    dat(
      final typDamOut=typDamOut,
      final typDamOutMin=typDamOutMin,
      final typDamRet=typDamRet,
      final typDamRel=typDamRel,
      final typFanRel=typFanRel,
      final typFanRet=typFanRet)
    "Design and operating parameters"
    annotation (Placement(transformation(extent={{150,110},{170,130}})));

  final parameter Modelica.Units.SI.MassFlowRate mAirSup_flow_nominal=
    dat.damOut.m_flow_nominal
    "Supply air mass flow rate";
  final parameter Modelica.Units.SI.MassFlowRate mAirRet_flow_nominal=
    dat.damRet.m_flow_nominal
    "Return air mass flow rate";
  final parameter Modelica.Units.SI.MassFlowRate mOutMin_flow_nominal=
    dat.mOutMin_flow_nominal
    "Minimum outdoor air mass flow rate at design conditions";

  final parameter Modelica.Units.SI.PressureDifference dpDamOut_nominal=
    dat.damOut.dp_nominal
    "Outdoor air damper pressure drop";
  final parameter Modelica.Units.SI.PressureDifference dpDamOutMin_nominal=
    dat.damOutMin.dp_nominal
    "Minimum outdoor air damper pressure drop";
  final parameter Modelica.Units.SI.PressureDifference dpDamRel_nominal=
    dat.damRel.dp_nominal
    "Relief air damper pressure drop";
  final parameter Modelica.Units.SI.PressureDifference dpDamRet_nominal=
    dat.damRet.dp_nominal
    "Return air damper pressure drop";

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"),
      __ctrlFlow(enable=false));

  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true, __ctrlFlow(enable=false));

  Modelica.Fluid.Interfaces.FluidPort_b port_Rel(
    redeclare final package Medium = MediumAir,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
    if typ <> Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.MixedAirNoRelief
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
    annotation (Placement(
      transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,140}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,800})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-800,-800}, {800,800}}),
    graphics={
      Line(
          visible=typFanRet <> Buildings.Templates.Components.Types.Fan.None,
          points={{440,440},{440,576}},
          color={0,0,0}),
      Line(
          visible=typFanRel <> Buildings.Templates.Components.Types.Fan.None,
          points={{-240,440},{-240,570}},
          color={0,0,0}),
      Text(
          extent={{-149,-834},{151,-874}},
          textColor={0,0,255},
          textString="%name"),
      Bitmap(
        visible=typFanRet==Buildings.Templates.Components.Types.Fan.SingleVariable,
        extent={{540,500},{340,700}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Fans/Housed.svg"),
      Bitmap(
        visible=typFanRet==Buildings.Templates.Components.Types.Fan.ArrayVariable,
        extent={{540,500},{340,700}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Fans/Array.svg"),
      Bitmap(
        visible=typFanRet<>Buildings.Templates.Components.Types.Fan.None,
        extent={{358,280},{520,440}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/VFD.svg"),
      Bitmap(
        visible=typDamRel==Buildings.Templates.Components.Types.Damper.TwoPosition,
        extent={{-680,360},{-600,440}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
      Bitmap(
        visible=typDamRel==Buildings.Templates.Components.Types.Damper.Modulating,
        extent={{-680,360},{-600,440}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
              Bitmap(
        extent={{-510,440},{-770,700}},
        visible=typDamRel<>Buildings.Templates.Components.Types.Damper.None,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Dampers/BladesOpposed.svg"),
                Bitmap(
        visible=typFanRel==Buildings.Templates.Components.Types.Fan.SingleVariable,
        extent={{-140,500},{-340,700}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Fans/Propeller.svg"),
              Bitmap(
        visible=typFanRel==Buildings.Templates.Components.Types.Fan.ArrayVariable,
        extent={{-140,500},{-340,700}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Fans/Array.svg"),
      Bitmap(
        visible=typFanRel<>Buildings.Templates.Components.Types.Fan.None,
        extent={{-320,278},{-158,440}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/VFD.svg"),
      Bitmap(
        visible=typ<>Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.HundredPctOutdoorAir,
        extent={{-240,-40},{-160,40}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
      Bitmap(
        extent={{-160,-130},{100,130}},
        visible=typ<>Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.HundredPctOutdoorAir,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Dampers/BladesParallel.svg",
          origin={-30,-30},
          rotation=-90),
      Bitmap(
        extent={{-770,-760},{-510,-500}},
        visible=typDamOut<>Buildings.Templates.Components.Types.Damper.None,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Dampers/BladesParallel.svg"),
      Bitmap(
        visible=typDamOut==Buildings.Templates.Components.Types.Damper.TwoPosition,
        extent={{-680,-840},{-600,-760}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
      Bitmap(
        visible=typDamOut==Buildings.Templates.Components.Types.Damper.Modulating,
        extent={{-680,-840},{-600,-760}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
      Bitmap(
        extent={{-510,-240},{-770,-500}},
        visible=typDamOutMin<>Buildings.Templates.Components.Types.Damper.None,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Dampers/BladesParallel.svg"),
      Bitmap(
        visible=typDamOutMin==Buildings.Templates.Components.Types.Damper.TwoPosition,
        extent={{-680,-240},{-600,-160}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
      Bitmap(
        visible=typDamOutMin==Buildings.Templates.Components.Types.Damper.Modulating,
        extent={{-680,-240},{-600,-160}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
      Line(points={{-100,700},{800,700}}, color={0,0,0}),
      Line(
        visible=typ <> Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.MixedAirNoRelief,
        points={{-800,500},{-100,500}},
        color={0,0,0}),
      Line(
        visible=typ==Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.MixedAirNoRelief,
        points={{-100,700},{-100,500}},
        color={0,0,0}),
      Line(points={{96,500},{796,500}}, color={0,0,0}),
      Line(points={{100,-500},{800,-500}},color={0,0,0}),
      Line(points={{-800,-500},{-100,-500}},color={0,0,0}),
      Line(points={{-800,-700},{800,-700}}, color={0,0,0}),
      Line(
        visible=typ <> Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.HundredPctOutdoorAir,
        points={{100,500},{100,-500}},
        color={0,0,0}),
      Line(
        visible=typ <> Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.HundredPctOutdoorAir,
        points={{-100,500},{-100,-300}},
        color={0,0,0}),
      Line(
        points={{-800,700},{-100,700}},
        color={0,0,0},
        visible=typ <> Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.MixedAirNoRelief),
      Line(
          points={{-100,500},{100,500}},
          color={0,0,0},
          visible=typ == Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.HundredPctOutdoorAir),
      Line(
          points={{-100,-500},{100,-500}},
          color={0,0,0},
          visible=typ == Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.HundredPctOutdoorAir),
      Line(
        points={{-800,-300},{-100,-300}},
        color={0,0,0},
        visible=typDamOutMin <> Buildings.Templates.Components.Types.Damper.None),
      Line(
        points={{-100,-300},{-100,-500}},
        color={0,0,0},
        visible=typDamOutMin == Buildings.Templates.Components.Types.Damper.None and
          typ <> Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.HundredPctOutdoorAir),
      Bitmap(
        visible=typSecOut==Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure,
        extent={{-680,-142},{-600,-62}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/DifferentialPressure.svg"),
      Bitmap(
          visible=typSecOut == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow,
          extent={{-260,-500},{-60,-300}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Sensors/VolumeFlowRateAFMS.svg"),
      Bitmap(
        visible=typSecOut==Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow,
        extent={{-200,-240},{-120,-160}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/VolumeFlowRate.svg"),
      Bitmap(
        visible=typFanRet<>Buildings.Templates.Components.Types.Fan.None and
          typCtlFanRet==Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.AirflowMeasured,
        extent={{580,360},{660,440}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/VolumeFlowRate.svg"),
        Line(points={{664,446}}, color={28,108,200}),
      Bitmap(
        visible=typDamOutMin<>Buildings.Templates.Components.Types.Damper.None,
        extent={{-338,-240},{-258,-160}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/Temperature.svg"),
      Bitmap(
          visible=typDamOutMin <> Buildings.Templates.Components.Types.Damper.None,
          extent={{-400,-240},{-200,-440}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Sensors/ProbeStandard.svg"),
      Bitmap(
        visible=typDamOutMin<>Buildings.Templates.Components.Types.Damper.None and
          (typCtlEco==Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb or
          typCtlEco==Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb),
        extent={{-460,-160},{-380,-240}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/SpecificEnthalpy.svg"),
      Bitmap(
          visible=typDamOutMin <> Buildings.Templates.Components.Types.Damper.None
               and (typCtlEco == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb
               or typCtlEco == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb),
          extent={{-520,-240},{-320,-440}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Sensors/ProbeStandard.svg"),
      Bitmap(
        visible=typDamOutMin==Buildings.Templates.Components.Types.Damper.None,
        extent={{-340,-840},{-260,-760}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/Temperature.svg"),
      Bitmap(
          visible=typDamOutMin == Buildings.Templates.Components.Types.Damper.None,
          extent={{-400,-760},{-200,-560}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Sensors/ProbeStandard.svg"),
      Bitmap(
        visible=typDamOutMin==Buildings.Templates.Components.Types.Damper.None and
          (typCtlEco==Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb or
          typCtlEco==Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb),
        extent={{-460,-840},{-380,-760}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/SpecificEnthalpy.svg"),
      Bitmap(
          visible=typDamOutMin == Buildings.Templates.Components.Types.Damper.None
               and (typCtlEco == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb
               or typCtlEco == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb),
          extent={{-520,-760},{-320,-560}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Sensors/ProbeStandard.svg"),
      Bitmap(
          visible=typSecOut == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.SingleDamper,
          extent={{-260,-700},{-60,-500}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Sensors/VolumeFlowRateAFMS.svg"),
      Bitmap(
        visible=typSecOut==Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.SingleDamper,
        extent={{-200,-840},{-120,-760}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/VolumeFlowRate.svg"),
      Bitmap(
          visible=typFanRet <> Buildings.Templates.Components.Types.Fan.None
               and typCtlFanRet == Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.BuildingPressure,
          extent={{260,760},{340,840}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Sensors/DifferentialPressure.svg"),
        Line(
          points={{-160,-700},{-160,-760}},
          color={0,0,0},
          visible=typSecOut == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.SingleDamper),
        Line(
          points={{-160,-238},{-160,-300}},
          color={0,0,0},
          visible=typSecOut == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow),
        Polygon(
          points={{260,805},{220,805},{220,660},{230,660},{230,795},{260,795},{
              260,805}},
          lineColor={0,0,0},
          visible=typFanRet <> Buildings.Templates.Components.Types.Fan.None
               and typCtlFanRet == Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.BuildingPressure),
        Polygon(
          points={{492,605},{625,605},{625,440},{615,440},{615,595},{492,595},{
              492,605}},
          lineColor={0,0,0},
          visible=typFanRet <> Buildings.Templates.Components.Types.Fan.None
               and typCtlFanRet == Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.AirflowMeasured),
        Rectangle(
          extent={{340,805},{380,795}},
          lineColor={0,0,0},
          visible=typFanRet <> Buildings.Templates.Components.Types.Fan.None
               and typCtlFanRet == Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.BuildingPressure),
        Polygon(
          points={{-680,-95},{-725,-95},{-725,-340},{-715,-340},{-715,-105},{-680,
              -105},{-680,-95}},
          lineColor={0,0,0},
          visible=typSecOut == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure),
        Polygon(
          points={{-600,-95},{-555,-95},{-555,-340},{-565,-340},{-565,-105},{-600,
              -105},{-600,-95}},
          lineColor={0,0,0},
          visible=typSecOut == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure)}),
   Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},{180,140}})),
    Documentation(info="<html>
<p>
This class provides a standard interface for the outdoor/relief/return
air section of an air handler.
Typical components in that section include
</p>
<ul>
<li>
shut off dampers,
</li>
<li>
the heat recovery unit,
</li>
<li>
the air economizer,
</li>
<li>
the relief or return fan.
</li>
</ul>
</html>"));

end PartialOutdoorReliefReturnSection;
