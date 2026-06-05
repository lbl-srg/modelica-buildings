within Buildings.Templates.Plants.Controls.PolyvalentHeatPumps;
block ExtractStagingMatrix
  parameter Real sta[:,:]
    "Partially flattened (2D) staging matrix [(nSta+1)*nSta, nEqu], row-major over (iHea, iCoo)";
  parameter Boolean is_transpose = false annotation(Evaluate=true);
  final parameter Integer nRow = size(sta, 1) "= (nSta+1)*nSta";
  final parameter Integer nEqu = size(sta, 2) "= nHp + 2*nPhp";
  final parameter Integer nSta = integer((1 + sqrt(1 + 4*nRow)) / 2) - 1;
  final parameter Integer nOut = nEqu * nSta;

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u
    "Stage index of opposite mode (from 0 to stage number)"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y[
    if is_transpose then nEqu else nSta,
    if is_transpose then nSta else nEqu]
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  // ---- Data path ----
  // Each output p maps to (iCoo, iEqu): iCoo = mod(p-1, nSta)+1, iEqu = div(p-1, nSta)+1   [transpose layout]
  //                                  or  iEqu = mod(p-1, nEqu)+1, iCoo = div(p-1, nEqu)+1   [straight layout]
  // Feed each extractor the column of sta for its iEqu, i.e. sta[:, iEqu].
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conStaCoo[nOut,nRow](
    final k=if is_transpose then
      {sta[r, div(p - 1, nSta) + 1] for r in 1:nRow, p in 1:nOut}
    else
      {sta[r, mod(p - 1, nEqu) + 1] for r in 1:nRow, p in 1:nOut})
    "Per-output column of sta (selected by iEqu)"
    annotation (Placement(transformation(extent={{-68,30},{-48,50}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndRea[nOut](each nin=nRow)
    "Scalar extraction along the row dimension"
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));

  // ---- Index path ----
  // row index = (u-1)*nSta + iCoo
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant nStaCst(k=nSta)
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply mulInt "(u-1)*nSta"
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(nout=nOut)
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  // Per-output iCoo offset (1-based row-within-stage)
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant offCst[nOut](
    final k=if is_transpose then
      {mod(p - 1, nSta) + 1 for p in 1:nOut}
    else
      {div(p - 1, nEqu) + 1 for p in 1:nOut})
    "Per-output iCoo (row within heating stage)"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt[nOut]
    annotation (Placement(transformation(extent={{30,-30},{50,-10}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractSignal extReaSig[
    if is_transpose then nEqu else nSta](
    each final nin=nOut,
    each final nout=if is_transpose then nSta else nEqu,
    final extract=if is_transpose then
      {(i - 1)*nSta + j for j in 1:nSta, i in 1:nEqu}
    else
      {(j - 1)*nEqu + i for i in 1:nEqu, j in 1:nSta})
    annotation (Placement(transformation(extent={{50,30},{70,50}})));
  Buildings.Controls.OBC.CDL.Routing.RealVectorReplicator reaVecRep(
    final nin=nOut, final nout=if is_transpose then nEqu else nSta)
    annotation (Placement(transformation(extent={{10,29},{30,51}})));
equation
  connect(nStaCst.y, mulInt.u2) annotation (Line(points={{-68,-60},{-60,-60},{-60,-26},{-52,-26}}, color={255,127,0}));
  connect(u, mulInt.u1) annotation (Line(points={{-120,0},{-60,0},{-60,-14},{-52,-14}}, color={255,127,0}));
  connect(mulInt.y, intScaRep.u) annotation (Line(points={{-28,-20},{-12,-20}}, color={255,127,0}));
  connect(intScaRep.y, addInt.u1) annotation (Line(points={{12,-20},{40,-20},{40,-14},{28,-14}}, color={255,127,0}));
  connect(offCst.y, addInt.u2) annotation (Line(points={{12,-60},{20,-60},{20,-26},{28,-26}}, color={255,127,0}));
  connect(addInt.y, extIndRea.index) annotation (Line(points={{52,-20},{60,-20},{60,0},{-20,0},{-20,28}}, color={255,127,0}));
  connect(conStaCoo.y, extIndRea.u) annotation (Line(points={{-46,40},{-32,40}}, color={0,0,127}));
  connect(extIndRea.y, reaVecRep.u) annotation (Line(points={{-8,40},{8,40}}, color={0,0,127}));
  connect(reaVecRep.y, extReaSig.u) annotation (Line(points={{32,40},{48,40}}, color={0,0,127}));
  connect(extReaSig.y, y) annotation (Line(points={{72,40},{80,40},{80,0},{120,0}}, color={0,0,127}));
  annotation (
    defaultComponentName="extSta",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}),                      Diagram(coordinateSystem(preserveAspectRatio=false)));
end ExtractStagingMatrix;
