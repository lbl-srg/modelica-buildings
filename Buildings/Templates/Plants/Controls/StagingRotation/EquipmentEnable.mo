within Buildings.Templates.Plants.Controls.StagingRotation;
block EquipmentEnable
  "Return array of equipment to be enabled at given stage"
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
    annotation (Placement(transformation(extent={{-260,80},{-220,120}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta
    "Stage index"
    annotation (Placement(transformation(extent={{-260,-20},{-220,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Ava[nEqu]
    "Equipment available signal"
    annotation (Placement(transformation(extent={{-260,-100},{-220,-60}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant traMatStaEqu[nEqu, nSta](
    final k=traStaEqu)
    "Transpose of staging matrix"
    annotation (Placement(transformation(extent={{-190,70},{-170,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1[nEqu]
    "Equipment enable command"
    annotation (Placement(transformation(extent={{220,-20},{260,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor reqEquSta[nEqu](
    each final nin=nSta)
    "Extract equipment required at given stage"
    annotation (Placement(transformation(extent={{-160,70},{-140,90}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(
    final nout=nEqu)
    "Replicate signal"
    annotation (Placement(transformation(extent={{-130,-10},{-110,10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum nEquStaRea(
    nin=nEqu)
    "Return the number of equipment required"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold isReq[nEqu](
    each final t=0.99)
    "Return true if equipment required without lead/lag alternate"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Logical.And isReqAva[nEqu]
    "Return true if equipment required without lead/lag alternate and available"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold isReqPosAlt[nEqu](
      each final t=1E-4)
    "Return true if equipment required (with or without lead/lag alternate)"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold isNotReqNoAlt[nEqu](
      each final t=0.9999)
    "Return true if equipment not required or required with lead/lag alternate"
    annotation (Placement(transformation(extent={{-60,-18},{-40,2}})));
  Buildings.Controls.OBC.CDL.Logical.And isReqAlt[nEqu]
    "Return true if lead/lag alternate equipment required"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Logical.Or ena[nEqu]
    "Enable equipment required without lead/lag alternate and available or lead/lag alternate equipment to meet stage requirement"
    annotation (Placement(transformation(extent={{130,-10},{150,10}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger nEquSta
    "Number of equipment required"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Buildings.Controls.OBC.CDL.Integers.Subtract nAltReq
    "Number of lead/lag alternate equipment to run to meet stage requirement"
    annotation (Placement(transformation(extent={{32,30},{52,50}})));
  Buildings.Controls.OBC.CDL.Logical.And isReqAltAvaNee[nEqu]
    "Return true if equipment required with lead/lag alternate and available and needed to meet stage requirement"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Integers.Change cha
    "Detect stage index change"
    annotation (Placement(transformation(extent={{50,-70},{70,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Pre y1Pre[nEqu]
    "Left limit of signal in discrete time"
    annotation (Placement(transformation(extent={{200,-70},{180,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi[nEqu]
    "Switch to newly computed value at stage change"
    annotation (Placement(transformation(extent={{180,-10},{200,10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep(
    final nout=nEqu)
    "Replicate signal"
    annotation (Placement(transformation(extent={{130,-70},{150,-50}})));
  Utilities.CountTrue nReq(
    nin=nEqu)
    "Count the number of required equipment without lead/lag alternate, not necessarily available"
    annotation (Placement(transformation(extent={{-10,24},{10,44}})));
  Utilities.CountTrue nEnaAvaPre(
    nin=nEqu)
    "Count the number of previously enabled equipment that are available"
    annotation (Placement(transformation(extent={{120,-110},{100,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Less intLes
    "Compare to required number of equipment"
    annotation (Placement(transformation(extent={{50,-110},{70,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Or swiEna
    "Evaluate condition to switch to newly computed enable signal"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And isEnaPreAva[nEqu]
    "Return true if equipment previously enabled and available"
    annotation (Placement(transformation(extent={{150,-110},{130,-90}})));
  Utilities.TrueArrayConditional truArrCon(
    final nout=nEqu, nin=nEquAlt)
    "Generate array of size nEqu with nAltReq true elements at uIdxAltSor indices "
    annotation (Placement(transformation(extent={{70,30},{90,50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant one(
    final k=1)
    "Constant"
    annotation (Placement(transformation(extent={{-190,10},{-170,30}})));
  Buildings.Controls.OBC.CDL.Integers.Max maxInt
    "Maximum between stage index and 1"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold greZer(
    final t=0)
    "Check if stage index is greater than zero"
    annotation (Placement(transformation(extent={{-170,-50},{-150,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    final realTrue=1,
    final realFalse=0)
    "Cast to real"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(
    final nout=nEqu)
    "Replicate signal"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply voiStaZer[nEqu]
    "Void if stage is equal to zero"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger avaInt[nEqu]
    "Cast available signal to integer"
    annotation (Placement(transformation(extent={{-190,110},{-170,130}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerVectorReplicator avaIntAltRep(nin=
        nEqu, nout=nEquAlt) "Replicate to support reordering at next step"
    annotation (Placement(transformation(extent={{-150,110},{-130,130}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerExtractor avaIntIdxEquAlt[nEquAlt](
      each final nin=nEqu)
    "Available signals of lead/lag alternate equipment reordered based on idxEquAlt"
    annotation (Placement(transformation(extent={{-110,110},{-90,130}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply voiUna[nEquAlt]
    "Void unavailable units"
    annotation (Placement(transformation(extent={{30,100},{50,120}})));
equation
  connect(intScaRep.y, reqEquSta.index)
    annotation (Line(points={{-108,0},{-100,0},{-100,60},{-150,60},{-150,68}},
      color={255,127,0}));
  connect(traMatStaEqu.y, reqEquSta.u)
    annotation (Line(points={{-168,80},{-162,80}},color={0,0,127}));
  connect(isReq.y, isReqAva.u1)
    annotation (Line(points={{-38,-40},{-12,-40}},color={255,0,255}));
  connect(u1Ava, isReqAva.u2)
    annotation (Line(points={{-240,-80},{-20,-80},{-20,-48},{-12,-48}},color={255,0,255}));
  connect(isReqAva.y, ena.u2)
    annotation (Line(points={{12,-40},{124,-40},{124,-8},{128,-8}},color={255,0,255}));
  connect(nEquStaRea.y, nEquSta.u)
    annotation (Line(points={{-38,80},{-12,80}},color={0,0,127}));
  connect(nEquSta.y, nAltReq.u1)
    annotation (Line(points={{12,80},{20,80},{20,46},{30,46}},color={255,127,0}));
  connect(isReqAlt.y, isReqAltAvaNee.u2) annotation (Line(points={{12,0},{80,0},
    {80,-8},{98,-8}}, color={255,0,255}));
  connect(isReqAltAvaNee.y, ena.u1)
    annotation (Line(points={{122,0},{128,0}},color={255,0,255}));
  connect(uSta, cha.u)
    annotation (Line(points={{-240,0},{-200,0},{-200,-60},{48,-60}},color={255,127,0}));
  connect(logSwi.y, y1)
    annotation (Line(points={{202,0},{240,0}},color={255,0,255}));
  connect(y1, y1Pre.u)
    annotation (Line(points={{240,0},{210,0},{210,-60},{202,-60}},color={255,0,255}));
  connect(y1Pre.y, logSwi.u3)
    annotation (Line(points={{178,-60},{170,-60},{170,-8},{178,-8}},color={255,0,255}));
  connect(ena.y, logSwi.u1)
    annotation (Line(points={{152,0},{158,0},{158,8},{178,8}},color={255,0,255}));
  connect(booScaRep.y, logSwi.u2)
    annotation (Line(points={{152,-60},{164,-60},{164,0},{178,0}},color={255,0,255}));
  connect(nReq.y, nAltReq.u2)
    annotation (Line(points={{12,34},{30,34}},color={255,127,0}));
  connect(isReq.y, nReq.u1)
    annotation (Line(points={{-38,-40},{-20,-40},{-20,34},{-12,34}},
                                                                  color={255,0,255}));
  connect(nEnaAvaPre.y, intLes.u1)
    annotation (Line(points={{98,-100},{90,-100},{90,-120},{40,-120},{40,-100},
          {48,-100}},
      color={255,127,0}));
  connect(nEquSta.y, intLes.u2)
    annotation (Line(points={{12,80},{20,80},{20,-108},{48,-108}},color={255,127,0}));
  connect(swiEna.y, booScaRep.u)
    annotation (Line(points={{122,-60},{128,-60}},color={255,0,255}));
  connect(cha.y, swiEna.u1)
    annotation (Line(points={{72,-60},{98,-60}},color={255,0,255}));
  connect(intLes.y, swiEna.u2)
    annotation (Line(points={{72,-100},{80,-100},{80,-68},{98,-68}},color={255,0,255}));
  connect(isEnaPreAva.y, nEnaAvaPre.u1)
    annotation (Line(points={{128,-100},{122,-100}},color={255,0,255}));
  connect(y1Pre.y, isEnaPreAva.u2)
    annotation (Line(points={{178,-60},{170,-60},{170,-108},{152,-108}},color={255,0,255}));
  connect(u1Ava, isEnaPreAva.u1)
    annotation (Line(points={{-240,-80},{160,-80},{160,-100},{152,-100}},color={255,0,255}));
  connect(nAltReq.y, truArrCon.u)
    annotation (Line(points={{54,40},{68,40}},color={255,127,0}));
  connect(truArrCon.y1, isReqAltAvaNee.u1)
    annotation (Line(points={{92,40},{94,40},{94,0},{98,0}},
      color={255,0,255}));
  connect(one.y, maxInt.u1)
    annotation (Line(points={{-168,20},{-166,20},{-166,6},{-162,6}},color={255,127,0}));
  connect(uSta, maxInt.u2)
    annotation (Line(points={{-240,0},{-186,0},{-186,-6},{-162,-6}},color={255,127,0}));
  connect(maxInt.y, intScaRep.u)
    annotation (Line(points={{-138,0},{-132,0}},color={255,127,0}));
  connect(uSta, greZer.u)
    annotation (Line(points={{-240,0},{-200,0},{-200,-40},{-172,-40}},color={255,127,0}));
  connect(greZer.y, booToRea.u)
    annotation (Line(points={{-148,-40},{-142,-40}},color={255,0,255}));
  connect(booToRea.y, reaScaRep.u)
    annotation (Line(points={{-118,-40},{-112,-40}},color={0,0,127}));
  connect(reqEquSta.y, voiStaZer.u1)
    annotation (Line(points={{-138,80},{-120,80},{-120,86},{-102,86}},color={0,0,127}));
  connect(reaScaRep.y, voiStaZer.u2)
    annotation (Line(points={{-88,-40},{-80,-40},{-80,64},{-110,64},{-110,74},{-102,74}},
      color={0,0,127}));
  connect(voiStaZer.y, nEquStaRea.u)
    annotation (Line(points={{-78,80},{-62,80}},color={0,0,127}));
  connect(voiStaZer.y, isReqPosAlt.u)
    annotation (Line(points={{-78,80},{-70,80},{-70,20},{-62,20}},color={0,0,127}));
  connect(voiStaZer.y, isNotReqNoAlt.u)
    annotation (Line(points={{-78,80},{-70,80},{-70,-8},{-62,-8}},
                                                                color={0,0,127}));
  connect(voiStaZer.y, isReq.u)
    annotation (Line(points={{-78,80},{-70,80},{-70,-40},{-62,-40}},color={0,0,127}));
  connect(u1Ava, avaInt.u) annotation (Line(points={{-240,-80},{-210,-80},{-210,
          120},{-192,120}}, color={255,0,255}));
  connect(avaIntAltRep.y, avaIntIdxEquAlt.u)
    annotation (Line(points={{-128,120},{-112,120}}, color={255,127,0}));
  connect(voiUna.y, truArrCon.uIdx) annotation (Line(points={{52,110},{60,110},
          {60,34},{68,34}}, color={255,127,0}));
  connect(uIdxAltSor, avaIntIdxEquAlt.index) annotation (Line(points={{-240,100},
          {-100,100},{-100,108}}, color={255,127,0}));
  connect(avaIntIdxEquAlt.y, voiUna.u1) annotation (Line(points={{-88,120},{20,
          120},{20,116},{28,116}}, color={255,127,0}));
  connect(uIdxAltSor, voiUna.u2) annotation (Line(points={{-240,100},{20,100},{
          20,104},{28,104}}, color={255,127,0}));
  connect(isReqPosAlt.y, isReqAlt.u1) annotation (Line(points={{-38,20},{-26,20},
          {-26,0},{-12,0}}, color={255,0,255}));
  connect(isNotReqNoAlt.y, isReqAlt.u2)
    annotation (Line(points={{-38,-8},{-12,-8}}, color={255,0,255}));
  connect(avaInt.y, avaIntAltRep.u)
    annotation (Line(points={{-168,120},{-152,120}}, color={255,127,0}));
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
        extent={{-220,-140},{220,140}}, grid={2,2})),
    Documentation(
      info="<html>
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
gives the number of equipment required at stage <code>i</code>.
If this number cannot be achieved with the available equipment,
stage <code>i</code> is deemed unavailable.
</li>
<li>
The condition <code>∑_j staEqu[i+1, j] &ge; ∑_j staEqu[i, j]</code>
is required for all <code>i &lt; size(staEqu, 1)</code>.
</li>
</ul>
<p>
The state of the enable signals is only updated at stage change, or
if the number of previously enabled equipment that is available is
strictly less than the number of equipment required to run.
This avoids hot swapping equipment, e.g., an equipment would not be started
and another stopped during operation just to fulfill the priority order.
However, when a lead/lag alternate equipment becomes unavailable and another
lead/lag alternate equipment can be enabled to meet the number of required
equipment, then the state of the enable signals is updated.
</p>
</html>", revisions="<html>
<ul>
<li>
June 2, 2026, by Antoine Gautier:<br/>
Added logic to remove unavailable equipment from staging order.<br/>
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
