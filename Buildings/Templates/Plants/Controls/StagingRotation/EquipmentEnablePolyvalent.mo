within Buildings.Templates.Plants.Controls.StagingRotation;
block EquipmentEnablePolyvalent
  "Return array of equipment to be enabled at given stage"
  parameter Integer nHp
    "Number of reversible heat pumps"
    annotation(Evaluate=true);
  parameter Integer nShc
    "Number of polyvalent units"
    annotation(Evaluate=true);
  final parameter Integer nEquAlt = nHp + nShc
    "Number of lead/lag alternate equipment";
  final parameter Integer nSta = nHp + nShc "Number of stages";
  final parameter Integer nCol = nHp + 2 * nShc
    "Number of columns in staging matrix";
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uIdxHpSor[nHp]
    "Indices of heat pumps sorted by increasing runtime"
    annotation(Placement(transformation(extent={{-240,80},{-200,120}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta
    "Stage index"
    annotation(Placement(transformation(extent={{-240,-20},{-200,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HpAva[nHp]
    "HP available signal"
    annotation(Placement(transformation(extent={{-240,-120},{-200,-80}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput staTra[nCol, nSta]
    "Transpose of staging matrix at current heating or cooling stage"
    annotation(Placement(transformation(extent={{-240,20},{-200,60}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Hp[nHp]
    "HP enable command"
    annotation(Placement(transformation(extent={{200,20},{240,60}}),
      iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor reqEquSta[nCol](
    each final nin=nSta)
    "Extract equipment required at given stage"
    annotation(Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(
    final nout=nCol)
    "Replicate signal"
    annotation(Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant one(final k=1)
    "Constant"
    annotation(Placement(transformation(extent={{-180,10},{-160,30}})));
  Buildings.Controls.OBC.CDL.Integers.Max maxInt
    "Maximum between stage index and 1"
    annotation(Placement(transformation(extent={{-150,-10},{-130,10}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold greZer(final t=0)
    "Check if stage index is greater than zero"
    annotation(Placement(transformation(extent={{-180,-50},{-160,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    final realTrue=1,
    final realFalse=0)
    "Cast to real"
    annotation(Placement(transformation(extent={{-150,-50},{-130,-30}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(
    final nout=nCol)
    "Replicate signal"
    annotation(Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply voiStaZer[nCol]
    "Void if stage is equal to zero"
    annotation(Placement(transformation(extent={{-68,-10},{-48,10}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractSignal reqHpSta(
    nin=nCol,
    nout=nHp,
    extract={i for i in 1:nHp})
    "Extract heat pumps required at given stage"
    annotation(Placement(transformation(extent={{-30,30},{-10,50}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractSignal reqShc1Sta(
    nin=nCol,
    nout=nShc,
    extract={nHp + i for i in 1:nShc})
    "Extract SHC units required in single mode at given stage"
    annotation(Placement(transformation(extent={{-30,-10},{-10,10}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractSignal reqShc2Sta(
    nin=nCol,
    nout=nShc,
    extract={nHp + nShc + i for i in 1:nShc})
    "Extract SHC units required in SHC mode at given stage"
    annotation(Placement(transformation(extent={{-30,-50},{-10,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uIdxShcSor[nShc]
    "Indices of SHC units sorted by increasing runtime"
    annotation(Placement(transformation(extent={{-240,60},{-200,100}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Shc1Ava[nShc]
    "Polyvalent HP in single mode available signal"
    annotation(Placement(transformation(extent={{-240,-140},{-200,-100}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Shc2Ava[nShc]
    "Polyvalent HP in SHC mode available signal"
    annotation(Placement(transformation(extent={{-240,-160},{-200,-120}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  BaseClasses.SelectSortedAvailable selSorAvaHp(final nEqu=nHp, final nEquAlt=
        nHp) "Select units by priority order and availability – HP"
    annotation (Placement(transformation(extent={{70,30},{90,50}})));
  BaseClasses.SelectSortedAvailable selSorAvaShc1(final nEqu=nShc, final
      nEquAlt=nShc)
    "Select units by priority order and availability – Polyvalent HP in single mode"
    annotation (Placement(transformation(extent={{72,-10},{92,10}})));
  BaseClasses.SelectSortedAvailable selSorAvaShc2(final nEqu=nShc, final
      nEquAlt=nShc)
    "Select units by priority order and availability – Polyvalent HP in SHC mode"
    annotation (Placement(transformation(extent={{72,-50},{92,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Not notSelShc1[nShc]
    "Return true if equipment not selected in single mode"
    annotation(Placement(transformation(extent={{-68,-90},{-48,-70}})));
  Buildings.Controls.OBC.CDL.Logical.And notSelShc1AndAva[nShc]
    "Return true if equipment not selected in single mode AND available"
    annotation(Placement(transformation(extent={{-30,-90},{-10,-70}})));
  Buildings.Controls.OBC.CDL.Logical.And isHpReqAltAvaNee[nHp]
    "Return true if equipment required with lead/lag alternate and available and needed to meet stage requirement"
    annotation(Placement(transformation(extent={{110,30},{130,50}})));
  Buildings.Controls.OBC.CDL.Logical.And isShc1ReqAltAvaNee1[nShc]
    "Return true if equipment required with lead/lag alternate and available and needed to meet stage requirement"
    annotation(Placement(transformation(extent={{110,-10},{130,10}})));
  Buildings.Controls.OBC.CDL.Logical.And isShc2ReqAltAvaNee[nShc]
    "Return true if equipment required with lead/lag alternate and available and needed to meet stage requirement"
    annotation(Placement(transformation(extent={{110,-50},{130,-30}})));
  BaseClasses.UpdateEnableState updEnaStaHp(final nEqu=nHp)
    "Update enable state"
    annotation (Placement(transformation(extent={{170,30},{190,50}})));
  BaseClasses.UpdateEnableState updEnaStaShc1(final nEqu=nShc)
    "Update enable state"
    annotation (Placement(transformation(extent={{170,-10},{190,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Shc1[nShc]
    "Polyvalent HP enable command in single mode" annotation (Placement(
        transformation(extent={{200,-20},{240,20}}), iconTransformation(extent=
            {{100,-20},{140,20}})));
  BaseClasses.UpdateEnableState updEnaStaShc2(final nEqu=nShc)
    "Update enable state"
    annotation (Placement(transformation(extent={{170,-50},{190,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Shc2[nShc]
    "Polyvalent HP enable command in SHC mode" annotation (Placement(
        transformation(extent={{200,-60},{240,-20}}), iconTransformation(extent
          ={{100,-60},{140,-20}})));
  BaseClasses.SelectEquipmentAtStage selEquStaHp(final nEqu=nHp)
    "Select equipment at stage"
    annotation (Placement(transformation(extent={{10,30},{30,50}})));
  BaseClasses.SelectEquipmentAtStage selEquStaShc1(final nEqu=nShc)
    "Select equipment at stage"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  BaseClasses.SelectEquipmentAtStage selEquStaShc2(final nEqu=nShc)
    "Select equipment at stage"
    annotation (Placement(transformation(extent={{10,-50},{30,-30}})));
equation
  connect(intScaRep.y, reqEquSta.index)
    annotation(Line(points={{-98,0},{-90,0},{-90,28}},
      color={255,127,0}));
  connect(one.y, maxInt.u1)
    annotation(Line(points={{-158,20},{-154,20},{-154,6},{-152,6}},
      color={255,127,0}));
  connect(uSta, maxInt.u2)
    annotation(Line(points={{-220,0},{-190,0},{-190,-6},{-152,-6}},
      color={255,127,0}));
  connect(maxInt.y, intScaRep.u)
    annotation(Line(points={{-128,0},{-122,0}},
      color={255,127,0}));
  connect(uSta, greZer.u)
    annotation(Line(points={{-220,0},{-190,0},{-190,-40},{-182,-40}},
      color={255,127,0}));
  connect(greZer.y, booToRea.u)
    annotation(Line(points={{-158,-40},{-152,-40}},
      color={255,0,255}));
  connect(booToRea.y, reaScaRep.u)
    annotation(Line(points={{-128,-40},{-122,-40}},
      color={0,0,127}));
  connect(reqEquSta.y, voiStaZer.u1)
    annotation(Line(points={{-78,40},{-74,40},{-74,6},{-70,6}},
      color={0,0,127}));
  connect(reaScaRep.y, voiStaZer.u2)
    annotation(Line(points={{-98,-40},{-80,-40},{-80,-6},{-70,-6}},
      color={0,0,127}));
  connect(staTra, reqEquSta.u)
    annotation(Line(points={{-220,40},{-102,40}},
      color={0,0,127}));
  connect(voiStaZer.y, reqHpSta.u)
    annotation(Line(points={{-46,0},{-40,0},{-40,40},{-32,40}},
      color={0,0,127}));
  connect(voiStaZer.y, reqShc1Sta.u)
    annotation(Line(points={{-46,0},{-32,0}},
      color={0,0,127}));
  connect(voiStaZer.y, reqShc2Sta.u)
    annotation(Line(points={{-46,0},{-40,0},{-40,-40},{-32,-40}},
      color={0,0,127}));
  connect(uIdxHpSor, selSorAvaHp.uIdxSor)
    annotation(Line(points={{-220,100},{62,100},{62,46},{68,46}},
      color={255,127,0}));
  connect(u1HpAva, selSorAvaHp.u1Ava)
    annotation(Line(points={{-220,-100},{62,-100},{62,34},{68,34}},
      color={255,0,255}));
  connect(uIdxShcSor, selSorAvaShc1.uIdxSor)
    annotation(Line(points={{-220,80},{60,80},{60,6},{70,6}},
      color={255,127,0}));
  connect(u1Shc1Ava, selSorAvaShc1.u1Ava)
    annotation(Line(points={{-220,-120},{64,-120},{64,-6},{70,-6}},
      color={255,0,255}));
  connect(selSorAvaShc1.y1, notSelShc1.u)
    annotation(Line(
      points={{94,0},{100,0},{100,-60},{-80,-60},{-80,-80},{-70,-80}},
      color={255,0,255}));
  connect(notSelShc1.y, notSelShc1AndAva.u1)
    annotation(Line(points={{-46,-80},{-32,-80}},
      color={255,0,255}));
  connect(notSelShc1AndAva.y, selSorAvaShc2.u1Ava)
    annotation(Line(points={{-8,-80},{66,-80},{66,-46},{70,-46}},
      color={255,0,255}));
  connect(u1Shc2Ava, notSelShc1AndAva.u2)
    annotation(Line(points={{-220,-140},{-40,-140},{-40,-88},{-32,-88}},
      color={255,0,255}));
  connect(selSorAvaHp.y1, isHpReqAltAvaNee.u1)
    annotation(Line(points={{92,40},{108,40}},
      color={255,0,255}));
  connect(selSorAvaShc1.y1, isShc1ReqAltAvaNee1.u1)
    annotation(Line(points={{94,0},{108,0}},
      color={255,0,255}));
  connect(selSorAvaShc2.y1, isShc2ReqAltAvaNee.u1)
    annotation(Line(points={{94,-40},{108,-40}},
      color={255,0,255}));
  connect(updEnaStaHp.y1, y1Hp)
    annotation(Line(points={{192,40},{220,40}},
      color={255,0,255}));
  connect(uSta, updEnaStaHp.uSta)
    annotation(Line(
      points={{-220,0},{-190,0},{-190,60},{160,60},{160,44},{168,44}},
      color={255,127,0}));
  connect(isHpReqAltAvaNee.y, updEnaStaHp.u1)
    annotation(Line(points={{132,40},{168,40}},
      color={255,0,255}));
  connect(u1HpAva, updEnaStaHp.u1Ava)
    annotation(Line(points={{-220,-100},{162,-100},{162,36},{168,36}},
      color={255,0,255}));
  connect(updEnaStaShc1.y1, y1Shc1)
    annotation(Line(points={{192,0},{220,0}},
      color={255,0,255}));
  connect(isShc1ReqAltAvaNee1.y, updEnaStaShc1.u1)
    annotation(Line(points={{132,0},{168,0}},
      color={255,0,255}));
  connect(u1Shc1Ava, updEnaStaShc1.u1Ava)
    annotation(Line(points={{-220,-120},{164,-120},{164,-4},{168,-4}},
      color={255,0,255}));
  connect(uSta, updEnaStaShc1.uSta)
    annotation(Line(
      points={{-220,0},{-190,0},{-190,60},{160,60},{160,4},{168,4}},
      color={255,127,0}));
  connect(updEnaStaShc2.y1, y1Shc2)
    annotation(Line(points={{192,-40},{220,-40}},
      color={255,0,255}));
  connect(notSelShc1AndAva.y, updEnaStaShc2.u1Ava)
    annotation(Line(points={{-8,-80},{166,-80},{166,-44},{168,-44}},
      color={255,0,255}));
  connect(isShc2ReqAltAvaNee.y, updEnaStaShc2.u1)
    annotation(Line(points={{132,-40},{168,-40}},
      color={255,0,255}));
  connect(uSta, updEnaStaShc2.uSta)
    annotation(Line(
      points={{-220,0},{-190,0},{-190,60},{160,60},{160,-36},{168,-36}},
      color={255,127,0}));
  connect(uIdxShcSor, selSorAvaShc2.uIdxSor)
    annotation(Line(points={{-220,80},{60,80},{60,-34},{70,-34}},
      color={255,127,0}));
  connect(reqHpSta.y, selEquStaHp.uEquSta)
    annotation(Line(points={{-8,40},{8,40}},
      color={0,0,127}));
  connect(reqShc1Sta.y, selEquStaShc1.uEquSta)
    annotation(Line(points={{-8,0},{8,0}},
      color={0,0,127}));
  connect(reqShc2Sta.y, selEquStaShc2.uEquSta)
    annotation(Line(points={{-8,-40},{8,-40}},
      color={0,0,127}));
  connect(u1HpAva, selEquStaHp.u1Ava)
    annotation(Line(points={{-220,-100},{0,-100},{0,34},{8,34}},
      color={255,0,255}));
  connect(u1Shc1Ava, selEquStaShc1.u1Ava)
    annotation(Line(points={{-220,-120},{2,-120},{2,-6},{8,-6}},
      color={255,0,255}));
  connect(notSelShc1AndAva.y, selEquStaShc2.u1Ava)
    annotation(Line(points={{-8,-80},{4,-80},{4,-46},{8,-46}},
      color={255,0,255}));
  connect(selEquStaHp.nTot, selSorAvaHp.n)
    annotation(Line(points={{32,48},{40,48},{40,40},{68,40}},
      color={255,127,0}));
  connect(selEquStaShc1.nTot, selSorAvaShc1.n)
    annotation(Line(points={{32,8},{40,8},{40,0},{70,0}},
      color={255,127,0}));
  connect(selEquStaShc2.nTot, selSorAvaShc2.n)
    annotation(Line(points={{32,-32},{40,-32},{40,-40},{70,-40}},
      color={255,127,0}));
  connect(selEquStaShc2.y1ReqOrAltAndAva, isShc2ReqAltAvaNee.u2)
    annotation(Line(
      points={{32,-48},{40,-48},{40,-54},{96,-54},{96,-48},{108,-48}},
      color={255,0,255}));
  connect(selEquStaHp.y1ReqOrAltAndAva, isHpReqAltAvaNee.u2)
    annotation(Line(points={{32,32},{40,32},{40,26},{96,26},{96,32},{108,32}},
      color={255,0,255}));
  connect(selEquStaShc1.y1ReqOrAltAndAva, isShc1ReqAltAvaNee1.u2)
    annotation(Line(points={{32,-8},{40,-8},{40,-14},{96,-14},{96,-8},{108,-8}},
      color={255,0,255}));
  connect(selEquStaHp.nTot, updEnaStaHp.n)
    annotation(Line(points={{32,48},{40,48},{40,58},{158,58},{158,48},{168,48}},
      color={255,127,0}));
  connect(selEquStaShc1.nTot, updEnaStaShc1.n)
    annotation(Line(points={{32,8},{40,8},{40,18},{158,18},{158,8},{168,8}},
      color={255,127,0}));
  connect(selEquStaShc2.nTot, updEnaStaShc2.n)
    annotation(Line(
      points={{32,-32},{40,-32},{40,-22},{158,-22},{158,-32},{168,-32}},
      color={255,127,0}));
annotation(defaultComponentName="enaEqu",
  Icon(coordinateSystem(preserveAspectRatio=true),
    graphics={Rectangle(extent={{-100,100},{100,-100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
    Text(extent={{-150,150},{150,110}},
      textString="%name",
      textColor={0,0,255})}),
  Diagram(coordinateSystem(extent={{-200,-160},{200,140}})));
end EquipmentEnablePolyvalent;
