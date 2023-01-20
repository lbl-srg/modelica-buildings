within Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses;
block ModeCondenserLoop
  "Block that determines the condenser loop mode"

  parameter Modelica.Units.SI.Temperature TTanSet[2, 2]
    "Tank temperature setpoints: 2 cycles with 2 setpoints"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  parameter Real fraUslTan(final unit="1", final min=0, final max=1)
    "Useless fraction of TES"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  parameter Integer nTTan=1
    "Number of tank temperature points"
    annotation (Dialog(connectorSizing=true),HideResult=true);
  parameter Real ratFraChaTanLim[3](each final unit="1/h")=
    {-0.3, -0.15, -0.8}
    "Rate of change of tank charge fraction (over 10, 30 and 60') that triggers charge assist (<0)";

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
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput mode "Operating mode"
    annotation (Placement(transformation(extent={{160,-20},{200,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Real fraChaTan(final unit="1")=
    (sum(TTan .- TTanSet[2, 2]) / (TTanSet[1, 2] - TTanSet[1, 1]) / nTTan - fraUslTan) /
    (1 - fraUslTan)
    "Tank charge fraction";
  Real ratFraChaTan[3](each final unit="1/h")=
    {(fraChaTan - delay(fraChaTan, i * 60)) * 3600 / (i * 60) for i in {10, 30, 60}}
    "Rate of change of tank charge fraction (over 10, 30 and 60')";
  Real nHouToWarUp(final unit="h") = noEvent(
    if mod(time, 24 * 3600) > 4 * 3600
      then 4 + 24 - mod(time, 24 * 3600) / 3600
    else 4 - mod(time, 24 * 3600) / 3600)
    "Number of hours between next warmup period (set at 4 AM by default)";

  Modelica.Blocks.Sources.RealExpression ratFraChaTanVal[3](final y=
        ratFraChaTan)
    "Rate of change of tank charge fraction, over 10, 30 and 60 minutes"
    annotation (Placement(transformation(extent={{-150,-50},{-130,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr[3](final t=
        ratFraChaTanLim)
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(t=5*60)
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(nin=3)
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Modelica.Blocks.Sources.RealExpression varCriWarUp(y=1 - fraChaTan)
                          "Compute variable used to evaluate warmup criterion"
    annotation (Placement(transformation(extent={{-150,-90},{-130,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater          criWarUp
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim1(t=5*60)
    annotation (Placement(transformation(extent={{-50,-90},{-30,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Any of the enabling conditions is true for given time"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And or1
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));
  Modelica.Blocks.Sources.RealExpression fraChaTanVal(y=fraChaTan)
    annotation (Placement(transformation(extent={{-150,-130},{-130,-110}})));
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
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold criFlo(t=0)
    annotation (Placement(transformation(extent={{-150,50},{-130,70}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold criTem(t=TTanSet[1, 2] -
        2) annotation (Placement(transformation(extent={{-150,10},{-130,30}})));
  Buildings.Controls.OBC.CDL.Logical.Or or4
    "Any of the enabling conditions is true for given time"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timCriFlo(t=5*60)
    "Criterion true for given time"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Logical.Or anyDis
    "Any of the disabling conditions is true"
    annotation (Placement(transformation(extent={{50,30},{70,50}})));
  Buildings.Controls.OBC.CDL.Logical.Latch latAss "Latch charge assist mode"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timNotCha(t=5*60)
    annotation (Placement(transformation(extent={{-60,150},{-40,170}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timCriTem(t=5*60)
    "Criterion true for given time"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Logical.Not criFraChaHig
    "High charge fraction criterion"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  Buildings.Controls.OBC.CDL.Logical.And3    and3
    annotation (Placement(transformation(extent={{20,130},{40,150}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timCriFraChaHig(t=5*60)
    annotation (Placement(transformation(extent={{-48,-130},{-28,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Or criTemOrCriChaHig
    "Temperature criterion or high charge fraction criterion true"
    annotation (Placement(transformation(extent={{-10,110},{10,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mConWatHexCoo_flow(final unit
      ="kg/s")
    "Mass flow rate out of lower port of TES tank (>0 when charging)"
    annotation (Placement(transformation(extent={{-200,100},{-160,140}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold criFlo1(t=0)
    annotation (Placement(transformation(extent={{-150,110},{-130,130}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timCriFlo1(t=1*60)
    "Criterion true for given time"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
  Buildings.Controls.OBC.CDL.Logical.Latch latRej "Latch heat rejection mode"
    annotation (Placement(transformation(extent={{50,130},{70,150}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant modTan(final k=Buildings.Experimental.DHC.Plants.Combined.Controls.ModeCondenserLoop.tankCharge)
    "Tank charge or discharge mode"
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant modRej(final k=Buildings.Experimental.DHC.Plants.Combined.Controls.ModeCondenserLoop.heatRejection)
    "Heat rejection mode"
    annotation (Placement(transformation(extent={{88,130},{108,150}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant modAss(final k=Buildings.Experimental.DHC.Plants.Combined.Controls.ModeCondenserLoop.chargeAssist)
    "Charge assist mode"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi
    annotation (Placement(transformation(extent={{130,-10},{150,10}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi1
    annotation (Placement(transformation(extent={{90,90},{110,110}})));
  Modelica.Blocks.Sources.RealExpression varCriWarUp1(final y=0.08*(nHouToWarUp -
        2))               "Compute variable used to evaluate warmup criterion"
    annotation (Placement(transformation(extent={{-150,-110},{-130,-90}})));
equation

  connect(ratFraChaTanVal.y, lesThr.u)
    annotation (Line(points={{-129,-40},{-122,-40}},
                                                 color={0,0,127}));
  connect(lesThr.y, mulOr.u[1:3])
    annotation (Line(points={{-98,-40},{-92,-40},{-92,-37.6667}},
                                                           color={255,0,255}));
  connect(tim.u, mulOr.y)
    annotation (Line(points={{-52,-40},{-68,-40}},
                                               color={255,0,255}));
  connect(tim.passed, or2.u1) annotation (Line(points={{-28,-48},{-24,-48},{-24,
          -60},{-12,-60}}, color={255,0,255}));
  connect(tim1.passed, or2.u2) annotation (Line(points={{-28,-88},{-24,-88},{-24,
          -68},{-12,-68}}, color={255,0,255}));
  connect(criWarUp.y, or1.u1)
    annotation (Line(points={{-98,-80},{-92,-80}}, color={255,0,255}));
  connect(tim1.u, or1.y)
    annotation (Line(points={{-52,-80},{-68,-80}}, color={255,0,255}));
  connect(fraChaTanVal.y, criChaLow.u)
    annotation (Line(points={{-129,-120},{-122,-120}}, color={0,0,127}));
  connect(criChaLow.y, or1.u2) annotation (Line(points={{-98,-120},{-94,-120},{-94,
          -88},{-92,-88}}, color={255,0,255}));
  connect(mulOr.y, enaFal[1].u) annotation (Line(points={{-68,-40},{-60,-40},{-60,
          0},{-52,0}}, color={255,0,255}));
  connect(or1.y, enaFal[2].u) annotation (Line(points={{-68,-80},{-60,-80},{-60,
          0},{-52,0}}, color={255,0,255}));
  connect(enaFal.y, anyEnaFal.u)
    annotation (Line(points={{-28,0},{-12,0}}, color={255,0,255}));
  connect(anyEnaFal.y, tim2.u)
    annotation (Line(points={{12,0},{18,0}}, color={255,0,255}));
  connect(mConWatOutTan_flow, criFlo.u)
    annotation (Line(points={{-180,60},{-152,60}}, color={0,0,127}));
  connect(tim2.passed, anyDis.u2) annotation (Line(points={{42,-8},{44,-8},{44,32},
          {48,32}}, color={255,0,255}));
  connect(or2.y, latAss.u)
    annotation (Line(points={{12,-60},{18,-60}}, color={255,0,255}));
  connect(anyDis.y, latAss.clr) annotation (Line(points={{72,40},{80,40},{80,-80},
          {14,-80},{14,-66},{18,-66}}, color={255,0,255}));
  connect(criTem.y, timCriTem.u)
    annotation (Line(points={{-128,20},{-122,20}}, color={255,0,255}));
  connect(criFlo.y, timCriFlo.u)
    annotation (Line(points={{-128,60},{-122,60}}, color={255,0,255}));
  connect(timCriFlo.passed, or4.u1) annotation (Line(points={{-98,52},{-60,52},{
          -60,40},{-52,40}}, color={255,0,255}));
  connect(timCriTem.passed, or4.u2) annotation (Line(points={{-98,12},{-60,12},{
          -60,32},{-52,32}}, color={255,0,255}));
  connect(criChaLow.y, criFraChaHig.u)
    annotation (Line(points={{-98,-120},{-82,-120}}, color={255,0,255}));
  connect(or4.y, anyDis.u1)
    annotation (Line(points={{-28,40},{48,40}}, color={255,0,255}));
  connect(timNotCha.passed, and3.u1) annotation (Line(points={{-38,152},{-20,152},
          {-20,148},{18,148}}, color={255,0,255}));
  connect(anyDis.y, timNotCha.u) annotation (Line(points={{72,40},{80,40},{80,80},
          {-66,80},{-66,160},{-62,160}}, color={255,0,255}));
  connect(criFraChaHig.y, timCriFraChaHig.u)
    annotation (Line(points={{-58,-120},{-50,-120}}, color={255,0,255}));
  connect(timCriFlo.passed, and3.u2) annotation (Line(points={{-98,52},{-60,52},
          {-60,140},{18,140}}, color={255,0,255}));
  connect(criTemOrCriChaHig.y, and3.u3) annotation (Line(points={{12,120},{16,120},
          {16,132},{18,132}}, color={255,0,255}));
  connect(timCriTem.passed, criTemOrCriChaHig.u1) annotation (Line(points={{-98,
          12},{-56,12},{-56,120},{-12,120}}, color={255,0,255}));
  connect(timCriFraChaHig.passed, criTemOrCriChaHig.u2) annotation (Line(points
        ={{-26,-128},{-20,-128},{-20,112},{-12,112}}, color={255,0,255}));
  connect(mConWatHexCoo_flow, criFlo1.u)
    annotation (Line(points={{-180,120},{-152,120}}, color={0,0,127}));
  connect(criFlo1.y, timCriFlo1.u)
    annotation (Line(points={{-128,120},{-122,120}}, color={255,0,255}));
  connect(and3.y, latRej.u)
    annotation (Line(points={{42,140},{48,140}}, color={255,0,255}));
  connect(timCriFlo1.passed, latRej.clr) annotation (Line(points={{-98,112},{-80,
          112},{-80,100},{44,100},{44,134},{48,134}}, color={255,0,255}));
  connect(latRej.y, intSwi1.u2) annotation (Line(points={{72,140},{80,140},{80,100},
          {88,100}}, color={255,0,255}));
  connect(modRej.y, intSwi1.u1) annotation (Line(points={{110,140},{120,140},{120,
          120},{84,120},{84,108},{88,108}}, color={255,127,0}));
  connect(modTan.y, intSwi1.u3) annotation (Line(points={{112,60},{120,60},{120,
          80},{86,80},{86,92},{88,92}}, color={255,127,0}));
  connect(intSwi.y, mode)
    annotation (Line(points={{152,0},{180,0}}, color={255,127,0}));
  connect(latAss.y, intSwi.u2) annotation (Line(points={{42,-60},{60,-60},{60,0},
          {128,0}}, color={255,0,255}));
  connect(modAss.y, intSwi.u1) annotation (Line(points={{112,-60},{120,-60},{120,
          8},{128,8}}, color={255,127,0}));
  connect(intSwi1.y, intSwi.u3) annotation (Line(points={{112,100},{124,100},{124,
          -8},{128,-8}}, color={255,127,0}));
  connect(varCriWarUp1.y, criWarUp.u2) annotation (Line(points={{-129,-100},{-126,
          -100},{-126,-88},{-122,-88}}, color={0,0,127}));
  connect(varCriWarUp.y, criWarUp.u1)
    annotation (Line(points={{-129,-80},{-122,-80}}, color={0,0,127}));
  connect(TTan[nTTan], criTem.u) annotation (Line(points={{-180,-60},{-156,-60},{-156,
          20},{-152,20}}, color={0,0,127}));
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
            180}})));
end ModeCondenserLoop;
