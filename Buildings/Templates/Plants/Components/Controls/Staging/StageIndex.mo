within Buildings.Templates.Plants.Components.Controls.Staging;
block StageIndex
  "Block that computes the stage index from staging signals"

  parameter Integer nSta(start=1, min=1)
    "Number of stages"
    annotation(Evaluate=true);
  parameter Modelica.Units.SI.Time tSta(min=0)=0
    "Minimum runtime of each stage"
    annotation(Evaluate=true);

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Lea
    "Lead unit enable signal" annotation (Placement(transformation(extent={{-260,
            100},{-220,140}}), iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Up "Stage up command"
    annotation (Placement(transformation(extent={{-260,-20},{-220,20}}),
    iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Dow "Stage down command"
    annotation (Placement(
      transformation(extent={{-260,-60},{-220,-20}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Ava[nSta]
    "Stage available signal"
    annotation (Placement(transformation(extent={{-260,-140},{-220,-100}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y "Stage index"
    annotation (Placement(transformation(extent={{220,80},{260,120}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput preY
    "Left limit (in discrete-time) of stage index"
      annotation (Placement(transformation(extent={{220,40},{260,80}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

  Modelica.StateGraph.InitialStepWithSignal sta0(
    final nOut=1,
    final nIn=nSta+1)
    "Stage 0: no unit is enabled"
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));
  Modelica.StateGraph.StepWithSignal sta[nSta](
    each final nIn=2, each final nOut=3)
    "Stage i"
    annotation (Placement(transformation(extent={{-10,130},{10,150}})));
  Modelica.StateGraph.TransitionWithSignal enaLea(
    final enableTimer=false) "Transition enabling lead unit"
    annotation (Placement(transformation(extent={{-70,130},{-50,150}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot "State graph root"
    annotation (Placement(transformation(extent={{-10,210},{10,230}})));
  Modelica.StateGraph.TransitionWithSignal enaLag[nSta](
    each final enableTimer=false)
    "Transition enabling lag unit"
    annotation (Placement(transformation(extent={{90,130},{110,150}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim[nSta](
    each final t=tSta)
    "Timer for minimum runtime"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Buildings.Controls.OBC.CDL.Logical.And runAndUp[nSta]
    "Runtime criterion met AND staging up order"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rep(
    final nout=nSta)
    "Replicate"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Logical.And runAndDow[nSta]
    "Runtime criterion met AND staging down order"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rep1(
    final nout=nSta) "Replicate"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
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
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Logical.Not notEna
    "True if enable signal is false"
    annotation (Placement(transformation(extent={{-160,30},{-140,50}})));
  Buildings.Controls.OBC.CDL.Logical.And upAndEna
    "Stage up only if enabled"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  FirstTrueIndex idxFirTru(nin=nSta)
    annotation (Placement(transformation(extent={{150,90},{170,110}})));
  Pre pre "Return pre(idxSta)"
    annotation (Placement(transformation(extent={{150,50},{170,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not una[nSta]
    "True if stage is not available"
    annotation (Placement(transformation(extent={{-200,-130},{-180,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Or orUna[nSta]
    "Runtime criterion met AND staging up order OR stage unavailable"
    annotation (Placement(transformation(extent={{70,-22},{90,-2}})));
  Buildings.Controls.OBC.CDL.Logical.And runAndEna[nSta]
    "Runtime criterion met AND enable signal false"
    annotation (Placement(transformation(extent={{30,30},{50,50}})));
  Buildings.Controls.OBC.CDL.Logical.Or orUna1[nSta]
    "Runtime criterion met AND staging up order OR stage unavailable"
    annotation (Placement(transformation(extent={{80,-90},{100,-70}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractor staUna(
    final nin=nSta)
    "Return true if current stage is unavailable"
    annotation (Placement(transformation(extent={{-170,-130},{-150,-110}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rep4(
    final nout=nSta)
    "Replicate"
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Max maxInt
    "Maximum between current stage index and 1"
    annotation (Placement(transformation(extent={{-130,-200},{-150,-180}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant one(final k=1)
    "Constant"
    annotation (Placement(transformation(extent={{-80,-230},{-100,-210}})));
  Buildings.Controls.OBC.CDL.Integers.Greater staUp
    "Return true if current stage index > last computed stage index"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Less staDow
    "Return true if current stage index < last computed stage index"
    annotation (Placement(transformation(extent={{-80,-158},{-60,-138}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rep3(final nout=
        nSta)
    "Replicate"
    annotation (Placement(transformation(extent={{20,-150},{40,-130}})));
  Buildings.Controls.OBC.CDL.Logical.And staUpAndUna
    "Staging up AND stage unavailable"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
  Buildings.Controls.OBC.CDL.Logical.And staDowAndUna
    "Staging down AND stage unavailable"
    annotation (Placement(transformation(extent={{-20,-150},{0,-130}})));
equation
  for i in 1:(nSta - 1) loop
    connect(enaLag[i].outPort, sta[i+1].inPort[1])
      annotation (Line(points={{101.5,140},{110,140},{110,180},{-20,180},{-20,139.75},
            {-11,139.75}}, color={0,0,0}));
  end for;
  if nSta > 1 then
    for i in 2:nSta loop
      connect(disLag[i].outPort, sta[i-1].inPort[2])
        annotation (Line(points={{121.5,120},{140,120},{140,180},{-20,180},{-20,140.25},
              {-11,140.25}},color={0,0,0}));
    end for;
  end if;
  connect(enaLag[nSta].outPort, sta[nSta].inPort[2])
    annotation (Line(points={{101.5,140},{110,140},{110,180},{-20,180},{-20,140.25},
          {-11,140.25}}, color={0,0,0}));
  connect(disAll.outPort, sta0.inPort[1:nSta])
    annotation (Line(points={{81.5,160},{90,160},{90,200},{-140,200},{-140,140},
          {-121,140}}, color={0,0,0}));
  connect(sta0.outPort[1], enaLea.inPort)
    annotation (Line(points={{-99.5,140},{-64,140}}, color={0,0,0}));
  connect(enaLea.outPort, sta[1].inPort[1])
    annotation (Line(points={{-58.5,140},{-24,140},{-24,139.75},{-11,139.75}}, color={0,0,0}));
  connect(disLag[1].outPort, sta0.inPort[nSta+1]) annotation (Line(points={{121.5,
          120},{140,120},{140,200},{-140,200},{-140,140},{-121,140}}, color={0,0,0}));
  connect(sta.outPort[1], disAll.inPort) annotation (Line(points={{10.5,139.833},
          {20,139.833},{20,160},{76,160}}, color={0,0,0}));
  connect(sta.outPort[2], enaLag.inPort) annotation (Line(points={{10.5,140},{96,
          140}},color={0,0,0}));
  connect(sta.outPort[3], disLag.inPort) annotation (Line(points={{10.5,140.167},
          {20,140.167},{20,120},{116,120}}, color={0,0,0}));
  connect(sta.active, tim.u)
    annotation (Line(points={{0,129},{0,100},{-20,100},{-20,60},{-12,60}}, color={255,0,255}));
  connect(rep.y, runAndUp.u2) annotation (Line(points={{-78,0},{10,0},{10,-8},{28,
          -8}}, color={255,0,255}));
  connect(tim.passed, runAndDow.u1) annotation (Line(points={{12,52},{20,52},{20,
          -40},{28,-40}}, color={255,0,255}));
  connect(rep1.y, runAndDow.u2) annotation (Line(points={{-78,-40},{0,-40},{0,-48},
          {28,-48}},        color={255,0,255}));
  connect(tim.passed, runAndUp.u1) annotation (Line(points={{12,52},{20,52},{20,
          0},{28,0}}, color={255,0,255}));
  connect(u1Lea, notEna.u) annotation (Line(points={{-240,120},{-200,120},{-200,
          40},{-162,40}}, color={255,0,255}));
  connect(notEna.y, rep2.u)
    annotation (Line(points={{-138,40},{-102,40}}, color={255,0,255}));
  connect(u1Lea, upAndEna.u2) annotation (Line(points={{-240,120},{-200,120},{-200,
          -8},{-162,-8}}, color={255,0,255}));
  connect(u1Up, upAndEna.u1)
    annotation (Line(points={{-240,0},{-162,0}},     color={255,0,255}));
  connect(upAndEna.y, rep.u)
    annotation (Line(points={{-138,0},{-102,0}},    color={255,0,255}));
  connect(idxFirTru.y, y)
    annotation (Line(points={{172,100},{240,100}},
                                               color={255,127,0}));
  connect(pre.y, preY) annotation (Line(points={{172,60},{240,60}},
                 color={255,127,0}));
  connect(u1Ava, una.u)
    annotation (Line(points={{-240,-120},{-202,-120}}, color={255,0,255}));
  connect(rep2.y, runAndEna.u1)
    annotation (Line(points={{-78,40},{28,40}},   color={255,0,255}));
  connect(tim.passed, runAndEna.u2) annotation (Line(points={{12,52},{20,52},{20,
          32},{28,32}},      color={255,0,255}));
  connect(runAndEna.y, disAll.condition)
    annotation (Line(points={{52,40},{80,40},{80,148}},  color={255,0,255}));
  connect(runAndUp.y, orUna.u1) annotation (Line(points={{52,0},{60,0},{60,-12},
          {68,-12}}, color={255,0,255}));
  connect(sta.active, idxFirTru.u1)
    annotation (Line(points={{0,129},{0,100},{148,100}},
                                                    color={255,0,255}));
  connect(u1Dow, rep1.u)
    annotation (Line(points={{-240,-40},{-102,-40}},   color={255,0,255}));
  connect(orUna.y, enaLag.condition)
    annotation (Line(points={{92,-12},{100,-12},{100,128}},color={255,0,255}));
  connect(runAndDow.y, orUna1.u1) annotation (Line(points={{52,-40},{70,-40},{70,
          -80},{78,-80}},      color={255,0,255}));
  connect(orUna1.y, disLag.condition) annotation (Line(points={{102,-80},{120,-80},
          {120,108}},
                    color={255,0,255}));
  connect(maxInt.y, staUna.index) annotation (Line(points={{-152,-190},{-160,-190},
          {-160,-132}},                       color={255,127,0}));
  connect(una.y, staUna.u)
    annotation (Line(points={{-178,-120},{-172,-120}}, color={255,0,255}));
  connect(rep4.y, orUna.u2) annotation (Line(points={{42,-100},{60,-100},{60,-20},
          {68,-20}}, color={255,0,255}));
  connect(staUpAndUna.y, rep4.u)
    annotation (Line(points={{2,-100},{18,-100}}, color={255,0,255}));
  connect(staUna.y, staUpAndUna.u2) annotation (Line(points={{-148,-120},{-40,-120},
          {-40,-108},{-22,-108}}, color={255,0,255}));
  connect(staDowAndUna.y, rep3.u)
    annotation (Line(points={{2,-140},{18,-140}}, color={255,0,255}));
  connect(rep3.y, orUna1.u2) annotation (Line(points={{42,-140},{70,-140},{70,-88},
          {78,-88}},        color={255,0,255}));
  connect(one.y, maxInt.u2) annotation (Line(points={{-102,-220},{-120,-220},{-120,
          -196},{-128,-196}}, color={255,127,0}));
  connect(idxFirTru.y, maxInt.u1) annotation (Line(points={{172,100},{200,100},{
          200,-200},{-100,-200},{-100,-184},{-128,-184}}, color={255,127,0}));
  connect(idxFirTru.y, staUp.u1) annotation (Line(points={{172,100},{200,100},{200,
          -200},{-100,-200},{-100,-100},{-82,-100}}, color={255,127,0}));
  connect(idxFirTru.y, staDow.u1) annotation (Line(points={{172,100},{200,100},{
          200,-200},{-100,-200},{-100,-148},{-82,-148}}, color={255,127,0}));
  connect(staUp.y, staUpAndUna.u1)
    annotation (Line(points={{-58,-100},{-22,-100}}, color={255,0,255}));
  connect(pre.y, staDow.u2) annotation (Line(points={{172,60},{180,60},{180,-180},
          {-90,-180},{-90,-156},{-82,-156}}, color={255,127,0}));
  connect(pre.y, staUp.u2) annotation (Line(points={{172,60},{180,60},{180,-180},
          {-90,-180},{-90,-108},{-82,-108}}, color={255,127,0}));
  connect(staDow.y, staDowAndUna.u2)
    annotation (Line(points={{-58,-148},{-22,-148}}, color={255,0,255}));
  connect(staUna.y, staDowAndUna.u1) annotation (Line(points={{-148,-120},{-40,-120},
          {-40,-140},{-22,-140}}, color={255,0,255}));
  connect(idxFirTru.y, pre.u) annotation (Line(points={{172,100},{200,100},{200,
          80},{140,80},{140,60},{148,60}}, color={255,127,0}));
  connect(u1Lea, enaLea.condition) annotation (Line(points={{-240,120},{-60,120},
          {-60,128}}, color={255,0,255}));
  annotation (
      __cdl(extensionBlock=true),
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
  Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-220,-240},{220,240}})),
  Documentation(info="<html>
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
<li>
Any unavailable stage (<code>u1Ava[i]=false</code>) is skipped during 
staging events.
</li>
</ul>
<h4>Caveats</h4>
<p>
The only way to transition to stage <code>0</code> if by disabling the lead unit 
(<code>u1Lea=false</code>).
Stage down commands cannot be used to transition below stage <code>1</code>.
</p>
<p>
The availability condition that is typically used to generate a stage up
command &ndash; e.g., when one of the staged units becomes unavalaible &ndash; 
shall be implemented externally to compute the input signal <code>u1Up</code>.
The availability signal <code>u1Ava</code> is used here only to skip stages
<i>during stage transitions</i>, not to trigger a stage change during an 
enabled stage.
</p>
</html>", revisions="<html>
<ul>
<li>
February 24, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end StageIndex;
