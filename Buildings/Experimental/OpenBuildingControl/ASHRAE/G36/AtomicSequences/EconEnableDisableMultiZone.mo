within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences;
block EconEnableDisableMultiZone "Economizer enable/disable switch"

  parameter Boolean fixEnt = true
    "Set to true if there is an enthalpy sensor and the economizer uses fixed enthalpy + fixed dry bulb temperature sensors";
  parameter Real delTemHis(unit="K", displayUnit="degC", quantity="Temperature")=1
    "Delta between the temperature hysteresis high and low limit";
  parameter Real delEntHis(unit="J/kg", displayUnit="kJ/kg", quantity="SpecificEnthalpy")=1000
    "Delta between the enthalpy hysteresis high and low limit"
    annotation(Evaluate=true, Dialog(group="Enthalpy sensor in use", enable = fixEnt));
  parameter Real uTemHigLimCutHig(final unit="K", displayUnit="degC") = 0
    "Hysteresis high limit cutoff, refering to the delta between the cutoff and the outdoor conditions 
    [fixme: maybe we don't need to expose these limits, revise all once the sequence runs ok]";
  parameter Real uTemHigLimCutLow(final unit="K", displayUnit="degC") = uTemHigLimCutHig - delTemHis
    "Hysteresis low limit cutoff, refering to the delta between the cutoff and the outdoor conditions";
  parameter Real uEntHigLimCutHig(unit="J/kg", displayUnit="kJ/kg", quantity="SpecificEnthalpy") = 0
    "Hysteresis high limit cutoff, refering to the delta between the cutoff and the outdoor conditions"
    annotation(Evaluate=true, Dialog(group="Enthalpy sensor in use", enable = fixEnt));
  parameter Real uEntHigLimCutLow(unit="J/kg", displayUnit="kJ/kg", quantity="SpecificEnthalpy") = uEntHigLimCutHig - delEntHis
    "Hysteresis low limit cutoff, refering to the delta between the cutoff and the outdoor conditions"
    annotation(Evaluate=true, Dialog(group="Enthalpy sensor in use", enable = fixEnt));
  parameter Modelica.SIunits.Time retDamFullyOpenTime = 180
    "Per G36 as the economizer disables the return air damper opens fully for this period of time before modulating 
    back to the min OA maximum, in order to avoid pressure fluctuations.";
  parameter Modelica.SIunits.Time smallDisDel = 15
    "Per G36 the outdoor air damper can switch to its minimal position only a short time period after the disable 
    signal got activated. The return air damper gets fully open before that in order to prevent pressure fluctuations";

  CDL.Logical.Constant fixedEntSwitch(k=fixEnt)
    "Set to true if there is an enthalpy sensor and the economizer uses fixed enthalpy + fixed dry bulb temperature sensors. 
    Defaults to true, set to false if only the outdoor air dry bulb temperature sensor is implemented. 
    [fixme: harmonize with issue #777]"
    annotation (Placement(transformation(extent={{100,180},{120,200}})));
  CDL.Continuous.Constant openRetDam(k=retDamFullyOpenTime)
    "Keep return damper open to its physical maximum for a short period of time before closing the outdoor air damper 
    and resuming the maximum return air damper position, per G36 Part N7"
    annotation (Placement(transformation(extent={{-20,-230},{0,-210}})));
  CDL.Continuous.Constant disableDelay(final k=smallDisDel)
    "Small delay before closing the outdoor air damper, per G36 Part N7"
    annotation (Placement(transformation(extent={{-20,-160},{0,-140}})));

  CDL.Interfaces.RealInput TOut(unit="K", displayUnit="degC", quantity = "Temperature")
    "Outdoor temperature"
    annotation (Placement(transformation(extent={{-220,180},{-180,220}}),
        iconTransformation(extent={{-120,90},{-100,110}})));
  CDL.Interfaces.RealInput hOut(unit="J/kg", displayUnit="kJ/kg", quantity="SpecificEnthalpy") if fixEnt
    "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-220,100},{-180,140}}),
        iconTransformation(extent={{-120,50},{-100,70}})));
  CDL.Interfaces.RealInput TOutCut(unit="K", displayUnit="degC")
    "Outdoor temperature high limit cutoff [fixme: see #777]" annotation (
      Placement(transformation(extent={{-220,140},{-180,180}}),
        iconTransformation(extent={{-120,70},{-100,90}})));
  CDL.Interfaces.RealInput hOutCut(unit="J/kg", displayUnit="kJ/kg") if fixEnt
    "Outdoor enthalpy high limit cutoff [fixme: see #777]"
    annotation (Placement(transformation(extent={{-220,60},{-180,100}}),
        iconTransformation(extent={{-120,30},{-100,50}})));
  CDL.Interfaces.RealInput uOutDamPosMin(min=0, max=1)
    "Minimal economizer damper position, as calculated in the EconDamperPositionLimitsMultiZone sequence."
    annotation (Placement(transformation(extent={{-220,-220},{-180,-180}}),
        iconTransformation(extent={{-120,-50},{-100,-30}})));
  CDL.Interfaces.RealInput uOutDamPosMax(min=0, max=1)
    "Maximum economizer damper position, as calculated in the EconDamperPositionLimitsMultiZone sequence."
    annotation (Placement(transformation(extent={{-220,-190},{-180,-150}}),
        iconTransformation(extent={{-120,-30},{-100,-10}})));
  CDL.Interfaces.RealInput uRetDamPosMax(min=0, max=1)
    "Maximum return air damper position as calculated in the EconDamperPositionLimitsMultiZone sequence"
    annotation (Placement(transformation(extent={{-220,-290},{-180,-250}}),
        iconTransformation(extent={{-120,-90},{-100,-70}})));
  CDL.Interfaces.RealInput uRetDamPosMin(min=0, max=1)
    "Minimum return air damper position as calculated in the EconDamperPositionLimitsMultiZone sequence" annotation (
      Placement(transformation(extent={{-220,-320},{-180,-280}}), iconTransformation(extent={{-120,-110},{-100,-90}})));
  CDL.Interfaces.RealInput uRetDamPhyPosMax(min=0, max=1)
    "Physical or at the comissioning fixed maximum opening of the return air damper. Connects to the damper limit sequence output"
    annotation (Placement(transformation(extent={{-220,-260},{-180,-220}}),
        iconTransformation(extent={{-120,-70},{-100,-50}})));

  CDL.Interfaces.RealOutput yOutDamPosMax
    "Output sets maximum allowable economizer damper position. Fixme: Should this remain as type real? Output can take two values: disable = yOutDamPosMin and enable = yOutDamPosMax."
    annotation (Placement(transformation(extent={{180,-190},{200,-170}}),
        iconTransformation(extent={{100,40},{140,80}})));
  CDL.Interfaces.RealOutput yRetDamPosMin
    "Output sets the min return air damper position, which is affected for a short period of time upon disabling the economizer"
    annotation (Placement(transformation(extent={{180,-300},{200,-280}}),
        iconTransformation(extent={{100,-100},{140,-60}})));
  CDL.Interfaces.RealOutput yRetDamPosMax
    "Output sets the max return air damper position, which is affected for a short period of time upon disabling the economizer"
    annotation (Placement(transformation(
          extent={{180,-260},{200,-240}}), iconTransformation(extent={{100,-40},{140,0}})));

  CDL.Logical.Hysteresis hysOutTem(                             uHigh=uTemHigLimCutHig, uLow=
        uTemHigLimCutLow)
    "Close damper when TOut is above the uTemHigh, open it again only when TOut drops to uTemLow [fixme: I'm using the same offset 
    for hysteresis regardless of the region and standard]"
    annotation (Placement(transformation(extent={{-100,170},{-80,190}})));
  CDL.Logical.Hysteresis hysOutEnt(final uLow=uEntHigLimCutLow, uHigh=
        uEntHigLimCutHig)
    "Close damper when hOut is above the uEntHigh, open it again only when hOut drops to uEntLow [fixme: I'm using the same offset 
    for hysteresis regardless of the region and standard, see del***His parameters]"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));

  CDL.Logical.Switch OutDamSwitch "If any of the conditions provided by TOut and FreezeProtectionStatus inputs are violating the enable status, the max outdoor 
    damper position is set to the minimum." annotation (Placement(transformation(extent={{80,-190},{100,-170}})));
  CDL.Logical.Switch RetDamSwitch
    "If any of the conditions provided by TOut and FreezeProtectionStatus inputs are violating the enable status, 
    the max outdoor damper position is set to the minimum." annotation (Placement(transformation(extent={{0,-310},{20,-290}})));
  CDL.Logical.Switch MaxRetDamSwitch "If any of the conditions provided by TOut and FreezeProtectionStatus inputs are violating the enable status, 
    the max outdoor damper position is set to the minimum." annotation (Placement(transformation(extent={{80,-260},{100,-240}})));
  CDL.Logical.Switch MinRetDamSwitch "If any of the conditions provided by TOut and FreezeProtectionStatus inputs are violating the enable status, 
    the max outdoor damper position is set to the minimum." annotation (Placement(transformation(extent={{80,-300},{100,-280}})));
  CDL.Logical.Composite.OnOffHold OnOffDelay(holdDuration=600) "10 min on/off delay"
              annotation (Placement(transformation(extent={{0,130},{20,150}})));
  CDL.Logical.GreaterEqual greEqu
    annotation (Placement(transformation(extent={{40,-150},{60,-130}})));
  CDL.Logical.Timer timer
    annotation (Placement(transformation(extent={{80,-110},{100,-90}})));
  CDL.Logical.Nor or2
    annotation (Placement(transformation(extent={{-40,130},{-20,150}})));
  CDL.Continuous.Constant deltaTemHis(k=delTemHis)
    "Delta between the temperature hysteresis high and low limit. delTemHis = uTemHigLimCutHig - uTemHigLimCutLow "
    annotation (Placement(transformation(extent={{140,180},{160,200}})));
  CDL.Continuous.Constant deltaEntHis(k=delEntHis)
    "Delta between the enthalpy hysteresis high and low limit. delEntHis = uEntHigLimCutHig - uTemEntLimCutLow "
    annotation (Placement(transformation(extent={{140,140},{160,160}})));
  CDL.Continuous.Add add2(k2=-1)
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  CDL.Continuous.Add add1(k2=-1)
    annotation (Placement(transformation(extent={{-140,170},{-120,190}})));
  CDL.Logical.Not not2 annotation (Placement(transformation(extent={{40,-110},{60,-90}})));
  CDL.Logical.Less les1 annotation (Placement(transformation(extent={{40,-230},{60,-210}})));
  CDL.Logical.And3 andEnaDis annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  CDL.Interfaces.IntegerInput uFreProSta "Freeze Protection Status" annotation (Placement(
        transformation(extent={{-220,-10},{-180,30}}),    iconTransformation(extent={{-120,10},{-100,30}})));
  CDL.Conversions.IntegerToReal intToRea
    annotation (Placement(transformation(extent={{-160,0},{-140,20}})));
  CDL.Logical.LessEqualThreshold equ(final threshold=threshold)
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  parameter Real threshold=0 "Comparison with respect to threshold";
  CDL.Interfaces.IntegerInput uZoneState "Zone state input (0=Heating, 1=Deadband, 2=Cooling)"
    annotation (Placement(transformation(extent={{-220,-70},{-180,-30}}), iconTransformation(extent={{-120,-10},{-100,10}})));
  CDL.Conversions.IntegerToReal intToRea1
    annotation (Placement(transformation(extent={{-160,-60},{-140,-40}})));
  CDL.Logical.GreaterThreshold greThr "Heating = 0" annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));

  CDL.Logical.GreaterThreshold greThr2(threshold=0) annotation (Placement(transformation(extent={{80,-230},{100,-210}})));
  CDL.Logical.And and2 annotation (Placement(transformation(extent={{124,-230},{144,-210}})));

equation
  connect(OutDamSwitch.y, yOutDamPosMax) annotation (Line(points={{101,-180},{101,-180},{190,-180}}, color={0,0,127}));
  connect(TOut, add1.u1) annotation (Line(points={{-200,200},{-170,200},{-170,186},{-142,186}},
        color={0,0,127}));
  connect(TOutCut, add1.u2) annotation (Line(points={{-200,160},{-170,160},{-170,174},{-142,174}},
        color={0,0,127}));
  connect(add1.y, hysOutTem.u) annotation (Line(points={{-119,180},{-102,180}}, color={0,0,127}));
  connect(hOut, add2.u1) annotation (Line(points={{-200,120},{-160,120},{-160,106},{-142,106}},
        color={0,0,127}));
  connect(hOutCut, add2.u2)
    annotation (Line(points={{-200,80},{-160,80},{-160,94},{-142,94}}, color={0,0,127}));
  connect(add2.y, hysOutEnt.u) annotation (Line(points={{-119,100},{-102,100}}, color={0,0,127}));
  connect(hysOutTem.y, or2.u1) annotation (Line(points={{-79,180},{-60,180},{-60,140},{-42,140}},
        color={255,0,255}));
  connect(hysOutEnt.y, or2.u2) annotation (Line(points={{-79,100},{-60,100},{-60,132},{-42,132}},
        color={255,0,255}));
  connect(disableDelay.y, greEqu.u2)
    annotation (Line(points={{1,-150},{10,-150},{10,-148},{38,-148}},
                                                              color={0,0,127}));
  connect(timer.y, greEqu.u1) annotation (Line(points={{101,-100},{110,-100},{110,-120},{20,-120},{20,-140},{38,-140}},
                   color={0,0,127}));
  connect(greEqu.y, OutDamSwitch.u2) annotation (Line(points={{61,-140},{72,-140},{72,-180},{78,-180}}, color={255,0,255}));
  connect(uOutDamPosMin, OutDamSwitch.u1)
    annotation (Line(points={{-200,-200},{-80,-200},{-80,-186},{0,-186},{0,-172},{78,-172}}, color={0,0,127}));
  connect(uOutDamPosMax, OutDamSwitch.u3)
    annotation (Line(points={{-200,-170},{-40,-170},{-40,-188},{78,-188}}, color={0,0,127}));
  connect(uRetDamPhyPosMax, MaxRetDamSwitch.u1)
    annotation (Line(points={{-200,-240},{-40,-240},{-40,-242},{78,-242}}, color={0,0,127}));
  connect(uRetDamPosMax, MaxRetDamSwitch.u3)
    annotation (Line(points={{-200,-270},{-30,-270},{-30,-258},{78,-258}}, color={0,0,127}));
  connect(timer.y, les1.u1) annotation (Line(points={{101,-100},{120,-100},{120,-200},{20,-200},{20,-220},{38,-220}},
                     color={0,0,127}));
  connect(or2.y, OnOffDelay.u)
    annotation (Line(points={{-19,140},{-1.2,140}}, color={255,0,255}));
  connect(OnOffDelay.y, andEnaDis.u1) annotation (Line(points={{21,140},{30,140},{30,8},{38,8}}, color={255,0,255}));
  connect(andEnaDis.y, not2.u)
    annotation (Line(points={{61,0},{80,0},{80,-60},{20,-60},{20,-100},{38,-100}}, color={255,0,255}));
  connect(MinRetDamSwitch.y, yRetDamPosMin) annotation (Line(points={{101,-290},{190,-290}}, color={0,0,127}));
  connect(MaxRetDamSwitch.y, yRetDamPosMax) annotation (Line(points={{101,-250},{190,-250}}, color={0,0,127}));
  connect(openRetDam.y, les1.u2)
    annotation (Line(points={{1,-220},{10,-220},{10,-228},{38,-228}}, color={0,0,127}));
  connect(not2.y, timer.u) annotation (Line(points={{61,-100},{78,-100}},           color={255,0,255}));
  connect(uFreProSta, intToRea.u) annotation (Line(points={{-200,10},{-200,10},{-162,10}}, color={255,127,0}));
  connect(intToRea.y, equ.u) annotation (Line(points={{-139,10},{-134,10},{-122,10}}, color={0,0,127}));
  connect(equ.y, andEnaDis.u2) annotation (Line(points={{-99,10},{-62,10},{-20,10},{-20,0},{38,0}}, color={255,0,255}));
  connect(uZoneState, intToRea1.u) annotation (Line(points={{-200,-50},{-182,-50},{-162,-50}}, color={255,127,0}));
  connect(intToRea1.y, greThr.u) annotation (Line(points={{-139,-50},{-134,-50},{-130,-50},{-122,-50}}, color={0,0,127}));
  connect(greThr.y, andEnaDis.u3) annotation (Line(points={{-99,-50},{-20,-50},{-20,-8},{38,-8}}, color={255,0,255}));
  connect(les1.y, and2.u1)
    annotation (Line(points={{61,-220},{70,-220},{70,-236},{86,-236},{116,-236},{116,-220},{122,-220}}, color={255,0,255}));
  connect(greThr2.y, and2.u2) annotation (Line(points={{101,-220},{112,-220},{112,-228},{122,-228}}, color={255,0,255}));
  connect(and2.y, MaxRetDamSwitch.u2)
    annotation (Line(points={{145,-220},{152,-220},{152,-270},{60,-270},{60,-250},{78,-250}}, color={255,0,255}));
  connect(and2.y, MinRetDamSwitch.u2)
    annotation (Line(points={{145,-220},{152,-220},{152,-270},{60,-270},{60,-290},{78,-290}}, color={255,0,255}));
  connect(timer.y, greThr2.u)
    annotation (Line(points={{101,-100},{130,-100},{130,-200},{74,-200},{74,-220},{78,-220}}, color={0,0,127}));
  connect(not2.y, RetDamSwitch.u2) annotation (Line(points={{61,-100},{68,-100},{68,-128},{-30,-128},{-30,-250},{-16,-250},{-16,-300},
          {-2,-300}}, color={255,0,255}));
  connect(uRetDamPosMax, RetDamSwitch.u1)
    annotation (Line(points={{-200,-270},{-102,-270},{-102,-292},{-2,-292}}, color={0,0,127}));
  connect(uRetDamPosMin, RetDamSwitch.u3)
    annotation (Line(points={{-200,-300},{-100,-300},{-100,-308},{-2,-308}}, color={0,0,127}));
  connect(RetDamSwitch.y, MinRetDamSwitch.u3)
    annotation (Line(points={{21,-300},{50,-300},{50,-298},{78,-298}}, color={0,0,127}));
  connect(uRetDamPhyPosMax, MinRetDamSwitch.u1)
    annotation (Line(points={{-200,-240},{-62,-240},{-62,-282},{78,-282}}, color={0,0,127}));
  annotation (
    Icon(graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-2,60},{78,60}},
          color={28,108,200},
          thickness=0.5),
        Text(
          extent={{104,110},{432,82}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yOutDamPosMax"),
        Line(
          points={{-82,-64},{-2,-64},{-2,60}},
          color={28,108,200},
          thickness=0.5),
        Text(
          extent={{-164,154},{164,116}},
          lineColor={85,0,255},
          textString="EnableDisable"),
        Text(
          extent={{68,32},{468,4}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yRetDamPosMax"),
        Text(
          extent={{-240,104},{88,76}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="T"),
        Text(
          extent={{-238,64},{90,36}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="h"),
        Text(
          extent={{-148,-16},{180,-44}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="OutDamPos"),
        Text(
          extent={{-148,-62},{180,-90}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="RetDamPos"),
        Text(
          extent={{-196,24},{132,-4}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="FrePro"),
        Text(
          extent={{64,-28},{464,-56}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yRetDamPosMin")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-180,-320},{180,240}},
        initialScale=0.1), graphics={Text(
          extent={{-170,54},{-90,38}},
          lineColor={28,108,200},
          textString="Outdoor air conditions"),
        Rectangle(extent={{-180,240},{180,40}}, lineColor={28,108,200}),
        Rectangle(extent={{-180,40},{180,-20}}, lineColor={28,108,200}),
        Rectangle(extent={{-180,-80},{180,-320}}, lineColor={28,108,200}),
                                     Text(
          extent={{108,30},{220,16}},
          lineColor={28,108,200},
          fontSize=12,
          horizontalAlignment=TextAlignment.Left,
          textString="Freeze protection 
conditions"),                        Text(
          extent={{-170,-86},{-52,-124}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="Enable-disable damper limit 
assignments with time delays 
per G36 PART5.N.7"),
        Rectangle(extent={{-180,-20},{180,-80}},lineColor={28,108,200}),
                                     Text(
          extent={{110,-24},{222,-38}},
          lineColor={28,108,200},
          textString="Zone State - disable 
when in heating",
          horizontalAlignment=TextAlignment.Left)}),
    Documentation(info="<html>      
             <p>
             implementation fixme: 10 min delay
             - pg. 119 - Ret damper position when disabled: before releasing 
             the return air damper to be controled by the minimum air req 
             (EconDamPosLimits): open fully, wait 15 sec MaxOA-P = MinOA-P,
             wait 3 min after that and release ret dam for EconDamPosLimits
             control.
             </p>   
             <p>
             This sequence enables or disables the economizer based on 
             conditions provided in G36 PART5.N.7.           
  Fixme: There might be a need to convert this block in a generic enable-disable
  control block that receives one or more hysteresis conditions, one or more 
  timed conditions, and one or more additional boolean signal conditions. For 
  now, the block is implemented as economizer enable-disable control block, an
  atomic sequence which is a part in the economizer control composite sequence.
  </p>
  <p>
  The economizer enable-disable sequence implements conditions from 
  ASHRAE guidline 36 (G36) as listed on the state machine diagram below. The 
  sequence output is binary, it either sets the economizer damper position to
  its high (yOutDamPosMax) or to its low limit (yOutDamPosMin).
  </p>
<p>
Fixme: Edit conditions based on any additional stakeholder input, e.g. include
space averaged MAT sensor output.
</p>
<p>
Fixme - feature related issues: Delay placement - 10 min delay right before
this block's output should cover this condition, since listed in G36; 
test excluding hysteresis by simply setting the delta parameter to 0. 
Notes: Delay seems to replace hysteresis in practice, 
at least based on our current project partners input.
</p>
<p align=\"center\">
<img alt=\"Image of economizer enable-disable state machine chart\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/EconHighLimitLockout.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
March 31, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end EconEnableDisableMultiZone;
