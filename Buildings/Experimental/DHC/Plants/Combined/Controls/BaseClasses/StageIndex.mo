within Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses;
block StageIndex
  "Block that computes the stage index out of staging signals"

  parameter Integer nSta(start=1)
    "Number of stages"
    annotation(Evaluate=true);
  parameter Modelica.Units.SI.Time tSta=0
    "Minimum runtime of each stage"
    annotation(Evaluate=true);

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1
    "Enable signal"
    annotation (Placement(
        transformation(extent={{-220,40},{-180,80}}),iconTransformation(extent={{-140,40},
            {-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Up
    "Staging up signal"
    annotation (Placement(
        transformation(extent={{-220,-100},{-180,-60}}),iconTransformation(extent={{-140,
            -20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Dow
    "Staging down signal"
    annotation (Placement(
        transformation(extent={{-220,-140},{-180,-100}}),
        iconTransformation(extent={{-140,
            -78},{-100,-38}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput idxSta
    "Stage index"
    annotation (Placement(transformation(extent={{180,-20},{220,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput preIdxSta
    "Left limit (in discrete-time) of stage index"
    annotation (Placement(
        transformation(extent={{180,-60},{220,-20}}), iconTransformation(extent={{100,-80},
            {140,-40}})));

  Modelica.StateGraph.InitialStepWithSignal sta0(
    final nOut=1,
    final nIn=nSta+1)
    "Stage 0: no unit"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Modelica.StateGraph.StepWithSignal sta[nSta](
    each final nIn=2, each final nOut=3)
    "Stage i"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Modelica.StateGraph.TransitionWithSignal enaLea(
    final enableTimer=false) "Transition enabling lead unit"
    annotation (Placement(transformation(extent={{-42,30},{-22,50}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot "State graph root"
    annotation (Placement(transformation(extent={{-10,128},{10,148}})));
  Modelica.StateGraph.TransitionWithSignal enaLag[nSta](
    each final enableTimer=false)
    "Transition enabling lag unit"
    annotation (Placement(transformation(extent={{90,30},{110,50}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim[nSta](each final t=tSta)
    "Timer for minimum runtime"
    annotation (Placement(transformation(extent={{10,-50},{30,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim0(final t=tSta)
    "Timer for minimum runtime"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Timer for minimum runtime"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.OBC.CDL.Logical.And andUp[nSta]
    "Runtime criterion met AND staging up order"
    annotation (Placement(transformation(extent={{50,-90},{70,-70}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rep(
    final nout=nSta)
    "Replicate"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Controls.OBC.CDL.Logical.And andDow[nSta]
    "Runtime criterion met AND staging down order"
    annotation (Placement(transformation(extent={{50,-130},{70,-110}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rep1(
    final nout=nSta) "Replicate"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  Modelica.StateGraph.TransitionWithSignal disLag[nSta](
    each final enableTimer=false)
    "Transition disabling lag unit"
    annotation (Placement(transformation(extent={{110,10},{130,30}})));
  Modelica.StateGraph.TransitionWithSignal disAll[nSta](
    each final enableTimer=false)
    "Transition disabling all units"
    annotation (Placement(transformation(extent={{70,50},{90,70}})));
  Buildings.Controls.OBC.CDL.Logical.And andNotEna[nSta]
    "Runtime criterion met AND enable signal false"
    annotation (Placement(transformation(extent={{50,-50},{70,-30}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rep2(
    final nout=nSta)
    "Replicate"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "True if enable signal false"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Modelica.Blocks.Sources.IntegerExpression calIdxSta(final y=
        Modelica.Math.BooleanVectors.firstTrueIndex(sta.active))
    "Compute stage index"
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Transition to stage 1 at enable time"
    annotation (Placement(transformation(extent={{-130,70},{-110,90}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Transition to stage 1 at enable time or staging up order"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Modelica.Blocks.Sources.IntegerExpression calPre(final y=pre(idxSta))
    "Compute left limit of stage index"
    annotation (Placement(transformation(extent={{140,-50},{160,-30}})));

  Buildings.Controls.OBC.CDL.Logical.And upAndEna "Stage up only if enabled"
    annotation (Placement(transformation(extent={{-160,-90},{-140,-70}})));
  Buildings.Controls.OBC.CDL.Logical.And dowOrDis "Stage down if disabled"
    annotation (Placement(transformation(extent={{-160,-130},{-140,-110}})));
initial equation
  preIdxSta=0;
equation
  for i in 1:(nSta - 1) loop
  connect(enaLag[i].outPort, sta[i+1].inPort[1]) annotation (Line(points={{101.5,
            40},{110,40},{110,80},{-20,80},{-20,39.75},{-11,39.75}},
                                                               color={0,0,0}));
  connect(disLag[i+1].outPort, sta[i].inPort[2]) annotation (Line(points={{121.5,
            20},{130,20},{130,80},{-20,80},{-20,40.25},{-11,40.25}}, color={0,0,0}));
  end for;
  connect(enaLag[nSta].outPort, sta[nSta].inPort[2])
    annotation (Line(points={{101.5,40},{110,40},{110,80},{-20,80},{-20,40.25},{
          -11,40.25}},                                       color={0,0,0}));
  connect(disAll.outPort, sta0.inPort[1:nSta])
    annotation (Line(points={{81.5,60},{90,60},{90,100},{-140,100},{-140,40},{
          -121,40}},                                color={0,0,0}));
  connect(sta0.outPort[1], enaLea.inPort)
    annotation (Line(points={{-99.5,40},{-36,40}}, color={0,0,0}));
  connect(enaLea.outPort, sta[1].inPort[1])
    annotation (Line(points={{-30.5,40},{-24,40},{-24,39.75},{-11,39.75}},color={0,0,0}));

  connect(disLag[1].outPort, sta0.inPort[nSta+1]) annotation (Line(points={{121.5,
          20},{130,20},{130,100},{-140,100},{-140,40},{-121,40}},
                                                            color={0,0,0}));
  connect(sta.outPort[1], disAll.inPort) annotation (Line(points={{10.5,39.8333},
          {20,39.8333},{20,60},{76,60}},
                            color={0,0,0}));
  connect(sta.outPort[2], enaLag.inPort) annotation (Line(points={{10.5,40},{96,
          40}},                         color={0,0,0}));
  connect(sta.outPort[3], disLag.inPort) annotation (Line(points={{10.5,40.1667},
          {20,40.1667},{20,20},{116,20}},
                                        color={0,0,0}));

  connect(sta.active, tim.u)
    annotation (Line(points={{0,29},{0,-40},{8,-40}}, color={255,0,255}));
  connect(sta0.active, tim0.u) annotation (Line(points={{-110,29},{-110,10},{
          -102,10}},
                color={255,0,255}));
  connect(tim0.passed, and2.u2)
    annotation (Line(points={{-78,2},{-62,2}}, color={255,0,255}));
  connect(and2.y, enaLea.condition)
    annotation (Line(points={{-38,10},{-32,10},{-32,28}}, color={255,0,255}));
  connect(rep.y, andUp.u2) annotation (Line(points={{-38,-80},{34,-80},{34,-88},
          {48,-88}}, color={255,0,255}));
  connect(andUp.y, enaLag.condition)
    annotation (Line(points={{72,-80},{100,-80},{100,28}}, color={255,0,255}));
  connect(tim.passed, andDow.u1) annotation (Line(points={{32,-48},{40,-48},{40,
          -120},{48,-120}}, color={255,0,255}));
  connect(rep1.y, andDow.u2) annotation (Line(points={{-38,-120},{36,-120},{36,-128},
          {48,-128}}, color={255,0,255}));
  connect(tim.passed, andUp.u1) annotation (Line(points={{32,-48},{40,-48},{40,-80},
          {48,-80}}, color={255,0,255}));
  connect(andDow.y, disLag.condition) annotation (Line(points={{72,-120},{120,-120},
          {120,8}}, color={255,0,255}));
  connect(u1, not1.u) annotation (Line(points={{-200,60},{-170,60},{-170,-40},{
          -102,-40}},
                 color={255,0,255}));
  connect(not1.y, rep2.u)
    annotation (Line(points={{-78,-40},{-62,-40}}, color={255,0,255}));
  connect(rep2.y, andNotEna.u1) annotation (Line(points={{-38,-40},{-20,-40},{-20,
          -20},{40,-20},{40,-40},{48,-40}}, color={255,0,255}));
  connect(tim.passed, andNotEna.u2)
    annotation (Line(points={{32,-48},{48,-48}}, color={255,0,255}));
  connect(andNotEna.y, disAll.condition)
    annotation (Line(points={{72,-40},{80,-40},{80,48}}, color={255,0,255}));

  connect(calIdxSta.y, idxSta)
    annotation (Line(points={{161,0},{200,0}},color={255,127,0}));
  connect(u1, edg.u) annotation (Line(points={{-200,60},{-170,60},{-170,80},{
          -132,80}},
                color={255,0,255}));
  connect(edg.y, or2.u1)
    annotation (Line(points={{-108,80},{-102,80}},
                                                 color={255,0,255}));
  connect(or2.y, and2.u1) annotation (Line(points={{-78,80},{-70,80},{-70,10},{
          -62,10}},               color={255,0,255}));
  connect(calPre.y, preIdxSta)
    annotation (Line(points={{161,-40},{200,-40}}, color={255,127,0}));
  connect(u1, upAndEna.u2) annotation (Line(points={{-200,60},{-170,60},{-170,
          -88},{-162,-88}}, color={255,0,255}));
  connect(u1Up, upAndEna.u1)
    annotation (Line(points={{-200,-80},{-162,-80}}, color={255,0,255}));
  connect(upAndEna.y, rep.u)
    annotation (Line(points={{-138,-80},{-62,-80}}, color={255,0,255}));
  connect(dowOrDis.y, rep1.u)
    annotation (Line(points={{-138,-120},{-62,-120}}, color={255,0,255}));
  connect(u1Dow, dowOrDis.u1)
    annotation (Line(points={{-200,-120},{-162,-120}}, color={255,0,255}));
  connect(u1, dowOrDis.u2) annotation (Line(points={{-200,60},{-170,60},{-170,
          -128},{-162,-128}}, color={255,0,255}));
  connect(upAndEna.y, or2.u2) annotation (Line(points={{-138,-80},{-130,-80},{
          -130,60},{-106,60},{-106,72},{-102,72}},
                                                color={255,0,255}));
  annotation (
  defaultComponentName="sta",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-180,-180},{180,180}})),
    Documentation(info="<html>
<p>
This block is used to compute the stage index of the plant or 
of multiple lead/lag units such as pump groups.
</p>
<p>
At initial time, stage <code>#0</code> is active.
The transition to stage <code>#1</code> is triggered when stage <code>#0</code> has been active
for the minimum runtime and when either the Enable signal <code>u1</code> 
has a rising edge or when the stage up signal <code>u1Up</code> is <code>true</code>.
</p>
<p>
From stage <code>#i</code>, the transition to stage <code>#i+1</code> (resp. <code>i-1</code>) is triggered 
when stage <code>#i</code> has been active for the minimum runtime and when the 
stage up signal <code>u1Up</code> (resp. stage down signal <code>u1Dow</code>)
is <code>true</code>.
From stage <code>#i</code>, the transition to stage <code>#0</code> is triggered 
when stage <code>#i</code> has been active for the minimum runtime and the Enable signal 
<code>u1</code> is <code>false</code>.
</p>
</html>"));
end StageIndex;
