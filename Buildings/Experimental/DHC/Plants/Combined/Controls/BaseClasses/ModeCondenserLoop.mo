within Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses;
block ModeCondenserLoop
  "Block that determines the condenser loop mode"

  parameter Modelica.Units.SI.Temperature TTanSet[2, 2]
    "Tank temperature setpoints: 2 cycles with 2 setpoints"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  parameter Real fraUslTan(unit="1")
    "Useless fraction of TES"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  parameter Integer nTTan=1
    "Number of tank temperature points"
    annotation (Dialog(connectorSizing=true),HideResult=true);
  parameter Real ratFraChaTanLim[5](each final unit="1/h")=
    {-0.3, -0.2, -0.15, -0.10, -0.08}
    "Rate of change of tank charge fraction (over 10, 30, 120, 240, and 360') that triggers Charge Assist (<0)";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput mConWatOutTan_flow(
    final unit="kg/s")
    "Mass flow rate out of lower port of TES tank (>0 when charging)"
    annotation (Placement(transformation(extent={{-200,40},{-160,80}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTan[nTTan](
    each final unit="K",
    each displayUnit="degC")
    "TES tank temperature"
    annotation (Placement(
        transformation(extent={{-200,-80},{-160,-40}}),   iconTransformation(
          extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput mode(
    final min=Buildings.Experimental.DHC.Plants.Combined.Controls.ModeCondenserLoop.tankCharge,
    final max=Buildings.Experimental.DHC.Plants.Combined.Controls.ModeCondenserLoop.heatRejection)
    "Condenser loop operating mode"
    annotation (Placement(transformation(extent={{160,-20},{200,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Real fraChaTanIns(final unit="1")=
    (sum(TTan .- min(TTanSet)) / (max(TTanSet) - min(TTanSet)) / nTTan - fraUslTan) /
    (1 - fraUslTan)
    "Tank charge fraction (instantaneous value)";
  Real ratFraChaTan[5](each final unit="1/h")=
    {(fraChaTan.y - delay(fraChaTan.y, x)) / x * 3600  for x in
    {10, 30, 120, 240, 360} .* 60}
    "Rate of change of tank charge fraction (over 10, 30, 120, 240, and 360')";
  Real nHouToWarUp(final unit="h") = noEvent(
    if mod(time, 24 * 3600) > 4 * 3600
      then 4 + 24 - mod(time, 24 * 3600) / 3600
    else 4 - mod(time, 24 * 3600) / 3600)
    "Number of hours between next warmup period (set at 4 AM by default)";

  Modelica.Blocks.Sources.RealExpression ratFraChaTanVal[5](final y=ratFraChaTan)
    "Rate of change of tank charge fraction"
    annotation (Placement(transformation(extent={{-150,-50},{-130,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr[5](
    final t=ratFraChaTanLim, each h=1E-4)
    "Compare rate of change to threshold"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(t=5*60)
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(nin=5) "Any true"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Modelica.Blocks.Sources.RealExpression varCriWarUp(y=1 - fraChaTan.y)
    "Compute variable used to evaluate warmup criterion"
    annotation (Placement(transformation(extent={{-150,-90},{-130,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater criWarUp
    "Enable criterion based on time to warmup"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim1(t=5*60)
    annotation (Placement(transformation(extent={{-50,-90},{-30,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Or anyEnaTru
    "Any of the enabling conditions is true for given time"
    annotation (Placement(transformation(extent={{-10,-102},{10,-82}})));
  Buildings.Controls.OBC.CDL.Logical.And criWarUpAndChaLow
    "Both enable criteria met"
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold criChaLow(t=0.97)
    "Low charge fraction criterion"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Not enaFal[2]
    "True if enabling condition is false"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd anyEnaFal(nin=2)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim2(t=15*60)
    "None of the enabling conditions is true for given time"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold criFlo(t=1E-4, h=1E-4)
    "Disable criterion based on flow rate"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold criTem(t=TTanSet[1, 2] - 2)
    "Disable criterion based on temperature"
           annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Logical.And criFloAndTem
    "Flow criterion and temperature criterion both true"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timCriFlo(t=5*60)
    "Criterion true for given time"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
  Buildings.Controls.OBC.CDL.Logical.Or disCha
    "Any of the disabling conditions is true"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Latch enaCha "Enable charge assist mode"
    annotation (Placement(transformation(extent={{50,-70},{70,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timNotCha(t=5*60)
    annotation (Placement(transformation(extent={{-10,150},{10,170}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timCriTem(t=5*60)
    "Criterion true for given time"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Buildings.Controls.OBC.CDL.Logical.Not criFraChaHig
    "High charge fraction criterion"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  Buildings.Controls.OBC.CDL.Logical.And3 allEnaTru "All enable criteria true"
    annotation (Placement(transformation(extent={{20,130},{40,150}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timCriFraChaHig(t=5*60)
    annotation (Placement(transformation(extent={{-50,-130},{-30,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Or criTemOrCriChaHig
    "Temperature criterion or high charge fraction criterion true"
    annotation (Placement(transformation(extent={{-10,110},{10,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mConWatHexCoo_flow(final unit="kg/s")
  "CW mass flow rate through secondary (plant) side of HX"
    annotation (Placement(transformation(extent={{-200,100},{-160,140}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold criFlo1(t=-1E-4, h=1E-4)
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timCriFlo1(t=60)
    "Criterion true for given time"
    annotation (Placement(transformation(extent={{-90,110},{-70,130}})));
  Buildings.Controls.OBC.CDL.Logical.Latch enaRej "Enable heat rejection mode"
    annotation (Placement(transformation(extent={{60,90},{80,110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant modTan(
    final k=Buildings.Experimental.DHC.Plants.Combined.Controls.ModeCondenserLoop.tankCharge)
    "Tank Charge/Discharge mode"
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant modRej(
    final k=Buildings.Experimental.DHC.Plants.Combined.Controls.ModeCondenserLoop.heatRejection)
    "Heat rejection mode"
    annotation (Placement(transformation(extent={{88,130},{108,150}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant modCha(
    final k=Buildings.Experimental.DHC.Plants.Combined.Controls.ModeCondenserLoop.chargeAssist)
    "Charge assist mode"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi
    annotation (Placement(transformation(extent={{130,-10},{150,10}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi1
    annotation (Placement(transformation(extent={{90,90},{110,110}})));
  Modelica.Blocks.Sources.RealExpression varCriWarUp1(
    final y=0.08*abs(nHouToWarUp - 2))
    "Compute variable used to evaluate warmup criterion"
    annotation (Placement(transformation(extent={{-150,-110},{-130,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Not isChaDis "Charge assist mode disabled"
    annotation (Placement(transformation(extent={{-40,150},{-20,170}})));
  Buildings.Controls.OBC.CDL.Logical.And enaAndNotDis
    "Reset enable condition when disable is true to trigger latch block when (enable, disable) becomes (true, false) again"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Not notDis "Not disabled"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And enaAndNotDis1
    "Reset enable condition when disable is true to trigger latch block when (enable, disable) becomes (true, false) again"
    annotation (Placement(transformation(extent={{30,100},{50,120}})));
  Buildings.Controls.OBC.CDL.Logical.Not notDis1 "Not disabled"
    annotation (Placement(transformation(extent={{-10,84},{10,104}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingAverage fraChaTan(delta=5*60)
    "Moving mean of tank charge fraction used for control logic"
    annotation (Placement(transformation(extent={{-120,-170},{-100,-150}})));
  Modelica.Blocks.Sources.RealExpression fraChaTanVal(y=fraChaTanIns)
    "Instantaneous tank charge fraction"
    annotation (Placement(transformation(extent={{-150,-170},{-130,-150}})));
equation
  connect(ratFraChaTanVal.y, lesThr.u)
    annotation (Line(points={{-129,-40},{-122,-40}},
                                                 color={0,0,127}));
  connect(lesThr.y, mulOr.u)
    annotation (Line(points={{-98,-40},{-92,-40},{-92,-40}},
                                                           color={255,0,255}));
  connect(tim.u, mulOr.y)
    annotation (Line(points={{-52,-40},{-68,-40}},
                                               color={255,0,255}));
  connect(tim.passed, anyEnaTru.u1) annotation (Line(points={{-28,-48},{-24,-48},
          {-24,-92},{-12,-92}}, color={255,0,255}));
  connect(tim1.passed, anyEnaTru.u2) annotation (Line(points={{-28,-88},{-26,-88},
          {-26,-100},{-12,-100}}, color={255,0,255}));
  connect(criWarUp.y, criWarUpAndChaLow.u1)
    annotation (Line(points={{-98,-80},{-92,-80}}, color={255,0,255}));
  connect(tim1.u, criWarUpAndChaLow.y)
    annotation (Line(points={{-52,-80},{-68,-80}}, color={255,0,255}));
  connect(criChaLow.y, criWarUpAndChaLow.u2) annotation (Line(points={{-98,-120},
          {-94,-120},{-94,-88},{-92,-88}}, color={255,0,255}));
  connect(mulOr.y, enaFal[1].u) annotation (Line(points={{-68,-40},{-60,-40},{-60,
          0},{-52,0}}, color={255,0,255}));
  connect(criWarUpAndChaLow.y, enaFal[2].u) annotation (Line(points={{-68,-80},{
          -60,-80},{-60,0},{-52,0}}, color={255,0,255}));
  connect(enaFal.y, anyEnaFal.u)
    annotation (Line(points={{-28,0},{-12,0}}, color={255,0,255}));
  connect(anyEnaFal.y, tim2.u)
    annotation (Line(points={{12,0},{18,0}}, color={255,0,255}));
  connect(tim2.passed, disCha.u2) annotation (Line(points={{42,-8},{46,-8},{46,
          -14},{14,-14},{14,-38},{18,-38}}, color={255,0,255}));
  connect(disCha.y, enaCha.clr) annotation (Line(points={{42,-30},{44,-30},{44,
          -44},{40,-44},{40,-66},{48,-66}}, color={255,0,255}));
  connect(criTem.y, timCriTem.u)
    annotation (Line(points={{-98,20},{-92,20}},   color={255,0,255}));
  connect(criFlo.y, timCriFlo.u)
    annotation (Line(points={{-98,60},{-92,60}},   color={255,0,255}));
  connect(timCriFlo.passed, criFloAndTem.u1) annotation (Line(points={{-68,52},{
          -60,52},{-60,40},{-52,40}}, color={255,0,255}));
  connect(timCriTem.passed, criFloAndTem.u2) annotation (Line(points={{-68,12},{
          -56,12},{-56,32},{-52,32}}, color={255,0,255}));
  connect(criChaLow.y, criFraChaHig.u)
    annotation (Line(points={{-98,-120},{-82,-120}}, color={255,0,255}));
  connect(criFloAndTem.y, disCha.u1) annotation (Line(points={{-28,40},{-16,40},
          {-16,-30},{18,-30}}, color={255,0,255}));
  connect(timNotCha.passed, allEnaTru.u1) annotation (Line(points={{12,152},{16,
          152},{16,148},{18,148}}, color={255,0,255}));
  connect(criFraChaHig.y, timCriFraChaHig.u)
    annotation (Line(points={{-58,-120},{-52,-120}}, color={255,0,255}));
  connect(timCriFlo.passed, allEnaTru.u2) annotation (Line(points={{-68,52},{-60,
          52},{-60,140},{18,140}}, color={255,0,255}));
  connect(criTemOrCriChaHig.y, allEnaTru.u3) annotation (Line(points={{12,120},{
          16,120},{16,132},{18,132}}, color={255,0,255}));
  connect(timCriTem.passed, criTemOrCriChaHig.u1) annotation (Line(points={{-68,12},
          {-56,12},{-56,120},{-12,120}},     color={255,0,255}));
  connect(timCriFraChaHig.passed, criTemOrCriChaHig.u2) annotation (Line(points={{-28,
          -128},{-20,-128},{-20,112},{-12,112}},      color={255,0,255}));
  connect(criFlo1.y, timCriFlo1.u)
    annotation (Line(points={{-98,120},{-92,120}},   color={255,0,255}));
  connect(timCriFlo1.passed,enaRej. clr) annotation (Line(points={{-68,112},{
          -64,112},{-64,80},{56,80},{56,94},{58,94}}, color={255,0,255}));
  connect(enaRej.y, intSwi1.u2) annotation (Line(points={{82,100},{88,100}},
                     color={255,0,255}));
  connect(modRej.y, intSwi1.u1) annotation (Line(points={{110,140},{120,140},{120,
          120},{84,120},{84,108},{88,108}}, color={255,127,0}));
  connect(modTan.y, intSwi1.u3) annotation (Line(points={{112,60},{120,60},{120,
          80},{84,80},{84,92},{88,92}}, color={255,127,0}));
  connect(intSwi.y, mode)
    annotation (Line(points={{152,0},{180,0}}, color={255,127,0}));
  connect(enaCha.y, intSwi.u2) annotation (Line(points={{72,-60},{80,-60},{80,0},
          {128,0}}, color={255,0,255}));
  connect(modCha.y, intSwi.u1) annotation (Line(points={{112,-40},{120,-40},{
          120,8},{128,8}},
                       color={255,127,0}));
  connect(intSwi1.y, intSwi.u3) annotation (Line(points={{112,100},{124,100},{124,
          -8},{128,-8}}, color={255,127,0}));
  connect(varCriWarUp1.y, criWarUp.u2) annotation (Line(points={{-129,-100},{-126,
          -100},{-126,-88},{-122,-88}}, color={0,0,127}));
  connect(varCriWarUp.y, criWarUp.u1)
    annotation (Line(points={{-129,-80},{-122,-80}}, color={0,0,127}));
  connect(TTan[nTTan], criTem.u) annotation (Line(points={{-180,-60},{-156,-60},
          {-156,20},{-122,20}},
                          color={0,0,127}));
  connect(isChaDis.y, timNotCha.u)
    annotation (Line(points={{-18,160},{-12,160}}, color={255,0,255}));
  connect(enaCha.y, isChaDis.u) annotation (Line(points={{72,-60},{80,-60},{80,
          60},{-52,60},{-52,160},{-42,160}}, color={255,0,255}));
  connect(mConWatHexCoo_flow, criFlo1.u)
    annotation (Line(points={{-180,120},{-122,120}}, color={0,0,127}));
  connect(mConWatOutTan_flow, criFlo.u)
    annotation (Line(points={{-180,60},{-122,60}}, color={0,0,127}));
  connect(disCha.y, notDis.u) annotation (Line(points={{42,-30},{44,-30},{44,
          -44},{-16,-44},{-16,-60},{-12,-60}}, color={255,0,255}));
  connect(notDis.y, enaAndNotDis.u1) annotation (Line(points={{12,-60},{16,-60},
          {16,-80},{18,-80}}, color={255,0,255}));
  connect(anyEnaTru.y, enaAndNotDis.u2) annotation (Line(points={{12,-92},{16,-92},
          {16,-88},{18,-88}}, color={255,0,255}));
  connect(enaAndNotDis.y, enaCha.u) annotation (Line(points={{42,-80},{44,-80},{
          44,-60},{48,-60}}, color={255,0,255}));
  connect(enaAndNotDis1.y, enaRej.u) annotation (Line(points={{52,110},{56,110},
          {56,100},{58,100}}, color={255,0,255}));
  connect(allEnaTru.y, enaAndNotDis1.u1) annotation (Line(points={{42,140},{44,140},
          {44,126},{24,126},{24,110},{28,110}}, color={255,0,255}));
  connect(notDis1.y, enaAndNotDis1.u2) annotation (Line(points={{12,94},{24,94},
          {24,102},{28,102}}, color={255,0,255}));
  connect(timCriFlo1.passed, notDis1.u) annotation (Line(points={{-68,112},{-64,
          112},{-64,94},{-12,94}}, color={255,0,255}));
  connect(fraChaTanVal.y, fraChaTan.u)
    annotation (Line(points={{-129,-160},{-122,-160}}, color={0,0,127}));
  connect(fraChaTan.y, criChaLow.u) annotation (Line(points={{-98,-160},{-88,-160},
          {-88,-140},{-130,-140},{-130,-120},{-122,-120}}, color={0,0,127}));
  annotation (
  defaultComponentName="modConLoo",
  Icon(graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name")}), Diagram(coordinateSystem(extent={{-160,-180},{160,
            180}})),
    Documentation(info="<html>
<h4>Tank charge fraction and rate of change</h4>
<p>
The tank charge fraction <i>fraChaTan</i> (-) is computed as the
5-minute moving average of the following expression:
<i>(&sum;<sub>i</sub> (TTan<sub>i</sub> - min(TTanSet)) /
(max(TTanSet) - min(TTanSet)) / nTTan - fraUslTan) /
(1 - fraUslTan)</i>, where
<i>TTan<sub>i</sub></i> is the measurement from the <i>i</i>-th temperature sensor
along the vertical axis of the tank,
<i>TTanSet</i> are the tank temperature setpoints (two values for each
tank cycle),
<i>nTTan</i> is the number of temperature sensors along the vertical axis of the tank,
<i>fraUslTan</i> is the useless fraction of the tank which is computed as follows:
<i>fraUslTan = ((max(TTanSet[2]) - min(TTanSet)) / (max(TTanSet) - min(TTanSet)) * hThe + hHee) / hTan</i>,
where <i>hThe</i> is the height of the thermocline (<i>1&nbsp;</i>m by default)
which is considered useless only during the second tank cycle,
<i>hHee</i> is the upper and lower heel heights above and below the diffusers
(<i>1&nbsp;</i>m by default), <i>hTan</i> is the tank height (used as an
approximation for the normal operating level of the tank at minimum
temperature).
</p>
<p>
The rate of change of the tank charge fraction <i>ratFraChaTan</i> (h-1) is computed
over several time periods (<i>10</i>, <i>30</i>, <i>120</i>, <i>240</i>
and <i>360&nbsp;</i>min) as:
<i>ratFraChaTan(&Delta;t) = (fraChaTan(t) - fraChaTan(t - &Delta;t)) / &Delta;t * 3600</i>,
where <i>&Delta;t</i> is the time period in seconds.
</p>
<h4>Operating modes</h4>
<p>
Three operating modes are defined within
<a href=\"modelica://Buildings.Experimental.DHC.Plants.Combined.Controls.ModeCondenserLoop\">
Buildings.Experimental.DHC.Plants.Combined.Controls.ModeCondenserLoop</a>.
</p>
<h5>Charge Assist</h5>
<p>
The mode is enabled whenever any of the following conditions
is true for <i>5&nbsp;</i>min.
Any of the rates of change exceeds the values specified with the parameter
<code>ratFraChaTanLim</code>.
The tank charge fraction is lower than <i>97&nbsp;%</i> and
<i>1 - fraChaTan > 0.08 * abs(nHouToWarUp - 2)</i>, where
<i>fraChaTan</i> is the tank charge fraction and
<i>nHouToWarUp</i> is the number
of hours between the present time and the start time of morning warmup (<i>4 AM</i> by default).
The 2-hour offset forces Charge Assist mode two hours before morning warmup
if the tank is not fully charged.
</p>
<p>
The mode is disabled whenever none of the Enable conditions is true for
<i>15&nbsp;</i>min,
or the flow rate out of the lower port of the tank is positive for <i>5&nbsp;</i>min
and the temperature at the bottom of the tank is higher than the maximum tank
temperature setpoint minus <i>2&nbsp;</i>K for <i>5&nbsp;</i>min.
</p>
<h5>Heat Rejection</h5>
<p>
The mode is enabled whenever all of the following conditions are true.
The Charge Assist mode is disabled for <i>5&nbsp;</i>min.
The flow rate out of the lower port of the tank is positive for <i>5&nbsp;</i>min.
The tank charge fraction is higher than <i>97&nbsp;%</i> for <i>5&nbsp;</i>min
or the temperature at the bottom of the tank is higher than the maximum tank
temperature setpoint minus <i>2&nbsp;</i>K for <i>5&nbsp;</i>min.
</p>
<p>
The mode is disabled whenever there is reverse flow through the cooling
heat exchanger for <i>1&nbsp;</i>min.
</p>
<h5>Tank Charge/Discharge</h5>
<p>
The mode is enabled whenever neither Charge Assist nor Heat Rejection mode is enabled.
</p>
</html>"));
end ModeCondenserLoop;
