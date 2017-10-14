within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences;
block Enable
  "Multi zone VAV AHU economizer enable/disable switch"

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

  parameter Modelica.SIunits.Temperature TFreSet = 277.15
    "Lower limit for mixed air temperature for freeze protection"
     annotation(Evaluate=true, Dialog(tab="Advanced", group="Freeze protection"));
  parameter Real kPFre = 1
    "Proportional gain for mixed air temperature tracking for freeze protection"
     annotation(Evaluate=true, Dialog(tab="Advanced", group="Freeze protection"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-320,250},{-280,290}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy
    "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-320,170},{-280,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOutCut(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "OA temperature high limit cutoff. For differential dry bulb temeprature condition use return air temperature measurement"
    annotation (Placement(transformation(extent={{-320,210},{-280,250}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOutCut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy
    "OA enthalpy high limit cutoff. For differential enthalpy use return air enthalpy measurement"
    annotation (Placement(transformation(extent={{-320,130},{-280,170}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMix(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Measured mixed air temperature, used for freeze protection"
    annotation (Placement(transformation(extent={{-320,-80},{-280,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDamPosMin(
    final unit="1",
    final min=0,
    final max=1)
    "Minimum outdoor air damper position, output from damper position limits sequence"
    annotation (Placement(transformation(extent={{-320,-180},{-280,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDamPosMax(
    final unit="1",
    final min=0,
    final max=1)
    "Maximum outdoor air damper position, output from damper position limits sequence"
    annotation (Placement(transformation(extent={{-320,-140},{-280,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRetDamPosMax(
    final unit="1",
    final min=0,
    final max=1)
    "Maximum return air damper position, output from damper position limits sequence"
    annotation (Placement(transformation(extent={{-320,-260},{-280,-220}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRetDamPosMin(
    final unit="1",
    final min=0,
    final max=1)
    "Minimum return air damper position, output from damper position limits sequence"
    annotation (Placement(transformation(extent={{-320,-300},{-280,-260}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRetDamPhyPosMax(
    final unit="1",
    final min=0,
    final max=1)
    "Physical maximum return air damper position, output from damper position limits sequence"
    annotation (Placement(transformation(extent={{-320,-220},{-280,-180}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan "Supply fan on/off status signal"
    annotation (Placement(transformation(extent={{-320,80},{-280,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uFreProSta "Freeze protection stage status signal"
    annotation (Placement(transformation(extent={{-320,30},{-280,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonSta "Zone state signal"
    annotation (Placement(transformation(extent={{-320,-30},{-280,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPosMax(
    final unit="1",
    final min=0,
    final max=1) "Maximum outdoor air damper position"
    annotation (Placement(transformation(extent={{280,70},{300,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPosMin(
    final unit="1",
    final min=0,
    final max=1) "Minimum return air damper position"
    annotation (Placement(transformation(extent={{280,-110},{300,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPosMax(
    final unit="1",
    final min=0,
    final max=1) "Maximum return air damper position"
    annotation (Placement(transformation(extent={{280,-10},{300,10}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(
    trueHoldDuration=600) "10 min on/off delay"
    annotation (Placement(transformation(extent={{0,200},{20,220}})));
  Buildings.Controls.OBC.CDL.Logical.And3 andEnaDis "Logical and to check freeze protection stage and zone state"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));

  CDL.Continuous.Min outDamMaxFre
    "Maximum control signal for outdoor air damper due to freeze protection"
    annotation (Placement(transformation(extent={{140,-116},{160,-96}})));
  CDL.Continuous.Max retDamMinFre
    "Minimum position for return air damper due to freeze protection"
    annotation (Placement(transformation(extent={{140,-260},{160,-240}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter yFreOut(final p=1, final k=
       -1) "Control signal for outdoor damper due to freeze protection"
    annotation (Placement(transformation(extent={{-138,-110},{-118,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.LimPID conFreTMix(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final k=kPFre,
    final yMax=1,
    final yMin=0)
    "Controller for mixed air to track freeze protection set point"
    annotation (Placement(transformation(extent={{-200,-80},{-180,-60}})));

protected
  final parameter Modelica.SIunits.TemperatureDifference TOutHigLimCutHig = 0
    "Hysteresis high limit cutoff";
  final parameter Real TOutHigLimCutLow = TOutHigLimCutHig - delTOutHis
    "Hysteresis low limit cutoff";
  final parameter Modelica.SIunits.SpecificEnergy hOutHigLimCutHig = 0
    "Hysteresis block high limit cutoff";
  final parameter Real hOutHigLimCutLow = hOutHigLimCutHig - delEntHis
    "Hysteresis block low limit cutoff";

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant entSubst(
    final k=false) if not use_enthalpy
    "Deactivates outdoor air enthalpy condition if there is no enthalpy sensor"
    annotation (Placement(transformation(extent={{-100,190},{-80,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(
    final k2=-1) if use_enthalpy "Add block determines difference between hOut and hOutCut"
    annotation (Placement(transformation(extent={{-140,160},{-120,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1(
    final k2=-1) "Add block determines difference between TOut and TOutCut"
    annotation (Placement(transformation(extent={{-140,240},{-120,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysOutTem(
    final uLow=TOutHigLimCutLow,
    final uHigh=TOutHigLimCutHig)
    "Outdoor air temperature hysteresis for both fixed and differential dry bulb temperature cutoff conditions"
    annotation (Placement(transformation(extent={{-100,240},{-80,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysOutEnt(
    final uLow=hOutHigLimCutLow,
    final uHigh=hOutHigLimCutHig) if use_enthalpy
    "Outdoor air enthalpy hysteresis for both fixed and differential enthalpy cutoff conditions"
    annotation (Placement(transformation(extent={{-100,160},{-80,180}})));
  Buildings.Controls.OBC.CDL.Logical.Switch outDamSwitch "Set maximum OA damper position to minimum at disable (after a given time delay)"
    annotation (Placement(transformation(extent={{62,-160},{82,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Switch retDamSwitch "Set minimum RA damper position to maximum at disable"
    annotation (Placement(transformation(extent={{-40,-268},{-20,-248}})));
  Buildings.Controls.OBC.CDL.Logical.Switch maxRetDamSwitch
    "Keep maximum RA damper position at physical maximum for a short time period after disable signal"
    annotation (Placement(transformation(extent={{40,-220},{60,-200}})));
  Buildings.Controls.OBC.CDL.Logical.Switch minRetDamSwitch
    "Keep minimum RA damper position at physical maximum for a short time period after disable"
    annotation (Placement(transformation(extent={{40,-260},{60,-240}})));
  Buildings.Controls.OBC.CDL.Logical.Nor nor1 "Logical nor"
    annotation (Placement(transformation(extent={{-40,200},{-20,220}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not that starts the timer at disable signal "
    annotation (Placement(transformation(extent={{-78,-134},{-58,-114}})));
  Buildings.Controls.OBC.CDL.Logical.And  and2 "Logical and"
    annotation (Placement(transformation(extent={{130,-174},{150,-154}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and checks supply fan status"
    annotation (Placement(transformation(extent={{0,100},{20,120}})));
  Buildings.Controls.OBC.CDL.Logical.And and3 "Logical and which checks supply fan status"
    annotation (Placement(transformation(extent={{20,-136},{40,-116}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    "Logical block to check if the freeze protection is deactivated"
    annotation (Placement(transformation(extent={{-98,50},{-78,70}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delOutDamOsc(
    final delayTime=disDel)
    "Small delay before closing the outdoor air damper to avoid pressure fluctuations"
    annotation (Placement(transformation(extent={{-40,-134},{-20,-114}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delRetDam(
    final delayTime=retDamFulOpeTim)
    "Keep return damper open to its physical maximum for a short period of time before closing the outdoor air damper and resuming the maximum return air damper position, per G36 Part N7"
    annotation (Placement(transformation(extent={{-40,-190},{-20,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{0,-190},{20,-170}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=Constants.FreezeProtectionStages.stage0)
    annotation (Placement(transformation(extent={{-138,30},{-118,50}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1
    "Logical block to check if the freeze protection is deactivated"
    annotation (Placement(transformation(extent={{-98,-10},{-78,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=Constants.ZoneStates.heating)
    annotation (Placement(transformation(extent={{-138,-30},{-118,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 "Negation for check of freeze protection status"
    annotation (Placement(transformation(extent={{-62,-10},{-42,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant setPoiFre(
    final k=TFreSet)
    "Set point for freeze protection"
    annotation (Placement(transformation(extent={{-240,-80},{-220,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter offSig(
    final k=1,
    final p=-1/kPFre)
    "Offset of TMix to account for P-band. This ensures that the damper is fully closed at TFreSet"
    annotation (Placement(transformation(extent={{-240,-120},{-220,-100}})));
equation
  connect(TOut, add1.u1) annotation (Line(points={{-300,270},{-270,270},{-270,256},
          {-142,256}},
        color={0,0,127}));
  connect(TOutCut, add1.u2) annotation (Line(points={{-300,230},{-252,230},{-252,
          244},{-142,244}},
        color={0,0,127}));
  connect(add1.y, hysOutTem.u) annotation (Line(points={{-119,250},{-102,250}}, color={0,0,127}));
  connect(hOut, add2.u1) annotation (Line(points={{-300,190},{-252,190},{-252,176},
          {-142,176}},
        color={0,0,127}));
  connect(hOutCut, add2.u2)
    annotation (Line(points={{-300,150},{-252,150},{-252,164},{-142,164}}, color={0,0,127}));
  connect(add2.y, hysOutEnt.u) annotation (Line(points={{-119,170},{-102,170}}, color={0,0,127}));
  connect(hysOutTem.y, nor1.u1) annotation (Line(points={{-79,250},{-60,250},{-60,210},{-42,210}},
    color={255,0,255}));
  connect(hysOutEnt.y, nor1.u2)
    annotation (Line(points={{-79,170},{-60,170},{-60,202},{-42,202}},color={255,0,255}));
  connect(entSubst.y, nor1.u2) annotation (Line(points={{-79,200},{-60,200},{-60,202},{-42,202}},
    color={255,0,255}));
  connect(uOutDamPosMin, outDamSwitch.u1)
    annotation (Line(points={{-300,-160},{-250,-160},{-250,-142},{60,-142}},             color={0,0,127}));
  connect(uOutDamPosMax, outDamSwitch.u3)
    annotation (Line(points={{-300,-120},{-244,-120},{-244,-158},{60,-158}},
                                                                           color={0,0,127}));
  connect(uRetDamPhyPosMax, maxRetDamSwitch.u1)
    annotation (Line(points={{-300,-200},{-178,-200},{-178,-202},{38,-202}},
                                                                           color={0,0,127}));
  connect(uRetDamPosMax, maxRetDamSwitch.u3)
    annotation (Line(points={{-300,-240},{-178,-240},{-178,-218},{38,-218}},
                                                                           color={0,0,127}));
  connect(nor1.y, truFalHol.u) annotation (Line(points={{-19,210},{-1,210}}, color={255,0,255}));
  connect(andEnaDis.y, not2.u)
    annotation (Line(points={{61,40},{72,40},{72,-20},{-86,-20},{-86,-124},{-80,
          -124}},                                                                     color={255,0,255}));
  connect(maxRetDamSwitch.y, yRetDamPosMax) annotation (Line(points={{61,-210},{
          248,-210},{248,0},{290,0}},                                                       color={0,0,127}));
  connect(and2.y, maxRetDamSwitch.u2)
    annotation (Line(points={{151,-164},{162,-164},{162,-230},{20,-230},{20,
          -210},{38,-210}},
                      color={255,0,255}));
  connect(and2.y, minRetDamSwitch.u2)
    annotation (Line(points={{151,-164},{162,-164},{162,-230},{20,-230},{20,
          -250},{38,-250}},
                      color={255,0,255}));
  connect(not2.y, retDamSwitch.u2)
    annotation (Line(points={{-57,-124},{-50,-124},{-50,-258},{-42,-258}},               color={255,0,255}));
  connect(uRetDamPosMax, retDamSwitch.u1)
    annotation (Line(points={{-300,-240},{-240,-240},{-240,-250},{-42,-250}},color={0,0,127}));
  connect(uRetDamPosMin, retDamSwitch.u3)
    annotation (Line(points={{-300,-280},{-172,-280},{-172,-266},{-42,-266}},color={0,0,127}));
  connect(retDamSwitch.y, minRetDamSwitch.u3)
    annotation (Line(points={{-19,-258},{38,-258}},                      color={0,0,127}));
  connect(uRetDamPhyPosMax, minRetDamSwitch.u1)
    annotation (Line(points={{-300,-200},{-220,-200},{-220,-242},{38,-242}},color={0,0,127}));
  connect(truFalHol.y, and1.u1)
    annotation (Line(points={{21,210},{30,210},{30,130},{-10,130},{-10,110},{-2,110}},color={255,0,255}));
  connect(and1.y, andEnaDis.u1)
    annotation (Line(points={{21,110},{21,110},{30,110},{30,48},{38,48}},color={255,0,255}));
  connect(uSupFan, and1.u2)
    annotation (Line(points={{-300,100},{-152,100},{-152,102},{-2,102}},color={255,0,255}));
  connect(outDamSwitch.u2, and3.y)
    annotation (Line(points={{60,-150},{50,-150},{50,-126},{41,-126}},color={255,0,255}));
  connect(not2.y, and3.u1)
    annotation (Line(points={{-57,-124},{-50,-124},{-50,-104},{8,-104},{8,-126},
          {18,-126}},                                                                     color={255,0,255}));

  connect(and2.u1, not2.y) annotation (Line(points={{128,-164},{106,-164},{106,-104},
          {-50,-104},{-50,-124},{-57,-124}},
                                       color={255,0,255}));
  connect(and3.u2, delOutDamOsc.y) annotation (Line(points={{18,-134},{0,-134},{
          0,-124},{-19,-124}},    color={255,0,255}));
  connect(delOutDamOsc.u, not2.y) annotation (Line(points={{-42,-124},{-57,-124}},
                                                 color={255,0,255}));
  connect(not2.y, delRetDam.u) annotation (Line(points={{-57,-124},{-50,-124},{-50,
          -180},{-42,-180}},
                      color={255,0,255}));
  connect(delRetDam.y, not1.u)
    annotation (Line(points={{-19,-180},{-2,-180}},color={255,0,255}));
  connect(not1.y, and2.u2) annotation (Line(points={{21,-180},{64,-180},{64,
          -172},{128,-172}},
                       color={255,0,255}));
  connect(uFreProSta, intEqu.u1) annotation (Line(points={{-300,50},{-240,50},{-240,
          60},{-100,60}},color={255,127,0}));
  connect(conInt.y, intEqu.u2) annotation (Line(points={{-117,40},{-110,40},{-110,
          52},{-100,52}},
                     color={255,127,0}));
  connect(intEqu.y, andEnaDis.u2) annotation (Line(points={{-77,60},{20,60},{20,
          40},{38,40}}, color={255,0,255}));
  connect(intEqu1.y, not3.u)
    annotation (Line(points={{-77,0},{-64,0}}, color={255,0,255}));
  connect(conInt1.y, intEqu1.u2) annotation (Line(points={{-117,-20},{-108,-20},
          {-108,-8},{-100,-8}},
                         color={255,127,0}));
  connect(uZonSta, intEqu1.u1) annotation (Line(points={{-300,-10},{-240,-10},{-240,
          0},{-100,0}},color={255,127,0}));
  connect(not3.y, andEnaDis.u3) annotation (Line(points={{-41,0},{19.5,0},{19.5,
          32},{38,32}}, color={255,0,255}));
  connect(outDamMaxFre.y, yOutDamPosMax) annotation (Line(points={{161,-106},{230,
          -106},{230,80},{290,80}},         color={0,0,127}));
  connect(outDamMaxFre.u2, outDamSwitch.y) annotation (Line(points={{138,-112},{
          100,-112},{100,-150},{83,-150}},  color={0,0,127}));
  connect(retDamMinFre.y, yRetDamPosMin)
    annotation (Line(points={{161,-250},{264,-250},{264,-100},{290,-100}},
                                                     color={0,0,127}));
  connect(retDamMinFre.u2, minRetDamSwitch.y) annotation (Line(points={{138,
          -256},{96,-256},{96,-250},{61,-250}}, color={0,0,127}));
  connect(conFreTMix.y,yFreOut. u) annotation (Line(points={{-179,-70},{-160,-70},
          {-160,-100},{-140,-100}}, color={0,0,127}));
  connect(conFreTMix.u_s, setPoiFre.y)
    annotation (Line(points={{-202,-70},{-219,-70}}, color={0,0,127}));
  connect(yFreOut.y, outDamMaxFre.u1)
    annotation (Line(points={{-117,-100},{138,-100}}, color={0,0,127}));
  connect(conFreTMix.y, retDamMinFre.u1) annotation (Line(points={{-179,-70},{92,
          -70},{92,-244},{138,-244}}, color={0,0,127}));
  connect(TMix, offSig.u) annotation (Line(points={{-300,-60},{-270,-60},{-270,-110},
          {-242,-110}}, color={0,0,127}));
  connect(offSig.y, conFreTMix.u_m) annotation (Line(points={{-219,-110},{-190,-110},
          {-190,-82}}, color={0,0,127}));
  annotation (
    defaultComponentName = "enaDis",
    Icon(coordinateSystem(
        extent={{-280,-280},{280,280}}),
         graphics={
        Rectangle(
          extent={{-282,-278},{280,278}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-2,120},{162,120}},
          color={0,0,127},
          thickness=0.5),
        Line(
          points={{-174,-158},{-2,-158},{-2,120}},
          color={0,0,127},
          thickness=0.5),
        Text(
          extent={{-174,332},{154,294}},
          lineColor={0,0,127},
          textString="%name")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-280,-280},{280,280}},
        initialScale=0.05),              graphics={
        Rectangle(
          extent={{-260,12},{200,-36}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-260,76},{200,24}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-260,136},{200,84}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-260,272},{202,144}},
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
          extent={{100,18},{212,-30}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Zone state -
disable if
Heating"),                       Text(
          extent={{100,102},{194,92}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Supply fan status"),
        Rectangle(
          extent={{-260,-44},{200,-274}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid)}),
Documentation(info="<html>
<p>
This is a multi zone VAV AHU economizer enable/disable sequence
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
The supply fan is off (<code>uSupFan = false</code>),
</li>
<li>
the zone state <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.Constants.ZoneStates\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.Constants.ZoneStates</a> is <code>heating</code>, or
</li>
<li>
the freeze protection stage
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.Constants.FreezeProtectionStages\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.Constants.FreezeProtectionStages</a>
is not <code>stage0</code>.
</li>
</ul>
<p>
The following state machine chart illustrates the transitions between enabling and disabling:
</p>
<p align=\"center\">
<img alt=\"Image of economizer enable-disable state machine chart\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36_PR1/AHUs/EconEnableDisableStateMachineChartMultiZone.png\"/>
</p>
<p>
After the disable signal is activated, the following procedure is applied, per PART5.N.7.d, in order to
prevent pressure fluctuations in the HVAC system:
</p>
<ul>
<li>
The return damper gets fully opened (<code>yRetDamPosMax = uRetDamPhyPosMax</code> and
<code>yRetDamPosMin = uRetDamPhyPosMax</code>) for <code>retDamFulOpeTim</code>
time period, after which the return damper gets released to its minimum outdoor airflow control position
(<code>yRetDamPosMax = uRetDamPosMax</code> and <code>yRetDamPosMin = uRetDamPosMax</code>).
</li>
<li>
The outdoor air damper is closed to its minimum outoor airflow control limit (<code>yOutDamPosMax = uOutDamPosMin</code>)
after a <code>disDel</code> time delay.
</li>
</ul>
<p>
This sequence also has an overwrite of the damper positions to track
a minimum mixed air temperature of <code>TFreSet</code>, which is
by default set to <i>4</i>&deg;C (<i>39.2</i> F).
This is implemented using a proportional controller with a default deadband of
<i>1</i> K, which can be adjusted using the parameter <code>kPFrePro</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 13, 2017, by Michael Wetter:<br/>
Added freeze protection that tracks mixed air temperature.
</li>
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
end Enable;
