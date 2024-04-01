within Buildings.Templates.Plants.Controls.StagingRotation;
block SortRuntime
  "Sort equipment by increasing staging runtime"
  parameter Integer nin=0
    "Size of input array"
    annotation (Evaluate=true,
    Dialog(connectorSizing=true),HideResult=true);
  parameter Integer idxEquAlt[:]={i for i in 1:nin}
    "Indices of lead/lag alternate equipment"
    annotation (Evaluate=true);
  final parameter Integer nEquAlt=size(idxEquAlt, 1)
    "Number of lead/lag alternate equipment"
    annotation (Evaluate=true);
  parameter Real runTim_start[nEquAlt]={60 + i for i in 1:nEquAlt}
    "Staging runtime initial values";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Run[nin]
    "Boolean signal used to assess equipment runtime"
    annotation (Placement(transformation(extent={{-240,20},{-200,60}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Ava[nin]
    "Equipment available signal"
    annotation (Placement(transformation(extent={{-240,-60},{-200,-20}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRunTimLif[nEquAlt]
    "Lifetime runtime"
    annotation (Placement(transformation(extent={{200,60},{240,100}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRunTimSta[nEquAlt]
    "Staging runtime"
    annotation (Placement(transformation(extent={{200,20},{240,60}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yIdx[nEquAlt](
    start={i for i in 1:nEquAlt})
    "Indices of equipment sorted by increasing staging runtime"
    annotation (Placement(transformation(extent={{200,-20},{240,20}}),
      iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Logical.TimerAccumulating timRun[nEquAlt]
    "Compute staging runtime"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not off[nEquAlt]
    "Return true if equipment off"
    annotation (Placement(transformation(extent={{-130,30},{-110,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant u1Res[nEquAlt](
    each k=false) "Signal for staging runtime reset"
    annotation (Placement(transformation(extent={{-180,-110},{-160,-90}})));
  Utilities.SortWithIndices sor(
    final ascending=true,
    nin=nEquAlt)
    "Sort equipment by increasing weighted runtime"
    annotation (Placement(transformation(extent={{110,-10},{130,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal weiOffAva[nEquAlt](
    each final realTrue=1E10,
    each final realFalse=1)
    "Weight to be applied to runtime of equipment off and available"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply appWeiOffAva[nEquAlt]
    "Apply weigths to runtime of equipment off and available"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply voiRunUna[nEquAlt]
    "Void runtime of unavailable equipment"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Controls.OBC.CDL.Logical.And offAva[nEquAlt]
    "Return true if equipment off and available"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  Buildings.Controls.OBC.CDL.Logical.Not una[nEquAlt]
    "Return true if equipment unavailable"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal zerUna[nEquAlt](
    each final realTrue=0,
    each final realFalse=1)
    "Assign zero to unavailable equipment"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timUna[nEquAlt]
    "Compute time elapsed since equipment is unavailable"
    annotation (Placement(transformation(extent={{-50,-90},{-30,-70}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addWei[nEquAlt](
    each final p=1E20)
    "Add weight"
    annotation (Placement(transformation(extent={{10,-90},{30,-70}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter opp[nEquAlt](
    each final k=- 1)
    "Take opposite value"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Add addWeiUna[nEquAlt]
    "Add weight to unavailable equipment"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply voiWeiAva[nEquAlt]
    "Void weight of available equipment"
    annotation (Placement(transformation(extent={{48,-90},{68,-70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal zerAva[nEquAlt](
    each final realTrue=0,
    each final realFalse=1)
    "Assign zero to available equipment"
    annotation (Placement(transformation(extent={{-50,-130},{-30,-110}})));
  Buildings.Controls.OBC.CDL.Logical.TimerAccumulating timRunLif[nEquAlt]
    "Compute lifetime runtime"
    annotation (Placement(transformation(extent={{-50,70},{-30,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fal[nEquAlt](
    each final k=false)
    "Constant"
    annotation (Placement(transformation(extent={{-180,90},{-160,110}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal u1RunEquAlt(
    final nin=nin,
    final nout=nEquAlt,
    final extract=idxEquAlt)
    "Extract signal for lead/lag alternate equipment only"
    annotation (Placement(transformation(extent={{-180,30},{-160,50}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal u1AvaEquAlt(
    final nin=nin,
    final nout=nEquAlt,
    final extract=idxEquAlt)
    "Extract signal for lead/lag alternate equipment only"
    annotation (Placement(transformation(extent={{-180,-50},{-160,-30}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerExtractor resIdxInp[nEquAlt](
    each final nin=nEquAlt)
    "Restore indices consistent with input vectors"
    annotation (Placement(transformation(extent={{170,-10},{190,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idxEquAltMat[nEquAlt, nEquAlt](
    final k={idxEquAlt for i in 1:nEquAlt})
    "Indices of lead/lag alternate equipment repeated nEquAlt times"
    annotation (Placement(transformation(extent={{110,-50},{130,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant runTimSta[nEquAlt](
    final k=runTim_start)
    "Staging runtime initial values"
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));
  Buildings.Controls.OBC.CDL.Reals.Max iniRunTim[nEquAlt]
    "Fix runtime until it exceeds the initial value"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
equation
  connect(u1Res.y, timRun.reset)
    annotation (Line(points={{-158,-100},{-120,-100},{-120,-8},{-92,-8}},color={255,0,255}));
  connect(weiOffAva.y, appWeiOffAva.u1)
    annotation (Line(points={{-28,40},{-26,40},{-26,6},{-12,6}},color={0,0,127}));
  connect(off.y, offAva.u1)
    annotation (Line(points={{-108,40},{-92,40}},color={255,0,255}));
  connect(offAva.y, weiOffAva.u)
    annotation (Line(points={{-68,40},{-52,40}},color={255,0,255}));
  connect(appWeiOffAva.y, voiRunUna.u1)
    annotation (Line(points={{12,0},{20,0},{20,6},{28,6}},color={0,0,127}));
  connect(zerUna.y, voiRunUna.u2)
    annotation (Line(points={{-28,-40},{20,-40},{20,-6},{28,-6}},color={0,0,127}));
  connect(una.y, timUna.u)
    annotation (Line(points={{-68,-40},{-60,-40},{-60,-80},{-52,-80}},color={255,0,255}));
  connect(una.y, zerUna.u)
    annotation (Line(points={{-68,-40},{-52,-40}},color={255,0,255}));
  connect(timUna.y, opp.u)
    annotation (Line(points={{-28,-80},{-22,-80}},color={0,0,127}));
  connect(opp.y, addWei.u)
    annotation (Line(points={{2,-80},{8,-80}},color={0,0,127}));
  connect(addWeiUna.y, sor.u)
    annotation (Line(points={{92,0},{108,0}},color={0,0,127}));
  connect(voiRunUna.y, addWeiUna.u1)
    annotation (Line(points={{52,0},{54,0},{54,6},{68,6}},color={0,0,127}));
  connect(voiWeiAva.y, addWeiUna.u2)
    annotation (Line(points={{70,-80},{80,-80},{80,-20},{60,-20},{60,-6},{68,-6}},
      color={0,0,127}));
  connect(addWei.y, voiWeiAva.u1)
    annotation (Line(points={{32,-80},{40,-80},{40,-74},{46,-74}},color={0,0,127}));
  connect(zerAva.y, voiWeiAva.u2)
    annotation (Line(points={{-28,-120},{40,-120},{40,-86},{46,-86}},color={0,0,127}));
  connect(timRunLif.y, yRunTimLif)
    annotation (Line(points={{-28,80},{220,80}},color={0,0,127}));
  connect(fal.y, timRunLif.reset)
    annotation (Line(points={{-158,100},{-60,100},{-60,72},{-52,72}},color={255,0,255}));
  connect(u1Run, u1RunEquAlt.u)
    annotation (Line(points={{-220,40},{-182,40}},color={255,0,255}));
  connect(u1RunEquAlt.y, off.u)
    annotation (Line(points={{-158,40},{-132,40}},color={255,0,255}));
  connect(u1RunEquAlt.y, timRunLif.u)
    annotation (Line(points={{-158,40},{-140,40},{-140,80},{-52,80}},color={255,0,255}));
  connect(u1RunEquAlt.y, timRun.u)
    annotation (Line(points={{-158,40},{-140,40},{-140,0},{-92,0}},color={255,0,255}));
  connect(u1Ava, u1AvaEquAlt.u)
    annotation (Line(points={{-220,-40},{-182,-40}},color={255,0,255}));
  connect(u1AvaEquAlt.y, una.u)
    annotation (Line(points={{-158,-40},{-92,-40}},color={255,0,255}));
  connect(u1AvaEquAlt.y, zerAva.u)
    annotation (Line(points={{-158,-40},{-100,-40},{-100,-120},{-52,-120}},color={255,0,255}));
  connect(u1AvaEquAlt.y, offAva.u2)
    annotation (Line(points={{-158,-40},{-100,-40},{-100,32},{-92,32}},color={255,0,255}));
  connect(idxEquAltMat.y, resIdxInp.u)
    annotation (Line(points={{132,-40},{160,-40},{160,0},{168,0}},color={255,127,0}));
  connect(sor.yIdx, resIdxInp.index)
    annotation (Line(points={{132,-6},{164,-6},{164,-16},{180,-16},{180,-12}},
      color={255,127,0}));
  connect(resIdxInp.y, yIdx)
    annotation (Line(points={{192,0},{220,0}},color={255,127,0}));
  connect(runTimSta.y, iniRunTim.u1)
    annotation (Line(points={{-78,120},{-66,120},{-66,6},{-52,6}},color={0,0,127}));
  connect(timRun.y, iniRunTim.u2)
    annotation (Line(points={{-68,0},{-60,0},{-60,-6},{-52,-6}},color={0,0,127}));
  connect(iniRunTim.y, appWeiOffAva.u2)
    annotation (Line(points={{-28,0},{-20,0},{-20,-6},{-12,-6}},color={0,0,127}));
  connect(timRun.y, yRunTimSta)
    annotation (Line(points={{-68,0},{-60,0},{-60,20},{180,20},{180,40},{220,40}},
      color={0,0,127}));
  annotation (
    defaultComponentName="sorRunTim",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
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
        extent={{-200,-160},{200,160}})),
    Documentation(
      info="<html>
<p>
This block implements the rotation logic for identical parallel
staged equipment that are lead/lag alternated.
</p>
<p>
Two runtime points are defined for each equipment.
The Lifetime Runtime is the cumulative runtime of the equipment
since equipment start-up. This point is not readily resettable by operators.
Lifetime Runtime should be stored to a software point on the control
system server so the recorded value is not lost due to controller reset,
loss of power, programming file update, etc.
The Staging Runtime is an operator resettable runtime point that stores
cumulative runtime since the last operator reset.
</p>
<p>
In the case of available equipment,
when more than one equipment is off or more than one is on,
the equipment with the most operating hours as determined by
Staging Runtime is made the last stage equipment and the one
with the least number of hours is made the lead stage equipment.
</p>
<p>
In the case of unavailable equipment,
the equipment that alarmed most recently is sent to the last position.
The equipment in alarm automatically moves up in the staging order
only if another equipment goes into alarm.
</p>
<h4>Staging runtime initialization</h4>
<p>
When the controller is initialized, the choice of the first equipment to run
is random since all runtimes are equal to zero.
So, before this first equipment reports status, all equipment will be
considered off and only this first equipment will increase runtime and be
queued in the staging order.
At next stage change, another equipment will then be staged on instead,
resulting in the first running equipment being \"hot swapped\".
To avoid this behavior, the vector parameter <code>runTim_start</code> is used
to initialize the staging runtime, which will be fixed at this parameter
value until it becomes higher.
The parameter <code>runTim_start</code> should be set to a vector of
strictly increasing values, where the minimum value is greater than
the time needed for the equipment to report status.
</p>
<h4>Implementation details</h4>
<p>
Weighting/sorting logic to be explained.
</p>
<p>
To facilitate integration into the plant controller, the input vectors
cover the full set of equipment, including equipment that may not be
lead/lag alternate.
The ouput vectors cover only the subset of lead/lag alternate equipment, 
and the vector of sorted equipment provides indices with respect
to the input vectors (full set of equipment).
</p>
<p>
The staging runtime and the time elapsed since an equipment became unavailable
are both computed from Boolean signals (<code>u1Run</code> and <code>u1Ava</code>).
These are discrete-time, piecewise constant variables,
which is why the caveat in the documentation of 
<a href=\"modelica://Buildings.Templates.Plants.Controls.Utilities.SortWithIndices\">
Buildings.Templates.Plants.Controls.Utilities.SortWithIndices</a>
for purely continuous time-varying variables does not apply here.
Therefore, no sampling is performed before sorting the equipment runtimes.
</p>
</html>", revisions="<html>
<ul>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end SortRuntime;
