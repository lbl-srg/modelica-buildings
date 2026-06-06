within Buildings.Templates.Plants.Controls.Utilities;
block TrueArrayConditional
  "Output a Boolean array with a given number of true elements and a priority order"
  parameter Integer nin=nin
    "Size of input array"
    annotation(Evaluate=true,
      Dialog(connectorSizing=true),
      HideResult=true);
  parameter Integer nout(min=0) = nin
    "Size of output array"
    annotation(Evaluate=true);
  final parameter Boolean filTru[nout, nout] =
    {j <= i for j in 1:nout, i in 1:nout}
    "Lower triangular true matrix"
    annotation(Evaluate=true);
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u
    "Number of true elements"
    annotation(Placement(transformation(extent={{-180,40},{-140,80}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uIdx[nin]
    "Array of indices by order of priority to be true"
    annotation(Placement(transformation(extent={{-180,-80},{-140,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1[nout]
    "Array with true at the first u priority-ordered indices"
    annotation(Placement(transformation(extent={{140,-20},{180,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nout, nin]
    "True if output position index matches a valid and required input index"
    annotation(Placement(transformation(extent={{-90,-10},{-70,10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr[nout](each final nin=nin)
    "True if output position matches any valid and required input index"
    annotation(Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerVectorReplicator repIdx(
    nin=nin,
    nout=nout)
    "Replicate filtered input indices to nout rows for comparison with output position matrix"
    annotation(Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idxNouNin[nout, nin](
    k={i for _ in 1:nin, i in 1:nout})
    "Indices of output vector replicated nin times"
    annotation(Placement(transformation(extent={{-120,-10},{-100,10}})));
  CountTrue couTru[nout](each final nin=nout)
    "Count of active true output elements up to and including each output position"
    annotation(Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorReplicator repCnd(
    final nin=nout,
    final nout=nout)
    "Replicate candidate output array to nout rows for cumulative true-count computation"
    annotation(Placement(transformation(extent={{-28,-10},{-8,10}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqual couLeqU[nout]
    "True if cumulative true count at each output position does not exceed requested count u"
    annotation(Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator repUNou(
    final nout=nout)
    "Replicate requested count u to array of size nout for comparison with cumulative counts"
    annotation(Placement(transformation(extent={{40,-50},{60,-30}})));
  Buildings.Controls.OBC.CDL.Logical.And andFin[nout]
    "True if output index is requested and cumulative true count does not exceed u"
    annotation(Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant filLowTri[nout, nout](
    final k=filTru)
    "Lower triangular boolean matrix for masking elements by output position"
    annotation(Placement(transformation(extent={{-28,30},{-8,50}})));
  Buildings.Controls.OBC.CDL.Logical.And mskRowCum[nout, nout]
    "Mask active output elements with lower triangular matrix to enable cumulative counting"
    annotation(Placement(transformation(extent={{10,-10},{30,10}})));
equation
  connect(repIdx.y, intEqu.u2)
    annotation(Line(points={{-98,-60},{-96,-60},{-96,-8},{-92,-8}},
      color={255,127,0}));
  connect(intEqu.y, mulOr.u)
    annotation(Line(points={{-68,0},{-62,0}},
      color={255,127,0}));
  connect(idxNouNin.y, intEqu.u1)
    annotation(Line(points={{-98,0},{-92,0}},
      color={255,127,0}));
  connect(mulOr.y, repCnd.u)
    annotation(Line(points={{-38,0},{-30,0}},
      color={255,0,255}));
  connect(couTru.y, couLeqU.u1)
    annotation(Line(points={{62,0},{68,0}},
      color={255,127,0}));
  connect(u, repUNou.u)
    annotation(Line(points={{-160,60},{-132,60},{-132,-40},{38,-40}},
      color={255,127,0}));
  connect(repUNou.y, couLeqU.u2)
    annotation(Line(points={{62,-40},{66,-40},{66,-8},{68,-8}},
      color={255,127,0}));
  connect(couLeqU.y, andFin.u1)
    annotation(Line(
      points={{92,0},{98,0}},
      color={255,0,255}));
  connect(mulOr.y, andFin.u2)
    annotation(Line(points={{-38,0},{-34,0},{-34,-60},{94,-60},{94,-8},{98,-8}},
      color={255,0,255}));
  connect(filLowTri.y, mskRowCum.u1)
    annotation(Line(points={{-6,40},{0,40},{0,0},{8,0}},
      color={255,0,255}));
  connect(repCnd.y, mskRowCum.u2)
    annotation(Line(points={{-6,0},{-4,0},{-4,-8},{8,-8}},
      color={255,0,255}));
  connect(mskRowCum.y, couTru.u1)
    annotation(Line(points={{32,0},{38,0}},
      color={255,0,255}));
  connect(uIdx, repIdx.u)
    annotation (Line(points={{-160,-60},{-122,-60}}, color={255,127,0}));
  connect(andFin.y, y1)
    annotation (Line(points={{122,0},{160,0}}, color={255,0,255}));
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
    extent={{-140,-120},{140,120}},
        grid={2,2})),
  Documentation(
    info="<html>
<p>
  This block outputs a Boolean array with true at the
  output positions given by the first <code>u</code> entries of the
  priority-ordered index array <code>uIdx[nin]</code>.
  The number of true elements equals <code>u</code>
  when at least <code>u</code> valid and distinct entries are present in
  <code>uIdx</code>, and is less otherwise.
</p>
</html>",
    revisions="<html>
<ul>
  <li>
    March 29, 2024, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>"));
end TrueArrayConditional;
