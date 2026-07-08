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
  parameter Real runTim_start[nEquAlt]=fill(0, nEquAlt)
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
  Buildings.Controls.OBC.CDL.Reals.Sort sor(
    final ascending=true,
    nin=nEquAlt)
    "Sort equipment by increasing weighted runtime"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal weiOffAva[nEquAlt](
    each final realTrue=1E10, each final realFalse=0)
    "Weight to be applied to runtime of equipment off and available"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Buildings.Controls.OBC.CDL.Reals.Add      appWeiOffAva[nEquAlt]
    "Apply weights to runtime of equipment off and available"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply clrRunUna[nEquAlt]
    "Clear runtime of unavailable equipment"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Buildings.Controls.OBC.CDL.Logical.And offAva[nEquAlt]
    "Return true if equipment off and available"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  Buildings.Controls.OBC.CDL.Logical.Not una[nEquAlt]
    "Return true if equipment unavailable"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal zerUna[nEquAlt](
    each final realTrue=0,
    each final realFalse=1) "Assign zero to unavailable equipment"
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
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Buildings.Controls.OBC.CDL.Logical.TimerAccumulating timRunLif[nEquAlt]
    "Compute lifetime runtime"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
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
    annotation (Placement(transformation(extent={{120,50},{140,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant runTimSta[nEquAlt](
    final k=runTim_start)
    "Staging runtime initial values"
    annotation (Placement(transformation(extent={{-90,110},{-70,130}})));
  Buildings.Controls.OBC.CDL.Reals.Add iniRunTim[nEquAlt]
    "Add runtime initial value"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Controls.OBC.CDL.Reals.Add iniRunTimLif[nEquAlt]
    "Add runtime initial value"
    annotation (Placement(transformation(extent={{-50,70},{-30,90}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal zerAva[nEquAlt](
    each final realTrue=0,
    each final realFalse=1)
    "Assign zero to available equipment"
    annotation (Placement(transformation(extent={{-50,-130},{-30,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply clrRunAva[nEquAlt]
    "Clear runtime of available equipment"
    annotation (Placement(transformation(extent={{50,-90},{70,-70}})));
equation
  connect(u1Res.y, timRun.reset)
    annotation (Line(points={{-158,-100},{-120,-100},{-120,-8},{-92,-8}},color={255,0,255}));
  connect(weiOffAva.y, appWeiOffAva.u1)
    annotation (Line(points={{-28,40},{-20,40},{-20,6},{8,6}},  color={0,0,127}));
  connect(off.y, offAva.u1)
    annotation (Line(points={{-108,40},{-92,40}},color={255,0,255}));
  connect(offAva.y, weiOffAva.u)
    annotation (Line(points={{-68,40},{-52,40}},color={255,0,255}));
  connect(appWeiOffAva.y,clrRunUna. u1)
    annotation (Line(points={{32,0},{40,0},{40,6},{48,6}},color={0,0,127}));
  connect(zerUna.y,clrRunUna. u2)
    annotation (Line(points={{-28,-40},{40,-40},{40,-6},{48,-6}},color={0,0,127}));
  connect(una.y, timUna.u)
    annotation (Line(points={{-68,-40},{-60,-40},{-60,-80},{-52,-80}},color={255,0,255}));
  connect(una.y, zerUna.u)
    annotation (Line(points={{-68,-40},{-52,-40}},color={255,0,255}));
  connect(timUna.y, opp.u)
    annotation (Line(points={{-28,-80},{-22,-80}},color={0,0,127}));
  connect(opp.y, addWei.u)
    annotation (Line(points={{2,-80},{8,-80}},color={0,0,127}));
  connect(addWeiUna.y, sor.u)
    annotation (Line(points={{112,0},{118,0}}, color={0,0,127}));
  connect(clrRunUna.y, addWeiUna.u1)
    annotation (Line(points={{72,0},{80,0},{80,6},{88,6}},color={0,0,127}));
  connect(fal.y, timRunLif.reset)
    annotation (Line(points={{-158,100},{-120,100},{-120,72},{-92,72}}, color={255,0,255}));
  connect(u1Run, u1RunEquAlt.u)
    annotation (Line(points={{-220,40},{-182,40}},color={255,0,255}));
  connect(u1RunEquAlt.y, off.u)
    annotation (Line(points={{-158,40},{-132,40}},color={255,0,255}));
  connect(u1RunEquAlt.y, timRunLif.u)
    annotation (Line(points={{-158,40},{-140,40},{-140,80},{-92,80}},color={255,0,255}));
  connect(u1RunEquAlt.y, timRun.u)
    annotation (Line(points={{-158,40},{-140,40},{-140,0},{-92,0}},color={255,0,255}));
  connect(u1Ava, u1AvaEquAlt.u)
    annotation (Line(points={{-220,-40},{-182,-40}},color={255,0,255}));
  connect(u1AvaEquAlt.y, una.u)
    annotation (Line(points={{-158,-40},{-92,-40}},color={255,0,255}));
  connect(u1AvaEquAlt.y, offAva.u2)
    annotation (Line(points={{-158,-40},{-100,-40},{-100,32},{-92,32}},color={255,0,255}));
  connect(idxEquAltMat.y, resIdxInp.u)
    annotation (Line(points={{142,60},{160,60},{160,0},{168,0}},  color={255,127,0}));
  connect(sor.yIdx, resIdxInp.index)
    annotation (Line(points={{142,-6},{160,-6},{160,-20},{180,-20},{180,-12}},
      color={255,127,0}));
  connect(resIdxInp.y, yIdx)
    annotation (Line(points={{192,0},{220,0}},color={255,127,0}));
  connect(runTimSta.y, iniRunTim.u1)
    annotation (Line(points={{-68,120},{-60,120},{-60,6},{-52,6}},color={0,0,127}));
  connect(timRun.y, iniRunTim.u2)
    annotation (Line(points={{-68,0},{-64,0},{-64,-6},{-52,-6}},color={0,0,127}));
  connect(iniRunTim.y, appWeiOffAva.u2)
    annotation (Line(points={{-28,0},{0,0},{0,-6},{8,-6}},      color={0,0,127}));
  connect(iniRunTim.y, yRunTimSta) annotation (Line(points={{-28,0},{0,0},{0,40},
          {220,40}},                           color={0,0,127}));
  connect(iniRunTimLif.y, yRunTimLif)
    annotation (Line(points={{-28,80},{220,80}}, color={0,0,127}));
  connect(timRunLif.y, iniRunTimLif.u2) annotation (Line(points={{-68,80},{-64,80},
          {-64,74},{-52,74}}, color={0,0,127}));
  connect(runTimSta.y, iniRunTimLif.u1) annotation (Line(points={{-68,120},{-60,
          120},{-60,86},{-52,86}}, color={0,0,127}));
  connect(u1AvaEquAlt.y, zerAva.u) annotation (Line(points={{-158,-40},{-100,-40},
          {-100,-120},{-52,-120}}, color={255,0,255}));
  connect(clrRunAva.y, addWeiUna.u2) annotation (Line(points={{72,-80},{80,-80},
          {80,-6},{88,-6}}, color={0,0,127}));
  connect(addWei.y, clrRunAva.u1) annotation (Line(points={{32,-80},{40,-80},{40,
          -74},{48,-74}}, color={0,0,127}));
  connect(zerAva.y, clrRunAva.u2) annotation (Line(points={{-28,-120},{40,-120},
          {40,-86},{48,-86}}, color={0,0,127}));
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
        extent={{-200,-140},{200,140}},
        grid={2,2})),
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
<p><i>
Note: This strategy effectively makes it such that equipment are not
\"hot swapped\", e.g., a pump would not be started and another stopped
during operation just for runtime equalization.
</p></i>
<p>
In the case of unavailable equipment,
the equipment that alarmed most recently is sent to the last position.
The equipment in alarm automatically moves up in the staging order
only if another equipment goes into alarm.
</p>
<h4>Details</h4>
<p>
The sorting logic is implemented using the following method.
</p>
<ul>
<li>
If a unit is on and available, its staging runtime is used as is.
</li>
<li>
If a unit is off and available, its staging runtime is increased
by <i>1E10</i>&nbsp;s.
</li>
<li>
If a unit is unavailable, its staging runtime is replaced by
<i>1E20</i>&nbsp;s minus the time elapsed since it became
unavailable.
</li>
<li>
A unique instance of the sorting block is then used to order
the different units.
</li>
</ul>
<p>
This is effectively the same as sorting the units within
the three following subsets: units that are on and available,
units that are off and available, units that are unavailable.
In particular, the order index of a given unit remains unchanged
if it is the only element of a given subset.
Note that the staging runtime and the time elapsed since an equipment became unavailable
are both computed from Boolean signals (<code>u1Run</code> and <code>u1Ava</code>).
These are discrete-time, piecewise constant variables,
which is why the caveat in the documentation of
<a href=\"modelica://Buildings.Controls.OBC.CDL.Reals.Sort\">
Buildings.Controls.OBC.CDL.Reals.Sort</a>
for purely continuous time-varying variables does not apply here.
Therefore, no sampling is performed before sorting the equipment runtimes.
</p>
<p>
To facilitate integration into the plant controller, the input vectors
cover the full set of equipment, including equipment that may not be
lead/lag alternate.
The output vectors cover only the subset of lead/lag alternate equipment,
and the vector of sorted equipment provides indices with respect
to the input vectors (full set of equipment).
</p>
</html>", revisions="<html>
<ul>
<li>
July 10, 2026, by Antoine Gautier:<br/>
Corrected the runtime replacement value for staged-off equipment.
</li>
<li>
June 10, 2026, by Antoine Gautier:<br/>
Corrected runtime weighting for unavailable units.
Updated handling and default value of runtime initialization.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4624\">#4624</a>.
</li>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end SortRuntime;
