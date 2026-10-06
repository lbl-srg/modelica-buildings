within Buildings.Templates.Plants.Controls.StagingRotation;
block EquipmentEnable "Return array of equipment to be enabled at given stage"
  parameter Real staEqu[:,:](
    each unit="1",
    each min=0,
    each max=1)
    "Staging matrix – Equipment required for each stage"
    annotation (Evaluate=true);
  parameter Integer nEquAlt=if nEqu==1 then 1 else
    max({sum({(if staEqu[i, j] > 0 and staEqu[i, j] < 1 then 1 else 0) for j in 1:nEqu}) for i in 1:nSta})
    "Number of lead/lag alternate equipment"
    annotation (Evaluate=true);
  final parameter Integer nSta=size(staEqu, 1)
    "Number of stages"
    annotation (Evaluate=true);
  final parameter Integer nEqu=size(staEqu, 2)
    "Number of equipment"
    annotation (Evaluate=true);
  final parameter Real traStaEqu[nEqu, nSta]={{staEqu[i, j] for i in 1:nSta} for j in 1:nEqu}
    "Transpose of staging matrix";
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uIdxAltSor[nEquAlt]
    "Indices of lead/lag alternate equipment sorted by increasing runtime"
    annotation (Placement(transformation(extent={{-240,60},{-200,100}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta
    "Stage index"
    annotation (Placement(transformation(extent={{-240,-20},{-200,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Ava[nEqu]
    "Equipment available signal"
    annotation (Placement(transformation(extent={{-240,-100},{-200,-60}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant traMatStaEqu[nEqu, nSta](
    final k=traStaEqu)
    "Transpose of staging matrix"
    annotation (Placement(transformation(extent={{-170,50},{-150,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1[nEqu]
    "Equipment enable command"
    annotation (Placement(transformation(extent={{200,-20},{240,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor reqEquSta[nEqu](
    each final nin=nSta)
    "Extract equipment required at given stage"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(
    final nout=nEqu)
    "Replicate signal"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Buildings.Controls.OBC.CDL.Logical.Or ena[nEqu]
    "Enable equipment required without lead/lag alternate and available or lead/lag alternate equipment to meet stage requirement"
    annotation (Placement(transformation(extent={{150,-10},{170,10}})));
  Buildings.Controls.OBC.CDL.Logical.And isReqAltAvaNee[nEqu]
    "Return true if equipment indexed as lead/lag alternate and available and needed to meet stage requirement"
    annotation (Placement(transformation(extent={{110,-10},{130,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant one(
    final k=1)
    "Constant"
    annotation (Placement(transformation(extent={{-170,10},{-150,30}})));
  Buildings.Controls.OBC.CDL.Integers.Max maxInt
    "Maximum between stage index and 1"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold greZer(
    final t=0)
    "Check if stage index is greater than zero"
    annotation (Placement(transformation(extent={{-150,-50},{-130,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    final realTrue=1,
    final realFalse=0)
    "Cast to real"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(
    final nout=nEqu)
    "Replicate signal"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply voiStaZer[nEqu]
    "Void if stage is equal to zero"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  BaseClasses.SelectSortedAvailable selSorAva(
    final nEqu=nEqu,
    final nEquAlt=nEquAlt)
    "Select lead/lag alternate units by priority order and availability"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  BaseClasses.SelectEquipmentAtStage selEquSta(
    final nEqu=nEqu)
    "Select available units at stage"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
equation
  connect(intScaRep.y, reqEquSta.index)
    annotation (Line(points={{-88,0},{-80,0},{-80,48}},
      color={255,127,0}));
  connect(traMatStaEqu.y, reqEquSta.u)
    annotation (Line(points={{-148,60},{-92,60}}, color={0,0,127}));
  connect(isReqAltAvaNee.y, ena.u1)
    annotation (Line(points={{132,0},{148,0}},color={255,0,255}));
  connect(one.y, maxInt.u1)
    annotation (Line(points={{-148,20},{-146,20},{-146,6},{-142,6}},color={255,127,0}));
  connect(uSta, maxInt.u2)
    annotation (Line(points={{-220,0},{-166,0},{-166,-6},{-142,-6}},color={255,127,0}));
  connect(maxInt.y, intScaRep.u)
    annotation (Line(points={{-118,0},{-112,0}},color={255,127,0}));
  connect(uSta, greZer.u)
    annotation (Line(points={{-220,0},{-180,0},{-180,-40},{-152,-40}},color={255,127,0}));
  connect(greZer.y, booToRea.u)
    annotation (Line(points={{-128,-40},{-122,-40}},color={255,0,255}));
  connect(booToRea.y, reaScaRep.u)
    annotation (Line(points={{-98,-40},{-92,-40}},  color={0,0,127}));
  connect(reqEquSta.y, voiStaZer.u1)
    annotation (Line(points={{-68,60},{-60,60},{-60,6},{-52,6}},      color={0,0,127}));
  connect(reaScaRep.y, voiStaZer.u2)
    annotation (Line(points={{-68,-40},{-60,-40},{-60,-6},{-52,-6}},
      color={0,0,127}));
  connect(uIdxAltSor, selSorAva.uIdxSor) annotation (Line(points={{-220,80},{50,
          80},{50,6},{58,6}},color={255,127,0}));
  connect(voiStaZer.y, selEquSta.uEquSta) annotation (Line(points={{-28,0},{8,0}},
          color={0,0,127}));
  connect(selEquSta.nAlt, selSorAva.n) annotation (Line(points={{32,4},{40,4},{
          40,0},{58,0}},  color={255,127,0}));
  connect(u1Ava, selEquSta.u1Ava) annotation (Line(points={{-220,-80},{0,-80},{
          0,-6},{8,-6}},      color={255,0,255}));
  connect(selSorAva.y1, isReqAltAvaNee.u1)
    annotation (Line(points={{82,0},{108,0}},color={255,0,255}));
  connect(selEquSta.y1AltAndAva, isReqAltAvaNee.u2) annotation (Line(points={{32,-2},
          {40,-2},{40,-16},{100,-16},{100,-8},{108,-8}}, color={255,0,255}));
  connect(selEquSta.y1ReqAndAva, ena.u2) annotation (Line(points={{32,0},{36,0},
          {36,-20},{140,-20},{140,-8},{148,-8}},     color={255,0,255}));
  connect(u1Ava, selSorAva.u1Ava) annotation (Line(points={{-220,-80},{50,-80},
          {50,-6},{58,-6}}, color={255,0,255}));
  connect(ena.y, y1)
    annotation (Line(points={{172,0},{220,0}}, color={255,0,255}));
  annotation (
    defaultComponentName="enaEqu",
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
        extent={{-200,-100},{200,100}}, grid={2,2})),
Documentation(info="<html>
<p>
This block generates the equipment enable commands based on the
active stage index <code>uSta</code>, the equipment available
signal <code>u1Ava</code> and the indices of lead/lag alternate
equipment, sorted by increasing staging runtime.
</p>
<p>
A staging matrix <code>staEqu</code> is required as a parameter.
</p>
<ul>
<li>Each row of this matrix corresponds to a given stage.</li>
<li>Each column of this matrix corresponds to a given equipment.</li>
<li>A coefficient <code>staEqu[i, j]</code> equal to <i>0</i>
means that equipment <code>j</code> shall not be enabled at
stage <code>i</code>.</li>
<li>A coefficient <code>staEqu[i, j]</code> equal to <i>1</i>
means that equipment <code>j</code> is required at stage <code>i</code>.
If equipment <code>j</code> is unavailable, stage <code>i</code> is
deemed unavailable.
</li>
<li>A coefficient <code>staEqu[i, j]</code> strictly lower than <i>1</i>
and strictly greater than <i>0</i> means that equipment <code>j</code>
may be enabled at stage <code>i</code> as a lead/lag alternate equipment.
If equipment <code>j</code> is unavailable but another lead/lag alternate
equipment is available, then the latter equipment is enabled.
Stage <code>i</code> is only deemed unavailable if all
lead/lag alternate equipment specified for stage <code>i</code>
are unavailable.
</li>
<li>
The sum of the coefficients in a given row <code>∑_j staEqu[i, j]</code>
gives the number of units required at stage <code>i</code>.
If this number cannot be achieved with the available equipment,
stage <code>i</code> is deemed unavailable.
</li>
<li>
The condition <code>∑_j staEqu[i+1, j] &ge; ∑_j staEqu[i, j]</code>
is required for all <code>i &lt; size(staEqu, 1)</code>.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
June 10, 2026, by Antoine Gautier:<br/>
Added logic to remove unavailable equipment from staging order.
Removed restriction on enable state updates.
Modularized the implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4624\">#4624</a>.
</li>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end EquipmentEnable;
