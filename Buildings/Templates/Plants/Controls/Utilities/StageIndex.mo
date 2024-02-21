within Buildings.Templates.Plants.Controls.Utilities;
block StageIndex
  "Evaluation of stage index from staging signals"
  parameter Integer nSta(
    start=1,
    final min=1)
    "Number of stages"
    annotation (Evaluate=true);
  parameter Modelica.Units.SI.Time dtRun(
    final min=0)=0
    "Minimum runtime of each stage"
    annotation (Evaluate=true);
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Lea
    "Lead unit enable signal"
    annotation (Placement(transformation(extent={{-260,100},{-220,140}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Up
    "Stage up command"
    annotation (Placement(transformation(extent={{-260,-20},{-220,20}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Dow
    "Stage down command"
    annotation (Placement(transformation(extent={{-260,-60},{-220,-20}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Ava[nSta]
    "Stage available signal"
    annotation (Placement(transformation(extent={{-260,-180},{-220,-140}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y "Stage index"
    annotation (Placement(transformation(extent={{220,80},{260,120}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yPre
    "Left limit (in discrete-time) of stage index"
    annotation (Placement(transformation(extent={{220,40},{260,80}}),
      iconTransformation(extent={{100,-80},{140,-40}})));
  Modelica.StateGraph.InitialStepWithSignal sta0(
    final nOut=1,
    final nIn=nSta)
    "Stage 0: no unit is enabled"
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));
  Modelica.StateGraph.StepWithSignal sta[nSta](
    final nIn=cat(1, {3}, fill(2, nSta - 1)),
    each final nOut=3)
    "Stage i"
    annotation (Placement(transformation(extent={{-10,130},{10,150}})));
  Modelica.StateGraph.TransitionWithSignal enaLea(
    final enableTimer=false)
    "Transition enabling lead unit"
    annotation (Placement(transformation(extent={{-70,130},{-50,150}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    "State graph root"
    annotation (Placement(transformation(extent={{-10,210},{10,230}})));
  Modelica.StateGraph.TransitionWithSignal enaLag[nSta](
    each final enableTimer=false)
    "Transition enabling lag unit"
    annotation (Placement(transformation(extent={{90,130},{110,150}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim[nSta](
    passed(
      each start=false),
    each final t=dtRun)
    if dtRun > 0
    "Timer for minimum runtime"
    annotation (Placement(transformation(extent={{-30,50},{-10,70}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd runAndUp[nSta](
    each final nin=3)
    "Runtime condition met AND stage up command AND higher stage available"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rep(
    final nout=nSta)
    "Replicate"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd runAndDow[nSta](
    each final nin=3)
    "Runtime condition met AND stage down command AND lower stage available"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rep1(
    final nout=nSta)
    "Replicate"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Modelica.StateGraph.TransitionWithSignal disLag[nSta](
    each final enableTimer=false)
    "Transition disabling lag unit"
    annotation (Placement(transformation(extent={{110,110},{130,130}})));
  Modelica.StateGraph.TransitionWithSignal disAll[nSta](
    each final enableTimer=false)
    "Transition disabling all units"
    annotation (Placement(transformation(extent={{70,150},{90,170}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rep2(
    final nout=nSta)
    "Replicate"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Logical.Not notEna
    "True if enable signal is false"
    annotation (Placement(transformation(extent={{-160,30},{-140,50}})));
  Buildings.Controls.OBC.CDL.Logical.And upAndEna
    "Stage up only if enabled"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  Utilities.FirstTrueIndex idxFirAct(
    nin=nSta)
    "Return index of first active stage"
    annotation (Placement(transformation(extent={{150,90},{170,110}})));
  Utilities.Pre pre
    "Return pre(idxSta)"
    annotation (Placement(transformation(extent={{150,50},{170,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not una[nSta]
    "True if stage is not available"
    annotation (Placement(transformation(extent={{-180,-170},{-160,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Or orUna[nSta]
    "Runtime criterion met AND staging up order OR stage unavailable"
    annotation (Placement(transformation(extent={{70,-22},{90,-2}})));
  Buildings.Controls.OBC.CDL.Logical.And runAndEna[nSta]
    "Runtime condition met AND lead enable signal false"
    annotation (Placement(transformation(extent={{30,30},{50,50}})));
  Buildings.Controls.OBC.CDL.Logical.Or orUna1[nSta]
    "Runtime criterion met AND staging up order OR stage unavailable"
    annotation (Placement(transformation(extent={{80,-130},{100,-110}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractor staUna(
    final nin=nSta)
    "Return true if current stage is unavailable"
    annotation (Placement(transformation(extent={{-150,-170},{-130,-150}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rep4(
    final nout=nSta)
    "Replicate"
    annotation (Placement(transformation(extent={{30,-150},{50,-130}})));
  Buildings.Controls.OBC.CDL.Integers.Max maxInt
    "Maximum between current stage index and 1"
    annotation (Placement(transformation(extent={{-180,-210},{-160,-190}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant one(
    final k=1)
    "Constant"
    annotation (Placement(transformation(extent={{-210,-190},{-190,-170}})));
  Buildings.Controls.OBC.CDL.Integers.Greater staUp
    "Return true if current stage index > last computed stage index"
    annotation (Placement(transformation(extent={{-50,-150},{-30,-130}})));
  Buildings.Controls.OBC.CDL.Integers.Less staDow
    "Return true if current stage index < last computed stage index"
    annotation (Placement(transformation(extent={{-50,-190},{-30,-170}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rep3(
    final nout=nSta)
    "Replicate"
    annotation (Placement(transformation(extent={{30,-190},{50,-170}})));
  Buildings.Controls.OBC.CDL.Logical.And staUpAndUna
    "Staging up AND stage unavailable"
    annotation (Placement(transformation(extent={{0,-150},{20,-130}})));
  Buildings.Controls.OBC.CDL.Logical.And staDowAndUna
    "Staging down AND stage unavailable"
    annotation (Placement(transformation(extent={{0,-190},{20,-170}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorFilter booVecFil(
    final nin=nSta,
    final nout=nSta)
    if dtRun <= 0
    "Direct pass-through when no minimum runtime"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={20,80})));
  FirstTrueIndex idxFirAva(
    nin=nSta)
    "Return index of first available stage"
    annotation (Placement(transformation(extent={{-200,-130},{-180,-110}})));
  LastTrueIndex idxLasAva(
    nin=nSta)
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
equation
  for i in 1:(nSta - 1) loop
    connect(enaLag[i].outPort, sta[i + 1].inPort[1])
      annotation (Line(points={{101.5,140},{110,140},{110,180},{-20,180},{-20,140},{-11,140}},
        color={0,0,0}));
  end for;
  if nSta > 1 then
    for i in 2:nSta loop
      connect(disLag[i].outPort, sta[i - 1].inPort[2])
        annotation (Line(points={{121.5,120},{140,120},{140,180},{-20,180},{-20,140},{-11,140}},
          color={0,0,0}));
    end for;
  end if;
  // Stage down command from stage 1 brings back to stage 1.
  connect(disLag[1].outPort, sta[1].inPort[3])
    annotation (Line(points={{121.5,120},{140,120},{140,200},{-140,200},{-140,140},{-11,140}},
      color={0,0,0}));
  // Stage up command from stage nSta brings back to stage nSta.
  connect(enaLag[nSta].outPort, sta[nSta].inPort[2])
    annotation (Line(points={{101.5,140},{110,140},{110,180},{-20,180},{-20,140},{-11,140}},
      color={0,0,0}));
  connect(disAll.outPort, sta0.inPort)
    annotation (Line(points={{81.5,160},{90,160},{90,200},{-140,200},{-140,140},{-121,140}},
      color={0,0,0}));
  connect(sta0.outPort[1], enaLea.inPort)
    annotation (Line(points={{-99.5,140},{-64,140}},color={0,0,0}));
  connect(enaLea.outPort, sta[1].inPort[1])
    annotation (Line(points={{-58.5,140},{-24,140},{-24,140},{-11,140}},color={0,0,0}));
  connect(sta.outPort[1], disAll.inPort)
    annotation (Line(points={{10.5,139.833},{20,139.833},{20,160},{76,160}},
      color={0,0,0}));
  connect(sta.outPort[2], enaLag.inPort)
    annotation (Line(points={{10.5,140},{96,140}},color={0,0,0}));
  connect(sta.outPort[3], disLag.inPort)
    annotation (Line(points={{10.5,140.167},{20,140.167},{20,120},{116,120}},
      color={0,0,0}));
  connect(sta.active, tim.u)
    annotation (Line(points={{0,129},{0,100},{-40,100},{-40,60},{-32,60}},color={255,0,255}));
  connect(u1Lea, notEna.u)
    annotation (Line(points={{-240,120},{-200,120},{-200,40},{-162,40}},color={255,0,255}));
  connect(notEna.y, rep2.u)
    annotation (Line(points={{-138,40},{-82,40}},color={255,0,255}));
  connect(u1Lea, upAndEna.u2)
    annotation (Line(points={{-240,120},{-200,120},{-200,-8},{-162,-8}},color={255,0,255}));
  connect(u1Up, upAndEna.u1)
    annotation (Line(points={{-240,0},{-162,0}},color={255,0,255}));
  connect(upAndEna.y, rep.u)
    annotation (Line(points={{-138,0},{-82,0}},color={255,0,255}));
  connect(pre.y,yPre)
    annotation (Line(points={{172,60},{240,60}},color={255,127,0}));
  connect(u1Ava, una.u)
    annotation (Line(points={{-240,-160},{-182,-160}},color={255,0,255}));
  connect(runAndEna.y, disAll.condition)
    annotation (Line(points={{52,40},{80,40},{80,148}},color={255,0,255}));
  connect(runAndUp.y, orUna.u1)
    annotation (Line(points={{52,0},{60,0},{60,-12},{68,-12}},color={255,0,255}));
  connect(sta.active, idxFirAct.u1)
    annotation (Line(points={{0,129},{0,100},{148,100}},color={255,0,255}));
  connect(u1Dow, rep1.u)
    annotation (Line(points={{-240,-40},{-82,-40}},color={255,0,255}));
  connect(orUna.y, enaLag.condition)
    annotation (Line(points={{92,-12},{100,-12},{100,128}},color={255,0,255}));
  connect(runAndDow.y, orUna1.u1)
    annotation (Line(points={{52,-40},{70,-40},{70,-120},{78,-120}},color={255,0,255}));
  connect(orUna1.y, disLag.condition)
    annotation (Line(points={{102,-120},{120,-120},{120,108}},color={255,0,255}));
  connect(maxInt.y, staUna.index)
    annotation (Line(points={{-158,-200},{-140,-200},{-140,-172}},color={255,127,0}));
  connect(una.y, staUna.u)
    annotation (Line(points={{-158,-160},{-152,-160}},color={255,0,255}));
  connect(rep4.y, orUna.u2)
    annotation (Line(points={{52,-140},{60,-140},{60,-20},{68,-20}},color={255,0,255}));
  connect(staUpAndUna.y, rep4.u)
    annotation (Line(points={{22,-140},{28,-140}},color={255,0,255}));
  connect(staUna.y, staUpAndUna.u2)
    annotation (Line(points={{-128,-160},{-10,-160},{-10,-148},{-2,-148}},color={255,0,255}));
  connect(staDowAndUna.y, rep3.u)
    annotation (Line(points={{22,-180},{28,-180}},color={255,0,255}));
  connect(rep3.y, orUna1.u2)
    annotation (Line(points={{52,-180},{70,-180},{70,-128},{78,-128}},color={255,0,255}));
  connect(idxFirAct.y, staUp.u1)
    annotation (Line(points={{172,100},{200,100},{200,-200},{-90,-200},{-90,-140},{-52,-140}},
      color={255,127,0}));
  connect(idxFirAct.y, staDow.u1)
    annotation (Line(points={{172,100},{200,100},{200,-200},{-90,-200},{-90,-180},{-52,-180}},
      color={255,127,0}));
  connect(staUp.y, staUpAndUna.u1)
    annotation (Line(points={{-28,-140},{-2,-140}},color={255,0,255}));
  connect(pre.y, staDow.u2)
    annotation (Line(points={{172,60},{180,60},{180,-220},{-80,-220},{-80,-188},{-52,-188}},
      color={255,127,0}));
  connect(pre.y, staUp.u2)
    annotation (Line(points={{172,60},{180,60},{180,-220},{-80,-220},{-80,-148},{-52,-148}},
      color={255,127,0}));
  connect(staDow.y, staDowAndUna.u2)
    annotation (Line(points={{-28,-180},{-20,-180},{-20,-188},{-2,-188}},color={255,0,255}));
  connect(staUna.y, staDowAndUna.u1)
    annotation (Line(points={{-128,-160},{-10,-160},{-10,-180},{-2,-180}},color={255,0,255}));
  connect(idxFirAct.y, pre.u)
    annotation (Line(points={{172,100},{200,100},{200,80},{140,80},{140,60},{148,60}},
      color={255,127,0}));
  connect(u1Lea, enaLea.condition)
    annotation (Line(points={{-240,120},{-60,120},{-60,128}},color={255,0,255}));
  connect(sta.active, booVecFil.u)
    annotation (Line(points={{0,129},{0,100},{20,100},{20,92}},color={255,0,255}));
  connect(rep2.y, runAndEna.u2)
    annotation (Line(points={{-58,40},{0,40},{0,32},{28,32}},color={255,0,255}));
  connect(booVecFil.y, runAndEna.u1)
    annotation (Line(points={{20,68},{20,40},{28,40}},color={255,0,255}));
  connect(tim.passed, runAndEna.u1)
    annotation (Line(points={{-8,52},{8,52},{8,40},{28,40}},color={255,0,255}));
  connect(idxFirAct.y, y)
    annotation (Line(points={{172,100},{240,100}},color={255,127,0}));
  connect(u1Ava, idxFirAva.u1)
    annotation (Line(points={{-240,-160},{-210,-160},{-210,-120},{-202,-120}},
      color={255,0,255}));
  connect(u1Ava, idxLasAva.u1)
    annotation (Line(points={{-240,-160},{-210,-160},{-210,-80},{-202,-80}},
      color={255,0,255}));
  connect(idxLasAva.y, higAva.u1)
    annotation (Line(points={{-178,-80},{-112,-80}},color={255,127,0}));
  connect(idxFirAva.y, lowAva.u1)
    annotation (Line(points={{-178,-120},{-112,-120}},color={255,127,0}));
  connect(idxFirAct.y, higAva.u2)
    annotation (Line(points={{172,100},{200,100},{200,-200},{-120,-200},{-120,-88},{-112,-88}},
      color={255,127,0}));
  connect(idxFirAct.y, lowAva.u2)
    annotation (Line(points={{172,100},{200,100},{200,-200},{-120,-200},{-120,-128},{-112,-128}},
      color={255,127,0}));
  connect(lowAva.y, rep6.u)
    annotation (Line(points={{-88,-120},{-82,-120}},color={255,0,255}));
  connect(higAva.y, rep5.u)
    annotation (Line(points={{-88,-80},{-82,-80}},color={255,0,255}));
  connect(rep6.y, runAndDow.u[3])
    annotation (Line(points={{-58,-120},{20,-120},{20,-37.6667},{28,-37.6667}},
      color={255,0,255}));
  connect(rep5.y, runAndUp.u[3])
    annotation (Line(points={{-58,-80},{0,-80},{0,2.33333},{28,2.33333}},color={255,0,255}));
  connect(booVecFil.y, runAndUp.u[1])
    annotation (Line(points={{20,68},{20,-2.33333},{28,-2.33333}},color={255,0,255}));
  connect(tim.passed, runAndUp.u[1])
    annotation (Line(points={{-8,52},{8,52},{8,-2.33333},{28,-2.33333}},color={255,0,255}));
  connect(tim.passed, runAndDow.u[1])
    annotation (Line(points={{-8,52},{8,52},{8,-42.3333},{28,-42.3333}},color={255,0,255}));
  connect(rep.y, runAndUp.u[2])
    annotation (Line(points={{-58,0},{28,0},{28,0}},color={255,0,255}));
  connect(rep1.y, runAndDow.u[2])
    annotation (Line(points={{-58,-40},{28,-40},{28,-40}},color={255,0,255}));
  connect(booVecFil.y, runAndDow.u[1])
    annotation (Line(points={{20,68},{20,-42.3333},{28,-42.3333}},color={255,0,255}));
  connect(one.y, maxInt.u1)
    annotation (Line(points={{-188,-180},{-184,-180},{-184,-194},{-182,-194}},
      color={255,127,0}));
  connect(idxFirAct.y, maxInt.u2)
    annotation (Line(points={{172,100},{200,100},{200,-200},{-120,-200},{-120,-220},{-184,-220},{-184,-206},{-182,-206}},
      color={255,127,0}));
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
        extent={{-220,-240},{220,240}})),
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
triggered when the lead unit is enabled (<code>u1=true</code>).
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
end StageIndex;
