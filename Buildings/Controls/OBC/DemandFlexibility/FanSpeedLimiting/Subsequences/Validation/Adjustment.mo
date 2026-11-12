within Buildings.Controls.OBC.DemandFlexibility.FanSpeedLimiting.Subsequences.Validation;
model Adjustment
  "Validation model for the fan speed limit adjustment block"

  Buildings.Controls.OBC.DemandFlexibility.FanSpeedLimiting.Subsequences.Adjustment adjMul(
    final delFanSpeLimShe=0.05,
    final delFanSpeLimReb=0.05,
    final use_mulSteSetCha=true)
    "Fan speed limit adjustment with multiple incremental steps"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.Controls.OBC.DemandFlexibility.FanSpeedLimiting.Subsequences.Adjustment adjSin(
    final delFanSpeLimShe=0.05,
    final delFanSpeLimReb=0.05,
    final use_mulSteSetCha=false)
    "Fan speed limit adjustment with a single step"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable demFleMod(
    final table=[0,1; 750,2; 3750,3; 6150,1],
    final period=7200)
    "Demand flexibility mode"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable uEna(
    final table=[0,1; 1600,0; 2200,1; 4350,0; 4650,1],
    final period=7200)
    "Signal to enable fan speed limit change"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant fanSpeLimDef(
    final k(final unit="1")=1)
    "Default fan speed limit"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant fanSpeLimTarShe(
    final k(final unit="1")=0.72)
    "Target fan speed limit for the load-shed mode"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler samMul(
    final samplePeriod=300)
    "Fan speed limit change period for multiple-step adjustment"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler samSin(
    final samplePeriod=300)
    "Fan speed limit change period for single-step adjustment"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDelMul(
    final samplePeriod=10,
    final y_start=1)
    "Emulates an external fan controller for multiple-step adjustment"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDelSin(
    final samplePeriod=10,
    final y_start=1)
    "Emulates an external fan controller for single-step adjustment"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));

equation
  connect(demFleMod.y[1], adjMul.demFleMod) annotation (Line(points={{-98,80},
          {-90,80},{-90,58},{-22,58}}, color={255,127,0}));
  connect(demFleMod.y[1], adjSin.demFleMod) annotation (Line(points={{-98,80},
          {-90,80},{-90,-42},{-22,-42}}, color={255,127,0}));
  connect(uEna.y[1], adjMul.uEna) annotation (Line(points={{-98,40},{-80,40},
          {-80,54},{-22,54}}, color={255,0,255}));
  connect(uEna.y[1], adjSin.uEna) annotation (Line(points={{-98,40},{-80,40},
          {-80,-46},{-22,-46}}, color={255,0,255}));
  connect(fanSpeLimDef.y, adjMul.fanSpeLimDef) annotation (Line(points={{-98,-20},
          {-70,-20},{-70,46},{-22,46}}, color={0,0,127}));
  connect(fanSpeLimDef.y, adjSin.fanSpeLimDef) annotation (Line(points={{-98,-20},
          {-70,-20},{-70,-54},{-22,-54}}, color={0,0,127}));
  connect(fanSpeLimTarShe.y, adjMul.fanSpeLimTarShe) annotation (Line(points={{-98,-60},
          {-60,-60},{-60,42},{-22,42}}, color={0,0,127}));
  connect(fanSpeLimTarShe.y, adjSin.fanSpeLimTarShe) annotation (Line(points={{-98,-60},
          {-60,-60},{-60,-58},{-22,-58}}, color={0,0,127}));
  connect(adjMul.fanSpeLimCom, samMul.u)
    annotation (Line(points={{2,50},{18,50}}, color={0,0,127}));
  connect(samMul.y, uniDelMul.u)
    annotation (Line(points={{42,50},{58,50}}, color={0,0,127}));
  connect(uniDelMul.y, adjMul.fanSpeLimCur) annotation (Line(points={{82,50},
          {100,50},{100,20},{-40,20},{-40,50},{-22,50}}, color={0,0,127}));
  connect(adjSin.fanSpeLimCom, samSin.u)
    annotation (Line(points={{2,-50},{18,-50}}, color={0,0,127}));
  connect(samSin.y, uniDelSin.u)
    annotation (Line(points={{42,-50},{58,-50}}, color={0,0,127}));
  connect(uniDelSin.y, adjSin.fanSpeLimCur) annotation (Line(points={{82,-50},
          {100,-50},{100,-80},{-40,-80},{-40,-50},{-22,-50}}, color={0,0,127}));

annotation (experiment(StopTime=6600, Interval=10, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/DemandFlexibility/FanSpeedLimiting/Subsequences/Validation/Adjustment.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.FanSpeedLimiting.Subsequences.Adjustment\">
FanSpeedLimiting.Subsequences.Adjustment</a>.
</p>
<p>
Two instances are tested: <code>adjMul</code> with multiple
incremental fan speed limit change steps of <i>0.05</i>, and
<code>adjSin</code> with a single change step. The default fan
speed limit is <i>1</i> and the target fan speed limit for the
load-shed mode is <i>0.72</i>.
</p>
<p>
For each instance, a <code>Sampler</code> with a period of
<i>300</i> seconds represents the waiting time between fan
speed limit changes, and a <code>UnitDelay</code> emulates an
external fan controller that passes its new fan speed limit
back to the input <code>fanSpeLimCur</code> after <i>10</i>
seconds, completing a full control loop.
</p>
<p>
The demand flexibility mode is default (<i>1</i>) until
<i>750</i> s, load-shed (<i>2</i>) until <i>3750</i> s,
load-rebound (<i>3</i>) until <i>6150</i> s, and default
afterwards. The enabling signal <code>uEna</code> is false from
<i>1600</i> s to <i>2200</i> s and from <i>4350</i> s to
<i>4650</i> s.
</p>
<p>
Expected results for <code>uniDelMul.y</code> (the current fan
speed limit of <code>adjMul</code>): it decreases by one step at
<i>910</i>, <i>1210</i>, and <i>1510</i> s, holds while
<code>uEna</code> is false, decreases at <i>2410</i> and
<i>2710</i> s, and reaches the load-shed target <i>0.72</i> at
<i>3010</i> s, where it is held. During the load-rebound mode,
it increases by one step at <i>3910</i> and <i>4210</i> s,
holds while <code>uEna</code> is false, increases at
<i>4810</i>, <i>5110</i>, and <i>5410</i> s, and reaches the
default fan speed limit <i>1</i> at <i>5710</i> s, where it is
held.
</p>
<p>
Expected results for <code>uniDelSin.y</code> (the current fan
speed limit of <code>adjSin</code>): it changes to the load-shed
target at <i>910</i> s and back to the default fan speed limit
at <i>3910</i> s.
</p>
</html>", revisions="<html>
<ul>
<li>
October 21, 2026, by Weiping Huang and Liam Cochrane:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
    graphics={
      Ellipse(lineColor={75,138,73},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              extent={{-100,-100},{100,100}}),
      Polygon(lineColor={0,0,255},
              fillColor={75,138,73},
              pattern=LinePattern.None,
              fillPattern=FillPattern.Solid,
              points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{120,100}})));
end Adjustment;
