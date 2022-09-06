within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences;
block Enable "Multi zone VAV AHU economizer enable/disable switch"

  parameter Boolean use_enthalpy = true
    "Set to true to evaluate outdoor air (OA) enthalpy in addition to temperature"
    annotation(Dialog(group="Conditional"));
  parameter Real delTOutHis(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=1
    "Delta between the temperature hysteresis high and low limit"
    annotation(Dialog(tab="Advanced", group="Hysteresis"));
  parameter Real delEntHis(
    final unit="J/kg",
    final quantity="SpecificEnergy")=1000
    "Delta between the enthalpy hysteresis high and low limits"
    annotation(Dialog(tab="Advanced", group="Hysteresis", enable = use_enthalpy));
  parameter Real retDamFulOpeTim(
    final unit="s",
    final quantity="Time")=180
    "Time period to keep RA damper fully open before releasing it for minimum outdoor airflow control
    at disable to avoid pressure fluctuations"
    annotation(Dialog(tab="Advanced", group="Delays at disable"));
  parameter Real disDel(
    final unit="s",
    final quantity="Time")=15
    "Short time delay before closing the OA damper at disable to avoid pressure fluctuations"
    annotation(Dialog(tab="Advanced", group="Delays at disable"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    final displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-300,232},{-260,272}}),
        iconTransformation(extent={{-140,110},{-100,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy
    "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-300,152},{-260,192}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOutCut(
    final unit="K",
    final displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "OA temperature high limit cutoff. For differential dry bulb temperature condition use return air temperature measurement"
    annotation (Placement(transformation(extent={{-300,192},{-260,232}}),
        iconTransformation(extent={{-140,90},{-100,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOutCut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy
    "OA enthalpy high limit cutoff. For differential enthalpy use return air enthalpy measurement"
    annotation (Placement(transformation(extent={{-300,112},{-260,152}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDam_min(
    final unit="1",
    final min=0,
    final max=1)
    "Minimum outdoor air damper position, output from damper position limits sequence"
    annotation (Placement(transformation(extent={{-300,-98},{-260,-58}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDam_max(
    final unit="1",
    final min=0,
    final max=1)
    "Maximum outdoor air damper position, output from damper position limits sequence"
    annotation (Placement(transformation(extent={{-300,-58},{-260,-18}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRetDam_max(
    final unit="1",
    final min=0,
    final max=1)
    "Maximum return air damper position, output from damper position limits sequence"
    annotation (Placement(transformation(extent={{-300,-178},{-260,-138}}),
        iconTransformation(extent={{-140,-130},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRetDam_min(
    final unit="1",
    final min=0,
    final max=1)
    "Minimum return air damper position, output from damper position limits sequence"
    annotation (Placement(transformation(extent={{-300,-218},{-260,-178}}),
        iconTransformation(extent={{-140,-150},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRetDamPhy_max(
    final unit="1",
    final min=0,
    final max=1)
    "Physical maximum return air damper position, output from damper position limits sequence"
    annotation (Placement(transformation(extent={{-300,-138},{-260,-98}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SupFan
    "Supply fan proven on"
    annotation (Placement(transformation(extent={{-300,62},{-260,102}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uFreProSta "Freeze protection stage status signal"
    annotation (Placement(transformation(extent={{-300,22},{-260,62}}),
        iconTransformation(extent={{-140,-10},{-100,30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDam_max(
    final unit="1",
    final min=0,
    final max=1)
    "Maximum outdoor air damper position"
    annotation (Placement(transformation(extent={{240,22},{280,62}}),
        iconTransformation(extent={{100,80},{140,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDam_min(
    final unit="1",
    final min=0,
    final max=1)
    "Minimum return air damper position"
    annotation (Placement(transformation(extent={{240,-98},{280,-58}}),
        iconTransformation(extent= {{100,-120},{140,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDam_max(
    final unit="1",
    final min=0,
    final max=1)
    "Maximum return air damper position"
    annotation (Placement(transformation(extent={{240,-38},{280,2}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(
    final trueHoldDuration=600)
    "Economizer should not be enabled or disabled within 10 minutes of change"
    annotation (Placement(transformation(extent={{20,182},{40,202}})));
  Buildings.Controls.OBC.CDL.Logical.And andEnaDis
    "Check freeze protection stage and zone state"
    annotation (Placement(transformation(extent={{60,12},{80,32}})));

protected
  final parameter Real TOutHigLimCutHig(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")= 0
    "Hysteresis high limit cutoff";
  final parameter Real TOutHigLimCutLow = TOutHigLimCutHig - delTOutHis
    "Hysteresis low limit cutoff";
  final parameter Real hOutHigLimCutHig(
    final unit="J/kg",
    final quantity="SpecificEnergy")= 0
    "Hysteresis block high limit cutoff";
  final parameter Real hOutHigLimCutLow = hOutHigLimCutHig - delEntHis
    "Hysteresis block low limit cutoff";

  Buildings.Controls.OBC.CDL.Continuous.Subtract sub2
    if use_enthalpy "Add block determines difference between hOut and hOutCut"
    annotation (Placement(transformation(extent={{-200,140},{-180,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub1
    "Add block determines difference between TOut and TOutCut"
    annotation (Placement(transformation(extent={{-200,220},{-180,240}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysOutTem(
    final uLow=TOutHigLimCutLow,
    final uHigh=TOutHigLimCutHig)
    "Outdoor air temperature hysteresis for both fixed and differential dry bulb temperature cutoff conditions"
    annotation (Placement(transformation(extent={{-160,220},{-140,240}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysOutEnt(
    final uLow=hOutHigLimCutLow,
    final uHigh=hOutHigLimCutHig) if use_enthalpy
    "Outdoor air enthalpy hysteresis for both fixed and differential enthalpy cutoff conditions"
    annotation (Placement(transformation(extent={{-160,140},{-140,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch outDamSwitch
    "Set maximum OA damper position to minimum at disable (after a given time delay)"
    annotation (Placement(transformation(extent={{82,-78},{102,-58}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch retDamSwitch "Set minimum RA damper position to maximum at disable"
    annotation (Placement(transformation(extent={{-20,-176},{0,-156}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch maxRetDamSwitch
    "Keep maximum RA damper position at physical maximum for a short time period after disable signal"
    annotation (Placement(transformation(extent={{60,-136},{80,-116}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch minRetDamSwitch
    "Keep minimum RA damper position at physical maximum for a short time period after disable"
    annotation (Placement(transformation(extent={{60,-178},{80,-158}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not that starts the timer at disable signal "
    annotation (Placement(transformation(extent={{-60,-58},{-40,-38}})));
  Buildings.Controls.OBC.CDL.Logical.And  and2 "Logical and"
    annotation (Placement(transformation(extent={{160,-100},{180,-80}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Check supply fan status"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Check if delay time has been passed after economizer being disabled"
    annotation (Placement(transformation(extent={{40,-54},{60,-34}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    "Logical block to check if the freeze protection is deactivated"
    annotation (Placement(transformation(extent={{-78,32},{-58,52}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delOutDamOsc(
    final delayTime=disDel)
    "Small delay before closing the outdoor air damper to avoid pressure fluctuations"
    annotation (Placement(transformation(extent={{-20,-58},{0,-38}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delRetDam(
    final delayTime=retDamFulOpeTim)
    "Keep return damper open to its physical maximum for a short period of time before closing the outdoor air damper and resuming the maximum return air damper position, per G36 Part N7"
    annotation (Placement(transformation(extent={{-20,-108},{0,-88}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{20,-108},{40,-88}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeProtectionStages.stage0)
    "Integer constant, stage 0"
    annotation (Placement(transformation(extent={{-118,12},{-98,32}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant entSubst1(
    final k=false) if not use_enthalpy
    "Deactivates outdoor air enthalpy condition if there is no enthalpy sensor"
    annotation (Placement(transformation(extent={{-160,180},{-140,200}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Check if either the temperature or the enthalpy condition is satisfied"
    annotation (Placement(transformation(extent={{-60,182},{-40,202}})));
equation
  connect(TOut, sub1.u1)
    annotation (Line(points={{-280,252},{-240,252},{-240,236},{-202,236}},color={0,0,127}));
  connect(TOutCut, sub1.u2)
    annotation (Line(points={{-280,212},{-240,212},{-240,224},{-202,224}},color={0,0,127}));
  connect(sub1.y, hysOutTem.u)
    annotation (Line(points={{-178,230},{-162,230}}, color={0,0,127}));
  connect(hOut, sub2.u1)
    annotation (Line(points={{-280,172},{-240,172},{-240,156},{-202,156}},color={0,0,127}));
  connect(hOutCut, sub2.u2)
    annotation (Line(points={{-280,132},{-240,132},{-240,144},{-202,144}}, color={0,0,127}));
  connect(sub2.y, hysOutEnt.u)
    annotation (Line(points={{-178,150},{-162,150}}, color={0,0,127}));
  connect(uOutDam_min, outDamSwitch.u1) annotation (Line(points={{-280,-78},{10,
          -78},{10,-60},{80,-60}}, color={0,0,127}));
  connect(uOutDam_max, outDamSwitch.u3) annotation (Line(points={{-280,-38},{-220,
          -38},{-220,-76},{80,-76}}, color={0,0,127}));
  connect(uRetDamPhy_max, maxRetDamSwitch.u1)
    annotation (Line(points={{-280,-118},{58,-118}}, color={0,0,127}));
  connect(uRetDam_max, maxRetDamSwitch.u3) annotation (Line(points={{-280,-158},
          {-158,-158},{-158,-134},{58,-134}}, color={0,0,127}));
  connect(andEnaDis.y, not2.u)
    annotation (Line(points={{82,22},{92,22},{92,-8},{-80,-8},{-80,-48},{-62,-48}},
      color={255,0,255}));
  connect(maxRetDamSwitch.y, yRetDam_max) annotation (Line(points={{82,-126},{200,
          -126},{200,-18},{260,-18}}, color={0,0,127}));
  connect(and2.y, maxRetDamSwitch.u2)
    annotation (Line(points={{182,-90},{190,-90},{190,-148},{40,-148},{40,-126},
          {58,-126}}, color={255,0,255}));
  connect(and2.y, minRetDamSwitch.u2)
    annotation (Line(points={{182,-90},{190,-90},{190,-148},{40,-148},{40,-168},
          {58,-168}}, color={255,0,255}));
  connect(not2.y, retDamSwitch.u2)
    annotation (Line(points={{-38,-48},{-30,-48},{-30,-166},{-22,-166}},color={255,0,255}));
  connect(uRetDam_max, retDamSwitch.u1)
    annotation (Line(points={{-280,-158},{-22,-158}}, color={0,0,127}));
  connect(uRetDam_min, retDamSwitch.u3) annotation (Line(points={{-280,-198},{-152,
          -198},{-152,-174},{-22,-174}}, color={0,0,127}));
  connect(retDamSwitch.y, minRetDamSwitch.u3)
    annotation (Line(points={{2,-166},{20,-166},{20,-176},{58,-176}},color={0,0,127}));
  connect(uRetDamPhy_max, minRetDamSwitch.u1) annotation (Line(points={{-280,-118},
          {20,-118},{20,-160},{58,-160}}, color={0,0,127}));
  connect(truFalHol.y, and1.u1)
    annotation (Line(points={{42,192},{50,192},{50,112},{10,112},{10,90},{18,90}},
      color={255,0,255}));
  connect(and1.y, andEnaDis.u1)
    annotation (Line(points={{42,90},{50,90},{50,22},{58,22}}, color={255,0,255}));
  connect(u1SupFan, and1.u2)
    annotation (Line(points={{-280,82},{18,82}}, color={255,0,255}));
  connect(outDamSwitch.u2, and3.y)
    annotation (Line(points={{80,-68},{70,-68},{70,-44},{62,-44}},color={255,0,255}));
  connect(not2.y, and3.u1)
    annotation (Line(points={{-38,-48},{-30,-48},{-30,-22},{28,-22},{28,-44},{38,-44}},
      color={255,0,255}));
  connect(and2.u1, not2.y)
    annotation (Line(points={{158,-90},{126,-90},{126,-22},{-30,-22},{-30,-48},{-38,-48}},
      color={255,0,255}));
  connect(and3.u2, delOutDamOsc.y)
    annotation (Line(points={{38,-52},{20,-52},{20,-48},{2,-48}},color={255,0,255}));
  connect(delOutDamOsc.u, not2.y)
    annotation (Line(points={{-22,-48},{-38,-48}}, color={255,0,255}));
  connect(not2.y, delRetDam.u)
    annotation (Line(points={{-38,-48},{-30,-48},{-30,-98},{-22,-98}},color={255,0,255}));
  connect(delRetDam.y, not1.u)
    annotation (Line(points={{2,-98},{18,-98}}, color={255,0,255}));
  connect(not1.y, and2.u2)
    annotation (Line(points={{42,-98},{158,-98}}, color={255,0,255}));
  connect(uFreProSta, intEqu.u1)
    annotation (Line(points={{-280,42},{-80,42}}, color={255,127,0}));
  connect(conInt.y, intEqu.u2)
    annotation (Line(points={{-96,22},{-90,22},{-90,34},{-80,34}}, color={255,127,0}));
  connect(intEqu.y, andEnaDis.u2)
    annotation (Line(points={{-56,42},{40,42},{40,14},{58,14}},color={255,0,255}));
  connect(outDamSwitch.y, yOutDam_max) annotation (Line(points={{104,-68},{190,-68},
          {190,42},{260,42}}, color={0,0,127}));
  connect(minRetDamSwitch.y, yRetDam_min) annotation (Line(points={{82,-168},{210,
          -168},{210,-78},{260,-78}}, color={0,0,127}));
  connect(or2.y, truFalHol.u) annotation (Line(points={{-38,192},{18,192}},
                     color={255,0,255}));
  connect(hysOutTem.y, or2.u1)
    annotation (Line(points={{-138,230},{-80,230},{-80,192},{-62,192}},
                                                    color={255,0,255}));
  connect(hysOutEnt.y, or2.u2) annotation (Line(points={{-138,150},{-100,150},{-100,
          184},{-62,184}}, color={255,0,255}));
  connect(entSubst1.y, or2.u2) annotation (Line(points={{-138,190},{-100,190},{-100,
          184},{-62,184}}, color={255,0,255}));
annotation (
    defaultComponentName = "enaDis",
    Icon(coordinateSystem(extent={{-100,-140},{100,140}}),
         graphics={
        Rectangle(
          extent={{-100,-140},{100,140}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,180},{100,140}},
          textColor={0,0,255},
          textString="%name"),
        Line(
          points={{0,60},{80,60}},
          color={0,0,127},
          thickness=0.5),
        Line(
          points={{-80,-60},{0,-60},{0,60}},
          color={0,0,127},
          thickness=0.5),
        Text(
          extent={{-98,38},{-56,24}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1SupFan"),
        Text(
          extent={{-100,18},{-44,4}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uFreProSta"),
        Text(
          extent={{-100,68},{-56,54}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="hOutCut",
          visible=use_enthalpy),
        Text(
          extent={{-100,86},{-70,72}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="hOut",
          visible=use_enthalpy),
        Text(
          extent={{-100,116},{-56,102}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TOutCut"),
        Text(
          extent={{-100,138},{-72,124}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TOut"),
        Text(
          extent={{-96,-100},{-32,-118}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uRetDam_max"),
        Text(
          extent={{-96,-10},{-28,-28}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uOutDam_max"),
        Text(
          extent={{-96,-30},{-28,-48}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uOutDam_min"),
        Text(
          extent={{-96,-80},{-12,-98}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uRetDamPhy_max"),
        Text(
          extent={{-96,-120},{-32,-138}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uRetDam_min"),
        Text(
          extent={{36,110},{96,92}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yOutDam_max"),
        Text(
          extent={{36,12},{96,-6}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yRetDam_max"),
        Text(
          extent={{36,-88},{96,-106}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yRetDam_min")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-260,-280},{240,280}},
        initialScale=0.05),              graphics={
        Rectangle(
          extent={{-240,-2},{220,-250}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-240,58},{220,6}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-240,118},{220,66}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-240,258},{220,130}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
                                     Text(
          extent={{120,158},{204,138}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Outdoor air
conditions"),                        Text(
          extent={{120,52},{298,18}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Freeze protection -
disable if stage1
and above"),                         Text(
          extent={{120,-198},{288,-246}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Damper position
limit assignments
with delays"),                   Text(
          extent={{120,84},{214,74}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Supply fan status")}),
Documentation(info="<html>
<p>
This is a multi zone VAV AHU economizer enable/disable sequence
based on the Section 5.16.7 of the ASHRAE Guideline 36, May 2020. Additional
conditions included in the sequence are: freeze protection (freeze protection
stage 0-3, see Section 5.16.12), supply fan status (on or off, see Section 5.16.5).
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
The supply fan is off (<code>u1SupFan = false</code>),
</li>
<li>
the freeze protection stage
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeProtectionStages\">
Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeProtectionStages</a>
is not <code>stage0</code>.
</li>
</ul>
<p>
The following state machine chart illustrates the transitions between enabling and disabling:
</p>
<p align=\"center\">
<img alt=\"Image of economizer enable-disable state machine chart\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/AHUs/MultiZone/VAV/Economizers/Subsequences/EconEnableDisableStateMachineChart.png\"/>
</p>
<p>
After the disable signal is activated, the following procedure is applied, in order to
prevent pressure fluctuations in the HVAC system:
</p>
<ul>
<li>
The return damper gets fully opened (<code>yRetDam_max = uRetDamPhy_max</code> and
<code>yRetDam_min = uRetDamPhy_max</code>) for <code>retDamFulOpeTim</code>
time period, after which the return damper gets released to its minimum outdoor airflow control position
(<code>yRetDam_max = uRetDam_max</code> and <code>yRetDam_min = uRetDam_max</code>).
</li>
<li>
The outdoor air damper is closed to its minimum outoor airflow control limit (<code>yOutDam_max = uOutDam_min</code>)
after a <code>disDel</code> time delay.
</li>
</ul>
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
