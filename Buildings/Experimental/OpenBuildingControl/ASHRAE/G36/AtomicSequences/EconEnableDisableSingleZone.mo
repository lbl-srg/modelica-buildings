within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences;
block EconEnableDisableSingleZone "Single zone VAV AHU economizer enable/disable switch"

  parameter Boolean use_enthalpy = true
    "Set to true to evaluate outdoor air enthalpy in addition to temperature";
  parameter Real delTemHis(unit="K", quantity="TermodynamicTemperature")=1
    "Delta between the temperature hysteresis high and low limit";
  parameter Real delEntHis(unit="J/kg", quantity="SpecificEnergy")=1000
    "Delta between the enthalpy hysteresis high and low limits"
    annotation(Evaluate=true, Dialog(group="Enthalpy sensor in use", enable = use_enthalpy));
  parameter Modelica.SIunits.Time retDamFulOpeTim = 180
    "Time period to keep RA damper fully open at disable to avoid pressure fluctuations";
  parameter Modelica.SIunits.Time smaDisDel = 15
    "Small time delay before closing the OA damper at disable to avoid pressure fluctuations";

  CDL.Interfaces.RealInput TOut(unit="K", quantity = "ThermodynamicTemperature") "Outdoor air (OA) temperature"
    annotation (Placement(transformation(extent={{-220,250},{-180,290}}),
        iconTransformation(extent={{-120,90},{-100,110}})));
  CDL.Interfaces.RealInput hOut(unit="J/kg", quantity="SpecificEnergy") if use_enthalpy
      "Outdoor air enthalpy"
      annotation (Placement(transformation(extent={{-220,170},{-180,210}}),
        iconTransformation(extent={{-120,50},{-100,70}})));
  CDL.Interfaces.RealInput TOutCut(unit="K", quantity = "ThermodynamicTemperature")
    "OA temperature high limit cutoff. For differential dry bulb temeprature condition use return air temperature measurement"
    annotation (Placement(transformation(extent={{-220,210},{-180,250}}),
        iconTransformation(extent={{-120,70},{-100,90}})));
  CDL.Interfaces.RealInput hOutCut(unit="J/kg") if use_enthalpy
    "OA enthalpy high limit cutoff. For differential enthalpy use return air enthalpy measurement"
    annotation (Placement(transformation(extent={{-220,130},{-180,170}}),iconTransformation(extent={{-120,30},{-100,50}})));
  CDL.Interfaces.RealInput uOutDamPosMin(min=0, max=1)
    "Minimum outdoor air damper position, from EconDamperPositionLimitsMultiZone sequence"
    annotation (Placement(transformation(extent={{-220,-180},{-180,-140}}),
        iconTransformation(extent={{-120,-70},{-100,-50}})));
  CDL.Interfaces.RealInput uOutDamPosMax(min=0, max=1)
    "Maximum outdoor air damper position, from EconDamperPositionLimitsMultiZone sequence"
    annotation (Placement(transformation(extent={{-220,-150},{-180,-110}}),
        iconTransformation(extent={{-120,-50},{-100,-30}})));
  CDL.Interfaces.RealInput uRetDamPosMax(min=0, max=1)
    "Maximum return air damper position, from EconDamperPositionLimitsMultiZone sequence"
    annotation (Placement(transformation(extent={{-220,-250},{-180,-210}}),
        iconTransformation(extent={{-120,-110},{-100,-90}})));
  CDL.Interfaces.RealInput uRetDamPosMin(min=0, max=1)
    "Minimum return air damper position, from EconDamperPositionLimitsMultiZone sequence"
    annotation (Placement(transformation(extent={{-220,-280},{-180,-240}}),
        iconTransformation(extent={{-120,-130},{-100,-110}})));
  CDL.Interfaces.RealInput uRetDamPhyPosMax(min=0, max=1)
    "Physical maximum return air damper position, from EconDamperPositionLimitsMultiZone sequence"
    annotation (Placement(transformation(extent={{-220,-220},{-180,-180}}),
        iconTransformation(extent={{-120,-90},{-100,-70}})));
  CDL.Interfaces.BooleanInput uSupFan "Supply fan on/off status signal"
    annotation (Placement(transformation(extent={{-220,90},{-180,130}}),iconTransformation(extent={{-120,-30},{-100,-10}})));
  CDL.Interfaces.IntegerInput uZoneState "Zone state status signal"
    annotation (Placement(transformation(extent={{-220,-30},{-180,10}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  CDL.Interfaces.IntegerInput uFreProSta "Freeze protection stage status signal"
    annotation (Placement(transformation(extent={{-220,30},{-180,70}}),
        iconTransformation(extent={{-120,10},{-100,30}})));

  CDL.Interfaces.RealOutput yOutDamPosMax "Maximum outdoor air damper position"
    annotation (Placement(transformation(extent={{180,-150},{200,-130}}),
        iconTransformation(extent={{100,28},{140,68}})));
  CDL.Interfaces.RealOutput yRetDamPosMin "Minimum return air damper position"
    annotation (Placement(transformation(extent={{180,-260},{200,-240}}),
        iconTransformation(extent={{100,-100},{140,-60}})));
  CDL.Interfaces.RealOutput yRetDamPosMax "Maximum return air damper position"
    annotation (Placement(transformation(
        extent={{180,-220},{200,-200}}), iconTransformation(extent={{100,-40},{140,0}})));

  CDL.Logical.Hysteresis hysOutTem(final uHigh=uTemHigLimCutHig, final uLow=uTemHigLimCutLow)
    "Outdoor air temperature hysteresis for both fixed and differential dry bulb temperature cutoff conditions"
    annotation (Placement(transformation(extent={{-100,240},{-80,260}})));
  CDL.Logical.Hysteresis hysOutEnt(final uLow=uEntHigLimCutLow, final uHigh=uEntHigLimCutHig) if use_enthalpy
    "Outdoor air enthalpy hysteresis for both fixed and differential enthalpy cutoff conditions"
    annotation (Placement(transformation(extent={{-100,160},{-80,180}})));
  CDL.Logical.Switch OutDamSwitch "Set maximum OA damper position to minimum at disable (after time delay)"
    annotation (Placement(transformation(extent={{40,-150},{60,-130}})));
  CDL.Logical.Switch RetDamSwitch "Set minimum RA damper position to maximum at disable"
    annotation (Placement(transformation(extent={{-60,-270},{-40,-250}})));
  CDL.Logical.Switch MaxRetDamSwitch
    "Keep maximum RA damper position at physical maximum for a short time period after disable signal"
    annotation (Placement(transformation(extent={{40,-220},{60,-200}})));
  CDL.Logical.Switch MinRetDamSwitch
    "Keep minimum RA damper position at physical maximum for a short time period after disable"
    annotation (Placement(transformation(extent={{40,-260},{60,-240}})));
  CDL.Logical.TrueFalseHold TrueFalseHold(duration=600) "10 min on/off delay"
    annotation (Placement(transformation(extent={{0,200},{20,220}})));
  CDL.Logical.GreaterEqual greEqu "Logical greater or equal block"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  CDL.Logical.Timer timer "Timer gets started as the economizer gets disabled"
    annotation (Placement(transformation(extent={{30,-70},{50,-50}})));
  CDL.Logical.Nor nor1 "Logical nor"
    annotation (Placement(transformation(extent={{-40,200},{-20,220}})));
  CDL.Logical.Not not2 "Logical \"not\" starts the timer at disable signal "
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  CDL.Logical.Less les1 "Check if the RA damper should be fully open"
    annotation (Placement(transformation(extent={{-8,-190},{12,-170}})));
  CDL.Logical.And3 andEnaDis "Logical \"and\" checks freeze protection stage and zone state"
   annotation (Placement(transformation(extent={{40,30},{60,50}})));
  CDL.Logical.LessEqualThreshold equ(final threshold=freProDisabledNum)
    "Logical block to check if the freeze protection is deactivated"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  CDL.Logical.GreaterThreshold greThr(final threshold=heatingNum) "Check if ZoneState is other than heating"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  CDL.Logical.GreaterThreshold greThr2(final threshold=0) "Check if the timer got started"
    annotation (Placement(transformation(extent={{88,-182},{108,-162}})));
  CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{120,-190},{140,-170}})));
  CDL.Logical.And and1 "Logical \"and\" checks supply fan status"
    annotation (Placement(transformation(extent={{0,100},{20,120}})));
  CDL.Conversions.IntegerToReal intToRea "Integer to real converter"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
  CDL.Conversions.IntegerToReal intToRea1 "Integer to real converter"
    annotation (Placement(transformation(extent={{-160,-20},{-140,0}})));

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
    annotation (Placement(transformation(extent={{-60,-190},{-40,-170}})));
  CDL.Continuous.Constant disableDelay(final k=smaDisDel)
    "Small delay before closing the outdoor air damper to avoid pressure fluctuations"
    annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));
  CDL.Continuous.Add add2(k2=-1) if use_enthalpy "Add block determines difference between hOut and hOutCut"
    annotation (Placement(transformation(extent={{-140,160},{-120,180}})));
  CDL.Continuous.Add add1(k2=-1) "Add block determines difference between TOut and TOutCut"
    annotation (Placement(transformation(extent={{-140,240},{-120,260}})));
  CDL.Logical.Constant entSubst(final k=false) if not use_enthalpy
    "Deactivates outdoor air enthalpy condition if there is no enthalpy sensor"
    annotation (Placement(transformation(extent={{-100,190},{-80,210}})));

equation
  connect(OutDamSwitch.y, yOutDamPosMax) annotation (Line(points={{61,-140},{61,-140},{190,-140}}, color={0,0,127}));
  connect(TOut, add1.u1) annotation (Line(points={{-200,270},{-160,270},{-160,256},{-142,256}},
        color={0,0,127}));
  connect(TOutCut, add1.u2) annotation (Line(points={{-200,230},{-160,230},{-160,244},{-142,244}},
        color={0,0,127}));
  connect(add1.y, hysOutTem.u) annotation (Line(points={{-119,250},{-102,250}}, color={0,0,127}));
  connect(hOut, add2.u1) annotation (Line(points={{-200,190},{-160,190},{-160,176},{-142,176}},
        color={0,0,127}));
  connect(hOutCut, add2.u2)
    annotation (Line(points={{-200,150},{-160,150},{-160,164},{-142,164}}, color={0,0,127}));
  connect(add2.y, hysOutEnt.u) annotation (Line(points={{-119,170},{-102,170}}, color={0,0,127}));
  connect(hysOutTem.y, nor1.u1) annotation (Line(points={{-79,250},{-60,250},{-60,210},{-42,210}}, color={255,0,255}));
  if use_enthalpy then
    connect(hysOutEnt.y, nor1.u2)
      annotation (Line(points={{-79,170},{-60,170},{-60,202},{-42,202}},  color={255,0,255}));
  else
    connect(entSubst.y, nor1.u2) annotation (Line(points={{-79,200},{-60,200},{-60,202},{-42,202}}, color={255,0,255}));
  end if;
  connect(disableDelay.y, greEqu.u2)
    annotation (Line(points={{-39,-110},{-20,-110},{-20,-108},{-12,-108}}, color={0,0,127}));
  connect(timer.y, greEqu.u1) annotation (Line(points={{51,-60},{62,-60},{62,-80},{-20,-80},{-20,-100},{-12,-100}},
        color={0,0,127}));
  connect(greEqu.y, OutDamSwitch.u2) annotation (Line(points={{11,-100},{20,-100},{20,-140},{38,-140}}, color={255,0,255}));
  connect(uOutDamPosMin, OutDamSwitch.u1)
    annotation (Line(points={{-200,-160},{-120,-160},{-120,-134},{-120,-132},{38,-132}}, color={0,0,127}));
  connect(uOutDamPosMax, OutDamSwitch.u3)
    annotation (Line(points={{-200,-130},{-80,-130},{-80,-148},{38,-148}}, color={0,0,127}));
  connect(uRetDamPhyPosMax, MaxRetDamSwitch.u1)
    annotation (Line(points={{-200,-200},{-78,-200},{-78,-202},{38,-202}}, color={0,0,127}));
  connect(uRetDamPosMax, MaxRetDamSwitch.u3)
    annotation (Line(points={{-200,-230},{-78,-230},{-78,-218},{38,-218}}, color={0,0,127}));
  connect(timer.y, les1.u1)
    annotation (Line(points={{51,-60},{72,-60},{72,-154},{-20,-154},{-20,-180},{-10,-180}},color={0,0,127}));
  connect(nor1.y, TrueFalseHold.u) annotation (Line(points={{-19,210},{-1,210}}, color={255,0,255}));
  connect(andEnaDis.y, not2.u)
    annotation (Line(points={{61,40},{72,40},{72,-20},{-20,-20},{-20,-60},{-12,-60}}, color={255,0,255}));
  connect(MinRetDamSwitch.y, yRetDamPosMin)
    annotation (Line(points={{61,-250},{124,-250},{190,-250}}, color={0,0,127}));
  connect(MaxRetDamSwitch.y, yRetDamPosMax) annotation (Line(points={{61,-210},{190,-210}},  color={0,0,127}));
  connect(openRetDam.y, les1.u2)
    annotation (Line(points={{-39,-180},{-30,-180},{-30,-188},{-10,-188}}, color={0,0,127}));
  connect(not2.y, timer.u) annotation (Line(points={{11,-60},{28,-60}},   color={255,0,255}));
  connect(uFreProSta, intToRea.u) annotation (Line(points={{-200,50},{-200,50},{-162,50}}, color={255,127,0}));
  connect(intToRea.y, equ.u) annotation (Line(points={{-139,50},{-134,50},{-122,50}}, color={0,0,127}));
  connect(equ.y, andEnaDis.u2)
    annotation (Line(points={{-99,50},{-62,50},{-20,50},{-20,40},{38,40}},color={255,0,255}));
  connect(uZoneState, intToRea1.u) annotation (Line(points={{-200,-10},{-182,-10},{-162,-10}}, color={255,127,0}));
  connect(intToRea1.y, greThr.u) annotation (Line(points={{-139,-10},{-134,-10},{-130,-10},{-122,-10}}, color={0,0,127}));
  connect(greThr.y, andEnaDis.u3)
    annotation (Line(points={{-99,-10},{-20,-10},{-20,32},{38,32}}, color={255,0,255}));
  connect(and2.y, MaxRetDamSwitch.u2)
    annotation (Line(points={{141,-180},{150,-180},{150,-230},{20,-230},{20,-210},{38,-210}}, color={255,0,255}));
  connect(and2.y, MinRetDamSwitch.u2)
    annotation (Line(points={{141,-180},{150,-180},{150,-230},{20,-230},{20,-250},{38,-250}}, color={255,0,255}));
  connect(timer.y, greThr2.u)
    annotation (Line(points={{51,-60},{82,-60},{82,-172},{86,-172}},   color={0,0,127}));
  connect(not2.y, RetDamSwitch.u2)
    annotation (Line(points={{11,-60},{20,-60},{20,-72},{-90,-72},{-90,-260},{-62,-260}},color={255,0,255}));
  connect(uRetDamPosMax, RetDamSwitch.u1)
    annotation (Line(points={{-200,-230},{-140,-230},{-140,-252},{-62,-252}},color={0,0,127}));
  connect(uRetDamPosMin, RetDamSwitch.u3)
    annotation (Line(points={{-200,-260},{-140,-260},{-140,-268},{-62,-268}},color={0,0,127}));
  connect(RetDamSwitch.y, MinRetDamSwitch.u3)
    annotation (Line(points={{-39,-260},{-30,-260},{-30,-258},{38,-258}},color={0,0,127}));
  connect(uRetDamPhyPosMax, MinRetDamSwitch.u1)
    annotation (Line(points={{-200,-200},{-120,-200},{-120,-242},{38,-242}},color={0,0,127}));
  connect(TrueFalseHold.y, and1.u1)
    annotation (Line(points={{21,210},{30,210},{30,130},{-10,130},{-10,110},{-2,110}},color={255,0,255}));
  connect(and1.y, andEnaDis.u1)
    annotation (Line(points={{21,110},{21,110},{30,110},{30,48},{38,48}},color={255,0,255}));
  connect(greThr2.y, and2.u1)
    annotation (Line(points={{109,-172},{114,-172},{114,-180},{118,-180}}, color={255,0,255}));
  connect(les1.y, and2.u2)
    annotation (Line(points={{13,-180},{20,-180},{20,-188},{118,-188}},color={255,0,255}));
  connect(uSupFan, and1.u2)
    annotation (Line(points={{-200,110},{-102,110},{-102,102},{-2,102}},color={255,0,255}));
    annotation(Evaluate=true, Dialog(group="Enthalpy sensor in use", enable = use_enthalpy),
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
        extent={{-180,-280},{180,280}},
        initialScale=0.1), graphics={
        Rectangle(
          extent={{-170,-44},{170,-272}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-170,16},{170,-36}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-170,76},{170,24}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-170,136},{170,84}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-170,272},{170,144}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
                                     Text(
          extent={{102,168},{184,156}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Outdoor air
conditions"),                        Text(
          extent={{100,70},{278,36}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Freeze protection -
disable if \"stage1\"
and above"),                         Text(
          extent={{100,-42},{268,-90}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Damper position
limit assignments
with delays"),                       Text(
          extent={{102,18},{226,-34}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Zone state -
disable if
\"heating\""),                       Text(
          extent={{100,102},{194,92}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Supply fan status")}),
    Documentation(info="<html>
      <p>
      This is a single zone VAV AHU economizer enable/disable sequence
      based on ASHRAE G36 PART5-P.5 and PART5-A.17. Additional
      conditions included in the sequence are: freeze protection (freeze protection
      stage 0-3, see PART5-P.9), supply fan status (on or off, based on PART5-P.4.d),
      and zone state (cooling, heating, or deadband, as illustrated in the
      modulation control chart, PART5-P.3.b).
      </p>
      <p>
      Economizer shall be disabled whenever the outdoor air conditions
      exceed the economizer high limit setpoint as specified by the local
      code. This sequence allows for all device types listed in
      ASHRAE 90.1-2013 and Title 24-2013.
      </p>
      <p>
      In addition, economizer shall be disabled without a delay whenever any of the
      following is true: supply fan is off, zone state is <code>Heating</code>,
      freeze protection stage is not <code>0</code>.
      </p>
      <p>
      The following state machine chart illustrates the above listed conditions:
      </p>
      <p align=\"center\">
      <img alt=\"Image of economizer enable-disable state machine chart\"
      src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/EconEnableDisableStateMachineChartMultiZone.png\"/>
      </p>
      </html>", revisions="<html>
      <ul>
      <li>
      July 06, 2017, by Milica Grahovac:<br/>
      First implementation.
      </li>
      </ul>
      </html>"));
end EconEnableDisableSingleZone;
