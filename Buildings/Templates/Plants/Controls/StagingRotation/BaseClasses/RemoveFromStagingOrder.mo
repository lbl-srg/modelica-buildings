within Buildings.Templates.Plants.Controls.StagingRotation.BaseClasses;
block RemoveFromStagingOrder "Remove flagged units from staging order"
  parameter Integer nUni(min=1)
    "Number of units"
    annotation(Evaluate=true);
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uIdxSor[nUni]
    "Indices of polyvalent units sorted by increasing runtime"
    annotation(Placement(transformation(extent={{-240,60},{-200,100}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1[nUni]
    "Flag of each unit to be removed from the staging order, indexed by unit number"
    annotation(Placement(transformation(extent={{-240,-100},{-200,-60}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yIdxSor[nUni]
    "Staging order with each flagged unit replaced by the next non-flagged unit"
    annotation(Placement(transformation(extent={{200,-20},{240,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorReplicator repFla(
    final nin=nUni,
    final nout=nUni)
    "Replicate unit flags for each position of the staging order"
    annotation(Placement(transformation(extent={{-180,-90},{-160,-70}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractor extFla[nUni](
    each final nin=nUni)
    "Extract flag of unit at each position of the staging order"
    annotation(Placement(transformation(extent={{-130,-90},{-110,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conPos[nUni](
    final k=1:nUni)
    "Position index within staging order"
    annotation(Placement(transformation(extent={{-180,10},{-160,30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conNUni[nUni](
    each final k=nUni)
    "Number of units"
    annotation(Placement(transformation(extent={{-180,-50},{-160,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Switch swiVal[nUni]
    "Penalized position: nUni if unit at position is flagged, position index otherwise"
    annotation(Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerVectorReplicator repPos(
    final nin=nUni,
    final nout=nUni)
    "Position index matrix: element (i, j) is j"
    annotation(Placement(transformation(extent={{-130,50},{-110,70}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator repRow[nUni](
    each final nout=nUni)
    "Position index matrix: element (i, j) is i"
    annotation(Placement(transformation(extent={{-130,10},{-110,30}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqual greEqu[nUni, nUni]
    "True if j >= i: candidate positions for resolving position i"
    annotation(Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerVectorReplicator repVal(
    final nin=nUni,
    final nout=nUni)
    "Replicate penalized positions for each position"
    annotation(Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conNUniMat[nUni, nUni](
    each final k=nUni)
    "Number of units"
    annotation(Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Switch swiMas[nUni, nUni]
    "Mask out positions before position i with nUni"
    annotation(Placement(transformation(extent={{10,-10},{30,10}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nUni, nUni]
    "Convert to real for row-wise minimum"
    annotation(Placement(transformation(extent={{50,-10},{70,10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMin mulMin[nUni](each final nin=nUni)
    "First non-flagged position at or after position i, nUni if none"
    annotation(Placement(transformation(extent={{90,-10},{110,10}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt[nUni]
    "Convert resolved position back to integer"
    annotation(Placement(transformation(extent={{130,-10},{150,10}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerVectorReplicator repIdx(
    final nin=nUni,
    final nout=nUni)
    "Replicate sorted unit indices for each position"
    annotation(Placement(transformation(extent={{90,70},{110,90}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerExtractor extIdx[nUni](
    each final nin=nUni)
    "Extract unit index at resolved position: uIdxSor[k[i]]"
    annotation(Placement(transformation(extent={{150,70},{170,90}})));
equation
  connect(u1, repFla.u)
    annotation(Line(points={{-220,-80},{-182,-80}},
      color={255,0,255}));
  connect(repFla.y, extFla.u)
    annotation(Line(points={{-158,-80},{-132,-80}},
      color={255,0,255}));
  connect(uIdxSor, extFla.index)
    annotation(Line(
      points={{-220,80},{-190,80},{-190,-100},{-120,-100},{-120,-92}},
      color={255,127,0}));
  connect(extFla.y, swiVal.u2)
    annotation(Line(points={{-108,-80},{-90,-80},{-90,0},{-82,0}},
      color={255,0,255}));
  connect(conNUni.y, swiVal.u1)
    annotation(Line(points={{-158,-40},{-100,-40},{-100,8},{-82,8}},
      color={255,127,0}));
  connect(conPos.y, swiVal.u3)
    annotation(Line(points={{-158,20},{-140,20},{-140,-8},{-82,-8}},
      color={255,127,0}));
  connect(conPos.y, repPos.u)
    annotation(Line(points={{-158,20},{-140,20},{-140,60},{-132,60}},
      color={255,127,0}));
  connect(conPos.y, repRow.u)
    annotation(Line(points={{-158,20},{-132,20}},
      color={255,127,0}));
  connect(repPos.y, greEqu.u1)
    annotation(Line(points={{-108,60},{-100,60},{-100,40},{-82,40}},
      color={255,127,0}));
  connect(repRow.y, greEqu.u2)
    annotation(Line(points={{-108,20},{-100,20},{-100,32},{-82,32}},
      color={255,127,0}));
  connect(swiVal.y, repVal.u)
    annotation(Line(points={{-58,0},{-42,0}},
      color={255,127,0}));
  connect(greEqu.y, swiMas.u2)
    annotation(Line(points={{-58,40},{0,40},{0,0},{8,0}},
      color={255,0,255}));
  connect(repVal.y, swiMas.u1)
    annotation(Line(points={{-18,0},{-10,0},{-10,8},{8,8}},
      color={255,127,0}));
  connect(conNUniMat.y, swiMas.u3)
    annotation(Line(points={{-18,-40},{0,-40},{0,-8},{8,-8}},
      color={255,127,0}));
  connect(swiMas.y, intToRea.u)
    annotation(Line(points={{32,0},{48,0}},
      color={255,127,0}));
  connect(intToRea.y, mulMin.u)
    annotation(Line(points={{72,0},{88,0}},
      color={0,0,127}));
  connect(mulMin.y, reaToInt.u)
    annotation(Line(points={{112,0},{128,0}},
      color={0,0,127}));
  connect(reaToInt.y, extIdx.index)
    annotation(Line(points={{152,0},{160,0},{160,68}},
      color={255,127,0}));
  connect(uIdxSor, repIdx.u)
    annotation(Line(points={{-220,80},{88,80}},
      color={255,127,0}));
  connect(repIdx.y, extIdx.u)
    annotation(Line(points={{112,80},{148,80}},
      color={255,127,0}));
  connect(extIdx.y, yIdxSor)
    annotation(Line(points={{172,80},{180,80},{180,0},{220,0}},
      color={255,127,0}));
annotation(defaultComponentName="remStaOrd",
  Diagram(coordinateSystem(extent={{-200,-120},{200,120}},
    grid={2,2})),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}},
    grid={2,2}),
    graphics={Rectangle(extent={{-100,100},{100,-100}},
      lineColor={0,0,127},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
    Text(extent={{-150,150},{150,110}},
      textString="%name",
      textColor={0,0,255})}),
  Documentation(
    info="<html>
<p>
  This block takes a staging order – a list of units ranked by increasing
  runtime – together with a flag for each unit, and produces a revised staging
  order in which the flagged units have been removed.
</p>
<p>
  The position of each removed unit is filled with the next unflagged unit
  found further down the order. As a result, the enable logic that reads any
  position of the revised order is directed to a unit that is allowed to be
  enabled, while the ranking by runtime is preserved.
</p>
<p>
  If all units ranked at or after a given position are flagged, that position
  falls back to the last unit in the order. The last position therefore always
  returns its own unit, whether or not it is flagged.
</p>
</html>",
    revisions="<html>
<ul>
  <li>
    July 10, 2026, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>"));
end RemoveFromStagingOrder;
