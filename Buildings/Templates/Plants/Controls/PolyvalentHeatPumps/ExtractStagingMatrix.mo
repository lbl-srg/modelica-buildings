within Buildings.Templates.Plants.Controls.PolyvalentHeatPumps;
block ExtractStagingMatrix
  parameter Real sta[:]
    "Fully flattened (1D) row-major expansion of 3D staging matrix";
  parameter Integer nHp
    "Number of reversible heat pumps"
    annotation (Evaluate=true);
  parameter Integer nShc
    "Number of polyvalent units"
    annotation (Evaluate=true);
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
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u
    "Stage index of opposite mode (from 0 to stage number)"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y[if is_transpose then nEqu
     else nSta,if is_transpose then nSta else nEqu] annotation (Placement(
        transformation(extent={{100,-20},{140,20}}), iconTransformation(extent=
            {{100,-20},{140,20}})));
  // ---- Data path (all 2D) ----
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conStaCoo[nOut,nLen](final
      k={sta[m] for m in 1:nLen,p in 1:nOut})
    "Full flat vector duplicated for each of nOut extractors"
    annotation (Placement(transformation(extent={{-68,30},{-48,50}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndRea[nOut](each nin=
        nLen) "Scalar extraction per output element"
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));
  // ---- Index path ----
  // flat index = (u-1)*nSta*nEqu + offset
  // straight (non-transpose): offset = q = (iCoo-1)*nEqu + iEqu
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant nStaCst(k=nSta*nEqu)
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply mulInt "(u-1)*nSta*nEqu"
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(nout=nOut)
    "Broadcast runtime base to all outputs"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant offCst[nOut](final k=if
        is_transpose then {(mod(p - 1, nSta))*nEqu + (div(p - 1, nSta) + 1)
        for p in 1:nOut} else {p for p in 1:nOut})
    "Per-output offset = flat position (identity for straight extraction)"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt[nOut]
    annotation (Placement(transformation(extent={{30,-30},{50,-10}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractSignal extReaSig[if
    is_transpose then nEqu else nSta](
    each final nin=nOut,
    each final nout=if is_transpose then nSta else nEqu,
    final extract=if is_transpose then {(i - 1)*nSta + j for j in 1:nSta,i in 1
        :nEqu} else {(j - 1)*nEqu + i for i in 1:nEqu,j in 1:nSta})
    annotation (Placement(transformation(extent={{50,30},{70,50}})));
  Buildings.Controls.OBC.CDL.Routing.RealVectorReplicator reaVecRep(final nin=
        nOut, final nout=if is_transpose then nEqu else nSta)
    annotation (Placement(transformation(extent={{10,29},{30,51}})));
equation
  // index path
  connect(nStaCst.y, mulInt.u2)
    annotation(Line(points={{-68,-60},{-60,-60},{-60,-26},{-52,-26}},
      color={255,127,0}));
  connect(mulInt.y, intScaRep.u)
    annotation(Line(points={{-28,-20},{-12,-20}},
      color={255,127,0}));
  connect(intScaRep.y, addInt.u1)
    annotation(Line(points={{12,-20},{40,-20},{40,-14},{28,-14}},
      color={255,127,0}));
  connect(offCst.y, addInt.u2)
    annotation(Line(points={{12,-60},{20,-60},{20,-26},{28,-26}},
      color={255,127,0}));
  connect(addInt.y, extIndRea.index)
    annotation(Line(points={{52,-20},{60,-20},{60,0},{-20,0},{-20,28}},
      color={255,127,0}));
  // data path
  connect(conStaCoo.y, extIndRea.u)
    annotation(Line(points={{-46,40},{-32,40}},
      color={0,0,127}));
  connect(extIndRea.y, reaVecRep.u)
    annotation(Line(points={{-8,40},{8,40}},
      color={0,0,127}));
  connect(reaVecRep.y, extReaSig.u)
    annotation(Line(points={{32,40},{48,40}},
      color={0,0,127}));
  connect(extReaSig.y, y)
    annotation(Line(points={{72,40},{80,40},{80,0},{120,0}},
      color={0,0,127}));
  connect(u, mulInt.u1) annotation (Line(points={{-120,0},{-60,0},{-60,-14},{
          -52,-14}}, color={255,127,0}));
annotation(Icon(coordinateSystem(preserveAspectRatio=false)),
  Diagram(coordinateSystem(preserveAspectRatio=false)));
end ExtractStagingMatrix;
