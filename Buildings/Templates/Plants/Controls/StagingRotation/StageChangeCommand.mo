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
    final unit="1")=0.9
    "Staging part load ratio"
    annotation (Dialog(enable=not have_inpPlrSta));
  final parameter Real traStaEqu[nEqu, nSta]={{staEqu[i, j] for i in 1:nSta} for j in 1:nEqu}
    "Transpose of staging matrix";
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
    displayUnit="degC") "Return temperature used to compute required capacity"
    annotation (Placement(transformation(extent={{-240,-120},{-200,-80}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(
    final unit="K",
    displayUnit="degC")
    "Active supply temperature setpoint used to compute required capacity"
    annotation (Placement(transformation(extent={{-240,-80},{-200,-40}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput V_flow(
    final unit="m3/s") "Volume flow rate used to compute required capacity"
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
  Buildings.Controls.OBC.CDL.Reals.Greater gre(h=1E-4*min(capEqu))
    "Compare OPLR to SPLR (hysteresis is to avoid chattering with some simulators)"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Templates.Plants.Controls.Utilities.TimerWithReset timUp(
    final t=dtRun)
    "Timer"
    annotation (Placement(transformation(extent={{110,-70},{130,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Less les(h=1E-4*min(capEqu))
    "Compare OPLR to SPLR (hysteresis is to avoid chattering with some simulators)"
    annotation (Placement(transformation(extent={{60,-130},{80,-110}})));
  Buildings.Templates.Plants.Controls.Utilities.TimerWithReset timDow(
    final t=dtRun)
    "Timer"
    annotation (Placement(transformation(extent={{110,-130},{130,-110}})));
  Utilities.HoldReal hol(final dtHol=dtRun)
    "Hold value of required capacity at stage change"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
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
    annotation (Placement(transformation(extent={{20,-130},{40,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply splTimCapStaLow
    "SPLR times capacity of next available lower stage"
    annotation (Placement(transformation(extent={{20,-170},{40,-150}})));
  Utilities.PlaceholderReal parPlrSta(
    final have_inp=have_inpPlrSta,
    final have_inpPh=false,
    final u_internal=plrSta) "Parameter value for SPLR"
    annotation (Placement(transformation(extent={{-160,-190},{-140,-170}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge endStaPro
    "True when staging process terminates"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  LoadAverage capReq(
    final cp_default=cp_default,
    final rho_default=rho_default,
    final dtMea=dtMea) "Compute required capacity"
    annotation (Placement(transformation(extent={{-160,-110},{-140,-90}})));
equation
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
    annotation (Line(points={{42,-60},{58,-60}},color={0,0,127}));
  connect(splTimCapSta.y, gre.u2)
    annotation (Line(points={{42,-120},{44,-120},{44,-68},{58,-68}},color={0,0,127}));
  connect(capSta.y, splTimCapSta.u2)
    annotation (Line(points={{92,220},{184,220},{184,-140},{10,-140},{10,-126},
          {18,-126}},
      color={0,0,127}));
  connect(setZer.y, splTimCapStaLow.u2)
    annotation (Line(points={{132,180},{180,180},{180,-180},{10,-180},{10,-166},
          {18,-166}},
      color={0,0,127}));
  connect(splTimCapStaLow.y, les.u2)
    annotation (Line(points={{42,-160},{50,-160},{50,-128},{58,-128}},color={0,0,127}));
  connect(hol.y, les.u1)
    annotation (Line(points={{42,-60},{50,-60},{50,-120},{58,-120}},color={0,0,127}));
  connect(gre.y, timUp.u)
    annotation (Line(points={{82,-60},{108,-60}},
                                                color={255,0,255}));
  connect(les.y, timDow.u)
    annotation (Line(points={{82,-120},{108,-120}},
                                                  color={255,0,255}));
  connect(uPlrSta, parPlrSta.u)
    annotation (Line(points={{-220,-180},{-162,-180}}, color={0,0,127}));
  connect(parPlrSta.y, splTimCapSta.u1) annotation (Line(points={{-138,-180},{0,
          -180},{0,-114},{18,-114}},    color={0,0,127}));
  connect(parPlrSta.y, splTimCapStaLow.u1) annotation (Line(points={{-138,-180},
          {0,-180},{0,-154},{18,-154}},      color={0,0,127}));
  connect(u1StaPro, hol.u1)
    annotation (Line(points={{-220,-20},{0,-20},{0,-60},{18,-60}},     color={255,0,255}));
  connect(u1StaPro, endStaPro.u)
    annotation (Line(points={{-220,-20},{18,-20}}, color={255,0,255}));
  connect(endStaPro.y, timUp.reset)
    annotation (Line(points={{42,-20},{90,-20},{90,-68},{108,-68}},
                                                                  color={255,0,255}));
  connect(endStaPro.y, timDow.reset)
    annotation (Line(points={{42,-20},{90,-20},{90,-128},{108,-128}},
                                                                    color={255,0,255}));
  connect(timUp.passed, y1Up) annotation (Line(points={{132,-68},{140,-68},{140,
          80},{220,80}}, color={255,0,255}));
  connect(timDow.passed, y1Dow) annotation (Line(points={{132,-128},{140,-128},
          {140,-80},{220,-80}},color={255,0,255}));
  connect(TSupSet, capReq.TSupSet) annotation (Line(points={{-220,-60},{-180,
          -60},{-180,-94},{-162,-94}}, color={0,0,127}));
  connect(TRet, capReq.TRet)
    annotation (Line(points={{-220,-100},{-162,-100}}, color={0,0,127}));
  connect(V_flow, capReq.V_flow) annotation (Line(points={{-220,-140},{-180,
          -140},{-180,-106},{-162,-106}}, color={0,0,127}));
  connect(capReq.QReq_flow, hol.u) annotation (Line(points={{-138,-100},{0,-100},
          {0,-66},{18,-66}}, color={0,0,127}));
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
Availability Condition: The equipment necessary to operate the 
current stage is unavailable. 
The availability condition is not subject to the minimum stage runtime requirement.
(This condition is implemented in
<a href=\"modelica://Buildings.Templates.Plants.Controls.Utilities.StageIndex\">
Buildings.Templates.Plants.Controls.Utilities.StageIndex</a>.)
</li>
<li>
Efficiency Condition: Current stage <i>OPLR &gt; plrSta</i> for a duration of <code>dtRun</code>.
</li>
</ul>
<p>
A stage down command is triggered if the following is true:
</p>
<ul>
<li>
Next available lower stage <i>OPLR &lt; plrSta</i> for a duration of <code>dtRun</code>.
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
Refactored using <code>LoadAverage</code> block.
</li>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end StageChangeCommand;
