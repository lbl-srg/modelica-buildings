within Buildings.Templates.Plants.Controls.HeatPumps.Subsequences;
block RemoveFromStagingMultiple
  parameter Integer nPhp(final min=1) "Number of polyvalent HP"
    annotation(Evaluate=true);
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uIdxSor[nPhp]
    "Indices of polyvalent units sorted by increasing runtime" annotation (
      Placement(transformation(extent={{-240,-160},{-200,-120}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nHea annotation (Placement(
        transformation(extent={{-240,120},{-200,160}}), iconTransformation(
          extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nCoo annotation (Placement(
        transformation(extent={{-240,80},{-200,120}}), iconTransformation(
          extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nShc annotation (Placement(
        transformation(extent={{-240,40},{-200,80}}), iconTransformation(extent={{-140,20},
            {-100,60}})));
  Buildings.Controls.OBC.CDL.Integers.Change chaHea
    annotation (Placement(transformation(extent={{-180,130},{-160,150}})));
  Buildings.Controls.OBC.CDL.Integers.Change chaCoo
    annotation (Placement(transformation(extent={{-180,90},{-160,110}})));
  Buildings.Controls.OBC.CDL.Integers.Change chaShc
    annotation (Placement(transformation(extent={{-180,50},{-160,70}})));
  Buildings.Controls.OBC.CDL.Logical.And and2[nPhp]
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));
  RemoveFromStagingOrder removeFromStagingOrder(final nUni=nPhp)
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hea[nPhp] annotation (
      Placement(transformation(extent={{-240,-60},{-200,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Coo[nPhp] annotation (
      Placement(transformation(extent={{-240,-100},{-200,-60}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Shc[nPhp] annotation (
      Placement(transformation(extent={{-240,-140},{-200,-100}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  RemoveFromStagingOrder removeFromStagingOrder1(final nUni=nPhp)
    annotation (Placement(transformation(extent={{-90,-130},{-70,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi[nPhp]
    annotation (Placement(transformation(extent={{140,130},{160,150}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi1[nPhp]
    annotation (Placement(transformation(extent={{90,110},{110,130}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep(nout=nPhp)
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep1(nout=nPhp)
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep2(nout=nPhp)
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
  Buildings.Controls.OBC.CDL.Logical.And and1[nPhp]
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi2[nPhp]
    annotation (Placement(transformation(extent={{50,90},{70,110}})));
  RemoveFromStagingOrder removeFromStagingOrder2(final nUni=nPhp)
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi3[nPhp]
    annotation (Placement(transformation(extent={{10,70},{30,90}})));
  RemoveFromStagingOrder removeFromStagingOrder3(final nUni=nPhp)
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));
  RemoveFromStagingOrder remHeaAndCoo(final nUni=nPhp)
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi4[nPhp]
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yIdxSorHea[nPhp]( start=1:nPhp)
    "Indices of polyvalent units sorted by increasing runtime" annotation (
      Placement(transformation(extent={{200,120},{240,160}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Logical.Pre preHea[nPhp]
    annotation (Placement(transformation(extent={{-190,-50},{-170,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Pre preCoo[nPhp]
    annotation (Placement(transformation(extent={{-188,-90},{-168,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Pre preShc[nPhp]
    annotation (Placement(transformation(extent={{-188,-130},{-168,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yIdxSorCoo[nPhp]( start=1:nPhp)
    "Indices of polyvalent units sorted by increasing runtime" annotation (
      Placement(transformation(extent={{200,80},{240,120}}), iconTransformation(
          extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yIdxSorShc[nPhp](
     start=1:nPhp)
    "Indices of polyvalent units sorted by increasing runtime" annotation (
      Placement(transformation(extent={{200,40},{240,80}}), iconTransformation(
          extent={{100,-100},{140,-60}})));
  Modelica.Blocks.Sources.IntegerExpression integerExpression[nPhp](y=pre(
        yIdxSorShc))
    annotation (Placement(transformation(extent={{172,-26},{152,-6}})));
  Modelica.Blocks.Sources.IntegerExpression integerExpression1[nPhp](y=pre(
        yIdxSorCoo))
    annotation (Placement(transformation(extent={{170,62},{150,82}})));
  Modelica.Blocks.Sources.IntegerExpression integerExpression2[nPhp](y=pre(
        yIdxSorHea))
    annotation (Placement(transformation(extent={{170,102},{150,122}})));
  Buildings.Controls.OBC.CDL.Logical.And and3[nPhp]
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi5[nPhp]
    annotation (Placement(transformation(extent={{-26,50},{-6,70}})));
  RemoveFromStagingOrder remHeaAndCoo1(final nUni=nPhp)
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
  Buildings.Controls.OBC.CDL.Logical.Or  or2   [nPhp]
    annotation (Placement(transformation(extent={{-188,-24},{-168,-4}})));
  Buildings.Controls.OBC.CDL.Logical.Or  and4[nPhp]
    annotation (Placement(transformation(extent={{-96,50},{-76,70}})));
equation
  connect(nHea, chaHea.u)
    annotation (Line(points={{-220,140},{-182,140}}, color={255,127,0}));
  connect(nCoo, chaCoo.u)
    annotation (Line(points={{-220,100},{-182,100}}, color={255,127,0}));
  connect(nShc, chaShc.u)
    annotation (Line(points={{-220,60},{-182,60}}, color={255,127,0}));
  connect(uIdxSor, removeFromStagingOrder.uIdxSor) annotation (Line(points={{-220,
          -140},{-150,-140},{-150,-74},{-142,-74}}, color={255,127,0}));
  connect(removeFromStagingOrder.yIdxSor, intSwi.u1) annotation (Line(points={{-118,
          -80},{120,-80},{120,148},{138,148}}, color={255,127,0}));
  connect(chaHea.y, booScaRep.u)
    annotation (Line(points={{-158,140},{-142,140}}, color={255,0,255}));
  connect(chaCoo.y, booScaRep1.u)
    annotation (Line(points={{-158,100},{-142,100}}, color={255,0,255}));
  connect(chaShc.y, booScaRep2.u)
    annotation (Line(points={{-158,60},{-142,60}}, color={255,0,255}));
  connect(booScaRep.y, and2.u1)
    annotation (Line(points={{-118,140},{-82,140}}, color={255,0,255}));
  connect(and2.y, intSwi.u2)
    annotation (Line(points={{-58,140},{138,140}}, color={255,0,255}));
  connect(booScaRep2.y, and2.u2) annotation (Line(points={{-118,60},{-100,60},{-100,
          132},{-82,132}}, color={255,0,255}));
  connect(booScaRep.y, intSwi1.u2) annotation (Line(points={{-118,140},{-110,
          140},{-110,120},{88,120}},
                                color={255,0,255}));
  connect(removeFromStagingOrder.yIdxSor, removeFromStagingOrder1.uIdxSor)
    annotation (Line(points={{-118,-80},{-100,-80},{-100,-114},{-92,-114}},
                                                                          color
        ={255,127,0}));
  connect(removeFromStagingOrder1.yIdxSor, intSwi1.u1) annotation (Line(points={{-68,
          -120},{80,-120},{80,128},{88,128}},    color={255,127,0}));
  connect(booScaRep1.y, and1.u1)
    annotation (Line(points={{-118,100},{-82,100}}, color={255,0,255}));
  connect(booScaRep2.y, and1.u2) annotation (Line(points={{-118,60},{-100,60},{-100,
          92},{-82,92}}, color={255,0,255}));
  connect(and1.y, intSwi2.u2)
    annotation (Line(points={{-58,100},{48,100}}, color={255,0,255}));
  connect(uIdxSor, removeFromStagingOrder2.uIdxSor) annotation (Line(points={{-220,
          -140},{-150,-140},{-150,-34},{-142,-34}},
                                                color={255,127,0}));
  connect(removeFromStagingOrder2.yIdxSor, intSwi2.u1) annotation (Line(points={{-118,
          -40},{40,-40},{40,108},{48,108}},   color={255,127,0}));
  connect(booScaRep1.y, intSwi3.u2) annotation (Line(points={{-118,100},{-110,100},
          {-110,80},{8,80}}, color={255,0,255}));
  connect(removeFromStagingOrder2.yIdxSor, removeFromStagingOrder3.uIdxSor)
    annotation (Line(points={{-118,-40},{-100,-40},{-100,-14},{-92,-14}},
                                                                    color={255,127,
          0}));
  connect(removeFromStagingOrder3.yIdxSor, intSwi3.u1) annotation (Line(points={{-68,-20},
          {0,-20},{0,88},{8,88}},         color={255,127,0}));
  connect(intSwi3.y, intSwi2.u3) annotation (Line(points={{32,80},{44,80},{44,92},
          {48,92}}, color={255,127,0}));
  connect(intSwi1.y, intSwi.u3) annotation (Line(points={{112,120},{130,120},{130,
          132},{138,132}}, color={255,127,0}));
  connect(remHeaAndCoo.yIdxSor, intSwi4.u1) annotation (Line(points={{-68,-60},
          {-60,-60},{-60,8},{-42,8}}, color={255,127,0}));
  connect(booScaRep2.y, intSwi4.u2)
    annotation (Line(points={{-118,60},{-100,60},{-100,0},{-42,0}},
                                                  color={255,0,255}));
  connect(u1Hea, preHea.u)
    annotation (Line(points={{-220,-40},{-192,-40}}, color={255,0,255}));
  connect(u1Coo, preCoo.u)
    annotation (Line(points={{-220,-80},{-190,-80}}, color={255,0,255}));
  connect(preCoo.y, removeFromStagingOrder.u1) annotation (Line(points={{-166,-80},
          {-160,-80},{-160,-86},{-142,-86}}, color={255,0,255}));
  connect(preHea.y, removeFromStagingOrder2.u1) annotation (Line(points={{-168,-40},
          {-160,-40},{-160,-46},{-142,-46}}, color={255,0,255}));
  connect(u1Shc, preShc.u)
    annotation (Line(points={{-220,-120},{-190,-120}}, color={255,0,255}));
  connect(preShc.y, removeFromStagingOrder1.u1) annotation (Line(points={{-166,-120},
          {-100,-120},{-100,-126},{-92,-126}}, color={255,0,255}));
  connect(preShc.y, removeFromStagingOrder3.u1) annotation (Line(points={{-166,-120},
          {-110,-120},{-110,-26},{-92,-26}}, color={255,0,255}));
  connect(intSwi.y, yIdxSorHea)
    annotation (Line(points={{162,140},{220,140}}, color={255,127,0}));
  connect(intSwi2.y, yIdxSorCoo)
    annotation (Line(points={{72,100},{220,100}}, color={255,127,0}));
  connect(integerExpression.y, intSwi4.u3) annotation (Line(points={{151,-16},{-50,
          -16},{-50,-8},{-42,-8}}, color={255,127,0}));
  connect(integerExpression1.y, intSwi3.u3)
    annotation (Line(points={{149,72},{8,72}}, color={255,127,0}));
  connect(integerExpression2.y, intSwi1.u3)
    annotation (Line(points={{149,112},{88,112}}, color={255,127,0}));
  connect(and3.y, intSwi5.u2)
    annotation (Line(points={{-38,60},{-28,60}}, color={255,0,255}));
  connect(intSwi5.y, yIdxSorShc)
    annotation (Line(points={{-4,60},{220,60}}, color={255,127,0}));
  connect(removeFromStagingOrder2.yIdxSor, remHeaAndCoo.uIdxSor) annotation (
      Line(points={{-118,-40},{-114,-40},{-114,-54},{-92,-54}}, color={255,127,
          0}));
  connect(preCoo.y, remHeaAndCoo.u1) annotation (Line(points={{-166,-80},{-160,
          -80},{-160,-66},{-92,-66}}, color={255,0,255}));
  connect(remHeaAndCoo1.yIdxSor, intSwi5.u1) annotation (Line(points={{-118,0},
          {-106,0},{-106,68},{-28,68}}, color={255,127,0}));
  connect(or2.y, remHeaAndCoo1.u1) annotation (Line(points={{-166,-14},{-156,
          -14},{-156,-6},{-142,-6}}, color={255,0,255}));
  connect(u1Hea, or2.u1) annotation (Line(points={{-220,-40},{-206,-40},{-206,
          -14},{-190,-14}}, color={255,0,255}));
  connect(u1Coo, or2.u2) annotation (Line(points={{-220,-80},{-220,-51},{-190,
          -51},{-190,-22}}, color={255,0,255}));
  connect(uIdxSor, remHeaAndCoo1.uIdxSor) annotation (Line(points={{-220,-140},
          {-182,-140},{-182,6},{-142,6}}, color={255,127,0}));
  connect(booScaRep1.y, and4.u2) annotation (Line(points={{-118,100},{-106,100},
          {-106,52},{-98,52}}, color={255,0,255}));
  connect(booScaRep.y, and4.u1) annotation (Line(points={{-118,140},{-112,140},
          {-112,146},{-104,146},{-104,60},{-98,60}}, color={255,0,255}));
  connect(and4.y, and3.u1)
    annotation (Line(points={{-74,60},{-62,60}}, color={255,0,255}));
  connect(booScaRep2.y, and3.u2) annotation (Line(points={{-118,60},{-112,60},{
          -112,40},{-72,40},{-72,52},{-62,52}}, color={255,0,255}));
  connect(intSwi4.y, intSwi5.u3) annotation (Line(points={{-18,0},{-24,0},{-24,
          52},{-28,52}}, color={255,127,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-160},{200,160}})));
end RemoveFromStagingMultiple;
