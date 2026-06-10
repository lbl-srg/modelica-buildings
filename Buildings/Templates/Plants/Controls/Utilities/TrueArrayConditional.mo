within Buildings.Templates.Plants.Controls.Utilities;
block TrueArrayConditional
  "Output a Boolean array with a given number of true elements and a priority order"
  parameter Integer nin
    "Size of input array"
    annotation(Evaluate=true,
      Dialog(connectorSizing=true),
      HideResult=true);
  parameter Integer nout(min=0) = nin
    "Size of output array"
    annotation(Evaluate=true);
  final parameter Boolean filTru[nin, nin] = {j <= i for j in 1:nin, i in 1:nin}
    "Lower triangular true matrix"
    annotation(Evaluate=true);
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u
    "Number of true elements"
    annotation(Placement(transformation(extent={{-220,60},{-180,100}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uIdx[nin]
    "Array of indices by order of priority to be true"
    annotation(Placement(transformation(extent={{-220,-80},{-180,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1[nout]
    "Array with true at the first u priority-ordered indices"
    annotation(Placement(transformation(extent={{180,-20},{220,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  // Sequence 1: eliminate duplicates and elements outside 1..nout from uIdx
  Buildings.Controls.OBC.CDL.Integers.Equal equOutInp[nout, nin]
    "True if output position index equals input index value"
    annotation(Placement(transformation(extent={{-128,-70},{-108,-50}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerVectorReplicator repUIdx(
    nin=nin,
    nout=nout)
    "Replicate input index array to nout rows for comparison with output position indices"
    annotation(Placement(transformation(extent={{-168,-90},{-148,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conOutPos[nout, nin](
    k={i for _ in 1:nin, i in 1:nout})
    "Output position indices 1..nout replicated nin times across columns"
    annotation(Placement(transformation(extent={{-168,-50},{-148,-30}})));
  FirstTrueIndex idxFirOcc[nout](each final nin=nin)
    "Position of first occurrence in uIdx for each output-range value"
    annotation(Placement(transformation(extent={{-98,-70},{-78,-50}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerVectorReplicator repFirOcc(
    nin=nout,
    nout=nin)
    "Replicate first-occurrence positions to nin elements for input-position matching"
    annotation(Placement(transformation(extent={{-68,-70},{-48,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInpPos[nin, nout](
    k={i for _ in 1:nout, i in 1:nin})
    "Input position indices 1..nin replicated nout times across columns"
    annotation(Placement(transformation(extent={{-68,-110},{-48,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Equal equFirInp[nin, nout]
    "True if first-occurrence position matches input position index"
    annotation(Placement(transformation(extent={{-28,-90},{-8,-70}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulIsUnq[nin](each final nin=nout)
    "True at input position j if j is the first (unique) occurrence of its value in uIdx"
    annotation(Placement(transformation(extent={{12,-90},{32,-70}})));
  // Sequence 2: count valid non-zero elements and keep those with rank <= u
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorReplicator repIsVal(
    nin=nin,
    nout=nin)
    "Replicate element validity flag to matrix for element-wise AND with lower-triangular mask"
    annotation(Placement(transformation(extent={{-130,-10},{-110,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conLowTri[nin, nin](
    final k=filTru)
    "Constant lower-triangular true matrix for masking preceding elements"
    annotation(Placement(transformation(extent={{-130,30},{-110,50}})));
  Buildings.Controls.OBC.CDL.Logical.And andValPre[nin, nin]
    "True at [i,j] if element j is valid and j precedes or equals i"
    annotation(Placement(transformation(extent={{-100,-10},{-80,10}})));
  CountTrue couValPre[nin](each final nin=nin)
    "Count of valid preceding elements"
    annotation(Placement(transformation(extent={{-70,-10},{-50,10}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqual leqU[nin]
    "True if element rank is at most u (element is within the first u valid entries)"
    annotation(Placement(transformation(extent={{-30,-10},{-10,10}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator repU(nout=nin)
    "Replicate maximum selection count u to all elements for rank comparison"
    annotation(Placement(transformation(extent={{-170,70},{-150,90}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger intSel[nin]
    "Convert selection flag to integer for masking"
    annotation(Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply mulSel[nin]
    "Selected indices: uIdx at selected positions, 0 elsewhere"
    annotation(Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Integers.Equal equOutSel[nout, nin]
    "True if output position index equals selected index value"
    annotation(Placement(transformation(extent={{110,-10},{130,10}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerVectorReplicator repSelIdx(
    nin=nin,
    nout=nout)
    "Replicate selected indices to nout rows for comparison with output position indices"
    annotation(Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulIsOut[nout](each final nin=nin)
    "True at output position i if any selected input index equals i"
    annotation(Placement(transformation(extent={{140,-10},{160,10}})));
equation
  connect(equOutSel.y, mulIsOut.u)
    annotation(Line(points={{132,0},{138,0}},
      color={255,127,0}));
  connect(uIdx, mulSel.u2)
    annotation(Line(
      points={{-200,-60},{-176,-60},{-176,-20},{30,-20},{30,-6},{38,-6}},
      color={255,127,0}));
  connect(andValPre.y, couValPre.u1)
    annotation(Line(points={{-78,0},{-72,0}},
      color={255,127,0}));
  connect(equFirInp.y, mulIsUnq.u)
    annotation(Line(points={{-6,-80},{10,-80}},
      color={255,127,0}));
  connect(equOutInp.y, idxFirOcc.u1)
    annotation(Line(points={{-106,-60},{-100,-60}},
      color={255,127,0}));
  connect(repUIdx.y, equOutInp.u2)
    annotation(Line(points={{-146,-80},{-140,-80},{-140,-68},{-130,-68}},
      color={255,127,0}));
  connect(conOutPos.y, equOutInp.u1)
    annotation(Line(points={{-146,-40},{-140,-40},{-140,-60},{-130,-60}},
      color={255,127,0}));
  connect(uIdx, repUIdx.u)
    annotation(Line(points={{-200,-60},{-176,-60},{-176,-80},{-170,-80}},
      color={255,127,0}));
  connect(idxFirOcc.y, repFirOcc.u)
    annotation(Line(points={{-76,-60},{-70,-60}},
      color={255,127,0}));
  connect(repFirOcc.y, equFirInp.u1)
    annotation(Line(points={{-46,-60},{-40,-60},{-40,-80},{-30,-80}},
      color={255,127,0}));
  connect(conInpPos.y, equFirInp.u2)
    annotation(Line(points={{-46,-100},{-40,-100},{-40,-88},{-30,-88}},
      color={255,127,0}));
  connect(couValPre.y, leqU.u1)
    annotation(Line(points={{-48,0},{-32,0}},
      color={255,127,0}));
  connect(u, repU.u)
    annotation(Line(points={{-200,80},{-172,80}},
      color={255,127,0}));
  connect(repU.y, leqU.u2)
    annotation(Line(points={{-148,80},{-40,80},{-40,-8},{-32,-8}},
      color={255,127,0}));
  connect(leqU.y, intSel.u)
    annotation(Line(points={{-8,0},{-2,0}},
      color={255,0,255}));
  connect(intSel.y, mulSel.u1)
    annotation(Line(points={{22,0},{30,0},{30,6},{38,6}},
      color={255,127,0}));
  connect(mulSel.y, repSelIdx.u)
    annotation(Line(points={{62,0},{68,0}},
      color={255,127,0}));
  connect(mulIsOut.y, y1)
    annotation(Line(points={{162,0},{200,0}},
      color={255,0,255}));
  connect(mulIsUnq.y, repIsVal.u)
    annotation(Line(
      points={{34,-80},{40,-80},{40,-30},{-140,-30},{-140,0},{-132,0}},
      color={255,0,255}));
  connect(conLowTri.y, andValPre.u1)
    annotation(Line(points={{-108,40},{-104,40},{-104,0},{-102,0}},
      color={255,0,255}));
  connect(repIsVal.y, andValPre.u2)
    annotation(Line(points={{-108,0},{-106,0},{-106,-8},{-102,-8}},
      color={255,0,255}));
  connect(conOutPos.y, equOutSel.u2)
    annotation(Line(points={{-146,-40},{100,-40},{100,-8},{108,-8}},
      color={255,127,0}));
  connect(repSelIdx.y, equOutSel.u1)
    annotation(Line(points={{92,0},{108,0}},
      color={255,127,0}));
annotation(defaultComponentName="truArrCon",
  Icon(coordinateSystem(preserveAspectRatio=true,
    extent={{-100,-100},{100,100}}),
    graphics={Rectangle(extent={{-100,100},{100,-100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
    Text(extent={{-150,150},{150,110}},
      textString="%name",
      textColor={0,0,255})}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-180,-120},{180,120}})),
  Documentation(
    info="<html>
<p>
  This block outputs a Boolean array with true at the output positions given
  by the first <code>u</code> entries of the priority-ordered index array
  <code>uIdx</code>. The number of true elements equals <code>u</code> when at
  least <code>u</code> valid and distinct entries are present in
  <code>uIdx</code>, and is less otherwise.
</p>
</html>",
    revisions="<html>
<ul>
  <li>
    June 10, 2026, by Antoine Gautier:<br />
    Refactored using CDL Elementary Blocks.
  </li>
  <li>
    March 29, 2024, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>"));
end TrueArrayConditional;
