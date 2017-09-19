within Buildings.Controls.OBC.ASHRAE.G36.Atomic;
block EconEnableDisableMultiZone
  "Multiple zone VAV AHU economizer enable/disable switch"

  parameter Boolean use_enthalpy = true
    "Set to true to evaluate outdoor air enthalpy in addition to temperature"
    annotation(Dialog(group="Conditional"));
  parameter Modelica.SIunits.TemperatureDifference delTOutHis=1
    "Delta between the temperature hysteresis high and low limit"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Hysteresis"));
  parameter Modelica.SIunits.SpecificEnergy delEntHis=1000
    "Delta between the enthalpy hysteresis high and low limits"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Hysteresis", enable = use_enthalpy));
  parameter Modelica.SIunits.Time retDamFulOpeTim=180
    "Time period to keep RA damper fully open before releasing it for minimum outdoor airflow control 
    at disable to avoid pressure fluctuations"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Delays at disable"));
  parameter Modelica.SIunits.Time disDel=15
    "Short time delay before closing the OA damper at disable to avoid pressure fluctuations"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Delays at disable"));

  CDL.Interfaces.RealInput TOut(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-220,250},{-180,290}}),
      iconTransformation(extent={{-120,90},{-100,110}})));
  CDL.Interfaces.RealInput hOut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy
    "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-220,170},{-180,210}}),
      iconTransformation(extent={{-120,50},{-100,70}})));
  CDL.Interfaces.RealInput TOutCut(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "OA temperature high limit cutoff. For differential dry bulb temeprature condition use return air temperature measurement"
    annotation (Placement(transformation(extent={{-220,210},{-180,250}}),
      iconTransformation(extent={{-120,70},{-100,90}})));
  CDL.Interfaces.RealInput hOutCut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy
    "OA enthalpy high limit cutoff. For differential enthalpy use return air enthalpy measurement"
    annotation (Placement(transformation(extent={{-220,130},{-180,170}}),
      iconTransformation(extent={{-120,30},{-100,50}})));
  CDL.Interfaces.RealInput uOutDamPosMin(
    final unit="1",
    final min=0,
    final max=1)
    "Minimum outdoor air damper position, output from damper position limits sequence"
    annotation (Placement(transformation(extent={{-220,-180},{-180,-140}}),
      iconTransformation(extent={{-120,-70},{-100,-50}})));
  CDL.Interfaces.RealInput uOutDamPosMax(
    final unit="1",
    final min=0,
    final max=1)
    "Maximum outdoor air damper position, output from damper position limits sequence"
    annotation (Placement(transformation(extent={{-220,-150},{-180,-110}}),
      iconTransformation(extent={{-120,-50},{-100,-30}})));
  CDL.Interfaces.RealInput uRetDamPosMax(
    final unit="1",
    final min=0,
    final max=1)
    "Maximum return air damper position, output from damper position limits sequence"
    annotation (Placement(transformation(extent={{-220,-250},{-180,-210}}),
      iconTransformation(extent={{-120,-110},{-100,-90}})));
  CDL.Interfaces.RealInput uRetDamPosMin(
    final unit="1",
    final min=0,
    final max=1)
    "Minimum return air damper position, output from damper position limits sequence"
    annotation (Placement(transformation(extent={{-220,-280},{-180,-240}}),
      iconTransformation(extent={{-120,-130},{-100,-110}})));
  CDL.Interfaces.RealInput uRetDamPhyPosMax(
    final unit="1",
    final min=0,
    final max=1)
    "Physical maximum return air damper position, output from damper position limits sequence"
    annotation (Placement(transformation(extent={{-220,-220},{-180,-180}}),
      iconTransformation(extent={{-120,-90},{-100,-70}})));
  CDL.Interfaces.BooleanInput uSupFan "Supply fan on/off status signal"
    annotation (Placement(transformation(extent={{-220,90},{-180,130}}),
      iconTransformation(extent={{-120,-30},{-100,-10}})));
  CDL.Interfaces.IntegerInput uFreProSta "Freeze protection stage status signal"
    annotation (Placement(transformation(extent={{-220,30},{-180,70}}),
      iconTransformation(extent={{-120,10},{-100,30}})));
  CDL.Interfaces.IntegerInput uZonSta "Zone state signal"
    annotation (Placement(transformation(extent={{-220,-30},{-180,10}}),
      iconTransformation(extent={{-120,-10},{-100,10}})));

  CDL.Interfaces.RealOutput yOutDamPosMax(
    final unit="1",
    final min=0,
    final max=1) "Maximum outdoor air damper position"
    annotation (Placement(transformation(extent={{180,-150},{200,-130}}),
      iconTransformation(extent={{100,28},{140,68}})));
  CDL.Interfaces.RealOutput yRetDamPosMin(
    final unit="1",
    final min=0,
    final max=1) "Minimum return air damper position"
    annotation (Placement(transformation(extent={{180,-260},{200,-240}}),
      iconTransformation(extent={{100,-100},{140,-60}})));
  CDL.Interfaces.RealOutput yRetDamPosMax(
    final unit="1",
    final min=0,
    final max=1) "Maximum return air damper position"
    annotation (Placement(transformation(
      extent={{180,-220},{200,-200}}), iconTransformation(extent={{100,-40},{140,0}})));

  CDL.Logical.TrueFalseHold truFalHol(
    trueHoldDuration=600) "10 min on/off delay"
    annotation (Placement(transformation(extent={{0,200},{20,220}})));
  CDL.Logical.And3 andEnaDis "Logical and to check freeze protection stage and zone state"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));

protected
  final parameter Modelica.SIunits.TemperatureDifference TOutHigLimCutHig = 0
    "Hysteresis high limit cutoff";
  final parameter Real TOutHigLimCutLow = TOutHigLimCutHig - delTOutHis
    "Hysteresis low limit cutoff";
  final parameter Modelica.SIunits.SpecificEnergy hOutHigLimCutHig = 0
    "Hysteresis block high limit cutoff";
  final parameter Real hOutHigLimCutLow = hOutHigLimCutHig - delEntHis
    "Hysteresis block low limit cutoff";

  CDL.Logical.Sources.Constant entSubst(final k=false) if not use_enthalpy
    "Deactivates outdoor air enthalpy condition if there is no enthalpy sensor"
    annotation (Placement(transformation(extent={{-100,190},{-80,210}})));
  CDL.Continuous.Add add2(final k2=-1) if use_enthalpy "Add block determines difference between hOut and hOutCut"
    annotation (Placement(transformation(extent={{-140,160},{-120,180}})));
  CDL.Continuous.Add add1(final k2=-1) "Add block determines difference between TOut and TOutCut"
    annotation (Placement(transformation(extent={{-140,240},{-120,260}})));
  CDL.Continuous.Hysteresis hysOutTem(
    final uLow=TOutHigLimCutLow,
    final uHigh=TOutHigLimCutHig)
    "Outdoor air temperature hysteresis for both fixed and differential dry bulb temperature cutoff conditions"
    annotation (Placement(transformation(extent={{-100,240},{-80,260}})));
  CDL.Continuous.Hysteresis hysOutEnt(
    final uLow=hOutHigLimCutLow,
    final uHigh=hOutHigLimCutHig) if use_enthalpy
    "Outdoor air enthalpy hysteresis for both fixed and differential enthalpy cutoff conditions"
    annotation (Placement(transformation(extent={{-100,160},{-80,180}})));
  CDL.Logical.Switch outDamSwitch "Set maximum OA damper position to minimum at disable (after a given time delay)"
    annotation (Placement(transformation(extent={{40,-150},{60,-130}})));
  CDL.Logical.Switch retDamSwitch "Set minimum RA damper position to maximum at disable"
    annotation (Placement(transformation(extent={{-60,-270},{-40,-250}})));
  CDL.Logical.Switch maxRetDamSwitch
    "Keep maximum RA damper position at physical maximum for a short time period after disable signal"
    annotation (Placement(transformation(extent={{40,-220},{60,-200}})));
  CDL.Logical.Switch minRetDamSwitch
    "Keep minimum RA damper position at physical maximum for a short time period after disable"
    annotation (Placement(transformation(extent={{40,-260},{60,-240}})));
  CDL.Logical.Timer timer "Timer gets started as the economizer gets disabled"
    annotation (Placement(transformation(extent={{30,-70},{50,-50}})));
  CDL.Logical.Nor nor1 "Logical nor"
    annotation (Placement(transformation(extent={{-40,200},{-20,220}})));
  CDL.Logical.Not not2 "Logical not that starts the timer at disable signal "
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  CDL.Logical.And  and2 "Logical and"
    annotation (Placement(transformation(extent={{130,-182},{150,-162}})));
  CDL.Logical.And and1 "Logical and checks supply fan status"
    annotation (Placement(transformation(extent={{0,100},{20,120}})));
  CDL.Logical.And and3 "Logical and which checks supply fan status"
    annotation (Placement(transformation(extent={{-20,-120},{0,-100}})));

  CDL.Integers.Equal intEqu
    "Logical block to check if the freeze protection is deactivated"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  CDL.Logical.OnDelay damDelOsc(
    final delayTime=disDel)
    "Small delay before closing the outdoor air damper to avoid pressure fluctuations"
    annotation (Placement(transformation(extent={{-68,-110},{-48,-90}})));
  CDL.Logical.OnDelay delRetDam(
    final delayTime=retDamFulOpeTim)
    "Keep return damper open to its physical maximum for a short period of time before closing the outdoor air damper and resuming the maximum return air damper position, per G36 Part N7"
    annotation (Placement(transformation(extent={{42,-182},{62,-162}})));
  CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{80,-182},{100,-162}})));
  CDL.Integers.Sources.Constant conInt(
    final k=Constants.FreezeProtectionStages.stage0)
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  CDL.Integers.Equal intEqu1
    "Logical block to check if the freeze protection is deactivated"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  CDL.Integers.Sources.Constant conInt1(
    final k=Constants.ZoneStates.heating)
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  CDL.Logical.Not not3 "Negation for check of freeze protection status"
    annotation (Placement(transformation(extent={{-44,-10},{-24,10}})));
equation
  connect(outDamSwitch.y, yOutDamPosMax) annotation (Line(points={{61,-140},{61,-140},{190,-140}}, color={0,0,127}));
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
  connect(hysOutTem.y, nor1.u1) annotation (Line(points={{-79,250},{-60,250},{-60,210},{-42,210}},
    color={255,0,255}));
  connect(hysOutEnt.y, nor1.u2)
    annotation (Line(points={{-79,170},{-60,170},{-60,202},{-42,202}},color={255,0,255}));
  connect(entSubst.y, nor1.u2) annotation (Line(points={{-79,200},{-60,200},{-60,202},{-42,202}},
    color={255,0,255}));
  connect(uOutDamPosMin, outDamSwitch.u1)
    annotation (Line(points={{-200,-160},{-120,-160},{-120,-134},{-120,-132},{38,-132}}, color={0,0,127}));
  connect(uOutDamPosMax, outDamSwitch.u3)
    annotation (Line(points={{-200,-130},{-80,-130},{-80,-148},{38,-148}}, color={0,0,127}));
  connect(uRetDamPhyPosMax, maxRetDamSwitch.u1)
    annotation (Line(points={{-200,-200},{-78,-200},{-78,-202},{38,-202}}, color={0,0,127}));
  connect(uRetDamPosMax, maxRetDamSwitch.u3)
    annotation (Line(points={{-200,-230},{-78,-230},{-78,-218},{38,-218}}, color={0,0,127}));
  connect(nor1.y, truFalHol.u) annotation (Line(points={{-19,210},{-1,210}}, color={255,0,255}));
  connect(andEnaDis.y, not2.u)
    annotation (Line(points={{61,40},{72,40},{72,-20},{-20,-20},{-20,-60},{-12,-60}}, color={255,0,255}));
  connect(minRetDamSwitch.y, yRetDamPosMin)
    annotation (Line(points={{61,-250},{124,-250},{190,-250}}, color={0,0,127}));
  connect(maxRetDamSwitch.y, yRetDamPosMax) annotation (Line(points={{61,-210},{190,-210}}, color={0,0,127}));
  connect(not2.y, timer.u) annotation (Line(points={{11,-60},{28,-60}},   color={255,0,255}));
  connect(and2.y, maxRetDamSwitch.u2)
    annotation (Line(points={{151,-172},{162,-172},{162,-230},{20,-230},{20,-210},
          {38,-210}}, color={255,0,255}));
  connect(and2.y, minRetDamSwitch.u2)
    annotation (Line(points={{151,-172},{162,-172},{162,-230},{20,-230},{20,-250},
          {38,-250}}, color={255,0,255}));
  connect(not2.y, retDamSwitch.u2)
    annotation (Line(points={{11,-60},{20,-60},{20,-72},{-90,-72},{-90,-260},{-62,-260}},color={255,0,255}));
  connect(uRetDamPosMax, retDamSwitch.u1)
    annotation (Line(points={{-200,-230},{-140,-230},{-140,-252},{-62,-252}},color={0,0,127}));
  connect(uRetDamPosMin, retDamSwitch.u3)
    annotation (Line(points={{-200,-260},{-140,-260},{-140,-268},{-62,-268}},color={0,0,127}));
  connect(retDamSwitch.y, minRetDamSwitch.u3)
    annotation (Line(points={{-39,-260},{-30,-260},{-30,-258},{38,-258}},color={0,0,127}));
  connect(uRetDamPhyPosMax, minRetDamSwitch.u1)
    annotation (Line(points={{-200,-200},{-120,-200},{-120,-242},{38,-242}},color={0,0,127}));
  connect(truFalHol.y, and1.u1)
    annotation (Line(points={{21,210},{30,210},{30,130},{-10,130},{-10,110},{-2,110}},color={255,0,255}));
  connect(and1.y, andEnaDis.u1)
    annotation (Line(points={{21,110},{21,110},{30,110},{30,48},{38,48}},color={255,0,255}));
  connect(uSupFan, and1.u2)
    annotation (Line(points={{-200,110},{-102,110},{-102,102},{-2,102}},color={255,0,255}));
  connect(outDamSwitch.u2, and3.y)
    annotation (Line(points={{38,-140},{12,-140},{12,-110},{1,-110}}, color={255,0,255}));
  connect(not2.y, and3.u1)
    annotation (Line(points={{11,-60},{20,-60},{20,-86},{-28,-86},{-28,-110},{-22,-110}}, color={255,0,255}));

  connect(and2.u1, not2.y) annotation (Line(points={{128,-172},{116,-172},{116,-94},
          {20,-94},{20,-60},{11,-60}}, color={255,0,255}));
  connect(and3.u2, damDelOsc.y) annotation (Line(points={{-22,-118},{-34,-118},{
          -34,-100},{-47,-100}}, color={255,0,255}));
  connect(damDelOsc.u, not2.y) annotation (Line(points={{-70,-100},{-90,-100},{-90,
          -72},{20,-72},{20,-60},{11,-60}}, color={255,0,255}));
  connect(not2.y, delRetDam.u) annotation (Line(points={{11,-60},{20,-60},{20,-172},
          {40,-172}}, color={255,0,255}));
  connect(delRetDam.y, not1.u)
    annotation (Line(points={{63,-172},{78,-172}}, color={255,0,255}));
  connect(not1.y, and2.u2) annotation (Line(points={{101,-172},{112,-172},{112,-180},
          {128,-180}}, color={255,0,255}));
  connect(uFreProSta, intEqu.u1) annotation (Line(points={{-200,50},{-140,50},{-140,
          60},{-82,60}}, color={255,127,0}));
  connect(conInt.y, intEqu.u2) annotation (Line(points={{-99,40},{-92,40},{-92,52},
          {-82,52}}, color={255,127,0}));
  connect(intEqu.y, andEnaDis.u2) annotation (Line(points={{-59,60},{20,60},{20,
          40},{38,40}}, color={255,0,255}));
  connect(intEqu1.y, not3.u)
    annotation (Line(points={{-59,0},{-46,0}}, color={255,0,255}));
  connect(conInt1.y, intEqu1.u2) annotation (Line(points={{-99,-20},{-90,-20},{-90,
          -8},{-82,-8}}, color={255,127,0}));
  connect(uZonSta, intEqu1.u1) annotation (Line(points={{-200,-10},{-140,-10},{-140,
          0},{-82,0}}, color={255,127,0}));
  connect(not3.y, andEnaDis.u3) annotation (Line(points={{-23,0},{19.5,0},{19.5,
          32},{38,32}}, color={255,0,255}));
  annotation (
    defaultComponentName = "ecoEnaDis",
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
          extent={{-168,-44},{172,-272}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-168,16},{172,-36}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-168,76},{172,24}},
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
disable if stage1
and above"),                         Text(
          extent={{100,-42},{268,-90}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Damper position
limit assignments
with delays"),                       Text(
          extent={{102,18},{214,-30}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Zone state -
disable if
Heating"),                       Text(
          extent={{100,102},{194,92}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Supply fan status")}),
Documentation(info="<html>
<p>
This is a multiple zone VAV AHU economizer enable/disable sequence
based on ASHRAE G36 PART5.N.7 and PART5.A.17. Additional
conditions included in the sequence are: freeze protection (freeze protection
stage 0-3, see PART5.N.12), supply fan status (on or off, see PART5.N.5),
and zone state (cooling, heating, or deadband, as illustrated in the
modulation control chart, PART5.N.2.c).
</p>
<p>
The economizer is disabled whenever the outdoor air conditions
exceed the economizer high limit setpoint.
This sequence allows for all device types listed in
ASHRAE 90.1-2013 and Title 24-2013.
</p>
<p>
In addition, the economizer gets disabled without a delay whenever any of the
following is <code>true</code>:
</p>
<ul>
<li>
supply fan is off (<code>uSupFan = false</code>),
</li>
<li>
zone state <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Constants.ZoneStates\">
Buildings.Controls.OBC.ASHRAE.G36.Constants.ZoneStates</a> is <code>heating</code>,
</li>
<li>
freeze protection stage
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Constants.FreezeProtectionStages\">
Buildings.Controls.OBC.ASHRAE.G36.Constants.FreezeProtectionStages</a>
is not <code>stage0</code>.
</li>
</ul>
<p>
The following state machine chart illustrates the transitions between enabling and disabling:
</p>
<p align=\"center\">
<img alt=\"Image of economizer enable-disable state machine chart\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/Atomic/EconEnableDisableStateMachineChartMultiZone.png\"/>
</p>
<p>
After the disable signal is activated, the following procedure is applied, per PART5.N.7.d, in order to 
prevent pressure fluctuations in the HVAC system:
</p>
<ul>
<li>
return damper gets fully opened (<code>yRetDamPosMax = uRetDamPhyPosMax</code> and 
<code>yRetDamPosMin = uRetDamPhyPosMax</code>) for <code>retDamFulOpeTim</code>
time period, after which the return damper gets released to its minimum outdoor airflow control position
(<code>yRetDamPosMax = uRetDamPosMax</code> and <code>yRetDamPosMin = uRetDamPosMax</code>).
</li>
<li>
outdoor air damper is closed to its minimum outoor airflow control limit (<code>yOutDamPosMax = uOutDamPosMin</code>) 
after a <code>disDel</code> time delay.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
August 3, 2017, by Michael Wetter:<br/>
Removed unrequired input into block <code>and2</code> as this input
was always <code>true</code> if <code>and2.u2 = true</code>.
</li>
<li>
June 27, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end EconEnableDisableMultiZone;
