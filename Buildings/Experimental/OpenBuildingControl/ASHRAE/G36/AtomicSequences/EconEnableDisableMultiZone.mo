within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences;
block EconEnableDisableMultiZone "Economizer enable/disable switch"

  parameter Types.FreezeProtectionStage freProDisabled = Types.FreezeProtectionStage.stage0
    "Indicates that the freeze protection is disabled";
  parameter Real freProDisabledNum = Integer(freProDisabled)-1
    "Numerical value indicating that the freeze protection is disabled (=0)";

  parameter Types.ZoneState heating = Types.ZoneState.heating
    "Indicates that the freeze protection is disabled";
  parameter Real heatingNum = Integer(heating)
    "Numerical value for heating zone state (=1)";

  parameter Boolean fixEnt = true
    "Set to true if there is an enthalpy sensor and the economizer uses fixed enthalpy 
    in addition to fixed dry bulb temperature sensors";
  parameter Real delTemHis(unit="K", quantity="TermodynamicTemperature")=1
    "Delta between the temperature hysteresis high and low limit";
  parameter Real delEntHis(unit="J/kg", quantity="SpecificEnergy")=1000
    "Delta between the enthalpy hysteresis high and low limit"
    annotation(Evaluate=true, Dialog(group="Enthalpy sensor in use", enable = fixEnt));
  parameter Real uTemHigLimCutHig(final unit="K", quantity = "ThermodynamicTemperature") = 0
    "Hysteresis block high limit cutoff (the delta between the 
    cutoff and the outdoor temperature)";
  parameter Real uTemHigLimCutLow(
    final unit="K", quantity = "ThermodynamicTemperature") = uTemHigLimCutHig - delTemHis
    "Hysteresis block low limit cutoff (the delta between the cutoff 
    and the outdoor temperature)";
  parameter Real uEntHigLimCutHig(final unit="J/kg", quantity="SpecificEnergy") = 0
    "Hysteresis block high limit cutoff (the delta between the 
    cutoff and the outdoor enthalpy)";
  parameter Real uEntHigLimCutLow(
    final unit="J/kg", quantity="SpecificEnergy") = uEntHigLimCutHig - delEntHis
    "Hysteresis block low limit cutoff (the delta between the cutoff 
    and the outdoor temperature)";
  parameter Modelica.SIunits.Time retDamFullyOpenTime = 180
    "Per G36, as the economizer gets disabled, the return air damper opens fully for this 
    period of time before modulating back to the min OA maximum, in order to avoid pressure 
    fluctuations";
  parameter Modelica.SIunits.Time smallDisDel = 15
    "Per G36, the outdoor air damper can switch to its minimal position only this time period 
    after the disable signal got activated. The return air damper gets fully open before that 
    in order to prevent pressure fluctuations";

  CDL.Continuous.Constant openRetDam(k=retDamFullyOpenTime)
    "Keep return damper open to its physical maximum for a short period of time before closing the outdoor air damper
    and resuming the maximum return air damper position, per G36 Part N7"
    annotation (Placement(transformation(extent={{-20,-230},{0,-210}})));
  CDL.Continuous.Constant disableDelay(final k=smallDisDel)
    "Small delay before closing the outdoor air damper, per G36 Part N7"
    annotation (Placement(transformation(extent={{-20,-160},{0,-140}})));

  CDL.Interfaces.RealInput TOut(unit="K", quantity = "ThermodynamicTemperature") "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-220,210},{-180,250}}),
        iconTransformation(extent={{-120,90},{-100,110}})));
  CDL.Interfaces.RealInput hOut(unit="J/kg", quantity="SpecificEnergy") if fixEnt
      "Outdoor air enthalpy"
      annotation (Placement(transformation(extent={{-220,130},{-180,170}}),
        iconTransformation(extent={{-120,50},{-100,70}})));   //fixme quantities see bui.flui.sens for info
  CDL.Interfaces.RealInput TOutCut(unit="K", quantity = "ThermodynamicTemperature")
    "Outdoor temperature high limit cutoff. For differential dry bulb temeprature condition use return air temperature measurement"
      annotation (Placement(transformation(extent={{-220,170},{-180,210}}),
        iconTransformation(extent={{-120,70},{-100,90}})));
  CDL.Interfaces.RealInput hOutCut(unit="J/kg") if fixEnt
    "Outdoor enthalpy high limit cutoff. For differential enthalpy use return air enthalpy measurement"
    annotation (Placement(transformation(extent={{-220,90},{-180,130}}),
        iconTransformation(extent={{-120,30},{-100,50}})));
  CDL.Interfaces.RealInput uOutDamPosMin(min=0, max=1)
    "Minimal economizer damper position, as calculated in the EconDamperPositionLimitsMultiZone sequence."
    annotation (Placement(transformation(extent={{-220,-220},{-180,-180}}),
        iconTransformation(extent={{-120,-70},{-100,-50}})));
  CDL.Interfaces.RealInput uOutDamPosMax(min=0, max=1)
    "Maximum economizer damper position, as calculated in the EconDamperPositionLimitsMultiZone sequence."
    annotation (Placement(transformation(extent={{-220,-190},{-180,-150}}),
        iconTransformation(extent={{-120,-50},{-100,-30}})));
  CDL.Interfaces.RealInput uRetDamPosMax(min=0, max=1)
    "Maximum return air damper position as calculated in the EconDamperPositionLimitsMultiZone sequence"
    annotation (Placement(transformation(extent={{-220,-290},{-180,-250}}),
        iconTransformation(extent={{-120,-110},{-100,-90}})));
  CDL.Interfaces.RealInput uRetDamPosMin(min=0, max=1)
    "Minimum return air damper position as calculated in the EconDamperPositionLimitsMultiZone sequence" annotation (
      Placement(transformation(extent={{-220,-320},{-180,-280}}), iconTransformation(extent={{-120,
            -130},{-100,-110}})));
  CDL.Interfaces.RealInput uRetDamPhyPosMax(min=0, max=1)
    "Physical or at the comissioning fixed maximum opening of the return air damper. Connects to the damper limit sequence output"
    annotation (Placement(transformation(extent={{-220,-260},{-180,-220}}),
        iconTransformation(extent={{-120,-90},{-100,-70}})));

  CDL.Interfaces.BooleanInput uSupFan "Supply fan on/off status"
    annotation (Placement(transformation(extent={{-220,50},{-180,90}}),
        iconTransformation(extent={{-120,-30},{-100,-10}})));

  CDL.Interfaces.RealOutput yOutDamPosMax
    "Output sets maximum allowable economizer damper position. Fixme: Should this remain as type real? Output can take two values: disable = yOutDamPosMin and enable = yOutDamPosMax."
    annotation (Placement(transformation(extent={{180,-190},{200,-170}}),
        iconTransformation(extent={{100,28},{140,68}})));
  CDL.Interfaces.RealOutput yRetDamPosMin
    "Output sets the min return air damper position, which is affected for a short period of time upon disabling the economizer"
    annotation (Placement(transformation(extent={{180,-300},{200,-280}}),
        iconTransformation(extent={{100,-100},{140,-60}})));
  CDL.Interfaces.RealOutput yRetDamPosMax
    "Output sets the max return air damper position, which is affected for a short period of time upon disabling the economizer"
    annotation (Placement(transformation(
          extent={{180,-260},{200,-240}}), iconTransformation(extent={{100,-40},{140,0}})));

  CDL.Interfaces.IntegerInput uZoneState "Zone state input (integer, see Types for values)"
    annotation (Placement(transformation(extent={{-220,-70},{-180,-30}}), iconTransformation(extent={{-120,-10},{-100,10}})));
  CDL.Interfaces.IntegerInput uFreProSta "Freeze Protection Status" annotation (Placement(
        transformation(extent={{-220,-10},{-180,30}}), iconTransformation(extent={{-120,10},{-100,30}})));

  CDL.Logical.Hysteresis hysOutTem(uHigh=uTemHigLimCutHig, uLow=uTemHigLimCutLow)
    "Close damper when TOut is above the uTemHigh, open it again only when TOut drops to uTemLow [fixme: I'm using the same offset
    for hysteresis regardless of the region and standard]"
    annotation (Placement(transformation(extent={{-100,200},{-80,220}})));
  CDL.Logical.Hysteresis hysOutEnt(final uLow=uEntHigLimCutLow, uHigh=uEntHigLimCutHig) if fixEnt
    "Close damper when hOut is above the uEntHigh, open it again only when hOut drops to uEntLow [fixme: I'm using the same offset
    for hysteresis regardless of the region and standard, see del***His parameters]"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));

  CDL.Logical.Switch OutDamSwitch "If any of the conditions provided by TOut and FreezeProtectionStatus inputs are violating the enable status, the max outdoor
    damper position is set to the minimum." annotation (Placement(transformation(extent={{80,-190},{100,-170}})));
  CDL.Logical.Switch RetDamSwitch
    "If any of the conditions provided by TOut and FreezeProtectionStatus inputs are violating the enable status,
    the max outdoor damper position is set to the minimum." annotation (Placement(transformation(extent={{0,-310},{20,-290}})));
  CDL.Logical.Switch MaxRetDamSwitch "If any of the conditions provided by TOut and FreezeProtectionStatus inputs are violating the enable status,
    the max outdoor damper position is set to the minimum." annotation (Placement(transformation(extent={{80,-260},{100,-240}})));
  CDL.Logical.Switch MinRetDamSwitch "If any of the conditions provided by TOut and FreezeProtectionStatus inputs are violating the enable status,
    the max outdoor damper position is set to the minimum." annotation (Placement(transformation(extent={{80,-300},{100,-280}})));
  CDL.Logical.TrueFalseHold TrueFalseHold(duration=600) "10 min on/off delay"
    annotation (Placement(transformation(extent={{0,160},{20,180}})));
  CDL.Logical.GreaterEqual greEqu "Logical greater or equal block"
    annotation (Placement(transformation(extent={{40,-150},{60,-130}})));
  CDL.Logical.Timer timer "Timer gets started as the economizer gets disabled"
    annotation (Placement(transformation(extent={{80,-110},{100,-90}})));
  CDL.Logical.Nor nor1 "Logical nor"
    annotation (Placement(transformation(extent={{-40,160},{-20,180}})));
  CDL.Continuous.Add add2(k2=-1) if fixEnt "Add block"
    annotation (Placement(transformation(extent={{-140,120},{-120,140}})));
  CDL.Continuous.Add add1(k2=-1) "Add block"
    annotation (Placement(transformation(extent={{-140,200},{-120,220}})));
  CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{40,-110},{60,-90}})));
  CDL.Logical.Less les1 "Logical less"
    annotation (Placement(transformation(extent={{40,-230},{60,-210}})));
  CDL.Logical.And3 andEnaDis "Logical and"
   annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  CDL.Conversions.IntegerToReal intToRea "Integer to real converter"
    annotation (Placement(transformation(extent={{-160,0},{-140,20}})));
  CDL.Conversions.IntegerToReal intToRea1 "Integer to real converter"
    annotation (Placement(transformation(extent={{-160,-60},{-140,-40}})));

  CDL.Logical.LessEqualThreshold equ(final threshold=freProDisabledNum)
    "Logical block to check if the freeze protection is deactivated"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  CDL.Logical.GreaterThreshold greThr(final threshold=heatingNum) "Check if ZoneState is other than heating"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  CDL.Logical.GreaterThreshold greThr2(final threshold=0) "Check if the timer got started"
    annotation (Placement(transformation(extent={{80,-230},{100,-210}})));
  CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{120,-230},{140,-210}})));
  CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  CDL.Logical.Constant entSubst(final k=false) if not fixEnt
    "Deactivates outdoor air enthalpy condition in case that there is no fixed enthalpy measurement."
    annotation (Placement(transformation(extent={{-100,150},{-80,170}})));

equation
  connect(OutDamSwitch.y, yOutDamPosMax) annotation (Line(points={{101,-180},{101,-180},{190,-180}}, color={0,0,127}));
  connect(TOut, add1.u1) annotation (Line(points={{-200,230},{-160,230},{-160,216},{-142,216}},
        color={0,0,127}));
  connect(TOutCut, add1.u2) annotation (Line(points={{-200,190},{-160,190},{-160,204},{-142,204}},
        color={0,0,127}));
  connect(add1.y, hysOutTem.u) annotation (Line(points={{-119,210},{-102,210}}, color={0,0,127}));
  connect(hOut, add2.u1) annotation (Line(points={{-200,150},{-160,150},{-160,
          136},{-142,136}},
        color={0,0,127}));
  connect(hOutCut, add2.u2)
    annotation (Line(points={{-200,110},{-160,110},{-160,124},{-142,124}},
                                                                       color={0,0,127}));
  connect(add2.y, hysOutEnt.u) annotation (Line(points={{-119,130},{-102,130}}, color={0,0,127}));
  connect(hysOutTem.y, nor1.u1) annotation (Line(points={{-79,210},{-60,210},{
          -60,170},{-42,170}},                                                                     color={255,0,255}));
  if fixEnt then
    connect(hysOutEnt.y, nor1.u2)
      annotation (Line(points={{-79,130},{-60,130}, {-60,162},{-42,162}}, color={255,0,255}));
  else
    connect(entSubst.y, nor1.u2) annotation (Line(points={{-79,160},{-60,160},{-60,
          162},{-42,162}}, color={255,0,255}));
  end if;
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
  connect(nor1.y, TrueFalseHold.u) annotation (Line(points={{-19,170},{-1,170}}, color={255,0,255}));
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
  connect(and2.y, MaxRetDamSwitch.u2)
    annotation (Line(points={{141,-220},{150,-220},{150,-270},{60,-270},{60,-250},{78,-250}}, color={255,0,255}));
  connect(and2.y, MinRetDamSwitch.u2)
    annotation (Line(points={{141,-220},{150,-220},{150,-270},{60,-270},{60,-290},{78,-290}}, color={255,0,255}));
  connect(timer.y, greThr2.u)
    annotation (Line(points={{101,-100},{130,-100},{130,-200},{74,-200},{74,-220},{78,-220}}, color={0,0,127}));
  connect(not2.y, RetDamSwitch.u2) annotation (Line(points={{61,-100},{68,-100},{68,-114},{-50,-114},{-50,-252},{-50,-300},
          {-2,-300}}, color={255,0,255}));
  connect(uRetDamPosMax, RetDamSwitch.u1)
    annotation (Line(points={{-200,-270},{-100,-270},{-100,-292},{-2,-292}}, color={0,0,127}));
  connect(uRetDamPosMin, RetDamSwitch.u3)
    annotation (Line(points={{-200,-300},{-100,-300},{-100,-308},{-2,-308}}, color={0,0,127}));
  connect(RetDamSwitch.y, MinRetDamSwitch.u3)
    annotation (Line(points={{21,-300},{50,-300},{50,-298},{78,-298}}, color={0,0,127}));
  connect(uRetDamPhyPosMax, MinRetDamSwitch.u1)
    annotation (Line(points={{-200,-240},{-60,-240},{-60,-282},{78,-282}}, color={0,0,127}));
  connect(TrueFalseHold.y, and1.u1)
    annotation (Line(points={{21,170},{30,170},{30,90},{-10,90},{-10,70},{-2,70}}, color={255,0,255}));
  connect(uSupFan, and1.u2) annotation (Line(points={{-200,70},{-100,70},{-100,62},{-2,62}},
                        color={255,0,255}));
  connect(and1.y, andEnaDis.u1) annotation (Line(points={{21,70},{21,70},{30,70},
          {30,8},{38,8}}, color={255,0,255}));
  connect(greThr2.y, and2.u1) annotation (Line(points={{101,-220},{109.5,-220},{118,-220}}, color={255,0,255}));
  connect(les1.y, and2.u2)
    annotation (Line(points={{61,-220},{70,-220},{70,-234},{110,-234},{110,-228},{118,-228}}, color={255,0,255}));
    annotation(Evaluate=true, Dialog(group="Enthalpy sensor in use", enable = fixEnt),
               Evaluate=true, Dialog(group="Enthalpy sensor in use", enable = fixEnt),
    Icon(graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-2,60},{78,60}},
          color={0,0,127},
          thickness=0.5),
        Line(
          points={{-78,-64},{-2,-64},{-2,60}},
          color={0,0,127},
          thickness=0.5),
        Text(
          extent={{-170,150},{158,112}},
          lineColor={0,0,127},
          textString="%name")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-180,-320},{180,240}},
        initialScale=0.1), graphics={Text(
          extent={{84,112},{194,102}},
          lineColor={28,108,200},
          textString="Outdoor air conditions",
          fontSize=12),
        Rectangle(extent={{-180,240},{180,100}},lineColor={28,108,200}),
        Rectangle(extent={{-180,40},{180,-20}}, lineColor={28,108,200}),
        Rectangle(extent={{-180,-80},{180,-320}}, lineColor={28,108,200}),
                                     Text(
          extent={{100,30},{222,12}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="Freeze protection conditions",
          fontSize=12),              Text(
          extent={{-176,-82},{-58,-120}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="Enable-disable damper limit
          assignments with time delays per G36 PART5.N.7"),
        Rectangle(extent={{-180,-20},{180,-80}},lineColor={28,108,200}),
                                     Text(
          extent={{100,-18},{170,-60}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="Zone State - disable when in heating",
          fontSize=12),
        Rectangle(extent={{-180,100},{180,40}}, lineColor={28,108,200}),
                                     Text(
          extent={{100,54},{208,42}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="Supply fan",
          fontSize=12)}),
    Documentation(info="<html>
  <p>
  This is an economizer enable/disable sequence for a multiple zone VAV AHU 
  based on conditions provided in ASHRAE G36 PART5-N.7 and PART5-A.17. Additional
  conditions included in the sequence are: freeze protection (freeze protection 
  stage 0-3, see PART5-N.12), supply fan status (on or off, see PART5-N.5), 
  and zone state (cooling, heating, or deadband, as illustrated in the 
  modulation control chart, PART5-N.2.c).
  </p>
  <p>
  Economizer shall be disabled whenever the outdoor air conditions 
  exceed the economizer high limit setpoint as specified by the local 
  code. This sequence allows for all device types listed in 
  ASHRAE 90.1-2013 and Title 24-2013.
  </p>
  <p>
  Economizer shall be disabled whenever any of the following is true:
  supply fan is off, zone state is <code>Heating<\code>, freeze protection stage 
  is not <code>0<\code>.
  </p>
  <p>
  The following state machine chart illustrates the above listed conditions:
  </p>
<p>
<p align=\"center\">
<img alt=\"Image of economizer enable-disable state machine chart\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/EconEnableDisableStateMachineChartMultiZone.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
June 27, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end EconEnableDisableMultiZone;
