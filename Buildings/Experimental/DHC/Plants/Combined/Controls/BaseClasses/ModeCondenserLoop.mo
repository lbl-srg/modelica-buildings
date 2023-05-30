within Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses;
block ModeCondenserLoop
  "Block that determines the condenser loop mode"

  parameter Modelica.Units.SI.Temperature TTanSet[2, 2]
    "Tank temperature setpoints: 2 cycles with 2 setpoints"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  parameter Real fraUslTan(unit="1")
    "Useless fraction of TES"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  parameter Integer nTTan=2
    "Number of tank temperature points"
    annotation (Dialog(connectorSizing=true),HideResult=true);
  parameter Real ratFraChaTanLim[5](each final unit="1/h")=
    {-0.3, -0.2, -0.15, -0.10, -0.08}
    "Rate of change of tank charge fraction (over 10, 30, 120, 240, and 360') that triggers Charge Assist (<0)";
  parameter Modelica.Units.SI.SpecificHeatCapacity cp_default=
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "Specific heat capacity of the fluid";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput mConWatOutTan_flow(
    final unit="kg/s")
    "Mass flow rate out of lower port of TES tank (>0 when charging)"
    annotation (Placement(transformation(extent={{-240,40},{-200,80}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTan[nTTan](
    each final unit="K",
    each displayUnit="degC")
    "TES tank temperature"
    annotation (Placement(
        transformation(extent={{-240,0},{-200,40}}),      iconTransformation(
          extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput mode(
    final min=Buildings.Experimental.DHC.Plants.Combined.Controls.ModeCondenserLoop.tankCharge,
    final max=Buildings.Experimental.DHC.Plants.Combined.Controls.ModeCondenserLoop.heatRejection)
    "Condenser loop operating mode"
    annotation (Placement(transformation(extent={{200,-20},{240,20}}),
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
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim[5](each t=5*60)
    "Condition is true for given time"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyEnaTru(nin=6)
    "Any of the enable conditions is true"
    annotation (Placement(transformation(extent={{10,-98},{30,-78}})));
  Modelica.Blocks.Sources.RealExpression varCriWarUp(y=1 - fraChaTan.y)
    "Compute variable used to evaluate warmup criterion"
    annotation (Placement(transformation(extent={{-150,-90},{-130,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater criWarUp
    "Enable criterion based on time to warmup"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Buildings.Controls.OBC.CDL.Logical.And criWarUpAndChaLow
    "Both enable criteria met"
    annotation (Placement(transformation(extent={{-70,-90},{-50,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold criChaLow(t=0.97)
    "Low charge fraction criterion"
    annotation (Placement(transformation(extent={{-100,-130},{-80,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Not enaFal[6]
    "True if enabling condition is false"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd noEnaTruAndRatCon(nin=7)
    "None of the enable conditions is true AND HR rate condition true"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim2(t=15*60)
    "None of the enabling conditions is true for given time"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold criFlo(t=1E-4, h=1E-4)
    "Disable criterion based on flow rate"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold criTem(t=max(TTanSet)
         - 2)
    "Disable criterion based on temperature"
           annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.Controls.OBC.CDL.Logical.And criFloAndTem
    "Flow criterion and temperature criterion both true"
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timCriFlo(t=5*60)
    "Criterion true for given time"
    annotation (Placement(transformation(extent={{-70,50},{-50,70}})));
  Buildings.Controls.OBC.CDL.Logical.Or disCha
    "Any of the disabling conditions is true"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Latch enaCha "Enable charge assist mode"
    annotation (Placement(transformation(extent={{70,-70},{90,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timNotCha(t=5*60)
    annotation (Placement(transformation(extent={{10,150},{30,170}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timCriTem(t=5*60)
    "Criterion true for given time"
    annotation (Placement(transformation(extent={{-70,20},{-50,40}})));
  Buildings.Controls.OBC.CDL.Logical.Not criFraChaHig
    "High charge fraction criterion"
    annotation (Placement(transformation(extent={{-70,-130},{-50,-110}})));
  Buildings.Controls.OBC.CDL.Logical.And3 allEnaTru "All enable criteria true"
    annotation (Placement(transformation(extent={{40,130},{60,150}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timCriFraChaHig(t=5*60)
    annotation (Placement(transformation(extent={{-40,-130},{-20,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Or criTemOrCriChaHig
    "Temperature criterion or high charge fraction criterion true"
    annotation (Placement(transformation(extent={{10,110},{30,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mConWatHexCoo_flow(final unit="kg/s")
  "CW mass flow rate through secondary (plant) side of HX"
    annotation (Placement(transformation(extent={{-240,100},{-200,140}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold criFlo1(t=-1E-4, h=1E-4)
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timCriFlo1(t=60)
    "Criterion true for given time"
    annotation (Placement(transformation(extent={{-70,110},{-50,130}})));
  Buildings.Controls.OBC.CDL.Logical.Latch enaRej "Enable heat rejection mode"
    annotation (Placement(transformation(extent={{80,90},{100,110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant modTan(
    final k=Buildings.Experimental.DHC.Plants.Combined.Controls.ModeCondenserLoop.tankCharge)
    "Tank Charge/Discharge mode"
    annotation (Placement(transformation(extent={{110,50},{130,70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant modRej(
    final k=Buildings.Experimental.DHC.Plants.Combined.Controls.ModeCondenserLoop.heatRejection)
    "Heat rejection mode"
    annotation (Placement(transformation(extent={{108,130},{128,150}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant modCha(
    final k=Buildings.Experimental.DHC.Plants.Combined.Controls.ModeCondenserLoop.chargeAssist)
    "Charge assist mode"
    annotation (Placement(transformation(extent={{110,-50},{130,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi
    annotation (Placement(transformation(extent={{170,-10},{190,10}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi1
    annotation (Placement(transformation(extent={{110,90},{130,110}})));
  Modelica.Blocks.Sources.RealExpression varCriWarUp1(
    final y=0.08*abs(nHouToWarUp - 2))
    "Compute variable used to evaluate warmup criterion"
    annotation (Placement(transformation(extent={{-180,-98},{-160,-78}})));
  Buildings.Controls.OBC.CDL.Logical.Not isChaDis "Charge assist mode disabled"
    annotation (Placement(transformation(extent={{-20,150},{0,170}})));
  Buildings.Controls.OBC.CDL.Logical.And enaAndNotDis
    "Reset enable condition when disable is true to trigger latch block when (enable, disable) becomes (true, false) again"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Not notDis "Not disabled"
    annotation (Placement(transformation(extent={{10,-70},{30,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And enaAndNotDis1
    "Reset enable condition when disable is true to trigger latch block when (enable, disable) becomes (true, false) again"
    annotation (Placement(transformation(extent={{50,100},{70,120}})));
  Buildings.Controls.OBC.CDL.Logical.Not notDis1 "Not disabled"
    annotation (Placement(transformation(extent={{10,84},{30,104}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingAverage fraChaTan(delta=5*60)
    "Moving mean of tank charge fraction used for control logic"
    annotation (Placement(transformation(extent={{-150,-130},{-130,-110}})));
  Modelica.Blocks.Sources.RealExpression fraChaTanVal(y=fraChaTanIns)
    "Instantaneous tank charge fraction"
    annotation (Placement(transformation(extent={{-180,-130},{-160,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim1(t=5*60)
    "Condition is true for given time"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mConWatCon_flow(final unit="kg/s")
                "CW condenser loop mass flow rate" annotation (Placement(
        transformation(extent={{-240,-180},{-200,-140}}),
                                                     iconTransformation(extent={{-140,
            -60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatConChiLvg(final unit="K",
      displayUnit="degC")        "Chiller and HRC leaving CW temperature"
    annotation (Placement(transformation(extent={{-240,-200},{-200,-160}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatConRet(final unit="K",
      displayUnit="degC")       "CWC return temperature"
    annotation (Placement(transformation(extent={{-240,-220},{-200,-180}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract delTem "Compute Delta-T"
    annotation (Placement(transformation(extent={{-170,-200},{-150,-180}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply floOutHeaPum
    "Compute HP heat flow rate output "
    annotation (Placement(transformation(extent={{-130,-190},{-110,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter floCap(final k=
        cp_default)
    "Compute capacity flow rate"
    annotation (Placement(transformation(extent={{-188,-170},{-168,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract delTem1 "Compute Delta-T"
    annotation (Placement(transformation(extent={{-180,-10},{-160,10}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter floCap1(final k=
        cp_default)
    "Compute capacity flow rate"
    annotation (Placement(transformation(extent={{-180,30},{-160,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply floChaTan
    "Compute tank charge rate"
    annotation (Placement(transformation(extent={{-150,-10},{-130,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract ratHeaRec
    "Compute heat recovery rate"
    annotation (Placement(transformation(extent={{-90,-190},{-70,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold criRatHeaRec(t=1E-4, h
      =1E-4) "Disable criterion based on heat recovery rate"
    annotation (Placement(transformation(extent={{-60,-190},{-40,-170}})));
equation
  connect(ratFraChaTanVal.y, lesThr.u)
    annotation (Line(points={{-129,-40},{-102,-40}},
                                                 color={0,0,127}));
  connect(criWarUp.y, criWarUpAndChaLow.u1)
    annotation (Line(points={{-78,-80},{-72,-80}}, color={255,0,255}));
  connect(criChaLow.y, criWarUpAndChaLow.u2) annotation (Line(points={{-78,-120},
          {-74,-120},{-74,-88},{-72,-88}}, color={255,0,255}));
  connect(noEnaTruAndRatCon.y, tim2.u)
    annotation (Line(points={{32,0},{38,0}}, color={255,0,255}));
  connect(disCha.y, enaCha.clr) annotation (Line(points={{62,-30},{64,-30},{64,-44},
          {60,-44},{60,-66},{68,-66}},      color={255,0,255}));
  connect(criTem.y, timCriTem.u)
    annotation (Line(points={{-78,30},{-72,30}},   color={255,0,255}));
  connect(criFlo.y, timCriFlo.u)
    annotation (Line(points={{-78,60},{-72,60}},   color={255,0,255}));
  connect(timCriFlo.passed, criFloAndTem.u1) annotation (Line(points={{-48,52},{
          -40,52},{-40,40},{-32,40}}, color={255,0,255}));
  connect(timCriTem.passed, criFloAndTem.u2) annotation (Line(points={{-48,22},
          {-36,22},{-36,32},{-32,32}},color={255,0,255}));
  connect(criChaLow.y, criFraChaHig.u)
    annotation (Line(points={{-78,-120},{-72,-120}}, color={255,0,255}));
  connect(criFloAndTem.y, disCha.u1) annotation (Line(points={{-8,40},{4,40},{4,
          -30},{38,-30}},      color={255,0,255}));
  connect(timNotCha.passed, allEnaTru.u1) annotation (Line(points={{32,152},{36,
          152},{36,148},{38,148}}, color={255,0,255}));
  connect(criFraChaHig.y, timCriFraChaHig.u)
    annotation (Line(points={{-48,-120},{-42,-120}}, color={255,0,255}));
  connect(timCriFlo.passed, allEnaTru.u2) annotation (Line(points={{-48,52},{-40,
          52},{-40,140},{38,140}}, color={255,0,255}));
  connect(criTemOrCriChaHig.y, allEnaTru.u3) annotation (Line(points={{32,120},{
          36,120},{36,132},{38,132}}, color={255,0,255}));
  connect(timCriTem.passed, criTemOrCriChaHig.u1) annotation (Line(points={{-48,22},
          {-36,22},{-36,120},{8,120}},       color={255,0,255}));
  connect(timCriFraChaHig.passed, criTemOrCriChaHig.u2) annotation (Line(points={{-18,
          -128},{0,-128},{0,112},{8,112}},            color={255,0,255}));
  connect(criFlo1.y, timCriFlo1.u)
    annotation (Line(points={{-78,120},{-72,120}},   color={255,0,255}));
  connect(timCriFlo1.passed,enaRej. clr) annotation (Line(points={{-48,112},{-44,
          112},{-44,80},{76,80},{76,94},{78,94}},     color={255,0,255}));
  connect(enaRej.y, intSwi1.u2) annotation (Line(points={{102,100},{108,100}},
                     color={255,0,255}));
  connect(modRej.y, intSwi1.u1) annotation (Line(points={{130,140},{140,140},{140,
          120},{104,120},{104,108},{108,108}},
                                            color={255,127,0}));
  connect(modTan.y, intSwi1.u3) annotation (Line(points={{132,60},{140,60},{140,
          80},{104,80},{104,92},{108,92}},
                                        color={255,127,0}));
  connect(intSwi.y, mode)
    annotation (Line(points={{192,0},{220,0}}, color={255,127,0}));
  connect(enaCha.y, intSwi.u2) annotation (Line(points={{92,-60},{100,-60},{100,
          0},{168,0}},
                    color={255,0,255}));
  connect(modCha.y, intSwi.u1) annotation (Line(points={{132,-40},{140,-40},{140,
          8},{168,8}}, color={255,127,0}));
  connect(intSwi1.y, intSwi.u3) annotation (Line(points={{132,100},{144,100},{144,
          -8},{168,-8}}, color={255,127,0}));
  connect(varCriWarUp1.y, criWarUp.u2) annotation (Line(points={{-159,-88},{-102,
          -88}},                        color={0,0,127}));
  connect(varCriWarUp.y, criWarUp.u1)
    annotation (Line(points={{-129,-80},{-102,-80}}, color={0,0,127}));
  connect(TTan[nTTan], criTem.u) annotation (Line(points={{-220,20},{-120,20},{
          -120,30},{-102,30}},
                          color={0,0,127}));
  connect(isChaDis.y, timNotCha.u)
    annotation (Line(points={{2,160},{8,160}},     color={255,0,255}));
  connect(enaCha.y, isChaDis.u) annotation (Line(points={{92,-60},{100,-60},{100,
          60},{-32,60},{-32,160},{-22,160}}, color={255,0,255}));
  connect(mConWatHexCoo_flow, criFlo1.u)
    annotation (Line(points={{-220,120},{-102,120}}, color={0,0,127}));
  connect(mConWatOutTan_flow, criFlo.u)
    annotation (Line(points={{-220,60},{-102,60}}, color={0,0,127}));
  connect(disCha.y, notDis.u) annotation (Line(points={{62,-30},{64,-30},{64,-44},
          {4,-44},{4,-60},{8,-60}},            color={255,0,255}));
  connect(notDis.y, enaAndNotDis.u1) annotation (Line(points={{32,-60},{36,-60},
          {36,-80},{38,-80}}, color={255,0,255}));
  connect(enaAndNotDis.y, enaCha.u) annotation (Line(points={{62,-80},{64,-80},{
          64,-60},{68,-60}}, color={255,0,255}));
  connect(enaAndNotDis1.y, enaRej.u) annotation (Line(points={{72,110},{76,110},
          {76,100},{78,100}}, color={255,0,255}));
  connect(allEnaTru.y, enaAndNotDis1.u1) annotation (Line(points={{62,140},{64,140},
          {64,126},{44,126},{44,110},{48,110}}, color={255,0,255}));
  connect(notDis1.y, enaAndNotDis1.u2) annotation (Line(points={{32,94},{44,94},
          {44,102},{48,102}}, color={255,0,255}));
  connect(timCriFlo1.passed, notDis1.u) annotation (Line(points={{-48,112},{-44,
          112},{-44,94},{8,94}},   color={255,0,255}));
  connect(fraChaTanVal.y, fraChaTan.u)
    annotation (Line(points={{-159,-120},{-152,-120}}, color={0,0,127}));
  connect(fraChaTan.y, criChaLow.u) annotation (Line(points={{-128,-120},{-102,-120}},
                                                           color={0,0,127}));
  connect(lesThr.y, tim.u)
    annotation (Line(points={{-78,-40},{-42,-40}}, color={255,0,255}));
  connect(criWarUpAndChaLow.y, tim1.u)
    annotation (Line(points={{-48,-80},{-42,-80}}, color={255,0,255}));
  connect(enaAndNotDis.u2, anyEnaTru.y)
    annotation (Line(points={{38,-88},{32,-88}}, color={255,0,255}));
  connect(tim.passed, anyEnaTru.u[1:5]) annotation (Line(points={{-18,-48},{-6,-48},
          {-6,-86.25},{8,-86.25}},
                                color={255,0,255}));
  connect(tim1.passed, anyEnaTru.u[6])
    annotation (Line(points={{-18,-88},{8,-88},{8,-85.0833}},
                                                   color={255,0,255}));
  connect(lesThr.y, enaFal[1:5].u) annotation (Line(points={{-78,-40},{-60,-40},
          {-60,0},{-42,0}}, color={255,0,255}));
  connect(criWarUpAndChaLow.y, enaFal[6].u) annotation (Line(points={{-48,-80},{
          -46,-80},{-46,0},{-42,0}}, color={255,0,255}));
  connect(enaFal.y, noEnaTruAndRatCon.u[1:6])
    annotation (Line(points={{-18,0},{8,0},{8,2}},
                                             color={255,0,255}));
  connect(TConWatConRet, delTem.u1) annotation (Line(points={{-220,-200},{-180,-200},
          {-180,-184},{-172,-184}}, color={0,0,127}));
  connect(TConWatConChiLvg, delTem.u2) annotation (Line(points={{-220,-180},{-190,
          -180},{-190,-196},{-172,-196}}, color={0,0,127}));
  connect(mConWatCon_flow, floCap.u)
    annotation (Line(points={{-220,-160},{-190,-160}}, color={0,0,127}));
  connect(floCap.y, floOutHeaPum.u1) annotation (Line(points={{-166,-160},{-140,
          -160},{-140,-174},{-132,-174}}, color={0,0,127}));
  connect(delTem.y, floOutHeaPum.u2) annotation (Line(points={{-148,-190},{-140,
          -190},{-140,-186},{-132,-186}}, color={0,0,127}));
  connect(mConWatOutTan_flow, floCap1.u) annotation (Line(points={{-220,60},{-194,
          60},{-194,40},{-182,40}}, color={0,0,127}));
  connect(floCap1.y,floChaTan. u1) annotation (Line(points={{-158,40},{-156,40},
          {-156,6},{-152,6}}, color={0,0,127}));
  connect(delTem1.y,floChaTan. u2) annotation (Line(points={{-158,0},{-154,0},{-154,
          -6},{-152,-6}}, color={0,0,127}));
  connect(TTan[1], delTem1.u1) annotation (Line(points={{-220,15},{-220,16},{-218,
          16},{-218,20},{-188,20},{-188,6},{-182,6}}, color={0,0,127}));
  connect(TTan[nTTan], delTem1.u2) annotation (Line(points={{-220,20},{-208,20},
          {-208,20},{-192,20},{-192,-6},{-182,-6}},
                                              color={0,0,127}));
  connect(floOutHeaPum.y, ratHeaRec.u2) annotation (Line(points={{-108,-180},{-100,
          -180},{-100,-186},{-92,-186}}, color={0,0,127}));
  connect(floChaTan.y, ratHeaRec.u1) annotation (Line(points={{-128,0},{-120,0},
          {-120,-160},{-100,-160},{-100,-174},{-92,-174}}, color={0,0,127}));
  connect(criRatHeaRec.y, noEnaTruAndRatCon.u[7]) annotation (Line(points={{-38,
          -180},{-12,-180},{-12,3},{8,3}}, color={255,0,255}));
  connect(tim2.passed, disCha.u2) annotation (Line(points={{62,-8},{64,-8},{64,-14},
          {34,-14},{34,-38},{38,-38}}, color={255,0,255}));
  connect(ratHeaRec.y, criRatHeaRec.u)
    annotation (Line(points={{-68,-180},{-62,-180}}, color={0,0,127}));
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
          textString="%name")}), Diagram(coordinateSystem(extent={{-200,-220},{200,
            220}})),
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
</html>", revisions="<html>
<ul>
<li>
February 24, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end ModeCondenserLoop;
