within Buildings.Templates.Utilities;
block ExtractStagingMatrix
  parameter Real sta[:]
    "Fully flattened (1D) row-major expansion of 3D staging matrix";
  parameter Integer nHp = 1;
  parameter Integer nShc = 0;
  parameter Boolean is_transpose = false
    "Set to true to output the staging matrix transpose, false for the matrix itself"
    annotation(Evaluate=true);
  final parameter Integer nLen = size(sta, 1);
  final parameter Integer nEqu = nHp + 2 * nShc
    "Number of equipment columns in staging matrix";
  final parameter Integer nRow = div(nLen, nEqu)
    "Number of staging rows = (nSta + 1) * nSta";
  final parameter Integer nSta = integer((1 + sqrt(1 + 4 * nRow)) / 2) - 1
    "Number of stages";
  final parameter Integer nOut = nEqu * nSta
    "Number of extracted scalar outputs";
  Controls.OBC.CDL.Interfaces.IntegerInput u
    "Stage index"
    annotation(Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Controls.OBC.CDL.Interfaces.RealOutput y[if is_transpose
  then nEqu else nSta, if is_transpose then nSta else nEqu]
    annotation(Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  // ---- Data path (all 2D) ----
  Controls.OBC.CDL.Reals.Sources.Constant conStaCoo[nOut, nLen](
    final k={sta[m] for m in 1:nLen, p in 1:nOut})
    "Full flat vector duplicated for each of nOut extractors"
    annotation(Placement(transformation(extent={{-40,60},{-20,80}})));
  Controls.OBC.CDL.Routing.RealExtractor extIndRea[nOut](each nin=nLen)
    "Scalar extraction per output element"
    annotation(Placement(transformation(extent={{30,60},{50,80}})));
  // ---- Index path ----
  // flat index = (u-1)*nSta*nEqu + offset
  // straight (non-transpose): offset = q = (iCoo-1)*nEqu + iEqu
  Controls.OBC.CDL.Integers.Sources.Constant one(k=1)
    annotation(Placement(transformation(extent={{-90,-80},{-70,-60}})));
  Controls.OBC.CDL.Integers.Subtract intSub
    "u - 1"
    annotation(Placement(transformation(extent={{-56,-40},{-36,-20}})));
  Controls.OBC.CDL.Integers.Sources.Constant nStaCst(k=nSta * nEqu)
    annotation(Placement(transformation(extent={{-50,-80},{-30,-60}})));
  Controls.OBC.CDL.Integers.Multiply mulInt
    "(u-1)*nSta*nEqu"
    annotation(Placement(transformation(extent={{-20,-40},{0,-20}})));
  Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(nout=nOut)
    "Broadcast runtime base to all outputs"
    annotation(Placement(transformation(extent={{10,-40},{30,-20}})));
  Controls.OBC.CDL.Integers.Sources.Constant offCst[nOut](
    final k=if is_transpose
      then {(mod(p - 1, nSta)) * nEqu + (div(p - 1, nSta) + 1) for p in 1:nOut}
      else {p for p in 1:nOut})
    "Per-output offset = flat position (identity for straight extraction)"
    annotation(Placement(transformation(extent={{10,-80},{30,-60}})));
  Controls.OBC.CDL.Integers.Add addInt[nOut]
    annotation(Placement(transformation(extent={{48,-40},{68,-20}})));
  Controls.OBC.CDL.Routing.RealExtractSignal extReaSig[if is_transpose
  then nEqu else nSta](
    each final nin=nOut,
    each final nout=if is_transpose then nSta else nEqu,
    final extract=if is_transpose
      then {(i - 1) * nSta + j for j in 1:nSta, i in 1:nEqu}
      else {(j - 1) * nEqu + i for i in 1:nEqu, j in 1:nSta})
    annotation(Placement(transformation(extent={{120,60},{140,80}})));
  Controls.OBC.CDL.Routing.RealVectorReplicator reaVecRep(
    final nin=nOut,
    final nout=if is_transpose then nEqu else nSta)
    annotation(Placement(transformation(extent={{70,59},{90,81}})));
equation
  // index path
  connect(u, intSub.u1)
    annotation(Line(points={{-120,0},{-80,0},{-80,-24},{-58,-24}},
      color={255,127,0}));
  connect(one.y, intSub.u2)
    annotation(Line(points={{-68,-70},{-64,-70},{-64,-36},{-58,-36}},
      color={255,127,0}));
  connect(intSub.y, mulInt.u1)
    annotation(Line(points={{-34,-30},{-30,-30},{-30,-24},{-22,-24}},
      color={255,127,0}));
  connect(nStaCst.y, mulInt.u2)
    annotation(Line(points={{-28,-70},{-24,-70},{-24,-36},{-22,-36}},
      color={255,127,0}));
  connect(mulInt.y, intScaRep.u)
    annotation(Line(points={{2,-30},{8,-30}},
      color={255,127,0}));
  connect(intScaRep.y, addInt.u1)
    annotation(Line(points={{32,-30},{40,-30},{40,-24},{46,-24}},
      color={255,127,0}));
  connect(offCst.y, addInt.u2)
    annotation(Line(points={{32,-70},{40,-70},{40,-36},{46,-36}},
      color={255,127,0}));
  connect(addInt.y, extIndRea.index)
    annotation(Line(points={{70,-30},{80,-30},{80,30},{40,30},{40,58}},
      color={255,127,0}));
  // data path
  connect(conStaCoo.y, extIndRea.u)
    annotation(Line(points={{-18,70},{28,70}},
      color={0,0,127}));
  connect(extIndRea.y, reaVecRep.u)
    annotation(Line(points={{52,70},{68,70}},
      color={0,0,127}));
  connect(reaVecRep.y, extReaSig.u)
    annotation(Line(points={{92,70},{118,70}},
      color={0,0,127}));
  connect(extReaSig.y, y)
    annotation(Line(points={{142,70},{124,70},{124,0},{120,0}},
      color={0,0,127}));
annotation(Icon(coordinateSystem(preserveAspectRatio=false)),
  Diagram(coordinateSystem(preserveAspectRatio=false)));
end ExtractStagingMatrix;
