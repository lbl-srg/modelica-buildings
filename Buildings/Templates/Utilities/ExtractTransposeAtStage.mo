within Buildings.Templates.Utilities;
block ExtractTransposeAtStage
  parameter Real sta[:,:]
    "Row-major expansion of staging matrix";
  parameter Integer nRow=size(sta, 1);
  parameter Integer nCol=size(sta, 2);
  parameter Integer nSta = integer((1 + sqrt(1 + 4*nRow)) / 2);
  Controls.OBC.CDL.Reals.Sources.Constant conStaCoo[nCol,nRow](final k={sta[i,
        j] for i in 1:nRow,j in 1:nCol})
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Controls.OBC.CDL.Integers.Multiply mulInt
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Controls.OBC.CDL.Integers.Sources.Constant nStaCst(k=nSta - 1)
    annotation (Placement(transformation(extent={{-50,-80},{-30,-60}})));
  Controls.OBC.CDL.Integers.Subtract intSub
    annotation (Placement(transformation(extent={{-56,-40},{-36,-20}})));
  Controls.OBC.CDL.Integers.Sources.Constant one(k=1)
    annotation (Placement(transformation(extent={{-90,-80},{-70,-60}})));
  Controls.OBC.CDL.Integers.Sources.Constant nStaCst1[nSta - 1](k={i for i in 1:
        nSta - 1})
    annotation (Placement(transformation(extent={{10,-80},{30,-60}})));
  Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(nout=nSta - 1)
    annotation (Placement(transformation(extent={{10,-40},{30,-20}})));
  Controls.OBC.CDL.Integers.Add addInt[nSta - 1]
    annotation (Placement(transformation(extent={{48,-40},{68,-20}})));
  Controls.OBC.CDL.Routing.RealExtractor extIndRea[nCol,nSta - 1](each nin
      =nRow)
    annotation (Placement(transformation(extent={{30,60},{50,80}})));
  Controls.OBC.CDL.Routing.IntegerVectorReplicator intVecRep(nin=nSta - 1, nout
      =nCol)
    annotation (Placement(transformation(extent={{12,20},{32,40}})));
  Controls.OBC.CDL.Routing.RealVectorReplicator reaVecRep[nCol](each nin
      =nRow, each nout=nSta - 1)
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Controls.OBC.CDL.Interfaces.IntegerInput u "Stage index" annotation (
      Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Controls.OBC.CDL.Interfaces.RealOutput y[nCol,nSta - 1] annotation (Placement(
        transformation(extent={{100,-20},{140,20}}), iconTransformation(extent=
            {{100,-20},{140,20}})));
equation
  connect(nStaCst.y,mulInt. u2) annotation (Line(points={{-28,-70},{-24,-70},{-24,
          -36},{-22,-36}}, color={255,127,0}));
  connect(intSub.y,mulInt. u1) annotation (Line(points={{-34,-30},{-30,-30},{-30,
          -24},{-22,-24}}, color={255,127,0}));
  connect(one.y,intSub. u2) annotation (Line(points={{-68,-70},{-64,-70},{-64,-36},
          {-58,-36}}, color={255,127,0}));
  connect(mulInt.y,intScaRep. u)
    annotation (Line(points={{2,-30},{8,-30}}, color={255,127,0}));
  connect(intScaRep.y,addInt. u1) annotation (Line(points={{32,-30},{40,-30},{40,
          -24},{46,-24}}, color={255,127,0}));
  connect(nStaCst1.y,addInt. u2) annotation (Line(points={{32,-70},{40,-70},{40,
          -36},{46,-36}}, color={255,127,0}));
  connect(conStaCoo.y,reaVecRep. u)
    annotation (Line(points={{-58,70},{-42,70}}, color={0,0,127}));
  connect(reaVecRep.y,extIndRea. u)
    annotation (Line(points={{-18,70},{28,70}}, color={0,0,127}));
  connect(addInt.y,intVecRep. u) annotation (Line(points={{70,-30},{80,-30},{80,
          10},{0,10},{0,30},{10,30}},    color={255,127,0}));
  connect(intVecRep.y,extIndRea. index)
    annotation (Line(points={{34,30},{40,30},{40,58}}, color={255,127,0}));
  connect(u, intSub.u1) annotation (Line(points={{-120,0},{-80,0},{-80,-24},{-58,
          -24}}, color={255,127,0}));
  connect(extIndRea.y, y) annotation (Line(points={{52,70},{90,70},{90,0},{120,
          0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ExtractTransposeAtStage;
