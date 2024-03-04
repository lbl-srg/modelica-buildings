within Buildings.Templates.Plants.Controls.Utilities;
block StageIndex
  "Evaluation of stage index from staging signals"
  parameter Boolean have_inpAva=true
    "Set to true if stage availability is provided with input signal, false for stages always available"
    annotation (Evaluate=true);
  parameter Integer nSta(
    start=1,
    final min=1)
    "Number of stages"
    annotation (Evaluate=true);
  parameter Real dtRun(
    final unit="s",
    final min=0,
    displayUnit="min")=0
    "Minimum runtime of each stage"
    annotation (Evaluate=true);
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Lea
    "Lead unit enable signal"
    annotation (Placement(transformation(extent={{-280,100},{-240,140}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Up
    "Stage up command"
    annotation (Placement(transformation(extent={{-280,-20},{-240,20}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Dow
    "Stage down command"
    annotation (Placement(transformation(extent={{-280,-60},{-240,-20}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Ava[nSta]
    if have_inpAva
    "Stage available signal"
    annotation (Placement(transformation(extent={{-280,-180},{-240,-140}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y
    "Stage index"
    annotation (Placement(transformation(extent={{240,80},{280,120}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Modelica.StateGraph.InitialStepWithSignal sta0(
    final nOut=nSta,
    final nIn=nSta)
    "Stage 0 – All units disabled"
    annotation (Placement(transformation(extent={{-110,130},{-90,150}})));
  Modelica.StateGraph.StepWithSignal sta[nSta](
    each final nIn=nSta + 1,
    each final nOut=nSta + 1)
    "Stage i>0"
    annotation (Placement(transformation(extent={{-10,130},{10,150}})));
  Modelica.StateGraph.TransitionWithSignal sta0ToSta[nSta](
    each final enableTimer=false)
    "Transition from stage 0 to stage i>0"
    annotation (Placement(transformation(extent={{-70,130},{-50,150}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    "State graph root"
    annotation (Placement(transformation(extent={{-10,210},{10,230}})));
  Modelica.StateGraph.TransitionWithSignal staToSta[nSta,nSta](each final
      enableTimer=false) "Transition to higher or lower stage"
    annotation (Placement(transformation(extent={{130,130},{150,150}})));
  Buildings.Controls.OBC.CDL.Logical.And runAndTrn[nSta]
    "Runtime condition met AND stage transition command"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rep(
    final nout=nSta)
    "Replicate"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.StateGraph.TransitionWithSignal staToSta0[nSta](each final
      enableTimer=false) "Transition from stage i>0 to stage 0"
    annotation (Placement(transformation(extent={{50,150},{70,170}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rep2(
    final nout=nSta)
    "Replicate"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Logical.Not notLea
    "True if lead unit is disabled"
    annotation (Placement(transformation(extent={{-190,30},{-170,50}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd upAndEna(
    nin=3)
    "Stage up and lead unit enabled and higher stage available"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Utilities.FirstTrueIndex idxFirAct(
    nin=nSta)
    "Return index of first active stage"
    annotation (Placement(transformation(extent={{180,90},{200,110}})));
  Buildings.Controls.OBC.CDL.Logical.Not una[nSta]
    "True if stage is not available"
    annotation (Placement(transformation(extent={{-190,-170},{-170,-150}})));
  Buildings.Controls.OBC.CDL.Logical.And runAndEna[nSta]
    "Runtime condition met AND lead enable signal false"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractor staUna(
    final nin=nSta)
    "Return true if current stage is unavailable"
    annotation (Placement(transformation(extent={{-150,-170},{-130,-150}})));
  Buildings.Controls.OBC.CDL.Integers.Max maxInt
    "Maximum between current stage index and 1"
    annotation (Placement(transformation(extent={{-190,-210},{-170,-190}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant one(
    final k=1)
    "Constant"
    annotation (Placement(transformation(extent={{-230,-210},{-210,-190}})));
  PlaceHolder pas[nSta](
    each final have_inp=dtRun > 0,
    each final have_inpPla=true)
    "Direct pass-through when no minimum runtime"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={-30,80})));
  FirstTrueIndex idxFirAva(
    nin=nSta)
    "Return index of first available stage"
    annotation (Placement(transformation(extent={{-190,-130},{-170,-110}})));
  LastTrueIndex idxLasAva(
    nin=nSta)
    "Return index of last available stage"
    annotation (Placement(transformation(extent={{-190,-90},{-170,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Greater higAva
    "Return true if there is any higher stage available"
    annotation (Placement(transformation(extent={{-150,-90},{-130,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Less lowAva
    "Return true if there is any lower stage available"
    annotation (Placement(transformation(extent={{-150,-130},{-130,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim[nSta](
    passed(
      each start=false),
    each final t=dtRun)
    if dtRun > 0
    "Timer for minimum runtime"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  PlaceHolder pla[nSta](
    each final have_inp=have_inpAva,
    each final have_inpPla=false,
    each final u_internal=true)
    "Replace with placeholder value if input signal is not available"
    annotation (Placement(transformation(extent={{-230,-170},{-210,-150}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd dowAndEna(
    nin=3)
    "Stage down and lead unit enabled and lower stage available"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Or upOrDow
    "Stage up or down"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Buildings.Controls.OBC.CDL.Integers.Switch idxNex
    "Return index of next stage to be enabled"
    annotation (Placement(transformation(extent={{110,-190},{130,-170}})));
  Buildings.Controls.OBC.CDL.Integers.Less      intLesEqu[nSta]
    "Return true if index less or equal to active stage index minus one"
    annotation (Placement(transformation(extent={{-10,-210},{10,-190}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idxStaAll[nSta](
    final k={i for i in 1:nSta})
    "Stage indices"
    annotation (Placement(transformation(extent={{-50,-170},{-30,-150}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(
    nout=nSta)
    "Replicate signal"
    annotation (Placement(transformation(extent={{-50,-210},{-30,-190}})));
  Buildings.Controls.OBC.CDL.Logical.And andAva[nSta]
    "True if previous condition met and stage available"
    annotation (Placement(transformation(extent={{30,-210},{50,-190}})));
  LastTrueIndex idxNexLowAva(
    final nin=nSta)
    "Return index of next lower available stage"
    annotation (Placement(transformation(extent={{60,-210},{80,-190}})));
  FirstTrueIndex idxNexHigAva(
    final nin=nSta)
    "Return index of next higher available stage"
    annotation (Placement(transformation(extent={{60,-170},{80,-150}})));
  Buildings.Controls.OBC.CDL.Integers.Greater      intGreEqu[nSta]
    "Return true if index greater or equal to active stage index plus one"
    annotation (Placement(transformation(extent={{-10,-170},{10,-150}})));
  Buildings.Controls.OBC.CDL.Logical.And andAva1[nSta]
    "True if previous condition met and stage available"
    annotation (Placement(transformation(extent={{30,-170},{50,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Or upOrActUna
    "Stage up command or active stage unavailable"
    annotation (Placement(transformation(extent={{-10,-130},{10,-110}})));
  TrueArrayConditional truIdxNex(
    final is_fix=false,
    final nout=nSta,
    nin=1)
    "Generate array with true value at index of next stage to be enabled"
    annotation (Placement(transformation(extent={{150,-190},{170,-170}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorReplicator repVec(
    final nin=nSta,
    final nout=nSta)
    "Replicate vector"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=90,
      origin={160,-140})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rep3[nSta](
    each final nout=nSta)
    "Replicate signal"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Controls.OBC.CDL.Logical.And matTrn[nSta, nSta]
    "Generate matrix with a maximum of one true element where transition must fire"
    annotation (Placement(transformation(extent={{112,-10},{132,10}})));
  Buildings.Controls.OBC.CDL.Logical.And actUnaHigAva
    "Active stage unavailable and higher stage available"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Or upOrDowOrActUna[nSta]
    "Stage up or down command or active stage unavailable (not subject to runtime requirement)"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rep1(
    final nout=nSta)
    "Replicate"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  TrueArrayConditional truNexHigAva(
    final is_fix=false,
    final nout=nSta,
    nin=1)
    "Generate array with true element at index of next higher available stage (if any, otherwise all false)"
    annotation (Placement(transformation(extent={{-150,110},{-130,130}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt(
    final integerTrue=1,
    final integerFalse=0)
    "Cast to integer"
    annotation (Placement(transformation(extent={{-190,110},{-170,130}})));
equation
  for i in 1:nSta loop
    for j in 1:nSta loop
      connect(staToSta[i, j].outPort, sta[j].inPort[i]) annotation (Line(points
            ={{141.5,140},{160,140},{160,180},{-40,180},{-40,140},{-11,140}},
            color={0,0,0}));
      connect(sta[i].outPort[j], staToSta[i, j].inPort)
        annotation (Line(points={{10.5,140},{136,140}}, color={0,0,0}));
    end for;
  end for;
  // Transitio to/from stage 0 – All units disabled.
  connect(sta.outPort[nSta + 1], staToSta0.inPort) annotation (Line(points={{
          10.5,140},{20,140},{20,160},{56,160}}, color={0,0,0}));
  connect(sta0ToSta.outPort, sta.inPort[nSta + 1])
    annotation (Line(points={{-58.5,140},{-11,140}},                    color={0,0,0}));
  connect(staToSta0.outPort, sta0.inPort) annotation (Line(points={{61.5,160},{
          80,160},{80,200},{-140,200},{-140,140},{-111,140}}, color={0,0,0}));
  connect(sta0.outPort,sta0ToSta. inPort)
    annotation (Line(points={{-89.5,140},{-64,140}},color={0,0,0}));
  connect(u1Lea, notLea.u)
    annotation (Line(points={{-260,120},{-200,120},{-200,40},{-192,40}},color={255,0,255}));
  connect(runAndEna.y, staToSta0.condition)
    annotation (Line(points={{22,40},{60,40},{60,148}}, color={255,0,255}));
  connect(sta.active, idxFirAct.u1)
    annotation (Line(points={{0,129},{0,100},{178,100}},    color={255,0,255}));
  connect(maxInt.y, staUna.index)
    annotation (Line(points={{-168,-200},{-140,-200},{-140,-172}},color={255,127,0}));
  connect(una.y, staUna.u)
    annotation (Line(points={{-168,-160},{-152,-160}},color={255,0,255}));
  connect(idxFirAct.y, y)
    annotation (Line(points={{202,100},{260,100}},color={255,127,0}));
  connect(idxLasAva.y, higAva.u1)
    annotation (Line(points={{-168,-80},{-152,-80}},color={255,127,0}));
  connect(idxFirAva.y, lowAva.u1)
    annotation (Line(points={{-168,-120},{-152,-120}},color={255,127,0}));
  connect(idxFirAct.y, higAva.u2)
    annotation (Line(points={{202,100},{220,100},{220,-220},{-156,-220},{-156,
          -88},{-152,-88}},
      color={255,127,0}));
  connect(idxFirAct.y, lowAva.u2)
    annotation (Line(points={{202,100},{220,100},{220,-220},{-156,-220},{-156,
          -128},{-152,-128}},
      color={255,127,0}));
  connect(one.y, maxInt.u1)
    annotation (Line(points={{-208,-200},{-200,-200},{-200,-194},{-192,-194}},
      color={255,127,0}));
  connect(idxFirAct.y, maxInt.u2)
    annotation (Line(points={{202,100},{220,100},{220,-220},{-196,-220},{-196,
          -206},{-192,-206}},
      color={255,127,0}));
  connect(sta.active, tim.u)
    annotation (Line(points={{0,129},{0,100},{-100,100},{-100,80},{-92,80}},
      color={255,0,255}));
  connect(tim.passed, pas.u)
    annotation (Line(points={{-68,72},{-60,72},{-60,80},{-42,80}},color={255,0,255}));
  connect(sta.active, pas.uPla)
    annotation (Line(points={{0,129},{0,100},{-50,100},{-50,76},{-42,76}},
      color={255,0,255}));
  connect(u1Ava, pla.u)
    annotation (Line(points={{-260,-160},{-232,-160}},color={255,0,255}));
  connect(pla.y, una.u)
    annotation (Line(points={{-208,-160},{-192,-160}},color={255,0,255}));
  connect(pla.y, idxLasAva.u1)
    annotation (Line(points={{-208,-160},{-200,-160},{-200,-80},{-192,-80}},
      color={255,0,255}));
  connect(pla.y, idxFirAva.u1)
    annotation (Line(points={{-208,-160},{-200,-160},{-200,-120},{-192,-120}},
      color={255,0,255}));
  connect(u1Lea, upAndEna.u[1])
    annotation (Line(points={{-260,120},{-200,120},{-200,-2.33333},{-112,-2.33333}},
      color={255,0,255}));
  connect(u1Lea, dowAndEna.u[1])
    annotation (Line(points={{-260,120},{-200,120},{-200,-42.3333},{-112,
          -42.3333}},
      color={255,0,255}));
  connect(u1Up, upAndEna.u[2])
    annotation (Line(points={{-260,0},{-186,0},{-186,0},{-112,0}},color={255,0,255}));
  connect(u1Dow, dowAndEna.u[2])
    annotation (Line(points={{-260,-40},{-112,-40}},color={255,0,255}));
  connect(higAva.y, upAndEna.u[3])
    annotation (Line(points={{-128,-80},{-120,-80},{-120,2},{-112,2},{-112,2.33333}},
      color={255,0,255}));
  connect(lowAva.y, dowAndEna.u[3])
    annotation (Line(points={{-128,-120},{-116,-120},{-116,-37.6667},{-112,
          -37.6667}},
      color={255,0,255}));
  connect(upOrDow.y, rep.u)
    annotation (Line(points={{-48,0},{-42,0}},color={255,0,255}));
  connect(pas.y, runAndTrn.u1)
    annotation (Line(points={{-18,80},{-12,80},{-12,0},{-2,0}},color={255,0,255}));
  connect(rep.y, runAndTrn.u2)
    annotation (Line(points={{-18,0},{-14,0},{-14,-8},{-2,-8}},color={255,0,255}));
  connect(intScaRep.y, intLesEqu.u2)
    annotation (Line(points={{-28,-200},{-24,-200},{-24,-208},{-12,-208}},
                                                                      color={255,127,0}));
  connect(idxStaAll.y, intLesEqu.u1)
    annotation (Line(points={{-28,-160},{-20,-160},{-20,-200},{-12,-200}},
                                                                      color={255,127,0}));
  connect(intLesEqu.y, andAva.u1)
    annotation (Line(points={{12,-200},{28,-200}},color={255,0,255}));
  connect(pla.y, andAva.u2)
    annotation (Line(points={{-208,-160},{-200,-160},{-200,-180},{20,-180},{20,
          -208},{28,-208}},
      color={255,0,255}));
  connect(andAva.y, idxNexLowAva.u1)
    annotation (Line(points={{52,-200},{58,-200}},color={255,0,255}));
  connect(idxStaAll.y, intGreEqu.u1)
    annotation (Line(points={{-28,-160},{-12,-160}},                  color={255,127,0}));
  connect(intGreEqu.y, andAva1.u1)
    annotation (Line(points={{12,-160},{28,-160}},color={255,0,255}));
  connect(pla.y, andAva1.u2)
    annotation (Line(points={{-208,-160},{-200,-160},{-200,-180},{20,-180},{20,
          -168},{28,-168}},
      color={255,0,255}));
  connect(andAva1.y, idxNexHigAva.u1)
    annotation (Line(points={{52,-160},{58,-160}},color={255,0,255}));
  connect(u1Up, upOrActUna.u1)
    annotation (Line(points={{-260,0},{-220,0},{-220,-60},{-20,-60},{-20,-120},
          {-12,-120}},
      color={255,0,255}));
  connect(staUna.y, upOrActUna.u2)
    annotation (Line(points={{-128,-160},{-60,-160},{-60,-128},{-12,-128}},
                                                                         color={255,0,255}));
  connect(upOrActUna.y, idxNex.u2)
    annotation (Line(points={{12,-120},{100,-120},{100,-180},{108,-180}},
                                                                       color={255,0,255}));
  connect(andAva1.y, idxNexHigAva.u1)
    annotation (Line(points={{52,-160},{58,-160}},color={255,0,255}));
  connect(idxNexHigAva.y, idxNex.u1)
    annotation (Line(points={{82,-160},{90,-160},{90,-172},{108,-172}},   color={255,127,0}));
  connect(idxNexLowAva.y, idxNex.u3)
    annotation (Line(points={{82,-200},{90,-200},{90,-188},{108,-188}},   color={255,127,0}));
  connect(one.y, truIdxNex.u)
    annotation (Line(points={{-208,-200},{-200,-200},{-200,-224},{140,-224},{
          140,-180},{148,-180}},
      color={255,127,0}));
  connect(truIdxNex.y1, repVec.u)
    annotation (Line(points={{172,-180},{180,-180},{180,-160},{160,-160},{160,
          -152}},
      color={255,0,255}));
  connect(rep3.y, matTrn.u1)
    annotation (Line(points={{92,0},{110,0}},color={255,0,255}));
  connect(repVec.y, matTrn.u2)
    annotation (Line(points={{160,-128},{160,-20},{106,-20},{106,-8},{110,-8}},
      color={255,0,255}));
  connect(matTrn.y, staToSta.condition)
    annotation (Line(points={{134,0},{140,0},{140,128}}, color={255,0,255}));
  connect(dowAndEna.y, upOrDow.u2)
    annotation (Line(points={{-88,-40},{-80,-40},{-80,-8},{-72,-8}},color={255,0,255}));
  connect(staUna.y, actUnaHigAva.u2)
    annotation (Line(points={{-128,-160},{-60,-160},{-60,-48},{-52,-48}},color={255,0,255}));
  connect(higAva.y, actUnaHigAva.u1)
    annotation (Line(points={{-128,-80},{-74,-80},{-74,-40},{-52,-40}},color={255,0,255}));
  connect(actUnaHigAva.y, rep1.u)
    annotation (Line(points={{-28,-40},{-12,-40}},color={255,0,255}));
  connect(rep1.y, upOrDowOrActUna.u2)
    annotation (Line(points={{12,-40},{30,-40},{30,-8},{38,-8}},color={255,0,255}));
  connect(idxNex.y, truIdxNex.uIdx[1])
    annotation (Line(points={{132,-180},{134,-180},{134,-186},{148,-186}},color={255,127,0}));
  connect(truNexHigAva.y1,sta0ToSta. condition)
    annotation (Line(points={{-128,120},{-60,120},{-60,128}},color={255,0,255}));
  connect(u1Lea, booToInt.u)
    annotation (Line(points={{-260,120},{-192,120}},color={255,0,255}));
  connect(booToInt.y, truNexHigAva.u)
    annotation (Line(points={{-168,120},{-152,120}},color={255,127,0}));
  connect(idxFirAva.y, truNexHigAva.uIdx[1])
    annotation (Line(points={{-168,-120},{-160,-120},{-160,114},{-152,114}},
      color={255,127,0}));
  connect(upAndEna.y, upOrDow.u1)
    annotation (Line(points={{-88,0},{-72,0}},color={255,0,255}));
  connect(notLea.y, rep2.u)
    annotation (Line(points={{-168,40},{-42,40}}, color={255,0,255}));
  connect(runAndTrn.y, upOrDowOrActUna.u1)
    annotation (Line(points={{22,0},{38,0}},color={255,0,255}));
  connect(upOrDowOrActUna.y, rep3.u)
    annotation (Line(points={{62,0},{68,0}},color={255,0,255}));
  connect(rep2.y, runAndEna.u1)
    annotation (Line(points={{-18,40},{-2,40}}, color={255,0,255}));
  connect(pas.y, runAndEna.u2) annotation (Line(points={{-18,80},{-12,80},{-12,
          32},{-2,32}}, color={255,0,255}));
  connect(idxFirAct.y, intScaRep.u) annotation (Line(points={{202,100},{220,100},
          {220,-220},{-60,-220},{-60,-200},{-52,-200}}, color={255,127,0}));
  connect(intScaRep.y, intGreEqu.u2) annotation (Line(points={{-28,-200},{-24,
          -200},{-24,-168},{-12,-168}}, color={255,127,0}));
  annotation (
    __cdl(
      extensionBlock=true),
    defaultComponentName="idxSta",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Line(
          points={{-90,-80.3976},{68,-80.3976}},
          color={192,192,192}),
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-240,-240},{240,240}})),
    Documentation(
      info="<html>
<p>
This block is used to compute the stage index for a group of
multiple equipment such as CHW pumps or chillers.
</p>
<ul>
<li>
At initial time, stage <code>0</code> is active &ndash; 
all units are disabled.
</li>
<li>
From stage <code>0</code>, the transition to the next higher available 
stage is triggered when the lead unit is enabled (<code>u1Lea = true</code>)
and if at least one stage is available.
</li>
<li>
From any stage <code>i</code> (<code>1 &le; i &le; nSta</code>), the transition 
to the next higher or lower available stage <code>j</code> 
(<code>1 &le; j &le; nSta</code>, <code>j &ne; i</code>)
is triggered when stage <code>i</code> has been active for the minimum runtime 
and there is a stage up command <code>u1Up</code> or stage down command <code>u1Dow</code>, respectively.
</li>
<li>
From any stage <code>i</code> (<code>1 &le; i &le; nSta</code>), the transition 
to stage <code>0</code> is triggered when stage <code>i</code> has been active
for the minimum runtime and the lead unit is disabled (<code>u1Lea = false</code>).
</li>
</ul>
<p>
Unavailable stages are handled by the following requirements.
</p>
<ul>
<li>
Any unavailable stage (<code>u1Ava[i] = false</code>) is skipped during 
staging events.
</li>
<li>
If all higher (resp. lower) stages are unavailable, then the transition
to a higher (resp. lower) stage is blocked.
</li>
<li>
If the current stage is unavailable, the transition to the next 
higher available stage is triggered.
</li>
<li>
Stage transitions due to availability conditions are
not subject to the minimum stage runtime requirement.
</li>
</ul>
<h4>Caveats</h4>
<p>
The only way to transition to stage <code>0</code> is by disabling the lead unit 
(<code>u1Lea = false</code>).
The stage down command <code>u1Dow</code> cannot be used to transition 
below stage <code>1</code>.
</p>
<p>
When the current stage becomes unavailable, the transition to the next 
higher available stage is triggered.
However, it can happen that equipment that is enabled at the current 
stage is no longer available while the current stage is not deemed 
unavailable – for example if a lead/lag alternate equipment remains available.
In this case, the equipment rotation logic must stage on the 
lead/lag alternate equipment to replace the faulty equipment.
</p>
</html>",
      revisions="<html>
<ul>
<li>
February 24, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end StageIndex;
