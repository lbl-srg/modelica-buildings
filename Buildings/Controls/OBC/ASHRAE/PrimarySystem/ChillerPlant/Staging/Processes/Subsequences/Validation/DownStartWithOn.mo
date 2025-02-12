within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.Validation;
model DownStartWithOn
  "Validate sequence of starting the staging down process which requires enabling a chiller"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.DownStart
    staStaDow1(
    final nChi=2,
    need_reduceChillerDemand=true,
    final byPasSetTim=300,
    final minFloSet={1,1},
    final maxFloSet={1.5,1.5},
    final chaChiWatIsoTim=300)
    "Chiller stage down when the process does require one chiller on and another chiller off"
    annotation (Placement(transformation(extent={{0,130},{20,150}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler demLimRel
    "To indicate if the demand limit has been released"
    annotation (Placement(transformation(extent={{20,190},{40,210}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.15,
    final period=1200) "Boolean pulse"
    annotation (Placement(transformation(extent={{-180,210},{-160,230}})));
  Buildings.Controls.OBC.CDL.Logical.Not staDow1 "Stage down command"
    annotation (Placement(transformation(extent={{-140,210},{-120,230}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi3 "Logical switch"
    annotation (Placement(transformation(extent={{-100,-250},{-80,-230}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zerLoa(
    final k=0) "Zero load"
    annotation (Placement(transformation(extent={{-180,100},{-160,120}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yOpeParLoaRatMin1(final k=0.7)
    "Minimum cycling operative partial load ratio"
    annotation (Placement(transformation(extent={{-180,170},{-160,190}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant onOff1(
    final k=true) "Chiller on-off command"
    annotation (Placement(transformation(extent={{-180,-30},{-160,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiFlo1(
    final k=2) "Chilled water flow"
    annotation (Placement(transformation(extent={{-180,10},{-160,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant nexDisChi1(
    final k=2) "Next disable chiller"
    annotation (Placement(transformation(extent={{-180,-230},{-160,-210}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer2(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-180,-270},{-160,-250}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-60,-250},{-40,-230}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiOneSta(
    final pre_u_start=false) "Break algebraic loop"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));
  Buildings.Controls.OBC.CDL.Reals.Switch chiOneLoa "Chiller one"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiLoa2(final k=20)
    "Chiller load"
    annotation (Placement(transformation(extent={{-180,60},{-160,80}})));
  Buildings.Controls.OBC.CDL.Reals.Switch chiTwoLoa "Chiller two load"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiTwoSta(
    final pre_u_start=true) "Break algebraic loop"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant nexEnaChi3(
    final k=1) "Next enable chiller"
    annotation (Placement(transformation(extent={{-180,-70},{-160,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer4(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-180,-110},{-160,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi4 "Logical switch"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant fulOpe(
    final k=1) "Full open"
    annotation (Placement(transformation(extent={{-180,-190},{-160,-170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zerOpe(
    final k=0) "Zero open"
    annotation (Placement(transformation(extent={{-180,-150},{-160,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Switch chiIsoVal2
    "Chilled water isolation valve one"
    annotation (Placement(transformation(extent={{-100,-190},{-80,-170}})));
  Buildings.Controls.OBC.CDL.Reals.Switch chiIsoVal1
    "Chilled water isolation valve one"
    annotation (Placement(transformation(extent={{-100,-150},{-80,-130}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol(
    final samplePeriod=10) "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{60,150},{80,170}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol1[2](
    final samplePeriod=fill(10,2))
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{120,-120},{140,-100}})));
  Buildings.Controls.OBC.CDL.Reals.Switch chiLoa1[2] "Chiller load"
    annotation (Placement(transformation(extent={{120,150},{140,170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer3[2](
    final k=fill(0,2)) "Constant zero"
    annotation (Placement(transformation(extent={{60,100},{80,120}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiLoa3(final k=20)
    "Chiller load"
    annotation (Placement(transformation(extent={{60,190},{80,210}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol2(
    final samplePeriod=10)
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{160,190},{180,210}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiOneHea(
    final pre_u_start=false) "Break algebraic loop"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiTwoHea(
    final pre_u_start=true) "Break algebraic loop"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one(
    final k=1) "Constant one"
    annotation (Placement(transformation(extent={{-20,190},{0,210}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    final width=0.95,
    final period=1200) "Boolean pulse"
    annotation (Placement(transformation(extent={{-180,130},{-160,150}})));
  Buildings.Controls.OBC.CDL.Logical.Not staDow2 "Stage down command"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol3(
    final samplePeriod=10)
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{160,140},{180,160}})));

equation
  connect(booPul1.y, staDow1.u)
    annotation (Line(points={{-158,220},{-142,220}}, color={255,0,255}));
  connect(staDow1.y, swi3.u2)
    annotation (Line(points={{-118,220},{-110,220},{-110,-240},{-102,-240}},
      color={255,0,255}));
  connect(nexDisChi1.y, swi3.u1)
    annotation (Line(points={{-158,-220},{-140,-220},{-140,-232},{-102,-232}},
      color={0,0,127}));
  connect(zer2.y, swi3.u3)
    annotation (Line(points={{-158,-260},{-140,-260},{-140,-248},{-102,-248}},
      color={0,0,127}));
  connect(swi3.y, reaToInt1.u)
    annotation (Line(points={{-78,-240},{-62,-240}}, color={0,0,127}));
  connect(staDow1.y, chiOneLoa.u2)
    annotation (Line(points={{-118,220},{-110,220},{-110,110},{-102,110}},
      color={255,0,255}));
  connect(zerLoa.y, chiOneLoa.u3)
    annotation (Line(points={{-158,110},{-140,110},{-140,102},{-102,102}},
      color={0,0,127}));
  connect(staDow1.y, chiTwoLoa.u2)
    annotation (Line(points={{-118,220},{-110,220},{-110,70},{-102,70}},
      color={255,0,255}));
  connect(chiLoa2.y, chiTwoLoa.u3)
    annotation (Line(points={{-158,70},{-140,70},{-140,62},{-102,62}},
      color={0,0,127}));
  connect(staStaDow1.yChi[1], chiOneSta.u)
    annotation (Line(points={{22,133.5},{52,133.5},{52,60},{78,60}},
      color={255,0,255}));
  connect(staStaDow1.yChi[2], chiTwoSta.u)
    annotation (Line(points={{22,134.5},{48,134.5},{48,30},{78,30}},
      color={255,0,255}));
  connect(staDow1.y, staStaDow1.uStaDow)
    annotation (Line(points={{-118,220},{-110,220},{-110,150},{-2,150}},
      color={255,0,255}));
  connect(yOpeParLoaRatMin1.y, staStaDow1.yOpeParLoaRatMin)
    annotation (Line(points={{-158,180},{-100,180},{-100,148},{-2,148}},
      color={0,0,127}));
  connect(chiOneLoa.y, staStaDow1.uChiLoa[1])
    annotation (Line(points={{-78,110},{-56,110},{-56,145.5},{-2,145.5}},
      color={0,0,127}));
  connect(chiTwoLoa.y, staStaDow1.uChiLoa[2])
    annotation (Line(points={{-78,70},{-60,70},{-60,146.5},{-2,146.5}},
      color={0,0,127}));
  connect(chiOneSta.y, staStaDow1.uChi[1])
    annotation (Line(points={{102,60},{180,60},{180,0},{-52,0},{-52,143.5},{-2,143.5}},
      color={255,0,255}));
  connect(chiTwoSta.y, staStaDow1.uChi[2])
    annotation (Line(points={{102,30},{110,30},{110,4},{-48,4},{-48,144.5},{-2,144.5}},
      color={255,0,255}));
  connect(onOff1.y, staStaDow1.uOnOff)
    annotation (Line(points={{-158,-20},{-40,-20},{-40,138},{-2,138}},
      color={255,0,255}));
  connect(zer4.y, swi4.u3)
    annotation (Line(points={{-158,-100},{-140,-100},{-140,-88},{-102,-88}},
      color={0,0,127}));
  connect(nexEnaChi3.y, swi4.u1)
    annotation (Line(points={{-158,-60},{-140,-60},{-140,-72},{-102,-72}},
      color={0,0,127}));
  connect(swi4.y, reaToInt2.u)
    annotation (Line(points={{-78,-80},{-62,-80}}, color={0,0,127}));
  connect(staDow1.y, swi4.u2)
    annotation (Line(points={{-118,220},{-110,220},{-110,-80},{-102,-80}},
      color={255,0,255}));
  connect(reaToInt2.y, staStaDow1.nexEnaChi)
    annotation (Line(points={{-38,-80},{-36,-80},{-36,136},{-2,136}},
      color={255,127,0}));
  connect(fulOpe.y, chiIsoVal2.u3)
    annotation (Line(points={{-158,-180},{-140,-180},{-140,-188},{-102,-188}},
      color={0,0,127}));
  connect(zerOpe.y, chiIsoVal1.u3)
    annotation (Line(points={{-158,-140},{-140,-140},{-140,-148},{-102,-148}},
      color={0,0,127}));
  connect(staDow1.y, chiIsoVal1.u2)
    annotation (Line(points={{-118,220},{-110,220},{-110,-140},{-102,-140}},
      color={255,0,255}));
  connect(staDow1.y, chiIsoVal2.u2)
    annotation (Line(points={{-118,220},{-110,220},{-110,-180},{-102,-180}},
      color={255,0,255}));
  connect(staStaDow1.yChiWatIsoVal, zerOrdHol1.u)
    annotation (Line(points={{22,138},{44,138},{44,-110},{118,-110}},
      color={0,0,127}));
  connect(zerOrdHol1[1].y, chiIsoVal1.u1)
    annotation (Line(points={{142,-110},{160,-110},{160,-160},{-120,-160},
      {-120,-132},{-102,-132}}, color={0,0,127}));
  connect(zerOrdHol1[2].y, chiIsoVal2.u1)
    annotation (Line(points={{142,-110},{160,-110},{160,-200},{-120,-200},
      {-120,-172},{-102,-172}}, color={0,0,127}));
  connect(chiIsoVal1.y, staStaDow1.uChiWatIsoVal[1])
    annotation (Line(points={{-78,-140},{-24,-140},{-24,131.5},{-2,131.5}},
      color={0,0,127}));
  connect(chiIsoVal2.y, staStaDow1.uChiWatIsoVal[2])
    annotation (Line(points={{-78,-180},{-20,-180},{-20,132.5},{-2,132.5}},
      color={0,0,127}));
  connect(reaToInt1.y, staStaDow1.nexDisChi)
    annotation (Line(points={{-38,-240},{-16,-240},{-16,130},{-2,130}},
      color={255,127,0}));
  connect(chiOneSta.y, chiLoa1[1].u2)
    annotation (Line(points={{102,60},{180,60},{180,130},{110,130},{110,160},
      {118,160}},  color={255,0,255}));
  connect(chiTwoSta.y, chiLoa1[2].u2)
    annotation (Line(points={{102,30},{110,30},{110,160},{118,160}},
      color={255,0,255}));
  connect(zer3.y, chiLoa1.u3)
    annotation (Line(points={{82,110},{100,110},{100,152},{118,152}},
      color={0,0,127}));
  connect(staStaDow1.yChiDem[2], zerOrdHol.u)
    annotation (Line(points={{22,149.5},{52,149.5},{52,160},{58,160}},
      color={0,0,127}));
  connect(zerOrdHol.y, chiLoa1[2].u1)
    annotation (Line(points={{82,160},{100,160},{100,168},{118,168}},
      color={0,0,127}));
  connect(chiLoa3.y, chiLoa1[1].u1)
    annotation (Line(points={{82,200},{100,200},{100,168},{118,168}},
      color={0,0,127}));
  connect(chiLoa1[1].y, zerOrdHol2.u)
    annotation (Line(points={{142,160},{150,160},{150,200},{158,200}},
      color={0,0,127}));
  connect(chiLoa1[2].y, chiTwoLoa.u1)
    annotation (Line(points={{142,160},{150,160},{150,10},{-120,10},{-120,78},
      {-102,78}}, color={0,0,127}));
  connect(zerOrdHol2.y, chiOneLoa.u1)
    annotation (Line(points={{182,200},{190,200},{190,90},{-120,90},{-120,118},
      {-102,118}}, color={0,0,127}));
  connect(staStaDow1.yChiHeaCon[1], chiOneHea.u)
    annotation (Line(points={{22,141.5},{36,141.5},{36,-20},{58,-20}},
      color={255,0,255}));
  connect(staStaDow1.yChiHeaCon[2], chiTwoHea.u)
    annotation (Line(points={{22,142.5},{40,142.5},{40,-50},{58,-50}},
      color={255,0,255}));
  connect(chiOneHea.y, staStaDow1.uChiHeaCon[1])
    annotation (Line(points={{82,-20},{90,-20},{90,-36},{-32,-36},{-32,133.5},{-2,
          133.5}}, color={255,0,255}));
  connect(chiTwoHea.y, staStaDow1.uChiHeaCon[2])
    annotation (Line(points={{82,-50},{90,-50},{90,-70},{-28,-70},{-28,134.5},{-2,
          134.5}},color={255,0,255}));
  connect(one.y, demLimRel.u)
    annotation (Line(points={{2,200},{18,200}}, color={0,0,127}));
  connect(staStaDow1.yReaDemLim, demLimRel.trigger)
    annotation (Line(points={{22,131},{30,131},{30,188}},   color={255,0,255}));
  connect(booPul2.y, staDow2.u)
    annotation (Line(points={{-158,140},{-142,140}}, color={255,0,255}));
  connect(staDow2.y, staStaDow1.clr)
    annotation (Line(points={{-118,140},{-2,140}},
      color={255,0,255}));
  connect(staStaDow1.yChiWatMinFloSet, zerOrdHol3.u) annotation (Line(points={{22,
          146},{154,146},{154,150},{158,150}}, color={0,0,127}));
  connect(zerOrdHol3.y, staStaDow1.VChiWat_flow) annotation (Line(points={{182,150},
          {196,150},{196,180},{-20,180},{-20,142},{-2,142}}, color={0,0,127}));
annotation (
 experiment(StopTime=1200, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Processes/Subsequences/Validation/DownStartWithOn.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.DownStart\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.DownStart</a>.
It shows the begining steps when the plant starts staging down. In this example,
the staging down process requires enabling one chiller and disabling another chiller.
</p>
<p>
It stages from stage 2, which only has larger chiller enabled (chiller 2), down to
stage 1 which only has smaller chiller enabled (chiller 1).
</p>
<ul>
<li>
The staging process begins at 180 seconds. Before the moment, the chiller 1 is
disabled and the chiller 2 is enabled.
</li>
<li>
Since 180 seconds, the operating chiller load is reduced from 20 A to 15 A (75%
of command load).
</li>
<li>
From 180 seconds to 480 seconds, the minimum flow setpoint (<code>yChiWatMinFlowSet</code>)
changes from 1 m3/s to 2 m3/s, which are the minimal flow setpoints for 1 chiller
operation and 2 chillers operation.
</li>
<li>
After the minimum chilled water flow setpoint being changed at 480 seconds, the
head pressure control for the chiller 1 becomes enabled
(<code>yChiHeaCon[1]=true</code>).
</li>
<li>
After 30 seconds at the 510 seconds, the isolation valve of chiller 1 starts
open and becomes fully open at 810 seconds.
</li>
<li>
At 810 seconds, the chiller 1 becomes enabled.
</li>
<li>
After 300 seconds at the 1110 seconds, the chiller 2 becomes disabled. The chiller
demand limit is released and the minimum chiller water flow setpoint then changes
to the one for only chiller 1 operating.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
September 26, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
     graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-300},{200,300}}),
        graphics={
        Text(
          extent={{-176,264},{14,248}},
          textColor={0,0,127},
          textString="to stage 1 which only has small chiller enabled (chiller 1)."),
        Text(
          extent={{-174,276},{14,266}},
          textColor={0,0,127},
          textString="from stage 2 which only has large chiller enabled (chiller 2), "),
        Text(
          extent={{-184,288},{-136,280}},
          textColor={0,0,127},
          textString="Stage down:")}));
end DownStartWithOn;
