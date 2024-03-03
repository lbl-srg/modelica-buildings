within Buildings.Templates.Plants.Controls.StagingRotation;
block StageChangeCommand "Generate stage change command"
  parameter Boolean have_inpPlrSta=false
    "Set to true to use an input signal for SPLR, false to use a parameter"
    annotation(Evaluate=true);
  parameter Real plrSta(
    start=0.9,
    final unit="1", final min=0, final max=1)
    "Staging part load ratio"
    annotation(Dialog(enable=not have_inpPlrSta));
  final parameter Real traStaEqu[nEqu, nSta]=
    {{staEqu[i, j] for i in 1:nSta} for j in 1:nEqu}
    "Tranpose of staging matrix";
  parameter Real staEqu[:,:](
    each unit="1",
    each min=0,
    each max=1)
    "Staging matrix – Equipment required for each stage";
  final parameter Integer nSta = size(staEqu, 1)
    "Number of stages"
    annotation(Evaluate=true);
  final parameter Integer nEqu = size(staEqu, 2)
    "Number of equipment"
    annotation(Evaluate=true);
  parameter Real capEqu[nEqu](
    each unit="W",
    each min=0)
    "Design capacity of each equipment";
  parameter Real dtRun(
    final unit="s",
    final min=0)=900
    "Runtime with exceeded staging part load ratio before staging event is triggered";
  parameter Real dtMea(
    final unit="s",
    final min=0)=300
    "Duration used to compute the moving average of required capacity";
  parameter Real cp_default(
    final unit="J/(kg.K)",
    final min=0)
    "Default specific heat capacity used to compute required capacity";
  parameter Real rho_default(
    final unit="kg/m3",
    final min=0)
    "Default density used to compute required capacity";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uPlrSta(
    final unit="1", final min=0, final max=1)
    if have_inpPlrSta
    "Input signal for staging part load ratio" annotation (Placement(
        transformation(extent={{-240,-160},{-200,-120}}),
                                                        iconTransformation(
          extent={{-140,-120},{-100,-80}})));
  // We allow the stage index to be zero, e.g., when the plant is disabled.
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta(
    final min=0, final max=nSta) "Stage index"
    annotation (Placement(transformation(extent={{-240,120},{-200,160}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRet(final unit="K", displayUnit="degC")
    "Return temperature used to compute required capacity" annotation (
      Placement(transformation(extent={{-240,-80},{-200,-40}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(final unit="K", displayUnit="degC")
    "Active supply temperature setpoint used to compute required capacity"
    annotation (Placement(transformation(extent={{-240,-40},{-200,0}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput V_flow(final unit="m3/s")
    "Volume flow rate used to compute required capacity"
    annotation (Placement(
        transformation(extent={{-240,-120},{-200,-80}}),
                                                       iconTransformation(
          extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract delT(
    y(final unit="K"))
    "Compute ∆T"
    annotation (Placement(transformation(extent={{-170,-50},{-150,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Abs absDelT(
    y(final unit="K"))
    "Compute absolute value of ∆T"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter capFlo(
    y(final unit="W/K"), final k=rho_default*cp_default)
    "Compute capacity flow rate"
    annotation (Placement(transformation(extent={{-168,-110},{-148,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply capReq "Compute required capacity"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant plrStaPar(final k=plrSta)
    if not have_inpPlrSta "Parameter value for SPLR"
    annotation (Placement(transformation(extent={{-190,-170},{-170,-150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant traMatStaEqu[nEqu, nSta](final k=
        traStaEqu) "Transpose of staging matrix"
    annotation (Placement(transformation(extent={{-70,170},{-50,190}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor reqEquSta[nEqu](each final
      nin=nSta) "Extract equipment required at given stage"
    annotation (Placement(transformation(extent={{-10,170},{10,190}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(final
      nout=nEqu)
    "Replicate signal"
    annotation (Placement(transformation(extent={{-104,150},{-84,170}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply capEquSta[nEqu]
    "Capacity of each equipment required at given stage"
    annotation (Placement(transformation(extent={{30,170},{50,190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant capEquPar[nEqu](final k=
        capEqu) "Capacity of each equipment"
    annotation (Placement(transformation(extent={{-70,110},{-50,130}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum capSta(nin=nEqu)
    "Compute nominal capacity of active stage"
    annotation (Placement(transformation(extent={{70,170},{90,190}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre "Compare OPLR to SPLR"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
  Buildings.Controls.OBC.CDL.Reals.MovingAverage movAve(delta=dtMea)
    "Compute moving average"
    annotation (Placement(transformation(extent={{-70,-50},{-50,-30}})));
  Buildings.Templates.Plants.Controls.Utilities.TimerWithReset timUp(final t=dtRun) "Timer"
    annotation (Placement(transformation(extent={{80,-50},{100,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edgUp
    "Trigger staging event when timer switches to true"
    annotation (Placement(transformation(extent={{120,-50},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Up "Stage up command"
    annotation (Placement(transformation(extent={{200,60},{240,100}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Dow
    "Stage down command" annotation (Placement(transformation(extent={{200,-100},
            {240,-60}}), iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Less    les "Compare OPLR to SPLR"
    annotation (Placement(transformation(extent={{30,-90},{50,-70}})));
  Buildings.Templates.Plants.Controls.Utilities.TimerWithReset timDow(final t=dtRun) "Timer"
    annotation (Placement(transformation(extent={{80,-90},{100,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edgDow
    "Trigger staging event when timer switches to true"
    annotation (Placement(transformation(extent={{120,-90},{140,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Or isStaTrn
    "Return true when a stage up or stage down transition is initiated"
    annotation (Placement(transformation(extent={{140,-190},{120,-170}})));
  Utilities.HoldValue hol(final dtHol_max=dtRun)
    "Hold value of required capacity at stage change"
    annotation (Placement(transformation(extent={{-30,-50},{-10,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant FIXME(k=false)
    "FIXME: Add stage completion signal"
    annotation (Placement(transformation(extent={{-100,-130},{-80,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre
    "Use left-limit of signal to break algebraic loop"
    annotation (Placement(transformation(extent={{100,-190},{80,-170}})));
  Buildings.Controls.OBC.CDL.Integers.Max maxInt
    "Maximum between stage index and 1"
    annotation (Placement(transformation(extent={{-140,150},{-120,170}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant one(final k=1)
    "Constant"
    annotation (Placement(transformation(extent={{-180,130},{-160,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1AvaSta[nSta]
    "Stage available signal" annotation (Placement(transformation(extent={{-240,
            20},{-200,60}}), iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idxSta[nSta](final k={i
        for i in 1:nSta}) "Stage index"
    annotation (Placement(transformation(extent={{-180,90},{-160,110}})));
  Buildings.Controls.OBC.CDL.Integers.Less idxStaLesAct[nSta]
    "Return true if stage index lower than active stage index"
    annotation (Placement(transformation(extent={{-150,50},{-130,70}})));
  Buildings.Controls.OBC.CDL.Logical.And idxStaLesActAva[nSta]
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep1(final
      nout=nSta) "Replicate signal"
    annotation (Placement(transformation(extent={{-180,50},{-160,70}})));
  Utilities.LastTrueIndex idxLasTru(nin=nSta)
    "Index of next available lower stage"
    annotation (Placement(transformation(extent={{-70,30},{-50,50}})));
  Buildings.Controls.OBC.CDL.Integers.Max maxInt1
    "Maximum between stage index and 1"
    annotation (Placement(transformation(extent={{-30,70},{-10,90}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep2(final
      nout=nEqu)
    "Replicate signal"
    annotation (Placement(transformation(extent={{10,70},{30,90}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor reqEquStaLow[nEqu](each final
            nin=nSta)
    "Extract equipment required at next available lower stage"
    annotation (Placement(transformation(extent={{-10,130},{10,150}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply capEquStaLow[nEqu]
    "Capacity of each equipment required at next available lower stage"
    annotation (Placement(transformation(extent={{30,130},{50,150}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum capStaLow(nin=nEqu)
    "Compute nominal capacity of next available lower stage"
    annotation (Placement(transformation(extent={{70,130},{90,150}})));
  Buildings.Controls.OBC.CDL.Integers.Min minInt
    "Minimum between stage index and 1"
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Convert to real value"
    annotation (Placement(transformation(extent={{10,30},{30,50}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply setZer
    "Set nominal capacity to zero if no lower available stage"
    annotation (Placement(transformation(extent={{110,130},{130,150}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply splTimCapSta
    "SPLR times capacity of active stage"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply splTimCapStaLow
    "SPLR times capacity of next available lower stage"
    annotation (Placement(transformation(extent={{-10,-130},{10,-110}})));
equation
  connect(TSupSet, delT.u1) annotation (Line(points={{-220,-20},{-180,-20},{-180,
          -34},{-172,-34}},
                     color={0,0,127}));
  connect(TRet, delT.u2) annotation (Line(points={{-220,-60},{-180,-60},{-180,-46},
          {-172,-46}},
                color={0,0,127}));
  connect(delT.y, absDelT.u)
    annotation (Line(points={{-148,-40},{-142,-40}},
                                                 color={0,0,127}));
  connect(V_flow, capFlo.u)
    annotation (Line(points={{-220,-100},{-170,-100}},
                                                    color={0,0,127}));
  connect(absDelT.y, capReq.u1) annotation (Line(points={{-118,-40},{-110,-40},{
          -110,-34},{-102,-34}},
                         color={0,0,127}));
  connect(capFlo.y, capReq.u2) annotation (Line(points={{-146,-100},{-110,-100},
          {-110,-46},{-102,-46}},
                         color={0,0,127}));
  connect(intScaRep.y,reqEquSta. index)
    annotation (Line(points={{-82,160},{0,160},{0,168}},color={255,127,0}));
  connect(traMatStaEqu.y,reqEquSta. u)
    annotation (Line(points={{-48,180},{-12,180}},
                                                 color={0,0,127}));
  connect(reqEquSta.y, capEquSta.u1) annotation (Line(points={{12,180},{20,180},
          {20,186},{28,186}}, color={0,0,127}));
  connect(capEquPar.y, capEquSta.u2) annotation (Line(points={{-48,120},{20,120},
          {20,174},{28,174}}, color={0,0,127}));
  connect(capEquSta.y, capSta.u)
    annotation (Line(points={{52,180},{68,180}}, color={0,0,127}));
  connect(capReq.y, movAve.u)
    annotation (Line(points={{-78,-40},{-72,-40}},
                                             color={0,0,127}));
  connect(timUp.passed, edgUp.u) annotation (Line(points={{102,-48},{110,-48},{
          110,-40},{118,-40}},
                       color={255,0,255}));
  connect(edgUp.y, y1Up) annotation (Line(points={{142,-40},{180,-40},{180,80},
          {220,80}},
                color={255,0,255}));
  connect(timDow.passed, edgDow.u) annotation (Line(points={{102,-88},{110,-88},
          {110,-80},{118,-80}}, color={255,0,255}));
  connect(edgDow.y, y1Dow) annotation (Line(points={{142,-80},{220,-80}},
                      color={255,0,255}));
  connect(movAve.y, hol.u) annotation (Line(points={{-48,-40},{-46,-40},{-46,-46},
          {-32,-46}},
                color={0,0,127}));
  connect(FIXME.y, hol.u1Rel) annotation (Line(points={{-78,-120},{-36,-120},{
          -36,-40},{-32,-40}},
                    color={255,0,255}));
  connect(edgDow.y, isStaTrn.u2) annotation (Line(points={{142,-80},{180,-80},{
          180,-188},{142,-188}},
                           color={255,0,255}));
  connect(edgUp.y, isStaTrn.u1) annotation (Line(points={{142,-40},{174,-40},{
          174,-180},{142,-180}},
                      color={255,0,255}));
  connect(isStaTrn.y, pre.u)
    annotation (Line(points={{118,-180},{102,-180}},
                                                   color={255,0,255}));
  connect(pre.y, hol.u1) annotation (Line(points={{78,-180},{-40,-180},{-40,-34},
          {-32,-34}},
               color={255,0,255}));
  connect(intScaRep.u, maxInt.y)
    annotation (Line(points={{-106,160},{-118,160}}, color={255,127,0}));
  connect(idxSta.y, idxStaLesAct.u1) annotation (Line(points={{-158,100},{-154,100},
          {-154,60},{-152,60}}, color={255,127,0}));
  connect(uSta, intScaRep1.u) annotation (Line(points={{-220,140},{-190,140},{-190,
          60},{-182,60}}, color={255,127,0}));
  connect(intScaRep1.y, idxStaLesAct.u2) annotation (Line(points={{-158,60},{-156,
          60},{-156,52},{-152,52}}, color={255,127,0}));
  connect(idxStaLesAct.y, idxStaLesActAva.u1) annotation (Line(points={{-128,60},
          {-120,60},{-120,40},{-112,40}}, color={255,0,255}));
  connect(u1AvaSta, idxStaLesActAva.u2) annotation (Line(points={{-220,40},{-126,
          40},{-126,32},{-112,32}}, color={255,0,255}));
  connect(idxStaLesActAva.y, idxLasTru.u1)
    annotation (Line(points={{-88,40},{-72,40}}, color={255,0,255}));
  connect(idxLasTru.y,maxInt1. u2) annotation (Line(points={{-48,40},{-44,40},{
          -44,74},{-32,74}},
                         color={255,127,0}));
  connect(one.y,maxInt1. u1) annotation (Line(points={{-158,140},{-40,140},{-40,
          86},{-32,86}}, color={255,127,0}));
  connect(maxInt1.y, intScaRep2.u)
    annotation (Line(points={{-8,80},{8,80}}, color={255,127,0}));
  connect(uSta, maxInt.u1) annotation (Line(points={{-220,140},{-190,140},{-190,
          166},{-142,166}}, color={255,127,0}));
  connect(one.y, maxInt.u2) annotation (Line(points={{-158,140},{-150,140},{-150,
          154},{-142,154}}, color={255,127,0}));
  connect(intScaRep2.y, reqEquStaLow.index) annotation (Line(points={{32,80},{
          40,80},{40,100},{0,100},{0,128}},
                                      color={255,127,0}));
  connect(traMatStaEqu.y, reqEquStaLow.u) annotation (Line(points={{-48,180},{
          -20,180},{-20,140},{-12,140}},
                                   color={0,0,127}));
  connect(reqEquStaLow.y, capEquStaLow.u2) annotation (Line(points={{12,140},{
          16,140},{16,134},{28,134}},
                                color={0,0,127}));
  connect(capEquPar.y, capEquStaLow.u1) annotation (Line(points={{-48,120},{20,
          120},{20,146},{28,146}},
                                 color={0,0,127}));
  connect(capEquStaLow.y, capStaLow.u)
    annotation (Line(points={{52,140},{68,140}},
                                               color={0,0,127}));
  connect(idxLasTru.y, minInt.u2) annotation (Line(points={{-48,40},{-44,40},{
          -44,34},{-32,34}}, color={255,127,0}));
  connect(one.y, minInt.u1) annotation (Line(points={{-158,140},{-40,140},{-40,
          46},{-32,46}},
                       color={255,127,0}));
  connect(minInt.y, intToRea.u)
    annotation (Line(points={{-8,40},{8,40}},
                                            color={255,127,0}));
  connect(capStaLow.y, setZer.u1) annotation (Line(points={{92,140},{100,140},{
          100,146},{108,146}},
                             color={0,0,127}));
  connect(intToRea.y, setZer.u2) annotation (Line(points={{32,40},{100,40},{100,
          134},{108,134}},
                         color={0,0,127}));
  connect(hol.y, gre.u1)
    annotation (Line(points={{-8,-40},{28,-40}}, color={0,0,127}));
  connect(uPlrSta, splTimCapSta.u1) annotation (Line(points={{-220,-140},{-60,
          -140},{-60,-74},{-12,-74}}, color={0,0,127}));
  connect(plrStaPar.y, splTimCapSta.u1) annotation (Line(points={{-168,-160},{
          -60,-160},{-60,-74},{-12,-74}}, color={0,0,127}));
  connect(splTimCapSta.y, gre.u2) annotation (Line(points={{12,-80},{14,-80},{
          14,-48},{28,-48}}, color={0,0,127}));
  connect(uPlrSta, splTimCapStaLow.u1) annotation (Line(points={{-220,-140},{
          -60,-140},{-60,-114},{-12,-114}}, color={0,0,127}));
  connect(plrStaPar.y, splTimCapStaLow.u1) annotation (Line(points={{-168,-160},
          {-60,-160},{-60,-114},{-12,-114}}, color={0,0,127}));
  connect(capSta.y, splTimCapSta.u2) annotation (Line(points={{92,180},{160,180},
          {160,-160},{-24,-160},{-24,-86},{-12,-86}}, color={0,0,127}));
  connect(setZer.y, splTimCapStaLow.u2) annotation (Line(points={{132,140},{156,
          140},{156,-156},{-20,-156},{-20,-126},{-12,-126}},color={0,0,127}));
  connect(splTimCapStaLow.y, les.u2) annotation (Line(points={{12,-120},{20,
          -120},{20,-88},{28,-88}}, color={0,0,127}));
  connect(hol.y, les.u1) annotation (Line(points={{-8,-40},{20,-40},{20,-80},{
          28,-80}}, color={0,0,127}));
  connect(gre.y, timUp.u)
    annotation (Line(points={{52,-40},{78,-40}}, color={255,0,255}));
  connect(les.y, timDow.u)
    annotation (Line(points={{52,-80},{78,-80}}, color={255,0,255}));
  connect(pre.y, timUp.reset) annotation (Line(points={{78,-180},{60,-180},{60,
          -48},{78,-48}}, color={255,0,255}));
  connect(pre.y, timDow.reset) annotation (Line(points={{78,-180},{60,-180},{60,
          -88},{78,-88}}, color={255,0,255}));
  annotation (
   defaultComponentName="chaSta",
   Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-120},{100,120}}),
      graphics={
        Line(
          points={{-90,-80.3976},{68,-80.3976}},
          color={192,192,192}),
        Rectangle(
          extent={{-100,120},{100,-120}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,170},{150,130}},
          textString="%name",
          textColor={0,0,255})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},{200,200}})),
    Documentation(info="<html>
FIXME: Add failsafe conditions.
FIXME: Add stage completion signal and use it to reset timer and to 
release the hold on the required capacity.
<p>
\"Timers shall reset to zero at the completion of every stage change.\"
</p>
<p>
The availability condition, which consists of staging up when  
the equipment necessary to operate the current stage are unavailable,
is implemented in 
<a href=\"modelica://Buildings.Templates.Plants.Controls.Utilities.StageIndex\">
Buildings.Templates.Plants.Controls.Utilities.StageIndex</a>.
</p>
</html>"));
end StageChangeCommand;
