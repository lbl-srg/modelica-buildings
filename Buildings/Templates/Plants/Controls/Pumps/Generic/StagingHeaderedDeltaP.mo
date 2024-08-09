within Buildings.Templates.Plants.Controls.Pumps.Generic;
block StagingHeaderedDeltaP
  "Staging logic for headered variable speed pumps using ∆p pump speed control"
  parameter Integer nPum(final min=1)
    "Number of pumps that operate at design conditions"
    annotation (Evaluate=true);
  parameter Integer nSenDp(final min=1)
    "Number of hardwired ∆p sensors"
    annotation (Evaluate=true);
  parameter Real V_flow_nominal(min=1E-6, unit="m3/s")
    "Design flow rate";
  parameter Real dtRun(
    min=0,
    unit="s")=10*60
    "Runtime before triggering stage change command based on efficiency condition";
  parameter Real dtRunFaiSaf(
    min=0,
    unit="s")=5*60
    "Runtime before triggering stage change command based on failsafe condition";
  parameter Real dtRunFaiSafLowY(
    min=0,
    unit="s")=dtRun
    "Runtime before triggering stage change command based on low pump speed failsafe condition";
  parameter Real dVOffUp(
    max=1,
    min=0,
    unit="1")=0.03
    "Stage up flow point offset (>0)";
  parameter Real dVOffDow(
    max=1,
    min=0,
    unit="1")=dVOffUp
    "Stage down flow point offset (>0)";
  parameter Real dpOff(
    min=0,
    unit="Pa")=1E4
    "Stage change ∆p point offset (>0)";
  parameter Real yUp(
    min=0,
    unit="1")=0.99
    "Stage up pump speed point";
  parameter Real yDow(
    min=0,
    unit="1")=0.4
    "Stage down pump speed point";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput V_flow(
    final unit="m3/s") "Flow rate"
    annotation (Placement(transformation(extent={{-200,40},{-160,80}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Up
    "Stage up command"
    annotation (Placement(transformation(extent={{160,40},{200,80}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Dow
    "Stage down command"
    annotation (Placement(transformation(extent={{160,0},{200,40}}),
      iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1_actual[nPum]
    "Pump status"
    annotation (Placement(transformation(extent={{-200,140},{-160,180}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter norV(
    final k=1 / V_flow_nominal)
    "Normalize to design value"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter norN(
    final k=1 / nPum)
    "Normalize to design value"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nPum]
    "Convert to real value"
    annotation (Placement(transformation(extent={{-150,150},{-130,170}})));
  Buildings.Controls.OBC.CDL.Reals.Greater higV
    "Compare to stage up flow point"
    annotation (Placement(transformation(extent={{-30,50},{-10,70}})));
  Buildings.Controls.OBC.CDL.Reals.Less lowV "Compare to stage down flow point"
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter poiDow(
    p=- 1 / nPum - dVOffDow)
    "Calculate stage down flow point"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter poiUp(
    p=- dVOffUp)
    "Calculate stage up flow point"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Buildings.Templates.Plants.Controls.Utilities.TimerWithReset timHigV(final t=
        dtRun)
    "Return true if stage up condition is true for specified duration"
    annotation (Placement(transformation(extent={{10,50},{30,70}})));
  Buildings.Templates.Plants.Controls.Utilities.TimerWithReset timLowV(final t=
        dtRun)
    "Return true if stage down condition is true for specified duration"
    annotation (Placement(transformation(extent={{10,10},{30,30}})));
  Buildings.Controls.OBC.CDL.Logical.Change cha[nPum]
    "Return true when pump status changes"
    annotation (Placement(transformation(extent={{-148,10},{-128,30}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum nOpe(
    nin=nPum)
    "Return number of operating pumps"
    annotation (Placement(transformation(extent={{-120,150},{-100,170}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyCha(
    nin=nPum)
    "Return true when any pump status changes"
    annotation (Placement(transformation(extent={{-108,10},{-88,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput y(final unit="1")
    "Pump speed command" annotation (Placement(transformation(extent={{-200,-40},
            {-160,0}}),   iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dp[nSenDp](each final unit="Pa")
    "Loop differential pressure" annotation (Placement(transformation(extent={{-200,
            -100},{-160,-60}}), iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpSet[nSenDp](each final unit
      ="Pa") "Loop differential pressure setpoint" annotation (Placement(
        transformation(extent={{-200,-160},{-160,-120}}), iconTransformation(
          extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold higY(final t=yUp)
    "True if pump speed command exceeds high limit"
    annotation (Placement(transformation(extent={{-110,-30},{-90,-10}})));
  Utilities.TimerWithReset timHigY(final t=dtRunFaiSaf)
                                                     "Timer"
    annotation (Placement(transformation(extent={{-70,-30},{-50,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract delDpSet[nSenDp]
    "Difference between dp measurement and setpoint"
    annotation (Placement(transformation(extent={{-150,-130},{-130,-110}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lowDp[nSenDp](each final t=-
        dpOff)
    "True if dp < setpoint - dpOff"
    annotation (Placement(transformation(extent={{-110,-130},{-90,-110}})));
  Utilities.TimerWithReset timLowDp[nSenDp](each final t=dtRunFaiSaf)
                                                                 "Timer"
    annotation (Placement(transformation(extent={{-70,-130},{-50,-110}})));
  Buildings.Controls.OBC.CDL.Logical.And higYAndLowDp
    "Return true when pump status changes"
    annotation (Placement(transformation(extent={{10,-70},{30,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Or effOrFailSafUp
    "True if efficiency OR failsafe condition met"
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lowY(final t=yDow)
    "True if pump speed command is less than low limit"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
  Utilities.TimerWithReset timLowY(final t=dtRunFaiSafLowY)
                                                     "Timer"
    annotation (Placement(transformation(extent={{-70,-70},{-50,-50}})));
  Utilities.TimerWithReset timHigDp[nSenDp](each final t=dtRunFaiSaf)
                                                                 "Timer"
    annotation (Placement(transformation(extent={{-70,-170},{-50,-150}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold higDp[nSenDp](each final t=
        -dpOff)
               "True if dp > setpoint - dpOff"
    annotation (Placement(transformation(extent={{-110,-170},{-90,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lckEff
    "Lock efficiency condition true signal until failsafe condition true"
    annotation (Placement(transformation(extent={{50,-90},{70,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lckFaiSaf
    "Lock failsafe condition true signal until efficiency condition true"
    annotation (Placement(transformation(extent={{50,-130},{70,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Pre preEff
    "True if lag pump staged on based on efficiency condition"
    annotation (Placement(transformation(extent={{70,-50},{50,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Pre preFaiSaf
    "True if lag pump staged on based on failsafe condition"
    annotation (Placement(transformation(extent={{70,-170},{50,-150}})));
  Buildings.Controls.OBC.CDL.Logical.And staDowAndPreEff
    "Stage down efficiency condition met and lag pump staged on based on efficiency condition"
    annotation (Placement(transformation(extent={{50,10},{70,30}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd staDowAndPreFaiSaf(nin=3)
    "Stage down failsafe condition met and lag pump staged on based on failsafe condition"
    annotation (Placement(transformation(extent={{10,-110},{30,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Or effOrFailSafDow
    "True if efficiency OR failsafe condition met"
    annotation (Placement(transformation(extent={{90,10},{110,30}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edgUp
    "Trigger stage up command when the conditions are met"
    annotation (Placement(transformation(extent={{120,50},{140,70}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edgDow
    "Trigger stage down command when the conditions are met"
    annotation (Placement(transformation(extent={{120,10},{140,30}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd allLowDp(nin=nSenDp)
    "True if condition met for all sensors"
    annotation (Placement(transformation(extent={{-30,-130},{-10,-110}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd allHigDp(nin=nSenDp)
    "True if condition met for all sensors"
    annotation (Placement(transformation(extent={{-30,-170},{-10,-150}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep(final
      nout=nSenDp) "Replicate signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-80,-90})));
equation
  connect(norN.y, poiDow.u)
    annotation (Line(points={{-98,100},{-90,100},{-90,80},{-82,80}},
                                                                  color={0,0,127}));
  connect(norN.y, poiUp.u)
    annotation (Line(points={{-98,100},{-90,100},{-90,120},{-82,120}},
                                                                  color={0,0,127}));
  connect(norV.y, higV.u1)
    annotation (Line(points={{-98,60},{-32,60}}, color={0,0,127}));
  connect(poiUp.y, higV.u2) annotation (Line(points={{-58,120},{-40,120},{-40,52},
          {-32,52}}, color={0,0,127}));
  connect(poiDow.y, lowV.u2) annotation (Line(points={{-58,80},{-50,80},{-50,12},
          {-32,12}}, color={0,0,127}));
  connect(norV.y, lowV.u1) annotation (Line(points={{-98,60},{-60,60},{-60,20},{
          -32,20}}, color={0,0,127}));
  connect(lowV.y, timLowV.u)
    annotation (Line(points={{-8,20},{8,20}},  color={255,0,255}));
  connect(V_flow, norV.u)
    annotation (Line(points={{-180,60},{-122,60}},
                                               color={0,0,127}));
  connect(higV.y, timHigV.u)
    annotation (Line(points={{-8,60},{8,60}},  color={255,0,255}));
  connect(booToRea.y, nOpe.u)
    annotation (Line(points={{-128,160},{-122,160}},
                                                  color={0,0,127}));
  connect(u1_actual, booToRea.u)
    annotation (Line(points={{-180,160},{-152,160}},
                                                   color={255,0,255}));
  connect(u1_actual, cha.u)
    annotation (Line(points={{-180,160},{-156,160},{-156,20},{-150,20}}, color={255,0,255}));
  connect(nOpe.y, norN.u)
    annotation (Line(points={{-98,160},{-90,160},{-90,130},{-130,130},{-130,100},
          {-122,100}},
      color={0,0,127}));
  connect(cha.y, anyCha.u)
    annotation (Line(points={{-126,20},{-110,20}},color={255,0,255}));
  connect(anyCha.y, timHigV.reset) annotation (Line(points={{-86,20},{-80,20},{
          -80,40},{0,40},{0,52},{8,52}},
                    color={255,0,255}));
  connect(anyCha.y, timLowV.reset) annotation (Line(points={{-86,20},{-80,20},{
          -80,0},{0,0},{0,12},{8,12}},
                    color={255,0,255}));
  connect(higY.y, timHigY.u)
    annotation (Line(points={{-88,-20},{-72,-20}}, color={255,0,255}));
  connect(y, higY.u)
    annotation (Line(points={{-180,-20},{-112,-20}},color={0,0,127}));
  connect(anyCha.y, timHigY.reset) annotation (Line(points={{-86,20},{-80,20},{
          -80,-28},{-72,-28}},
                           color={255,0,255}));
  connect(dp, delDpSet.u1) annotation (Line(points={{-180,-80},{-156,-80},{-156,
          -114},{-152,-114}}, color={0,0,127}));
  connect(dpSet, delDpSet.u2) annotation (Line(points={{-180,-140},{-156,-140},{
          -156,-126},{-152,-126}}, color={0,0,127}));
  connect(delDpSet.y, lowDp.u)
    annotation (Line(points={{-128,-120},{-112,-120}},color={0,0,127}));
  connect(lowDp.y, timLowDp.u)
    annotation (Line(points={{-88,-120},{-72,-120}}, color={255,0,255}));
  connect(timHigY.passed, higYAndLowDp.u1) annotation (Line(points={{-48,-28},{
          2,-28},{2,-60},{8,-60}}, color={255,0,255}));
  connect(timHigV.passed, effOrFailSafUp.u1) annotation (Line(points={{32,52},{36,
          52},{36,60},{88,60}},  color={255,0,255}));
  connect(higYAndLowDp.y, effOrFailSafUp.u2) annotation (Line(points={{32,-60},{
          40,-60},{40,52},{88,52}},  color={255,0,255}));
  connect(y, lowY.u) annotation (Line(points={{-180,-20},{-120,-20},{-120,-60},
          {-112,-60}},
                     color={0,0,127}));
  connect(lowY.y, timLowY.u)
    annotation (Line(points={{-88,-60},{-72,-60}}, color={255,0,255}));
  connect(anyCha.y, timLowY.reset) annotation (Line(points={{-86,20},{-80,20},{
          -80,-68},{-72,-68}},
                           color={255,0,255}));
  connect(higDp.y, timHigDp.u)
    annotation (Line(points={{-88,-160},{-72,-160}}, color={255,0,255}));
  connect(delDpSet.y, higDp.u) annotation (Line(points={{-128,-120},{-120,-120},
          {-120,-160},{-112,-160}},color={0,0,127}));
  connect(higYAndLowDp.y, lckEff.clr) annotation (Line(points={{32,-60},{40,-60},
          {40,-86},{48,-86}}, color={255,0,255}));
  connect(timHigV.passed, lckEff.u) annotation (Line(points={{32,52},{36,52},{36,
          -80},{48,-80}}, color={255,0,255}));
  connect(higYAndLowDp.y, lckFaiSaf.u) annotation (Line(points={{32,-60},{40,-60},
          {40,-120},{48,-120}}, color={255,0,255}));
  connect(timHigV.passed, lckFaiSaf.clr) annotation (Line(points={{32,52},{36,52},
          {36,-126},{48,-126}}, color={255,0,255}));
  connect(lckFaiSaf.y, preFaiSaf.u) annotation (Line(points={{72,-120},{80,-120},
          {80,-160},{72,-160}},  color={255,0,255}));
  connect(lckEff.y, preEff.u) annotation (Line(points={{72,-80},{76,-80},{76,-40},
          {72,-40}}, color={255,0,255}));
  connect(preEff.y, staDowAndPreEff.u2) annotation (Line(points={{48,-40},{46,-40},
          {46,12},{48,12}}, color={255,0,255}));
  connect(timLowV.passed, staDowAndPreEff.u1) annotation (Line(points={{32,12},{
          44,12},{44,20},{48,20}}, color={255,0,255}));
  connect(timLowY.passed, staDowAndPreFaiSaf.u[1]) annotation (Line(points={{-48,-68},
          {6,-68},{6,-102.333},{8,-102.333}},      color={255,0,255}));
  connect(preFaiSaf.y, staDowAndPreFaiSaf.u[2]) annotation (Line(points={{48,-160},
          {4,-160},{4,-100},{8,-100}},         color={255,0,255}));
  connect(staDowAndPreEff.y, effOrFailSafDow.u1)
    annotation (Line(points={{72,20},{88,20}},  color={255,0,255}));
  connect(staDowAndPreFaiSaf.y, effOrFailSafDow.u2) annotation (Line(points={{32,-100},
          {80,-100},{80,12},{88,12}},          color={255,0,255}));
  connect(effOrFailSafUp.y, edgUp.u)
    annotation (Line(points={{112,60},{118,60}}, color={255,0,255}));
  connect(edgUp.y, y1Up)
    annotation (Line(points={{142,60},{180,60}}, color={255,0,255}));
  connect(effOrFailSafDow.y, edgDow.u)
    annotation (Line(points={{112,20},{118,20}}, color={255,0,255}));
  connect(edgDow.y, y1Dow)
    annotation (Line(points={{142,20},{180,20}}, color={255,0,255}));
  connect(timLowDp.passed, allLowDp.u) annotation (Line(points={{-48,-128},{-40,
          -128},{-40,-120},{-32,-120}}, color={255,0,255}));
  connect(timHigDp.passed, allHigDp.u) annotation (Line(points={{-48,-168},{-40,
          -168},{-40,-160},{-32,-160}}, color={255,0,255}));
  connect(allLowDp.y, higYAndLowDp.u2) annotation (Line(points={{-8,-120},{0,-120},
          {0,-68},{8,-68}}, color={255,0,255}));
  connect(allHigDp.y, staDowAndPreFaiSaf.u[3]) annotation (Line(points={{-8,-160},
          {2,-160},{2,-97.6667},{8,-97.6667}}, color={255,0,255}));
  connect(anyCha.y, booScaRep.u) annotation (Line(points={{-86,20},{-80,20},{
          -80,-78},{-80,-78},{-80,-78}}, color={255,0,255}));
  connect(booScaRep.y, timLowDp.reset) annotation (Line(points={{-80,-102},{-80,
          -128},{-72,-128}}, color={255,0,255}));
  connect(booScaRep.y, timHigDp.reset) annotation (Line(points={{-80,-102},{-80,
          -168},{-72,-168}}, color={255,0,255}));
  annotation (
    defaultComponentName="staPum",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}),
    Documentation(
      info="<html>
<p>
Pumps are staged as a function of the ratio <i>ratV_flow</i>
of current volume flow rate <i>V_flow</i> to design volume 
flow rate <i>V_flow_nominal</i>,
the number of operating pumps <i>nPum_actual</i> 
and the number of pumps that operate at design conditions
<i>nPum</i>. 
Pumps are assumed to be equally sized.
<p>
<i>FR = V_flow / V_flow_nominal</i>
</p>
<p>
The next lag pump is enabled whenever either:
</p>
<ul>
<li>Efficiency condition:
<i>FR &gt; nPum_actual / nPum − dVOffUp</i> is true for <code>dtRun</code>; or
</li>
<li>Failsafe condition:
Pump speed command &gt; <code>yUp</code> for <code>dtRunFaiSaf</code>
and loop ∆p &lt; setpoint – <code>dpOff</code> for <code>dtRunFaiSaf</code>
for all hardwired differential pressure sensors.
</li>
</ul>
<p>The last lag pump is disabled whenever either:</p>
<ul>
<li>The lag pump was staged on based on the efficiency condition and 
<i>FR &lt; (nPum_actual - 1) / nPum − dVOffDow</i> is true for <code>dtRun</code>; or
</li>
<li>The lag pump was staged on based on the failsafe condition, 
pump speed command &lt; <code>yDow</code> for <code>dtRunFaiSafLowY</code>
and loop ∆p &gt; setpoint – <code>dpOff</code> for <code>dtRunFaiSaf</code>
for all hardwired differential pressure sensors.
</li>
</ul>
<p>
If desired, the stage down flow point <code>dVOffDow</code> can be
offset slightly below the stage up point <code>dVOffUp</code> to
prevent cycling between pump stages in applications with highly variable loads.
</p>
<p>
The timers are reset to zero when the status of a pump changes.
This is necessary to ensure the minimum pump runtime with rapidly changing loads.
</p>
<h4>Details</h4>
<p>The staging logic based on the efficiency condition (excluding the failsafe condition) 
is prescribed in ASHRAE, 2021 for:</p>
<ul>
<li>
headered variable speed primary pumps in primary-only chiller
and boiler plants using differential pressure pump speed control,
</li>
<li>
variable speed secondary pumps in primary-secondary chiller plants
with one or more sets of secondary loop pumps serving downstream
control valves,
</li>
<li>
variable speed secondary pumps in primary-secondary boiler
plants with serving a secondary loop with a flow meter.
</li>
</ul>
<p>
For other plant configurations, the pumps are staged with the equipment,
i.e., the number of pumps matches the number of chillers or boilers.
The actual logic for generating the pump enable commands is part of the
staging event sequencing.
</p>
<h4>References</h4>
<ul>
<li id=\"ASHRAE2021\">
ASHRAE, 2021. Guideline 36-2021, High-Performance Sequences of Operation
for HVAC Systems. Atlanta, GA.
</li>
</ul>
</html>
", revisions="<html>
<ul>
<li>
May 31, 2024, by Antoine Gautier:<br/>
Added failsafe conditions and refactored to generate a stage change command
at the exact time when the conditions are met.
</li>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(
      coordinateSystem(
        extent={{-160,-180},{160,180}})));
end StagingHeaderedDeltaP;
