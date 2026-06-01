within Buildings.Templates.Utilities;
block ExtractTransposeAtStageFrom1D
  parameter Real sta[:]
    "Fully flattened (1D) row-major expansion of staging matrix";
  parameter Integer nHp = 1;
  parameter Integer nShc = 0;
  parameter Integer nLen=size(sta, 1);
  final parameter Integer nEqu=nHp + 2*nShc
    "Number of equipment columns (nHp + 2*nShc)";
  final parameter Integer nRow=div(nLen, nEqu)
    "Number of staging rows = nSta*(nSta-1)";
  final parameter Integer nSta=integer((1 + sqrt(1 + 4*nRow)) / 2)
    "Number of stages";
  final parameter Integer nOut=nEqu*(nSta - 1)
    "Number of extracted scalar outputs";

  // ---- Data path (all 2D) ----
  Controls.OBC.CDL.Reals.Sources.Constant conStaCoo[nOut,nLen](
    final k={{sta[m] for m in 1:nLen} for p in 1:nOut})
    "Full flat vector duplicated for each of nOut extractors"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Controls.OBC.CDL.Routing.RealExtractor extIndRea[nOut](each nin=nLen)
    "Scalar extraction per output element"
    annotation (Placement(transformation(extent={{30,60},{50,80}})));

  // ---- Index path ----
  // flat index = (u-1)*(nSta-1)*nEqu + offset
  // offset for output p (p = (iEqu-1)*(nSta-1) + iCoo, transpose order):
  //   = (iCoo-1)*nEqu + iEqu
  Controls.OBC.CDL.Integers.Sources.Constant one(k=1)
    annotation (Placement(transformation(extent={{-90,-80},{-70,-60}})));
  Controls.OBC.CDL.Integers.Subtract intSub "u - 1"
    annotation (Placement(transformation(extent={{-56,-40},{-36,-20}})));
  Controls.OBC.CDL.Integers.Sources.Constant nStaCst(k=(nSta - 1)*nEqu)
    annotation (Placement(transformation(extent={{-50,-80},{-30,-60}})));
  Controls.OBC.CDL.Integers.Multiply mulInt "(u-1)*(nSta-1)*nEqu"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(nout=nOut)
    "Broadcast runtime base to all outputs"
    annotation (Placement(transformation(extent={{10,-40},{30,-20}})));
Controls.OBC.CDL.Integers.Sources.Constant offCst[nOut](
    final k={(mod(p-1, nSta-1))*nEqu + (div(p-1, nSta-1) + 1) for p in 1:nOut})
    "Per-output sta-column offset, row-major in [iEqu, iCoo] to match extReaSig.extract"
    annotation (Placement(transformation(extent={{10,-80},{30,-60}})));
  Controls.OBC.CDL.Integers.Add addInt[nOut]
    annotation (Placement(transformation(extent={{48,-40},{68,-20}})));

  Controls.OBC.CDL.Interfaces.IntegerInput u "Stage index" annotation (
      Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Controls.OBC.CDL.Interfaces.RealOutput y[nEqu,nSta - 1] annotation (Placement(
        transformation(extent={{100,-20},{140,20}}), iconTransformation(extent={
            {100,-20},{140,20}})));
  Controls.OBC.CDL.Routing.RealExtractSignal extReaSig[nEqu](
    each final nin=nOut,
    each final nout=nSta - 1,
    final extract={{(i - 1)*(nSta - 1) + j for j in 1:nSta - 1} for i in 1:nEqu})
    annotation (Placement(transformation(extent={{120,60},{140,80}})));
  Controls.OBC.CDL.Routing.RealVectorReplicator reaVecRep(nin=nOut, nout=nEqu)
    annotation (Placement(transformation(extent={{70,59},{90,81}})));
equation
  // index path
  connect(u, intSub.u1) annotation (Line(points={{-120,0},{-80,0},{-80,-24},{-58,-24}}, color={255,127,0}));
  connect(one.y, intSub.u2) annotation (Line(points={{-68,-70},{-64,-70},{-64,-36},{-58,-36}}, color={255,127,0}));
  connect(intSub.y, mulInt.u1) annotation (Line(points={{-34,-30},{-30,-30},{-30,-24},{-22,-24}}, color={255,127,0}));
  connect(nStaCst.y, mulInt.u2) annotation (Line(points={{-28,-70},{-24,-70},{-24,-36},{-22,-36}}, color={255,127,0}));
  connect(mulInt.y, intScaRep.u) annotation (Line(points={{2,-30},{8,-30}}, color={255,127,0}));
  connect(intScaRep.y, addInt.u1) annotation (Line(points={{32,-30},{40,-30},{40,-24},{46,-24}}, color={255,127,0}));
  connect(offCst.y, addInt.u2) annotation (Line(points={{32,-70},{40,-70},{40,-36},{46,-36}}, color={255,127,0}));
  connect(addInt.y, extIndRea.index) annotation (Line(points={{70,-30},{80,-30},{80,30},{40,30},{40,58}}, color={255,127,0}));
  // data path
  connect(conStaCoo.y, extIndRea.u) annotation (Line(points={{-18,70},{28,70}}, color={0,0,127}));
  // output reshape: y[iEqu, iCoo] = extIndRea[(iCoo-1)*nEqu + iEqu].y
  // (handled by matching flat order; see note)
  connect(extIndRea.y, reaVecRep.u)
    annotation (Line(points={{52,70},{68,70}}, color={0,0,127}));
  connect(reaVecRep.y, extReaSig.u)
    annotation (Line(points={{92,70},{118,70}}, color={0,0,127}));
  connect(extReaSig.y, y) annotation (Line(points={{142,70},{124,70},{124,0},{120,
          0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ExtractTransposeAtStageFrom1D;
