within Buildings.Templates.Plants.Controls.Utilities;
block StageIndex_bck "Evaluation of stage index from staging signals"
  parameter Boolean have_inpAva=true
    "Set to true if stage availability is provided with input signal, false for stages always available"
    annotation(Evaluate=true);
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
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Ava[nSta] if have_inpAva
    "Stage available signal"
    annotation (Placement(transformation(extent={{-280,-180},{-240,-140}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y "Stage index"
    annotation (Placement(transformation(extent={{240,80},{280,120}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yPre
    "Left limit (in discrete-time) of stage index"
    annotation (Placement(transformation(extent={{240,40},{280,80}}),
      iconTransformation(extent={{100,-80},{140,-40}})));
  Modelica.StateGraph.InitialStepWithSignal sta0(
    final nOut=1,
    final nIn=nSta)
    "Stage 0: no unit is enabled"
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));
  Modelica.StateGraph.StepWithSignal sta[nSta](
    final nIn=cat(1, {3}, fill(2, nSta - 1)),
    each final nOut=3)
    "Stage i"
    annotation (Placement(transformation(extent={{-30,130},{-10,150}})));
  Modelica.StateGraph.TransitionWithSignal toSta1(
    final enableTimer=false) "Transition to stage 1"
    annotation (Placement(transformation(extent={{-70,130},{-50,150}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    "State graph root"
    annotation (Placement(transformation(extent={{-10,210},{10,230}})));
  Modelica.StateGraph.TransitionWithSignal toHig[nSta](each final enableTimer=false)
    "Transition to higher stage"
    annotation (Placement(transformation(extent={{90,130},{110,150}})));
  Buildings.Controls.OBC.CDL.Logical.And      runAndUp[nSta]
    "Runtime condition met AND stage up command"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rep(
    final nout=nSta)
    "Replicate"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Logical.And      runAndDow[nSta]
    "Runtime condition met AND stage down command"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rep1(
    final nout=nSta)
    "Replicate"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Modelica.StateGraph.TransitionWithSignal toLow[nSta](each final enableTimer=false)
    "Transition to lower stage"
    annotation (Placement(transformation(extent={{110,110},{130,130}})));
  Modelica.StateGraph.TransitionWithSignal toSta0[nSta](
    each final enableTimer=false) "Transition to stage 0"
    annotation (Placement(transformation(extent={{50,150},{70,170}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rep2(
    final nout=nSta)
    "Replicate"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Logical.Not notLea "True if lead unit is disabled"
    annotation (Placement(transformation(extent={{-190,30},{-170,50}})));
  Buildings.Controls.OBC.CDL.Logical.And upAndEna "Stage up only if enabled"
    annotation (Placement(transformation(extent={{-190,-10},{-170,10}})));
  Utilities.FirstTrueIndex idxFirAct(
    nin=nSta)
    "Return index of first active stage"
    annotation (Placement(transformation(extent={{160,90},{180,110}})));
  Utilities.Pre pre
    "Return pre(idxSta)"
    annotation (Placement(transformation(extent={{160,50},{180,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not una[nSta]
    "True if stage is not available"
    annotation (Placement(transformation(extent={{-200,-170},{-180,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Or orUna[nSta]
    "Runtime criterion met AND staging up order OR stage unavailable"
    annotation (Placement(transformation(extent={{30,-30},{50,-10}})));
  Buildings.Controls.OBC.CDL.Logical.And runAndEna[nSta]
    "Runtime condition met AND lead enable signal false"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Buildings.Controls.OBC.CDL.Logical.Or orUna1[nSta]
    "Runtime criterion met AND staging up order OR stage unavailable"
    annotation (Placement(transformation(extent={{30,-70},{50,-50}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractor staUna(
    final nin=nSta)
    "Return true if current stage is unavailable"
    annotation (Placement(transformation(extent={{-146,-170},{-126,-150}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rep4(
    final nout=nSta)
    "Replicate"
    annotation (Placement(transformation(extent={{20,-150},{40,-130}})));
  Buildings.Controls.OBC.CDL.Integers.Max maxInt
    "Maximum between current stage index and 1"
    annotation (Placement(transformation(extent={{-180,-210},{-160,-190}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant one(
    final k=1)
    "Constant"
    annotation (Placement(transformation(extent={{-210,-210},{-190,-190}})));
  Buildings.Controls.OBC.CDL.Integers.Greater staUp
    "Return true if current stage index > last computed stage index"
    annotation (Placement(transformation(extent={{-50,-150},{-30,-130}})));
  Buildings.Controls.OBC.CDL.Integers.Less staDow
    "Return true if current stage index < last computed stage index"
    annotation (Placement(transformation(extent={{-50,-190},{-30,-170}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rep3(
    final nout=nSta)
    "Replicate"
    annotation (Placement(transformation(extent={{20,-190},{40,-170}})));
  Buildings.Controls.OBC.CDL.Logical.And staUpAndUna
    "Staging up AND stage unavailable"
    annotation (Placement(transformation(extent={{-10,-150},{10,-130}})));
  Buildings.Controls.OBC.CDL.Logical.And staDowAndUna
    "Staging down AND stage unavailable"
    annotation (Placement(transformation(extent={{-10,-190},{10,-170}})));
  PlaceHolder pas[nSta](
    each final have_inp=dtRun > 0,
    each final have_inpPla=true)
    "Direct pass-through when no minimum runtime"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-40,80})));
  FirstTrueIndex idxFirAva(nin=nSta)
    "Return index of first available stage"
    annotation (Placement(transformation(extent={{-200,-130},{-180,-110}})));
  LastTrueIndex idxLasAva(nin=nSta)
    "Return index of last available stage"
    annotation (Placement(transformation(extent={{-200,-90},{-180,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Greater higAva
    "Return true if there is any higher stage available"
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Less lowAva
    "Return true if there is any lower stage available"
    annotation (Placement(transformation(extent={{-110,-130},{-90,-110}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rep5(
    final nout=nSta)
    "Replicate"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rep6(
    final nout=nSta)
    "Replicate"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim[nSta](passed(each start=false),
      each final t=dtRun) if dtRun > 0 "Timer for minimum runtime"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  Buildings.Controls.OBC.CDL.Logical.And upAndHigAva[nSta]
    "Stage up conditions met AND higher stage available"
    annotation (Placement(transformation(extent={{70,-30},{90,-10}})));
  Buildings.Controls.OBC.CDL.Logical.And dowAndLowAva[nSta]
    "Stage down conditions met AND lower stage available"
    annotation (Placement(transformation(extent={{70,-70},{90,-50}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd allUna(nin=nSta)
    "True if all stages are unavailable"
    annotation (Placement(transformation(extent={{-170,-150},{-150,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Or notLeaOrAllUna
    "True if lead unit is disabled or all stages are unavailable"
    annotation (Placement(transformation(extent={{-128,30},{-108,50}})));
  Buildings.Controls.OBC.CDL.Logical.Not anyAva
    "True if any stage is available" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-140,80})));
  Buildings.Controls.OBC.CDL.Logical.And leaAnyAva
    "True if lead enabled AND any stage available"
    annotation (Placement(transformation(extent={{-150,110},{-130,130}})));
  PlaceHolder pla[nSta](
    each final have_inp=have_inpAva,
    each final have_inpPla=false,
    each final u_internal=true)
    "Replace with placeholder value if input signal is not available"
    annotation (Placement(transformation(extent={{-230,-170},{-210,-150}})));
equation
  for i in 1:(nSta - 1) loop
    connect(toHig[i].outPort, sta[i + 1].inPort[1]) annotation (Line(points={{101.5,
            140},{110,140},{110,180},{-40,180},{-40,140},{-31,140}}, color={0,0,
            0}));
  end for;
  if nSta > 1 then
    for i in 2:nSta loop
      connect(toLow[i].outPort, sta[i - 1].inPort[2]) annotation (Line(points={{121.5,
              120},{140,120},{140,180},{-40,180},{-40,140},{-31,140}},
            color={0,0,0}));
    end for;
  end if;
  connect(sta.outPort[1],toSta0.inPort)
    annotation (Line(points={{-9.5,139.833},{20,139.833},{20,160},{56,160}},
      color={0,0,0}));
  // Stage down command from stage 1 brings back to stage 1.
  connect(toLow[1].outPort, sta[1].inPort[3]) annotation (Line(points={{121.5,
          120},{140,120},{140,180},{-40,180},{-40,140},{-31,140}},
                                                              color={0,0,0}));
  // Stage up command from stage nSta brings back to stage nSta.
  connect(toHig[nSta].outPort, sta[nSta].inPort[2]) annotation (Line(points={{101.5,
          140},{110,140},{110,180},{-40,180},{-40,140},{-31,140}}, color={0,0,0}));
  connect(toSta0.outPort, sta0.inPort)
    annotation (Line(points={{61.5,160},{90,160},{90,200},{-140,200},{-140,140},
          {-101,140}},
      color={0,0,0}));
  connect(sta0.outPort[1],toSta1. inPort)
    annotation (Line(points={{-79.5,140},{-64,140}}, color={0,0,0}));
  connect(toSta1.outPort, sta[1].inPort[1])
    annotation (Line(points={{-58.5,140},{-31,140}},                    color={0,0,0}));
  connect(sta.outPort[2], toHig.inPort)
    annotation (Line(points={{-9.5,140},{96,140}},  color={0,0,0}));
  connect(sta.outPort[3], toLow.inPort) annotation (Line(points={{-9.5,140.167},
          {20,140.167},{20,120},{116,120}}, color={0,0,0}));
  connect(u1Lea,notLea. u)
    annotation (Line(points={{-260,120},{-200,120},{-200,40},{-192,40}},color={255,0,255}));
  connect(u1Lea, upAndEna.u2)
    annotation (Line(points={{-260,120},{-200,120},{-200,-8},{-192,-8}},color={255,0,255}));
  connect(u1Up, upAndEna.u1)
    annotation (Line(points={{-260,0},{-192,0}},color={255,0,255}));
  connect(upAndEna.y, rep.u)
    annotation (Line(points={{-168,0},{-82,0}},color={255,0,255}));
  connect(pre.y,yPre)
    annotation (Line(points={{182,60},{260,60}},color={255,127,0}));
  connect(runAndEna.y,toSta0. condition)
    annotation (Line(points={{12,40},{60,40},{60,148}},color={255,0,255}));
  connect(runAndUp.y, orUna.u1)
    annotation (Line(points={{12,0},{20,0},{20,-20},{28,-20}},color={255,0,255}));
  connect(sta.active, idxFirAct.u1)
    annotation (Line(points={{-20,129},{-20,100},{158,100}},
                                                        color={255,0,255}));
  connect(u1Dow, rep1.u)
    annotation (Line(points={{-260,-40},{-82,-40}},color={255,0,255}));
  connect(runAndDow.y, orUna1.u1)
    annotation (Line(points={{12,-40},{14,-40},{14,-60},{28,-60}},  color={255,0,255}));
  connect(maxInt.y, staUna.index)
    annotation (Line(points={{-158,-200},{-136,-200},{-136,-172}},color={255,127,0}));
  connect(una.y, staUna.u)
    annotation (Line(points={{-178,-160},{-148,-160}},color={255,0,255}));
  connect(rep4.y, orUna.u2)
    annotation (Line(points={{42,-140},{50,-140},{50,-100},{20,-100},{20,-28},{28,
          -28}},                                                    color={255,0,255}));
  connect(staUpAndUna.y, rep4.u)
    annotation (Line(points={{12,-140},{18,-140}},color={255,0,255}));
  connect(staUna.y, staUpAndUna.u2)
    annotation (Line(points={{-124,-160},{-20,-160},{-20,-148},{-12,-148}},
                                                                          color={255,0,255}));
  connect(staDowAndUna.y, rep3.u)
    annotation (Line(points={{12,-180},{18,-180}},color={255,0,255}));
  connect(rep3.y, orUna1.u2)
    annotation (Line(points={{42,-180},{52,-180},{52,-98},{22,-98},{22,-68},{28,
          -68}},                                                      color={255,0,255}));
  connect(idxFirAct.y, staUp.u1)
    annotation (Line(points={{182,100},{220,100},{220,-200},{-92,-200},{-92,
          -140},{-52,-140}},
      color={255,127,0}));
  connect(idxFirAct.y, staDow.u1)
    annotation (Line(points={{182,100},{220,100},{220,-200},{-92,-200},{-92,
          -180},{-52,-180}},
      color={255,127,0}));
  connect(staUp.y, staUpAndUna.u1)
    annotation (Line(points={{-28,-140},{-12,-140}},
                                                   color={255,0,255}));
  connect(pre.y, staDow.u2)
    annotation (Line(points={{182,60},{200,60},{200,-220},{-82,-220},{-82,-188},
          {-52,-188}},
      color={255,127,0}));
  connect(pre.y, staUp.u2)
    annotation (Line(points={{182,60},{200,60},{200,-220},{-82,-220},{-82,-148},
          {-52,-148}},
      color={255,127,0}));
  connect(staDow.y, staDowAndUna.u2)
    annotation (Line(points={{-28,-180},{-24,-180},{-24,-188},{-12,-188}},
                                                                         color={255,0,255}));
  connect(staUna.y, staDowAndUna.u1)
    annotation (Line(points={{-124,-160},{-20,-160},{-20,-180},{-12,-180}},
                                                                          color={255,0,255}));
  connect(idxFirAct.y, pre.u)
    annotation (Line(points={{182,100},{200,100},{200,80},{150,80},{150,60},{
          158,60}},
      color={255,127,0}));
  connect(rep2.y, runAndEna.u2)
    annotation (Line(points={{-58,40},{-40,40},{-40,32},{-12,32}},
                                                             color={255,0,255}));
  connect(pas.y, runAndEna.u1) annotation (Line(points={{-28,80},{-20,80},{-20,40},
          {-12,40}},color={255,0,255}));
  connect(idxFirAct.y, y)
    annotation (Line(points={{182,100},{260,100}},color={255,127,0}));
  connect(idxLasAva.y, higAva.u1)
    annotation (Line(points={{-178,-80},{-112,-80}},color={255,127,0}));
  connect(idxFirAva.y, lowAva.u1)
    annotation (Line(points={{-178,-120},{-112,-120}},color={255,127,0}));
  connect(idxFirAct.y, higAva.u2)
    annotation (Line(points={{182,100},{220,100},{220,-200},{-120,-200},{-120,
          -88},{-112,-88}},
      color={255,127,0}));
  connect(idxFirAct.y, lowAva.u2)
    annotation (Line(points={{182,100},{220,100},{220,-200},{-120,-200},{-120,
          -128},{-112,-128}},
      color={255,127,0}));
  connect(lowAva.y, rep6.u)
    annotation (Line(points={{-88,-120},{-82,-120}},color={255,0,255}));
  connect(higAva.y, rep5.u)
    annotation (Line(points={{-88,-80},{-82,-80}},color={255,0,255}));
  connect(one.y, maxInt.u1)
    annotation (Line(points={{-188,-200},{-184,-200},{-184,-194},{-182,-194}},
      color={255,127,0}));
  connect(idxFirAct.y, maxInt.u2)
    annotation (Line(points={{182,100},{220,100},{220,-200},{-120,-200},{-120,
          -220},{-184,-220},{-184,-206},{-182,-206}},
      color={255,127,0}));
  connect(sta.active, tim.u) annotation (Line(points={{-20,129},{-20,100},{-100,
          100},{-100,80},{-92,80}},
                              color={255,0,255}));
  connect(tim.passed, pas.u) annotation (Line(points={{-68,72},{-56,72},{-56,80},
          {-52,80}}, color={255,0,255}));
  connect(sta.active, pas.uPla) annotation (Line(points={{-20,129},{-20,100},{
          -60,100},{-60,76},{-52,76}},
                              color={255,0,255}));
  connect(pas.y, runAndUp.u1) annotation (Line(points={{-28,80},{-20,80},{-20,0},
          {-12,0}}, color={255,0,255}));
  connect(pas.y, runAndDow.u1) annotation (Line(points={{-28,80},{-20,80},{-20,-40},
          {-12,-40}}, color={255,0,255}));
  connect(rep.y, runAndUp.u2) annotation (Line(points={{-58,0},{-40,0},{-40,-8},
          {-12,-8}}, color={255,0,255}));
  connect(rep1.y, runAndDow.u2) annotation (Line(points={{-58,-40},{-40,-40},{-40,
          -48},{-12,-48}}, color={255,0,255}));
  connect(orUna.y, upAndHigAva.u1)
    annotation (Line(points={{52,-20},{68,-20}}, color={255,0,255}));
  connect(upAndHigAva.y, toHig.condition) annotation (Line(points={{92,-20},{100,
          -20},{100,128}}, color={255,0,255}));
  connect(orUna1.y, dowAndLowAva.u1)
    annotation (Line(points={{52,-60},{68,-60}}, color={255,0,255}));
  connect(rep5.y, upAndHigAva.u2) annotation (Line(points={{-58,-80},{60,-80},{60,
          -28},{68,-28}}, color={255,0,255}));
  connect(rep6.y, dowAndLowAva.u2) annotation (Line(points={{-58,-120},{62,-120},
          {62,-68},{68,-68}}, color={255,0,255}));
  connect(dowAndLowAva.y, toLow.condition) annotation (Line(points={{92,-60},{120,
          -60},{120,108}}, color={255,0,255}));
  connect(notLea.y, notLeaOrAllUna.u1)
    annotation (Line(points={{-168,40},{-130,40}}, color={255,0,255}));
  connect(notLeaOrAllUna.y, rep2.u)
    annotation (Line(points={{-106,40},{-82,40}}, color={255,0,255}));
  connect(una.y, allUna.u) annotation (Line(points={{-178,-160},{-176,-160},{-176,
          -140},{-172,-140}}, color={255,0,255}));
  connect(allUna.y, notLeaOrAllUna.u2) annotation (Line(points={{-148,-140},{-140,
          -140},{-140,32},{-130,32}}, color={255,0,255}));
  connect(allUna.y, anyAva.u) annotation (Line(points={{-148,-140},{-140,-140},
          {-140,68}}, color={255,0,255}));
  connect(u1Lea, leaAnyAva.u1)
    annotation (Line(points={{-260,120},{-152,120}}, color={255,0,255}));
  connect(leaAnyAva.y, toSta1.condition) annotation (Line(points={{-128,120},{
          -60,120},{-60,128}}, color={255,0,255}));
  connect(anyAva.y, leaAnyAva.u2) annotation (Line(points={{-140,92},{-140,100},
          {-160,100},{-160,112},{-152,112}}, color={255,0,255}));
  connect(u1Ava, pla.u)
    annotation (Line(points={{-260,-160},{-232,-160}}, color={255,0,255}));
  connect(pla.y, una.u)
    annotation (Line(points={{-208,-160},{-202,-160}}, color={255,0,255}));
  connect(pla.y, idxLasAva.u1) annotation (Line(points={{-208,-160},{-206,-160},
          {-206,-80},{-202,-80}}, color={255,0,255}));
  connect(pla.y, idxFirAva.u1) annotation (Line(points={{-208,-160},{-206,-160},
          {-206,-120},{-202,-120}}, color={255,0,255}));
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
multiple lead/lag alternated equipment such as CHW pumps or
chillers.
</p>
<ul>
<li>
At initial time, stage <code>0</code> is active &ndash; 
all units are disabled.
</li>
<li>
From stage <code>0</code>, the transition to stage <code>1</code> is 
triggered when the lead unit is enabled (<code>u1=true</code>)
and if at least one stage is available.
</li>
<li>
From stage <code>i</code> with <i>1 &le; i &le; nSta-1</i>, 
the transition to stage <code>i+1</code> is triggered when 
stage <code>i</code> has been active for the minimum runtime and 
there is a stage up command (<code>u1Up=true</code>).
</li>
<li>
If there are two or more stages, then from stage <code>i</code> 
with <i>i &ge; 2</i>, the transition to stage <code>i-1</code> 
is triggered when stage <code>i</code> has been active for the minimum 
runtime and there is a stage down command (<code>u1Dow=true</code>).
</li>
<li>
From any stage, the transition to stage <code>0</code> is triggered 
when stage <code>i</code> has been active for the minimum runtime and 
the lead unit is disabled (<code>u1Lea=false</code>).
</li>
</ul>
<p>
Unavailable stages are handled by the following requirements.
</p>
<ul>
<li>
Any unavailable stage (<code>u1Ava[i]=false</code>) is skipped during 
staging events.
</li>
<li>
If all higher (resp. lower) stages are unavailable, then the transition
to a higher (resp. lower) stage is blocked.
</li>
<li>
If all stages are unavailable, then the transition to stage
<code>0</code> is triggered &ndash; 
all units are disabled.
</li>
</ul>
<h4>Caveats</h4>
<p>
The only way to transition to stage <code>0</code> is by disabling the lead unit 
(<code>u1Lea=false</code>).
The stage down command <code>u1Dow=false</code> cannot be used to transition 
below stage <code>1</code>.
</p>
<p>
The availability condition that is typically used to generate a stage up
command &ndash; e.g., when one of the staged units becomes unavalaible &ndash; 
shall be implemented externally to compute the input signal <code>u1Up</code>.
The availability signal <code>u1Ava</code> is used here only to skip stages
<i>during stage transitions</i>, not to trigger a stage change during an 
enabled stage.
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
end StageIndex_bck;
