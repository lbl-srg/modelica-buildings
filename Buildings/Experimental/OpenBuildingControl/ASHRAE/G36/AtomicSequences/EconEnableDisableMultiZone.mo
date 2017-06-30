within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences;
block EconEnableDisableMultiZone "Economizer enable/disable switch"

  parameter Boolean fixEnt = true
    "Set to true to evaluate outdoor air enthalpy in addition to temperature";
  parameter Real delTemHis(unit="K", quantity="TermodynamicTemperature")=1
    "Delta between the temperature hysteresis high and low limit";
  parameter Real delEntHis(unit="J/kg", quantity="SpecificEnergy")=1000
    "Delta between the enthalpy hysteresis high and low limit"
    annotation(Evaluate=true, Dialog(group="Enthalpy sensor in use", enable = fixEnt));
  parameter Modelica.SIunits.Time retDamFulOpeTim = 180
    "Time period to keep RA damper fully open at disable to avoid pressure fluctuations";
  parameter Modelica.SIunits.Time smaDisDel = 15
    "Small time delay before closing the OA damper at disable to avoid pressure fluctuations";

  CDL.Interfaces.RealInput TOut(unit="K", quantity = "ThermodynamicTemperature") "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-220,210},{-180,250}}),
        iconTransformation(extent={{-120,90},{-100,110}})));
  CDL.Interfaces.RealInput hOut(unit="J/kg", quantity="SpecificEnergy") if fixEnt
      "Outdoor air enthalpy"
      annotation (Placement(transformation(extent={{-220,130},{-180,170}}),
        iconTransformation(extent={{-120,50},{-100,70}})));
  CDL.Interfaces.RealInput TOutCut(unit="K", quantity = "ThermodynamicTemperature")
    "Outdoor temperature high limit cutoff. For differential dry bulb temeprature condition use return air temperature measurement"
    annotation (Placement(transformation(extent={{-220,170},{-180,210}}),
        iconTransformation(extent={{-120,70},{-100,90}})));
  CDL.Interfaces.RealInput hOutCut(unit="J/kg") if fixEnt
    "Outdoor enthalpy high limit cutoff. For differential enthalpy use return air enthalpy measurement"
    annotation (Placement(transformation(extent={{-220,90},{-180,130}}), iconTransformation(extent={{-120,30},{-100,50}})));
  CDL.Interfaces.RealInput uOutDamPosMin(min=0, max=1)
    "Minimum outdoor air (OA) damper position, from EconDamperPositionLimitsMultiZone sequence"
    annotation (Placement(transformation(extent={{-220,-220},{-180,-180}}),
        iconTransformation(extent={{-120,-70},{-100,-50}})));
  CDL.Interfaces.RealInput uOutDamPosMax(min=0, max=1)
    "Maximum outdoor air (OA) damper position, from EconDamperPositionLimitsMultiZone sequence"
    annotation (Placement(transformation(extent={{-220,-190},{-180,-150}}),
        iconTransformation(extent={{-120,-50},{-100,-30}})));
  CDL.Interfaces.RealInput uRetDamPosMax(min=0, max=1)
    "Maximum return air damper position, from EconDamperPositionLimitsMultiZone sequence"
    annotation (Placement(transformation(extent={{-220,-290},{-180,-250}}),
        iconTransformation(extent={{-120,-110},{-100,-90}})));
  CDL.Interfaces.RealInput uRetDamPosMin(min=0, max=1)
    "Minimum return air damper position, from EconDamperPositionLimitsMultiZone sequence"
    annotation (Placement(transformation(extent={{-220,-320},{-180,-280}}),
        iconTransformation(extent={{-120,-130},{-100,-110}})));
  CDL.Interfaces.RealInput uRetDamPhyPosMax(min=0, max=1)
    "Physical maximum return air damper position, from EconDamperPositionLimitsMultiZone sequence"
    annotation (Placement(transformation(extent={{-220,-260},{-180,-220}}),
        iconTransformation(extent={{-120,-90},{-100,-70}})));
  CDL.Interfaces.BooleanInput uSupFan "Supply fan on/off status signal"
    annotation (Placement(transformation(extent={{-220,50},{-180,90}}), iconTransformation(extent={{-120,-30},{-100,-10}})));
  CDL.Interfaces.IntegerInput uZoneState "Zone state status signal"
    annotation (Placement(transformation(extent={{-220,-70},{-180,-30}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  CDL.Interfaces.IntegerInput uFreProSta "Freeze protection stage status signal"
    annotation (Placement(transformation(extent={{-220,-10},{-180,30}}),
        iconTransformation(extent={{-120,10},{-100,30}})));

  CDL.Interfaces.RealOutput yOutDamPosMax "Maximum outdoor air damper position"
    annotation (Placement(transformation(extent={{180,-190},{200,-170}}),
        iconTransformation(extent={{100,28},{140,68}})));
  CDL.Interfaces.RealOutput yRetDamPosMin "Minimum return air damper position"
    annotation (Placement(transformation(extent={{180,-300},{200,-280}}),
        iconTransformation(extent={{100,-100},{140,-60}})));
  CDL.Interfaces.RealOutput yRetDamPosMax "Maximum return air damper position"
    annotation (Placement(transformation(
        extent={{180,-260},{200,-240}}), iconTransformation(extent={{100,-40},{140,0}})));

  CDL.Logical.Hysteresis hysOutTem(final uHigh=uTemHigLimCutHig, final uLow=uTemHigLimCutLow)
    "Outdoor air temperature hysteresis for both fixed and differential dry bulb temperature cutoff conditions"
    annotation (Placement(transformation(extent={{-100,200},{-80,220}})));
  CDL.Logical.Hysteresis hysOutEnt(final uLow=uEntHigLimCutLow, final uHigh=uEntHigLimCutHig) if fixEnt
    "Outdoor air enthalpy hysteresis for both fixed and differential enthalpy cutoff conditions"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
  CDL.Logical.Switch OutDamSwitch "Set maximum OA damper position to minimum at disable (after time delay)"
    annotation (Placement(transformation(extent={{40,-190},{60,-170}})));
  CDL.Logical.Switch RetDamSwitch "Set minimum RA damper position to maximum at disable"
    annotation (Placement(transformation(extent={{-60,-310},{-40,-290}})));
  CDL.Logical.Switch MaxRetDamSwitch
    "Keep maximum RA damper position at physical maximum for a short time period after disable signal"
    annotation (Placement(transformation(extent={{40,-260},{60,-240}})));
  CDL.Logical.Switch MinRetDamSwitch
    "Keep minimum RA damper position at physical maximum for a short time period after disable"
    annotation (Placement(transformation(extent={{40,-300},{60,-280}})));
  CDL.Logical.TrueFalseHold TrueFalseHold(duration=600) "10 min on/off delay"
    annotation (Placement(transformation(extent={{0,160},{20,180}})));
  CDL.Logical.GreaterEqual greEqu "Logical greater or equal block"
    annotation (Placement(transformation(extent={{-10,-150},{10,-130}})));
  CDL.Logical.Timer timer "Timer gets started as the economizer gets disabled"
    annotation (Placement(transformation(extent={{30,-110},{50,-90}})));
  CDL.Logical.Nor nor1 "Logical nor"
    annotation (Placement(transformation(extent={{-40,160},{-20,180}})));
  CDL.Logical.Not not2 "Logical \"not\" starts the timer at disable signal "
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  CDL.Logical.Less les1 "Check if the RA damper should be fully open"
    annotation (Placement(transformation(extent={{-8,-230},{12,-210}})));
  CDL.Logical.And3 andEnaDis "Logical \"and\" checks freeze protection stage and zone state"
   annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  CDL.Logical.LessEqualThreshold equ(final threshold=freProDisabledNum)
    "Logical block to check if the freeze protection is deactivated"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  CDL.Logical.GreaterThreshold greThr(final threshold=heatingNum) "Check if ZoneState is other than heating"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  CDL.Logical.GreaterThreshold greThr2(final threshold=0) "Check if the timer got started"
    annotation (Placement(transformation(extent={{88,-222},{108,-202}})));
  CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{120,-230},{140,-210}})));
  CDL.Logical.And and1 "Logical \"and\" checks supply fan status"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  CDL.Conversions.IntegerToReal intToRea "Integer to real converter"
    annotation (Placement(transformation(extent={{-160,0},{-140,20}})));
  CDL.Conversions.IntegerToReal intToRea1 "Integer to real converter"
    annotation (Placement(transformation(extent={{-160,-60},{-140,-40}})));

protected
  parameter Real uTemHigLimCutHig(final unit="K", quantity = "ThermodynamicTemperature") = 0
    "Hysteresis high limit cutoff";
  parameter Real uTemHigLimCutLow(
    final unit="K", quantity = "ThermodynamicTemperature") = uTemHigLimCutHig - delTemHis
    "Hysteresis low limit cutoff";
  parameter Real uEntHigLimCutHig(final unit="J/kg", quantity="SpecificEnergy") = 0
    "Hysteresis block high limit cutoff";
  parameter Real uEntHigLimCutLow(final unit="J/kg", quantity="SpecificEnergy") = uEntHigLimCutHig - delEntHis
    "Hysteresis block low limit cutoff";
  parameter Types.FreezeProtectionStage freProDisabled = Types.FreezeProtectionStage.stage0
    "Freeze protection stage 0 (disabled)";
  parameter Real freProDisabledNum = Integer(freProDisabled)-1
    "Numerical value for freeze protection stage 0 (=0)";
  parameter Types.ZoneState heating = Types.ZoneState.heating "Heating zone state";
  parameter Real heatingNum = Integer(heating) "Numerical value for heating zone state (=1)";

  CDL.Continuous.Constant openRetDam(final k=retDamFulOpeTim)
    "Keep return damper open to its physical maximum for a short period of time before closing the outdoor air damper
    and resuming the maximum return air damper position, per G36 Part N7"
    annotation (Placement(transformation(extent={{-60,-230},{-40,-210}})));
  CDL.Continuous.Constant disableDelay(final k=smaDisDel)
    "Small delay before closing the outdoor air damper to avoid pressure fluctuations"
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
  CDL.Continuous.Add add2(k2=-1) if fixEnt "Add block determines difference between hOut and hOutCut"
    annotation (Placement(transformation(extent={{-140,120},{-120,140}})));
  CDL.Continuous.Add add1(k2=-1) "Add block determines difference between TOut and TOutCut"
    annotation (Placement(transformation(extent={{-140,200},{-120,220}})));
  CDL.Logical.Constant entSubst(final k=false) if not fixEnt
    "Deactivates outdoor air enthalpy condition if there is no enthalpy sensor."
    annotation (Placement(transformation(extent={{-100,150},{-80,170}})));

equation
  connect(OutDamSwitch.y, yOutDamPosMax) annotation (Line(points={{61,-180},{61,-180},{190,-180}}, color={0,0,127}));
  connect(TOut, add1.u1) annotation (Line(points={{-200,230},{-160,230},{-160,216},{-142,216}},
        color={0,0,127}));
  connect(TOutCut, add1.u2) annotation (Line(points={{-200,190},{-160,190},{-160,204},{-142,204}},
        color={0,0,127}));
  connect(add1.y, hysOutTem.u) annotation (Line(points={{-119,210},{-102,210}}, color={0,0,127}));
  connect(hOut, add2.u1) annotation (Line(points={{-200,150},{-160,150},{-160, 136},{-142,136}},
        color={0,0,127}));
  connect(hOutCut, add2.u2)
    annotation (Line(points={{-200,110},{-160,110},{-160,124},{-142,124}}, color={0,0,127}));
  connect(add2.y, hysOutEnt.u) annotation (Line(points={{-119,130},{-102,130}}, color={0,0,127}));
  connect(hysOutTem.y, nor1.u1) annotation (Line(points={{-79,210},{-60,210},{-60,170},{-42,170}}, color={255,0,255}));
  if fixEnt then
    connect(hysOutEnt.y, nor1.u2)
      annotation (Line(points={{-79,130},{-60,130}, {-60,162},{-42,162}}, color={255,0,255}));
  else
    connect(entSubst.y, nor1.u2) annotation (Line(points={{-79,160},{-60,160},{-60,162},{-42,162}}, color={255,0,255}));
  end if;
  connect(disableDelay.y, greEqu.u2)
    annotation (Line(points={{-39,-150},{-20,-150},{-20,-148},{-12,-148}}, color={0,0,127}));
  connect(timer.y, greEqu.u1) annotation (Line(points={{51,-100},{62,-100},{62,-120},{-20,-120},{-20,-140},{-12,-140}},
        color={0,0,127}));
  connect(greEqu.y, OutDamSwitch.u2) annotation (Line(points={{11,-140},{20,-140},{20,-180},{38,-180}}, color={255,0,255}));
  connect(uOutDamPosMin, OutDamSwitch.u1)
    annotation (Line(points={{-200,-200},{-120,-200},{-120,-174},{-120,-172},{38,-172}}, color={0,0,127}));
  connect(uOutDamPosMax, OutDamSwitch.u3)
    annotation (Line(points={{-200,-170},{-80,-170},{-80,-188},{38,-188}}, color={0,0,127}));
  connect(uRetDamPhyPosMax, MaxRetDamSwitch.u1)
    annotation (Line(points={{-200,-240},{-78,-240},{-78,-242},{38,-242}}, color={0,0,127}));
  connect(uRetDamPosMax, MaxRetDamSwitch.u3)
    annotation (Line(points={{-200,-270},{-78,-270},{-78,-258},{38,-258}}, color={0,0,127}));
  connect(timer.y, les1.u1) annotation (Line(points={{51,-100},{72,-100},{72,-194},{-20,-194},{-20,-220},{-10,-220}},
        color={0,0,127}));
  connect(nor1.y, TrueFalseHold.u) annotation (Line(points={{-19,170},{-1,170}}, color={255,0,255}));
  connect(andEnaDis.y, not2.u)
    annotation (Line(points={{61,0},{72,0},{72,-60},{-20,-60},{-20,-100},{-12,-100}}, color={255,0,255}));
  connect(MinRetDamSwitch.y, yRetDamPosMin)
    annotation (Line(points={{61,-290},{124,-290},{190,-290}}, color={0,0,127}));
  connect(MaxRetDamSwitch.y, yRetDamPosMax) annotation (Line(points={{61,-250},{190,-250}},  color={0,0,127}));
  connect(openRetDam.y, les1.u2)
    annotation (Line(points={{-39,-220},{-30,-220},{-30,-228},{-10,-228}}, color={0,0,127}));
  connect(not2.y, timer.u) annotation (Line(points={{11,-100},{28,-100}}, color={255,0,255}));
  connect(uFreProSta, intToRea.u) annotation (Line(points={{-200,10},{-200,10},{-162,10}}, color={255,127,0}));
  connect(intToRea.y, equ.u) annotation (Line(points={{-139,10},{-134,10},{-122,10}}, color={0,0,127}));
  connect(equ.y, andEnaDis.u2) annotation (Line(points={{-99,10},{-62,10},{-20,10},{-20,0},{38,0}}, color={255,0,255}));
  connect(uZoneState, intToRea1.u) annotation (Line(points={{-200,-50},{-182,-50},{-162,-50}}, color={255,127,0}));
  connect(intToRea1.y, greThr.u) annotation (Line(points={{-139,-50},{-134,-50},{-130,-50},{-122,-50}}, color={0,0,127}));
  connect(greThr.y, andEnaDis.u3) annotation (Line(points={{-99,-50},{-20,-50},{-20,-8},{38,-8}}, color={255,0,255}));
  connect(and2.y, MaxRetDamSwitch.u2)
    annotation (Line(points={{141,-220},{150,-220},{150,-270},{20,-270},{20,-250},{38,-250}}, color={255,0,255}));
  connect(and2.y, MinRetDamSwitch.u2)
    annotation (Line(points={{141,-220},{150,-220},{150,-270},{20,-270},{20,-290},{38,-290}}, color={255,0,255}));
  connect(timer.y, greThr2.u)
    annotation (Line(points={{51,-100},{82,-100},{82,-212},{86,-212}}, color={0,0,127}));
  connect(not2.y, RetDamSwitch.u2)
    annotation (Line(points={{11,-100},{20,-100},{20,-112},{-90,-112},{-90,-300},{-62,-300}}, color={255,0,255}));
  connect(uRetDamPosMax, RetDamSwitch.u1)
    annotation (Line(points={{-200,-270},{-140,-270},{-140,-292},{-62,-292}},color={0,0,127}));
  connect(uRetDamPosMin, RetDamSwitch.u3)
    annotation (Line(points={{-200,-300},{-140,-300},{-140,-308},{-62,-308}},color={0,0,127}));
  connect(RetDamSwitch.y, MinRetDamSwitch.u3)
    annotation (Line(points={{-39,-300},{-30,-300},{-30,-298},{38,-298}},color={0,0,127}));
  connect(uRetDamPhyPosMax, MinRetDamSwitch.u1)
    annotation (Line(points={{-200,-240},{-120,-240},{-120,-282},{38,-282}},color={0,0,127}));
  connect(TrueFalseHold.y, and1.u1)
    annotation (Line(points={{21,170},{30,170},{30,90},{-10,90},{-10,70},{-2,70}}, color={255,0,255}));
  connect(and1.y, andEnaDis.u1)
    annotation (Line(points={{21,70},{21,70},{30,70},{30,8},{38,8}}, color={255,0,255}));
  connect(greThr2.y, and2.u1)
    annotation (Line(points={{109,-212},{114,-212},{114,-220},{118,-220}}, color={255,0,255}));
  connect(les1.y, and2.u2)
    annotation (Line(points={{13,-220},{20,-220},{20,-228},{118,-228}},color={255,0,255}));
  connect(uSupFan, and1.u2) annotation (Line(points={{-200,70},{-102,70},{-102,62},{-2,62}}, color={255,0,255}));
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
        initialScale=0.1), graphics={
        Rectangle(
          extent={{-170,-84},{170,-312}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-170,-24},{170,-76}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-170,36},{170,-16}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-170,96},{170,44}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-170,232},{170,104}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
                                     Text(
          extent={{102,128},{184,116}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Outdoor air
conditions"),                        Text(
          extent={{100,30},{278,-4}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Freeze protection -
disable if \"stage1\"
and above"),                         Text(
          extent={{100,-82},{268,-130}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Damper position
limit assignments
with delays"),                       Text(
          extent={{102,-22},{226,-74}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Zone state - 
disable if 
\"heating\""),                       Text(
          extent={{100,62},{194,52}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Supply fan status")}),
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
