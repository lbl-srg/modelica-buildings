within Buildings.Templates.Plants.Controls.StagingRotation;
block StageChangeCommand
  "Generate stage change command"
  parameter Buildings.Templates.Plants.Controls.Types.Application typ
    "Type of application"
    annotation (Evaluate=true);
  parameter Boolean have_pumSec
    "Set to true for primary-secondary distribution, false for primary-only"
    annotation (Evaluate=true);
  parameter Boolean have_inpPlrSta=false
    "Set to true to use an input signal for SPLR, false to use a parameter"
    annotation (Evaluate=true);
  parameter Real plrSta(
    max=1,
    min=0,
    start=0.9,
    unit="1")=0.9
    "Staging part load ratio"
    annotation (Dialog(enable=not have_inpPlrSta));
  final parameter Real traStaEqu[nEqu, nSta]={{staEqu[i, j] for i in 1:nSta} for j in 1:nEqu}
    "Transpose of staging matrix";
  parameter Real staEqu[:,:](
    max=1,
    min=0,
    unit="1")
    "Staging matrix – Equipment required for each stage";
  final parameter Integer nSta=size(staEqu, 1)
    "Number of stages"
    annotation (Evaluate=true);
  final parameter Integer nEqu=size(staEqu, 2)
    "Number of equipment"
    annotation (Evaluate=true);
  parameter Real capEqu[nEqu](min=0, unit="W")
    "Design capacity of each equipment";
  parameter Real dtRun(
    min=0,
    unit="s")=900
    "Runtime with exceeded staging part load ratio before staging event is triggered";
  parameter Real dtMea(
    min=0,
    unit="s")=300
    "Duration used to compute the moving average of required capacity";
  parameter Real cp_default(min=0, unit="J/(kg.K)")
    "Default specific heat capacity used to compute required capacity";
  parameter Real rho_default(min=0, unit="kg/m3")
    "Default density used to compute required capacity";
  parameter Real dT(min=0, unit="K")
    "Delta-T triggering stage up command (>0)";
  parameter Real dtPri(
    min=0,
    unit="s")=900
    "Runtime with high primary-setpoint Delta-T before staging up";
  parameter Real dtSec(
    min=0,
    start=600,
    unit="s")=600
    "Runtime with high secondary-primary and secondary-setpoint Delta-T before staging up"
    annotation(Dialog(enable=have_pumSec));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1AvaSta[nSta]
    "Stage available signal"
    annotation (Placement(transformation(extent={{-240,40},{-200,80}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1StaPro
    "Staging process in progress"
    annotation (Placement(transformation(extent={{-240,0},{-200,40}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uPlrSta(
    final unit="1",
    final min=0,
    final max=1)
    if have_inpPlrSta
    "Input signal for staging part load ratio"
    annotation (Placement(transformation(extent={{-240,-240},{-200,-200}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));
  // We allow the stage index to be zero, e.g., when the plant is disabled.
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta(
    final min=0,
    final max=nSta)
    "Stage index"
    annotation (Placement(transformation(extent={{-240,160},{-200,200}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRet(
    final unit="K",
    displayUnit="degC") "Return temperature used to compute required capacity"
    annotation (Placement(transformation(extent={{-240,-160},{-200,-120}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(
    final unit="K",
    displayUnit="degC")
    "Active supply temperature setpoint used to compute required capacity"
    annotation (Placement(transformation(extent={{-240,-100},{-200,-60}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput V_flow(
    final unit="m3/s") "Volume flow rate used to compute required capacity"
    annotation (Placement(transformation(extent={{-240,-200},{-200,-160}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Up
    "Stage up command"
    annotation (Placement(transformation(extent={{200,60},{240,100}}),
      iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Dow
    "Stage down command"
    annotation (Placement(transformation(extent={{200,-100},{240,-60}}),
      iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant traMatStaEqu[nEqu, nSta](
    final k=traStaEqu)
    "Transpose of staging matrix"
    annotation (Placement(transformation(extent={{-80,210},{-60,230}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor reqEquSta[nEqu](
    each final nin=nSta)
    "Extract equipment required at given stage"
    annotation (Placement(transformation(extent={{-10,210},{10,230}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(
    final nout=nEqu)
    "Replicate signal"
    annotation (Placement(transformation(extent={{-110,190},{-90,210}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply capEquSta[nEqu]
    "Capacity of each equipment required at given stage"
    annotation (Placement(transformation(extent={{30,210},{50,230}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant capEquPar[nEqu](
    final k=capEqu)
    "Capacity of each equipment"
    annotation (Placement(transformation(extent={{-80,150},{-60,170}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum capSta(
    nin=nEqu)
    "Compute nominal capacity of active stage"
    annotation (Placement(transformation(extent={{70,210},{90,230}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre(h=1E-4*min(capEqu))
    "Compare OPLR to SPLR (hysteresis is to avoid chattering with some simulators)"
    annotation (Placement(transformation(extent={{-90,-110},{-70,-90}})));
  Buildings.Templates.Plants.Controls.Utilities.TimerWithReset timUp(
    final t=dtRun)
    "Timer"
    annotation (Placement(transformation(extent={{-50,-110},{-30,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Less les(h=1E-4*min(capEqu))
    "Compare OPLR to SPLR (hysteresis is to avoid chattering with some simulators)"
    annotation (Placement(transformation(extent={{-90,-150},{-70,-130}})));
  Buildings.Templates.Plants.Controls.Utilities.TimerWithReset timDow(
    final t=dtRun)
    "Timer"
    annotation (Placement(transformation(extent={{-50,-150},{-30,-130}})));
  Utilities.HoldReal hol(final dtHol=dtRun)
    "Hold value of required capacity at stage change"
    annotation (Placement(transformation(extent={{-130,-110},{-110,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Max maxInt
    "Maximum between stage index and 1"
    annotation (Placement(transformation(extent={{-140,190},{-120,210}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant one(
    final k=1)
    "Constant"
    annotation (Placement(transformation(extent={{-180,170},{-160,190}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idxSta[nSta](
    final k={i for i in 1:nSta})
    "Stage index"
    annotation (Placement(transformation(extent={{-180,130},{-160,150}})));
  Buildings.Controls.OBC.CDL.Integers.Less idxStaLesAct[nSta]
    "Return true if stage index lower than active stage index"
    annotation (Placement(transformation(extent={{-150,90},{-130,110}})));
  Buildings.Controls.OBC.CDL.Logical.And idxStaLesActAva[nSta]
    "Return true if stage index lower than active stage index and stage available"
    annotation (Placement(transformation(extent={{-110,70},{-90,90}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep1(
    final nout=nSta)
    "Replicate signal"
    annotation (Placement(transformation(extent={{-180,90},{-160,110}})));
  Utilities.LastTrueIndex idxLasTru(
    nin=nSta)
    "Index of next available lower stage"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Integers.Max maxInt1
    "Maximum between stage index and 1"
    annotation (Placement(transformation(extent={{-30,110},{-10,130}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep2(
    final nout=nEqu)
    "Replicate signal"
    annotation (Placement(transformation(extent={{10,110},{30,130}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor reqEquStaLow[nEqu](
    each final nin=nSta)
    "Extract equipment required at next available lower stage"
    annotation (Placement(transformation(extent={{-10,170},{10,190}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply capEquStaLow[nEqu]
    "Capacity of each equipment required at next available lower stage"
    annotation (Placement(transformation(extent={{30,170},{50,190}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum capStaLow(
    nin=nEqu)
    "Compute nominal capacity of next available lower stage"
    annotation (Placement(transformation(extent={{70,170},{90,190}})));
  Buildings.Controls.OBC.CDL.Integers.Min minInt
    "Minimum between stage index and 1"
    annotation (Placement(transformation(extent={{-30,70},{-10,90}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Convert to real value"
    annotation (Placement(transformation(extent={{10,70},{30,90}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply setZer
    "Set nominal capacity to zero if no lower available stage"
    annotation (Placement(transformation(extent={{110,170},{130,190}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply splTimCapSta
    "SPLR times capacity of active stage"
    annotation (Placement(transformation(extent={{-130,-150},{-110,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply splTimCapStaLow
    "SPLR times capacity of next available lower stage"
    annotation (Placement(transformation(extent={{-130,-190},{-110,-170}})));
  Utilities.PlaceholderReal parPlrSta(
    final have_inp=have_inpPlrSta,
    final have_inpPh=false,
    final u_internal=plrSta) "Parameter value for SPLR"
    annotation (Placement(transformation(extent={{-190,-230},{-170,-210}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge endStaPro
    "True when staging process terminates"
    annotation (Placement(transformation(extent={{-130,10},{-110,30}})));
  LoadAverage capReq(
    final typ=typ,
    final cp_default=cp_default,
    final rho_default=rho_default,
    final dtMea=dtMea) "Compute required capacity"
    annotation (Placement(transformation(extent={{-170,-110},{-150,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TPriSup(final unit="K",
      displayUnit="degC") "Primary supply temperature" annotation (Placement(
        transformation(extent={{-240,-40},{-200,0}}), iconTransformation(extent={{-140,
            -40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSecSup(final unit="K",
      displayUnit="degC") if have_pumSec
                          "Secondary supply temperature" annotation (Placement(
        transformation(extent={{-240,-60},{-200,-20}}), iconTransformation(
          extent={{-140,-60},{-100,-20}})));
  FailsafeCondition faiSaf(
    final typ=typ,
    final have_pumSec=have_pumSec,
    final dT=dT,
    final dtPri=dtPri,
    final dtSec=dtSec) "Failsafe stage up condition "
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Or  effOrFaiSaf
    "Efficiency OR failsafe condition met"
    annotation (Placement(transformation(extent={{10,-70},{30,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Not notFaiSaf
    "Failsafe stage up condition is not true"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Buildings.Controls.OBC.CDL.Logical.And effAndNotFaiSaf
    "Efficiency condition met AND failsafe stage up condition is not true"
    annotation (Placement(transformation(extent={{10,-150},{30,-130}})));
equation
  connect(intScaRep.y, reqEquSta.index)
    annotation (Line(points={{-88,200},{0,200},{0,208}},color={255,127,0}));
  connect(traMatStaEqu.y, reqEquSta.u)
    annotation (Line(points={{-58,220},{-12,220}},color={0,0,127}));
  connect(reqEquSta.y, capEquSta.u1)
    annotation (Line(points={{12,220},{20,220},{20,226},{28,226}},color={0,0,127}));
  connect(capEquPar.y, capEquSta.u2)
    annotation (Line(points={{-58,160},{20,160},{20,214},{28,214}},color={0,0,127}));
  connect(capEquSta.y, capSta.u)
    annotation (Line(points={{52,220},{68,220}},color={0,0,127}));
  connect(intScaRep.u, maxInt.y)
    annotation (Line(points={{-112,200},{-118,200}},color={255,127,0}));
  connect(idxSta.y, idxStaLesAct.u1)
    annotation (Line(points={{-158,140},{-154,140},{-154,100},{-152,100}},color={255,127,0}));
  connect(uSta, intScaRep1.u)
    annotation (Line(points={{-220,180},{-190,180},{-190,100},{-182,100}},color={255,127,0}));
  connect(intScaRep1.y, idxStaLesAct.u2)
    annotation (Line(points={{-158,100},{-156,100},{-156,92},{-152,92}},color={255,127,0}));
  connect(idxStaLesAct.y, idxStaLesActAva.u1)
    annotation (Line(points={{-128,100},{-120,100},{-120,80},{-112,80}},color={255,0,255}));
  connect(u1AvaSta, idxStaLesActAva.u2)
    annotation (Line(points={{-220,60},{-120,60},{-120,72},{-112,72}},color={255,0,255}));
  connect(idxStaLesActAva.y, idxLasTru.u1)
    annotation (Line(points={{-88,80},{-82,80}},color={255,0,255}));
  connect(idxLasTru.y, maxInt1.u2)
    annotation (Line(points={{-58,80},{-44,80},{-44,114},{-32,114}},color={255,127,0}));
  connect(one.y, maxInt1.u1)
    annotation (Line(points={{-158,180},{-40,180},{-40,126},{-32,126}},color={255,127,0}));
  connect(maxInt1.y, intScaRep2.u)
    annotation (Line(points={{-8,120},{8,120}},color={255,127,0}));
  connect(uSta, maxInt.u1)
    annotation (Line(points={{-220,180},{-190,180},{-190,206},{-142,206}},color={255,127,0}));
  connect(one.y, maxInt.u2)
    annotation (Line(points={{-158,180},{-150,180},{-150,194},{-142,194}},color={255,127,0}));
  connect(intScaRep2.y, reqEquStaLow.index)
    annotation (Line(points={{32,120},{40,120},{40,140},{0,140},{0,168}},color={255,127,0}));
  connect(traMatStaEqu.y, reqEquStaLow.u)
    annotation (Line(points={{-58,220},{-20,220},{-20,180},{-12,180}},color={0,0,127}));
  connect(reqEquStaLow.y, capEquStaLow.u2)
    annotation (Line(points={{12,180},{16,180},{16,174},{28,174}},color={0,0,127}));
  connect(capEquPar.y, capEquStaLow.u1)
    annotation (Line(points={{-58,160},{20,160},{20,186},{28,186}},color={0,0,127}));
  connect(capEquStaLow.y, capStaLow.u)
    annotation (Line(points={{52,180},{68,180}},color={0,0,127}));
  connect(idxLasTru.y, minInt.u2)
    annotation (Line(points={{-58,80},{-44,80},{-44,74},{-32,74}},color={255,127,0}));
  connect(one.y, minInt.u1)
    annotation (Line(points={{-158,180},{-40,180},{-40,86},{-32,86}},color={255,127,0}));
  connect(minInt.y, intToRea.u)
    annotation (Line(points={{-8,80},{8,80}},color={255,127,0}));
  connect(capStaLow.y, setZer.u1)
    annotation (Line(points={{92,180},{100,180},{100,186},{108,186}},color={0,0,127}));
  connect(intToRea.y, setZer.u2)
    annotation (Line(points={{32,80},{100,80},{100,174},{108,174}},color={0,0,127}));
  connect(hol.y, gre.u1)
    annotation (Line(points={{-108,-100},{-92,-100}},
                                                color={0,0,127}));
  connect(splTimCapSta.y, gre.u2)
    annotation (Line(points={{-108,-140},{-106,-140},{-106,-108},{-92,-108}},
                                                                    color={0,0,127}));
  connect(capSta.y, splTimCapSta.u2)
    annotation (Line(points={{92,220},{136,220},{136,-160},{-136,-160},{-136,-146},
          {-132,-146}},
      color={0,0,127}));
  connect(setZer.y, splTimCapStaLow.u2)
    annotation (Line(points={{132,180},{140,180},{140,-200},{-136,-200},{-136,-186},
          {-132,-186}},
      color={0,0,127}));
  connect(splTimCapStaLow.y, les.u2)
    annotation (Line(points={{-108,-180},{-100,-180},{-100,-148},{-92,-148}},
                                                                      color={0,0,127}));
  connect(hol.y, les.u1)
    annotation (Line(points={{-108,-100},{-100,-100},{-100,-140},{-92,-140}},
                                                                    color={0,0,127}));
  connect(gre.y, timUp.u)
    annotation (Line(points={{-68,-100},{-52,-100}},
                                                color={255,0,255}));
  connect(les.y, timDow.u)
    annotation (Line(points={{-68,-140},{-52,-140}},
                                                  color={255,0,255}));
  connect(uPlrSta, parPlrSta.u)
    annotation (Line(points={{-220,-220},{-192,-220}}, color={0,0,127}));
  connect(parPlrSta.y, splTimCapSta.u1) annotation (Line(points={{-168,-220},{-140,
          -220},{-140,-134},{-132,-134}},
                                        color={0,0,127}));
  connect(parPlrSta.y, splTimCapStaLow.u1) annotation (Line(points={{-168,-220},
          {-140,-220},{-140,-174},{-132,-174}},
                                             color={0,0,127}));
  connect(u1StaPro, hol.u1)
    annotation (Line(points={{-220,20},{-140,20},{-140,-100},{-132,-100}},
                                                                       color={255,0,255}));
  connect(endStaPro.y, timUp.reset)
    annotation (Line(points={{-108,20},{-60,20},{-60,-108},{-52,-108}},
                                                                  color={255,0,255}));
  connect(endStaPro.y, timDow.reset)
    annotation (Line(points={{-108,20},{-60,20},{-60,-148},{-52,-148}},
                                                                    color={255,0,255}));
  connect(TSupSet, capReq.TSupSet) annotation (Line(points={{-220,-80},{-180,-80},
          {-180,-94},{-172,-94}},      color={0,0,127}));
  connect(TRet, capReq.TRet)
    annotation (Line(points={{-220,-140},{-192,-140},{-192,-100},{-172,-100}},
                                                       color={0,0,127}));
  connect(V_flow, capReq.V_flow) annotation (Line(points={{-220,-180},{-180,-180},
          {-180,-106},{-172,-106}},       color={0,0,127}));
  connect(capReq.QReq_flow, hol.u) annotation (Line(points={{-148,-100},{-144,-100},
          {-144,-106},{-132,-106}},
                             color={0,0,127}));
  connect(u1StaPro, endStaPro.u)
    annotation (Line(points={{-220,20},{-132,20}}, color={255,0,255}));
  connect(TPriSup, faiSaf.TPriSup)
    annotation (Line(points={{-220,-20},{-92,-20}}, color={0,0,127}));
  connect(endStaPro.y, faiSaf.reset) annotation (Line(points={{-108,20},{-100,20},
          {-100,-12},{-92,-12}}, color={255,0,255}));
  connect(TSecSup, faiSaf.TSecSup) annotation (Line(points={{-220,-40},{-100,-40},
          {-100,-24},{-92,-24}}, color={0,0,127}));
  connect(TSupSet, faiSaf.TSupSet) annotation (Line(points={{-220,-80},{-180,-80},
          {-180,-16},{-92,-16}}, color={0,0,127}));
  connect(faiSaf.y1, effOrFaiSaf.u1) annotation (Line(points={{-68,-20},{0,-20},
          {0,-60},{8,-60}},   color={255,0,255}));
  connect(timUp.passed, effOrFaiSaf.u2) annotation (Line(points={{-28,-108},{0,
          -108},{0,-68},{8,-68}},   color={255,0,255}));
  connect(effOrFaiSaf.y, y1Up) annotation (Line(points={{32,-60},{180,-60},{180,
          80},{220,80}}, color={255,0,255}));
  connect(faiSaf.y1, notFaiSaf.u) annotation (Line(points={{-68,-20},{-56,-20},
          {-56,-40},{-52,-40}}, color={255,0,255}));
  connect(timDow.passed, effAndNotFaiSaf.u2)
    annotation (Line(points={{-28,-148},{8,-148}}, color={255,0,255}));
  connect(notFaiSaf.y, effAndNotFaiSaf.u1) annotation (Line(points={{-28,-40},{
          -20,-40},{-20,-140},{8,-140}},
                                     color={255,0,255}));
  connect(effAndNotFaiSaf.y, y1Dow) annotation (Line(points={{32,-140},{180,
          -140},{180,-80},{220,-80}}, color={255,0,255}));
  annotation (
    defaultComponentName="chaSta",
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-120},{100,120}}),
      graphics={
        Rectangle(
          extent={{-100,120},{100,-120}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,170},{150,130}},
          textString="%name",
          textColor={0,0,255})}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-200,-240},{200,240}})),
    Documentation(
      info="<html>
<p>
The plant equipment is staged in part based on required capacity, <i>Qrequired</i>, 
relative to nominal capacity of a given stage, <i>Qstage</i>. 
This ratio is the operative part load ratio, <i>OPLR</i>.
</p>
<p>
<i>OPLR = Qrequired / Qstage</i>
</p>
<p>
If both primary and secondary hot water temperatures and flow rates are available, 
the sensors in the primary loop are used for calculating <i>Qrequired</i>. 
If a heat recovery chiller is piped into the secondary return, the sensors in the 
primary loop are used.
(These conditions are implemented in
<a href=\"modelica://Buildings.Templates.Plants.Controls.HeatPumps.AirToWater\">
Buildings.Templates.Plants.Controls.HeatPumps.AirToWater</a>.)
</p>
<p>
The required capacity is calculated based on return temperature, 
active supply temperature setpoint and measured flow through the 
associated circuit flow meter.
</p>
<p>
The required capacity used in logic is a rolling average over a period
of <code>dtMea</code>
of instantaneous values sampled at minimum once every <i>30</i>&nbsp;s.
</p>
<p>
When a stage up or stage down transition is initiated, 
<i>Qrequired</i> is held fixed at its last value until the longer of 
the successful completion of the stage change 
and the duration <code>dtRun</code>.
</p>
<p>
The nominal capacity of a given stage, <i>Qstage</i>, is calculated 
as the sum of the design capacities of all units enabled in a given stage.
</p>
<p>
Staging is executed per the conditions below subject to the following requirements.
</p>
<ul>
<li>
Each stage has a minimum runtime of <code>dtRun</code>.
(This condition is implemented in
<a href=\"modelica://Buildings.Templates.Plants.Controls.Utilities.StageIndex\">
Buildings.Templates.Plants.Controls.Utilities.StageIndex</a>.)
</li>
<li>
Timers are reset to zero at the completion of every stage change.
</li>
<li>
Any unavailable stage is skipped during staging events, 
but staging conditionals in the current stage are evaluated as per usual.
</li>
</ul>
<p>
A stage up command is triggered if any of the following is true:
</p>
<ul>
<li>
Availability condition: The equipment necessary to operate the 
current stage is unavailable. 
The availability condition is not subject to the minimum stage runtime requirement.
(This condition is implemented in
<a href=\"modelica://Buildings.Templates.Plants.Controls.Utilities.StageIndex\">
Buildings.Templates.Plants.Controls.Utilities.StageIndex</a>.)
</li>
<li>
Efficiency condition: Current stage <i>OPLR &gt; plrSta</i> for a duration of <code>dtRun</code>.
</li>
<li>
Failsafe condition: see 
<a href=\"modelica://Buildings.Templates.Plants.Controls.StagingRotation.FailsafeCondition\">
Buildings.Templates.Plants.Controls.StagingRotation.FailsafeCondition</a>.
</li>
</ul>
<p>
A stage down command is triggered if both of the following are true:
</p>
<ul>
<li>
Next available lower stage <i>OPLR &lt; plrSta</i> for a duration of <code>dtRun</code>.
</li>
<li>
The failsafe stage up condition is not true.
</li>
</ul>
<h4>
Details
</h4>
<p>
A staging matrix <code>staEqu</code> is required as a parameter. 
See the documentation of 
<a href=\"modelica://Buildings.Templates.Plants.Controls.StagingRotation.EquipmentEnable\">
Buildings.Templates.Plants.Controls.StagingRotation.EquipmentEnable</a>
for the associated definition and requirements.
</p>
<p>
An \"if\" condition is used to generate the stage up and down command as opposed
to a \"when\" condition. This means that the command remains true as long as the
condition is verified. This is necessary, for example, if no higher stage is
available when a stage up command is triggered. Using a \"when\" condition &ndash;
which is only valid at the point in time at which the condition becomes true &ndash;
would prevent the plant from staging when a higher stage becomes available again.
To avoid multiple consecutive stage changes, the block that receives the stage up
and down command and computes the stage index must enforce a minimum stage runtime
of <code>dtRun</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 31, 2024, by Antoine Gautier:<br/>
Refactored using <code>LoadAverage</code> block and added failsafe condition.
</li>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end StageChangeCommand;
