within Buildings.Controls.OBC.DemandFlexibility.ChillerSetpointReset.Subsequences.Validation;
model Adjustment
  "Validation model for the chilled water temperature setpoint adjustment block"

  Buildings.Controls.OBC.DemandFlexibility.ChillerSetpointReset.Subsequences.Adjustment adjMul(
    final dTChiSetShe=0.278,
    final dTChiSetReb=0.278,
    final use_mulSteSetCha=true)
    "Setpoint adjustment with multiple incremental steps"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.Controls.OBC.DemandFlexibility.ChillerSetpointReset.Subsequences.Adjustment adjSin(
    final dTChiSetShe=0.278,
    final dTChiSetReb=0.278,
    final use_mulSteSetCha=false)
    "Setpoint adjustment with a single step"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable demFleMod(
    final table=[0,1; 750,2; 3750,3; 6150,1],
    final period=7200)
    "Demand flexibility mode"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable uEna(
    final table=[0,1; 1600,0; 2200,1; 4350,0; 4650,1],
    final period=7200)
    "Signal to enable setpoint change"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiSetDef(
    final k(final unit="K", displayUnit="degC")=279.82)
    "Default chilled water temperature setpoint"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiSetTarShe(
    final k(final unit="K", displayUnit="degC")=281.48)
    "Target chilled water temperature setpoint for the load-shed mode"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler samMul(
    final samplePeriod=300)
    "Setpoint change period for multiple-step adjustment"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler samSin(
    final samplePeriod=300)
    "Setpoint change period for single-step adjustment"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDelMul(
    final samplePeriod=10,
    final y_start=279.82)
    "Emulates an external chilled water setpoint controller for multiple-step adjustment"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDelSin(
    final samplePeriod=10,
    final y_start=279.82)
    "Emulates an external chilled water setpoint controller for single-step adjustment"
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
  connect(TChiSetDef.y, adjMul.TChiSetDef) annotation (Line(points={{-98,-20},
          {-70,-20},{-70,46},{-22,46}}, color={0,0,127}));
  connect(TChiSetDef.y, adjSin.TChiSetDef) annotation (Line(points={{-98,-20},
          {-70,-20},{-70,-54},{-22,-54}}, color={0,0,127}));
  connect(TChiSetTarShe.y, adjMul.TChiSetTarShe) annotation (Line(points={{-98,-60},
          {-60,-60},{-60,42},{-22,42}}, color={0,0,127}));
  connect(TChiSetTarShe.y, adjSin.TChiSetTarShe) annotation (Line(points={{-98,-60},
          {-60,-60},{-60,-58},{-22,-58}}, color={0,0,127}));
  connect(adjMul.TChiSetCom, samMul.u)
    annotation (Line(points={{2,50},{18,50}}, color={0,0,127}));
  connect(samMul.y, uniDelMul.u)
    annotation (Line(points={{42,50},{58,50}}, color={0,0,127}));
  connect(uniDelMul.y, adjMul.TChiSetCur) annotation (Line(points={{82,50},
          {100,50},{100,20},{-40,20},{-40,50},{-22,50}}, color={0,0,127}));
  connect(adjSin.TChiSetCom, samSin.u)
    annotation (Line(points={{2,-50},{18,-50}}, color={0,0,127}));
  connect(samSin.y, uniDelSin.u)
    annotation (Line(points={{42,-50},{58,-50}}, color={0,0,127}));
  connect(uniDelSin.y, adjSin.TChiSetCur) annotation (Line(points={{82,-50},
          {100,-50},{100,-80},{-40,-80},{-40,-50},{-22,-50}}, color={0,0,127}));

annotation (experiment(StopTime=6600, Interval=10, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/DemandFlexibility/ChillerSetpointReset/Subsequences/Validation/Adjustment.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.ChillerSetpointReset.Subsequences.Adjustment\">
ChillerSetpointReset.Subsequences.Adjustment</a>.
</p>
<p>
Two instances are tested: <code>adjMul</code> with multiple
incremental setpoint change steps of <i>0.278</i> K (<i>0.5</i>
&deg;F), and <code>adjSin</code> with a single setpoint change
step. The default setpoint is <i>279.82</i> K (<i>44</i> &deg;F)
and the target setpoint for the load-shed mode is <i>281.48</i> K.
</p>
<p>
For each instance, a <code>Sampler</code> with a period of
<i>300</i> seconds represents the waiting time between setpoint
changes, and a <code>UnitDelay</code> emulates an external
chilled water setpoint controller that passes its new setpoint
back to the input <code>TChiSetCur</code> after <i>10</i> seconds,
completing a full control loop.
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
Expected results for <code>uniDelMul.y</code> (the current
setpoint of <code>adjMul</code>): it increases by one step at
<i>910</i>, <i>1210</i>, and <i>1510</i> s, holds while
<code>uEna</code> is false, increases at <i>2410</i> and
<i>2710</i> s, and reaches the load-shed target <i>281.48</i> K
at <i>3010</i> s, where it is held. During the load-rebound mode,
it decreases by one step at <i>3910</i> and <i>4210</i> s, holds
while <code>uEna</code> is false, decreases at <i>4810</i>,
<i>5110</i>, and <i>5410</i> s, and reaches the default setpoint
at <i>5710</i> s, where it is held.
</p>
<p>
Expected results for <code>uniDelSin.y</code> (the current
setpoint of <code>adjSin</code>): it changes to the load-shed
target at <i>910</i> s and back to the default setpoint at
<i>3910</i> s.
</p>
</html>", revisions="<html>
<ul>
<li>
November 8, 2026, by Weiping Huang and Liam Cochrane:<br/>
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
