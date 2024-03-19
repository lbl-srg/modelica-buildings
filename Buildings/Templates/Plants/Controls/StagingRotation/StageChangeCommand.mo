within Buildings.Templates.Plants.Controls.StagingRotation;
block StageChangeCommand
  "Generate stage change command"
  parameter Boolean have_inpPlrSta=false
    "Set to true to use an input signal for SPLR, false to use a parameter"
    annotation (Evaluate=true);
  parameter Real plrSta(
    final max=1,
    final min=0,
    start=0.9,
    final unit="1")
    "Staging part load ratio"
    annotation (Dialog(enable=not have_inpPlrSta));
  final parameter Real traStaEqu[nEqu, nSta]={{staEqu[i, j] for i in 1:nSta} for j in 1:nEqu}
    "Tranpose of staging matrix";
  parameter Real staEqu[:,:](
    each final max=1,
    each final min=0,
    each final unit="1")
    "Staging matrix – Equipment required for each stage";
  final parameter Integer nSta=size(staEqu, 1)
    "Number of stages"
    annotation (Evaluate=true);
  final parameter Integer nEqu=size(staEqu, 2)
    "Number of equipment"
    annotation (Evaluate=true);
  parameter Real capEqu[nEqu](
    each final min=0,
    each final unit="W")
    "Design capacity of each equipment";
  parameter Real dtRun(
    final min=0,
    final unit="s")=900
    "Runtime with exceeded staging part load ratio before staging event is triggered";
  parameter Real dtMea(
    final min=0,
    final unit="s")=300
    "Duration used to compute the moving average of required capacity";
  parameter Real cp_default(
    final min=0,
    final unit="J/(kg.K)")
    "Default specific heat capacity used to compute required capacity";
  parameter Real rho_default(
    final min=0,
    final unit="kg/m3")
    "Default density used to compute required capacity";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1AvaSta[nSta]
    "Stage available signal"
    annotation (Placement(transformation(extent={{-240,60},{-200,100}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1StaPro
    "Staging process in progress"
    annotation (Placement(transformation(extent={{-240,-40},{-200,0}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uPlrSta(
    final unit="1",
    final min=0,
    final max=1)
    if have_inpPlrSta
    "Input signal for staging part load ratio"
    annotation (Placement(transformation(extent={{-240,-200},{-200,-160}}),
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
    displayUnit="degC")
    "Return temperature used to compute required capacity"
    annotation (Placement(transformation(extent={{-240,-120},{-200,-80}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(
    final unit="K",
    displayUnit="degC")
    "Active supply temperature setpoint used to compute required capacity"
    annotation (Placement(transformation(extent={{-240,-80},{-200,-40}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput V_flow(
    final unit="m3/s")
    "Volume flow rate used to compute required capacity"
    annotation (Placement(transformation(extent={{-240,-160},{-200,-120}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Up
    "Stage up command"
    annotation (Placement(transformation(extent={{200,60},{240,100}}),
      iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Dow
    "Stage down command"
    annotation (Placement(transformation(extent={{200,-100},{240,-60}}),
      iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract delT(
    y(final unit="K"))
    "Compute ∆T"
    annotation (Placement(transformation(extent={{-170,-90},{-150,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Abs absDelT(
    y(final unit="K"))
    "Compute absolute value of ∆T"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter capFlo(
    y(final unit="W/K"),
    final k=rho_default * cp_default)
    "Compute capacity flow rate"
    annotation (Placement(transformation(extent={{-168,-150},{-148,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply capReq
    "Compute required capacity"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant traMatStaEqu[nEqu, nSta](
    final k=traStaEqu)
    "Transpose of staging matrix"
    annotation (Placement(transformation(extent={{-70,210},{-50,230}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor reqEquSta[nEqu](
    each final nin=nSta)
    "Extract equipment required at given stage"
    annotation (Placement(transformation(extent={{-10,210},{10,230}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(
    final nout=nEqu)
    "Replicate signal"
    annotation (Placement(transformation(extent={{-104,190},{-84,210}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply capEquSta[nEqu]
    "Capacity of each equipment required at given stage"
    annotation (Placement(transformation(extent={{30,210},{50,230}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant capEquPar[nEqu](
    final k=capEqu)
    "Capacity of each equipment"
    annotation (Placement(transformation(extent={{-70,150},{-50,170}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum capSta(
    nin=nEqu)
    "Compute nominal capacity of active stage"
    annotation (Placement(transformation(extent={{70,210},{90,230}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre
    "Compare OPLR to SPLR"
    annotation (Placement(transformation(extent={{30,-70},{50,-50}})));
  Buildings.Controls.OBC.CDL.Reals.MovingAverage movAve(
    delta=dtMea)
    "Compute moving average"
    annotation (Placement(transformation(extent={{-70,-90},{-50,-70}})));
  Buildings.Templates.Plants.Controls.Utilities.TimerWithReset timUp(
    final t=dtRun)
    "Timer"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Less les
    "Compare OPLR to SPLR"
    annotation (Placement(transformation(extent={{30,-130},{50,-110}})));
  Buildings.Templates.Plants.Controls.Utilities.TimerWithReset timDow(
    final t=dtRun)
    "Timer"
    annotation (Placement(transformation(extent={{80,-130},{100,-110}})));
  Utilities.HoldValue hol(
    final dtHol=dtRun)
    "Hold value of required capacity at stage change"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
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
    annotation (Placement(transformation(extent={{-110,70},{-90,90}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep1(
    final nout=nSta)
    "Replicate signal"
    annotation (Placement(transformation(extent={{-180,90},{-160,110}})));
  Utilities.LastTrueIndex idxLasTru(
    nin=nSta)
    "Index of next available lower stage"
    annotation (Placement(transformation(extent={{-70,70},{-50,90}})));
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
    annotation (Placement(transformation(extent={{-10,-130},{10,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply splTimCapStaLow
    "SPLR times capacity of next available lower stage"
    annotation (Placement(transformation(extent={{-10,-170},{10,-150}})));
  Utilities.PlaceHolderReal parPlrSta(
    final have_inp=have_inpPlrSta,
    final have_inpPla=false,
    final u_internal=plrSta) "Parameter value for SPLR"
    annotation (Placement(transformation(extent={{-170,-190},{-150,-170}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge endStaPro
    "True when staging process terminates"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
equation
  connect(TSupSet, delT.u1)
    annotation (Line(points={{-220,-60},{-180,-60},{-180,-74},{-172,-74}},color={0,0,127}));
  connect(TRet, delT.u2)
    annotation (Line(points={{-220,-100},{-180,-100},{-180,-86},{-172,-86}},
      color={0,0,127}));
  connect(delT.y, absDelT.u)
    annotation (Line(points={{-148,-80},{-142,-80}},color={0,0,127}));
  connect(V_flow, capFlo.u)
    annotation (Line(points={{-220,-140},{-170,-140}},color={0,0,127}));
  connect(absDelT.y, capReq.u1)
    annotation (Line(points={{-118,-80},{-110,-80},{-110,-74},{-102,-74}},color={0,0,127}));
  connect(capFlo.y, capReq.u2)
    annotation (Line(points={{-146,-140},{-110,-140},{-110,-86},{-102,-86}},
      color={0,0,127}));
  connect(intScaRep.y, reqEquSta.index)
    annotation (Line(points={{-82,200},{0,200},{0,208}},color={255,127,0}));
  connect(traMatStaEqu.y, reqEquSta.u)
    annotation (Line(points={{-48,220},{-12,220}},color={0,0,127}));
  connect(reqEquSta.y, capEquSta.u1)
    annotation (Line(points={{12,220},{20,220},{20,226},{28,226}},color={0,0,127}));
  connect(capEquPar.y, capEquSta.u2)
    annotation (Line(points={{-48,160},{20,160},{20,214},{28,214}},color={0,0,127}));
  connect(capEquSta.y, capSta.u)
    annotation (Line(points={{52,220},{68,220}},color={0,0,127}));
  connect(capReq.y, movAve.u)
    annotation (Line(points={{-78,-80},{-72,-80}},color={0,0,127}));
  connect(movAve.y, hol.u)
    annotation (Line(points={{-48,-80},{-40,-80},{-40,-66},{-12,-66}},color={0,0,127}));
  connect(intScaRep.u, maxInt.y)
    annotation (Line(points={{-106,200},{-118,200}},color={255,127,0}));
  connect(idxSta.y, idxStaLesAct.u1)
    annotation (Line(points={{-158,140},{-154,140},{-154,100},{-152,100}},color={255,127,0}));
  connect(uSta, intScaRep1.u)
    annotation (Line(points={{-220,180},{-190,180},{-190,100},{-182,100}},color={255,127,0}));
  connect(intScaRep1.y, idxStaLesAct.u2)
    annotation (Line(points={{-158,100},{-156,100},{-156,92},{-152,92}},color={255,127,0}));
  connect(idxStaLesAct.y, idxStaLesActAva.u1)
    annotation (Line(points={{-128,100},{-120,100},{-120,80},{-112,80}},color={255,0,255}));
  connect(u1AvaSta, idxStaLesActAva.u2)
    annotation (Line(points={{-220,80},{-126,80},{-126,72},{-112,72}},color={255,0,255}));
  connect(idxStaLesActAva.y, idxLasTru.u1)
    annotation (Line(points={{-88,80},{-72,80}},color={255,0,255}));
  connect(idxLasTru.y, maxInt1.u2)
    annotation (Line(points={{-48,80},{-44,80},{-44,114},{-32,114}},color={255,127,0}));
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
    annotation (Line(points={{-48,220},{-20,220},{-20,180},{-12,180}},color={0,0,127}));
  connect(reqEquStaLow.y, capEquStaLow.u2)
    annotation (Line(points={{12,180},{16,180},{16,174},{28,174}},color={0,0,127}));
  connect(capEquPar.y, capEquStaLow.u1)
    annotation (Line(points={{-48,160},{20,160},{20,186},{28,186}},color={0,0,127}));
  connect(capEquStaLow.y, capStaLow.u)
    annotation (Line(points={{52,180},{68,180}},color={0,0,127}));
  connect(idxLasTru.y, minInt.u2)
    annotation (Line(points={{-48,80},{-44,80},{-44,74},{-32,74}},color={255,127,0}));
  connect(one.y, minInt.u1)
    annotation (Line(points={{-158,180},{-40,180},{-40,86},{-32,86}},color={255,127,0}));
  connect(minInt.y, intToRea.u)
    annotation (Line(points={{-8,80},{8,80}},color={255,127,0}));
  connect(capStaLow.y, setZer.u1)
    annotation (Line(points={{92,180},{100,180},{100,186},{108,186}},color={0,0,127}));
  connect(intToRea.y, setZer.u2)
    annotation (Line(points={{32,80},{100,80},{100,174},{108,174}},color={0,0,127}));
  connect(hol.y, gre.u1)
    annotation (Line(points={{12,-60},{28,-60}},color={0,0,127}));
  connect(splTimCapSta.y, gre.u2)
    annotation (Line(points={{12,-120},{14,-120},{14,-68},{28,-68}},color={0,0,127}));
  connect(capSta.y, splTimCapSta.u2)
    annotation (Line(points={{92,220},{160,220},{160,-140},{-20,-140},{-20,-126},{-12,-126}},
      color={0,0,127}));
  connect(setZer.y, splTimCapStaLow.u2)
    annotation (Line(points={{132,180},{156,180},{156,-180},{-20,-180},{-20,-166},{-12,-166}},
      color={0,0,127}));
  connect(splTimCapStaLow.y, les.u2)
    annotation (Line(points={{12,-160},{20,-160},{20,-128},{28,-128}},color={0,0,127}));
  connect(hol.y, les.u1)
    annotation (Line(points={{12,-60},{20,-60},{20,-120},{28,-120}},color={0,0,127}));
  connect(gre.y, timUp.u)
    annotation (Line(points={{52,-60},{78,-60}},color={255,0,255}));
  connect(les.y, timDow.u)
    annotation (Line(points={{52,-120},{78,-120}},color={255,0,255}));
  connect(uPlrSta, parPlrSta.u)
    annotation (Line(points={{-220,-180},{-172,-180}}, color={0,0,127}));
  connect(parPlrSta.y, splTimCapSta.u1) annotation (Line(points={{-148,-180},{-40,
          -180},{-40,-114},{-12,-114}}, color={0,0,127}));
  connect(parPlrSta.y, splTimCapStaLow.u1) annotation (Line(points={{-148,-180},
          {-40,-180},{-40,-154},{-12,-154}}, color={0,0,127}));
  connect(u1StaPro, hol.u1)
    annotation (Line(points={{-220,-20},{-40,-20},{-40,-60},{-12,-60}},color={255,0,255}));
  connect(u1StaPro, endStaPro.u)
    annotation (Line(points={{-220,-20},{-12,-20}},color={255,0,255}));
  connect(endStaPro.y, timUp.reset)
    annotation (Line(points={{12,-20},{60,-20},{60,-68},{78,-68}},color={255,0,255}));
  connect(endStaPro.y, timDow.reset)
    annotation (Line(points={{12,-20},{60,-20},{60,-128},{78,-128}},color={255,0,255}));
  connect(timUp.passed, y1Up) annotation (Line(points={{102,-68},{120,-68},{120,
          80},{220,80}}, color={255,0,255}));
  connect(timDow.passed, y1Dow) annotation (Line(points={{102,-128},{120,-128},{
          120,-80},{220,-80}}, color={255,0,255}));
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
FIXME: Add failsafe conditions.
<p>
Timers are reset to zero at the completion of every stage change.
</p>
<p>
The availability condition, which consists of staging up when
the equipment necessary to operate the current stage is unavailable,
is implemented in
<a href=\"modelica://Buildings.Templates.Plants.Controls.Utilities.StageIndex\">
Buildings.Templates.Plants.Controls.Utilities.StageIndex</a>.
</p>
<h4>
Implementation details
</h4>
<p>
A \"if\" condition is used to generate the stage up and down command as opposed
to a \"when\" condition. This means that the command remains true as long as the
condition is verified. This is necessary, for example, if no higher stage is 
available when a stage up command is triggered. Using a \"when\" condition &ndash;
which is only valid at the point in time at which the condition becomes true &ndash; 
would prevent the plant from staging when a higher stage becomes available again.
To avoid multiple consecutive stage changes, the block that receives the stage up
and down command and computes the stage index must enforce a minimum stage runtime
of <code>dtRun</code>.
</p>
</html>"));
end StageChangeCommand;
