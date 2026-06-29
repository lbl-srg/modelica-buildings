within Buildings.Templates.Plants.Controls.HeatPumps.Subsequences;
block EquipmentEnable "Return array of equipment to be enabled at given stage"
  parameter Integer nStaHp(start=nHp)
    "Number of stages in HP staging matrix"
    annotation (Evaluate=true, Dialog(enable=nPhp==0));
  parameter Real staHp[:, :](
    each final unit="1",
    each final min=0,
    each final max=1) = {min(iSta, nHp)/nHp for _ in 1:nHp, iSta in 1:nStaHp}
    "HP staging matrix – Equipment required for each stage"
    annotation (Evaluate=true, Dialog(enable=nPhp==0));
  final parameter Real traStaHp[:, :]=
    {staHp[i, j] for i in 1:nStaHp, j in 1:nHp}
    "Transpose of staging matrix";
  parameter Integer nHp
    "Number of reversible heat pumps"
    annotation(Evaluate=true);
  parameter Integer nAltHp_select(start=nHp) = nHp
    "Number of reversible heat pumps subject to lead/lag alternation"
    annotation(Evaluate=true, Dialog(enable=nPhp==0));
  final parameter Integer nAltHp = if nPhp > 0 then nHp else nAltHp_select
    "Number of reversible heat pumps subject to lead/lag alternation"
    annotation(Evaluate=true, Dialog(enable=nPhp==0));
  parameter Integer nPhp
    "Number of polyvalent units"
    annotation(Evaluate=true);
  final parameter Integer nSta = if nPhp == 0 then size(staHp, 1)
    else nHp + nPhp
    "Number of stages";
  final parameter Integer nCol = if nPhp == 0 then size(staHp, 2)
    else nHp + 2 * nPhp
    "Number of columns in staging matrix";
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uIdxSorHp[nAltHp]
    if nHp > 0 "Indices of heat pumps sorted by increasing runtime" annotation
    (Placement(transformation(extent={{-240,100},{-200,140}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta
    "Stage index"
    annotation(Placement(transformation(extent={{-240,-20},{-200,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1AvaHp[nHp] if nHp > 0
    "HP available signal"
    annotation(Placement(transformation(extent={{-240,-120},{-200,-80}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput staTra[nCol, nSta] if nPhp > 0
    "Transpose of staging matrix at current heating or cooling stage"
    annotation(Placement(transformation(extent={{-240,20},{-200,60}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Hp[nHp] if nHp > 0
    "HP enable command"
    annotation(Placement(transformation(extent={{200,20},{240,60}}),
      iconTransformation(extent={{100,60},{140,100}})));
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
    extract={i for i in 1:nHp}) if nHp > 0
    "Extract heat pumps required at given stage"
    annotation(Placement(transformation(extent={{-30,30},{-10,50}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractSignal reqPhp1Sta(
    nin=nCol,
    nout=nPhp,
    extract={nHp + i for i in 1:nPhp}) if nPhp > 0
    "Extract polyvalent units required in single mode at given stage"
    annotation(Placement(transformation(extent={{-30,-10},{-10,10}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractSignal reqPhp2Sta(
    nin=nCol,
    nout=nPhp,
    extract={nHp + nPhp + i for i in 1:nPhp}) if nPhp > 0
    "Extract polyvalent units required in SHC mode at given stage"
    annotation(Placement(transformation(extent={{-30,-50},{-10,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uIdxSorPhp1[nPhp]
    if nPhp > 0
    "Indices of polyvalent units sorted by increasing runtime in single mode"
    annotation (Placement(transformation(extent={{-240,80},{-200,120}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1AvaPhp1[nPhp] if nPhp > 0
    "Polyvalent HP in single mode available signal"
    annotation(Placement(transformation(extent={{-240,-140},{-200,-100}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1AvaPhp2[nPhp] if nPhp > 0
    "Polyvalent HP in SHC mode available signal"
    annotation(Placement(transformation(extent={{-240,-160},{-200,-120}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  StagingRotation.BaseClasses.SelectSortedAvailable selSorAvaHp(final nEqu=nHp,
      final nEquAlt=nAltHp) if nHp > 0
    "Select units by priority order and availability – HP"
    annotation (Placement(transformation(extent={{70,30},{90,50}})));
  StagingRotation.BaseClasses.SelectSortedAvailable selSorAvaPhp1(final nEqu=
        nPhp, final nEquAlt=nPhp) if nPhp > 0
    "Select units by priority order and availability – Polyvalent HP in single mode"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  StagingRotation.BaseClasses.SelectSortedAvailable selSorAvaPhp2(final nEqu=
        nPhp, final nEquAlt=nPhp) if nPhp > 0
    "Select units by priority order and availability – Polyvalent HP in SHC mode"
    annotation (Placement(transformation(extent={{70,-50},{90,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Not notSelPhp1[nPhp] if nPhp > 0
    "Return true if equipment not selected in single mode"
    annotation(Placement(transformation(extent={{-70,-90},{-50,-70}})));
  Buildings.Controls.OBC.CDL.Logical.And notSelPhp1AndAva[nPhp] if nPhp > 0
    "Return true if equipment not selected in single mode AND available"
    annotation(Placement(transformation(extent={{-30,-90},{-10,-70}})));
  Buildings.Controls.OBC.CDL.Logical.And isHpAvaAltNee[nHp] if nHp > 0
    "True if available and lead/lag alternate needed to meet stage requirement"
    annotation (Placement(transformation(extent={{110,30},{130,50}})));
  Buildings.Controls.OBC.CDL.Logical.And isPhp1AvaReqOrAltNee1[nPhp] if nPhp > 0
    "True if available and required or indexed as lead/lag alternate and needed to meet stage requirement"
    annotation (Placement(transformation(extent={{110,-10},{130,10}})));
  Buildings.Controls.OBC.CDL.Logical.And isPhp2AvaReqOrAltNee[nPhp] if nPhp > 0
    "Return true if equipment available and required or lead/lag alternate and needed to meet stage requirement"
    annotation (Placement(transformation(extent={{110,-50},{130,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Php1[nPhp] if nPhp > 0
    "Polyvalent HP enable command in single mode" annotation (Placement(
        transformation(extent={{200,-20},{240,20}}), iconTransformation(extent=
            {{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Php2[nPhp] if nPhp > 0
    "Polyvalent HP enable command in SHC mode" annotation (Placement(
        transformation(extent={{200,-60},{240,-20}}), iconTransformation(extent
          ={{100,-20},{140,20}})));
  StagingRotation.BaseClasses.SelectEquipmentAtStage selEquStaHp(final nEqu=nHp)
    if nHp > 0 "Select equipment at stage"
    annotation (Placement(transformation(extent={{10,30},{30,50}})));
  StagingRotation.BaseClasses.SelectEquipmentAtStage selEquStaPhp1(final nEqu=
        nPhp) if nPhp > 0 "Select equipment at stage"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  StagingRotation.BaseClasses.SelectEquipmentAtStage selEquStaPhp2(final nEqu=
        nPhp) if nPhp > 0 "Select equipment at stage"
    annotation (Placement(transformation(extent={{10,-50},{30,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Php1Or2[nPhp]
    if nPhp > 0
    "True if polyvalent HP commanded on in either single mode or SHC mode"
    annotation (Placement(transformation(extent={{200,-100},{240,-60}}),
        iconTransformation(extent={{100,-100},{140,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Or on1Or2[nPhp] if nPhp > 0
    "True if polyvalent HP commanded on in either single mode or SHC mode"
    annotation (Placement(transformation(extent={{170,-90},{190,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1HpPhp1[nHp + nPhp]
    "HP enable command (up to nHp) and polyvalent HP enable command in single mode (from nHp+1)"
    annotation (Placement(transformation(extent={{200,60},{240,100}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Or enaHp[nHp] if nHp > 0
    "Enable HP required without lead/lag alternate and available or lead/lag alternate to meet stage requirement"
    annotation (Placement(transformation(extent={{150,30},{170,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant traMatStaHp[nCol,nSta](
      final k=traStaHp) if nPhp == 0 "Transpose of HP staging matrix"
    annotation (Placement(transformation(extent={{-180,50},{-160,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uIdxSorPhp2[nPhp]
    if nPhp > 0
    "Indices of polyvalent units sorted by increasing runtime in SHC mode"
    annotation(Placement(transformation(extent={{-240,60},{-200,100}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
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
  connect(voiStaZer.y, reqPhp1Sta.u)
    annotation(Line(points={{-46,0},{-32,0}},
      color={0,0,127}));
  connect(voiStaZer.y, reqPhp2Sta.u)
    annotation(Line(points={{-46,0},{-40,0},{-40,-40},{-32,-40}},
      color={0,0,127}));
  connect(uIdxSorHp, selSorAvaHp.uIdxSor)
    annotation(Line(points={{-220,120},{62,120},{62,46},{68,46}},
      color={255,127,0}));
  connect(u1AvaHp, selSorAvaHp.u1Ava)
    annotation(Line(points={{-220,-100},{60,-100},{60,34},{68,34}},
      color={255,0,255}));
  connect(uIdxSorPhp1, selSorAvaPhp1.uIdxSor) annotation (Line(points={{-220,
          100},{58,100},{58,6},{68,6}}, color={255,127,0}));
  connect(u1AvaPhp1, selSorAvaPhp1.u1Ava)
    annotation(Line(points={{-220,-120},{62,-120},{62,-6},{68,-6}},
      color={255,0,255}));
  connect(selSorAvaPhp1.y1, notSelPhp1.u)
    annotation(Line(
      points={{92,0},{100,0},{100,-60},{-80,-60},{-80,-80},{-72,-80}},
      color={255,0,255}));
  connect(notSelPhp1.y, notSelPhp1AndAva.u1)
    annotation(Line(points={{-48,-80},{-32,-80}},
      color={255,0,255}));
  connect(u1AvaPhp2, notSelPhp1AndAva.u2)
    annotation(Line(points={{-220,-140},{-40,-140},{-40,-88},{-32,-88}},
      color={255,0,255}));
  connect(selSorAvaHp.y1, isHpAvaAltNee.u1)
    annotation (Line(points={{92,40},{108,40}}, color={255,0,255}));
  connect(selSorAvaPhp1.y1, isPhp1AvaReqOrAltNee1.u1)
    annotation (Line(points={{92,0},{108,0}}, color={255,0,255}));
  connect(selSorAvaPhp2.y1, isPhp2AvaReqOrAltNee.u1)
    annotation (Line(points={{92,-40},{108,-40}}, color={255,0,255}));
  connect(reqHpSta.y, selEquStaHp.uEquSta)
    annotation(Line(points={{-8,40},{8,40}},
      color={0,0,127}));
  connect(reqPhp1Sta.y, selEquStaPhp1.uEquSta)
    annotation(Line(points={{-8,0},{8,0}},
      color={0,0,127}));
  connect(reqPhp2Sta.y, selEquStaPhp2.uEquSta)
    annotation(Line(points={{-8,-40},{8,-40}},
      color={0,0,127}));
  connect(u1AvaHp, selEquStaHp.u1Ava)
    annotation(Line(points={{-220,-100},{0,-100},{0,34},{8,34}},
      color={255,0,255}));
  connect(u1AvaPhp1, selEquStaPhp1.u1Ava)
    annotation(Line(points={{-220,-120},{2,-120},{2,-6},{8,-6}},
      color={255,0,255}));
  connect(selEquStaPhp1.nTot, selSorAvaPhp1.n)
    annotation(Line(points={{32,8},{40,8},{40,0},{68,0}},
      color={255,127,0}));
  connect(selEquStaPhp2.nTot, selSorAvaPhp2.n)
    annotation(Line(points={{32,-32},{40,-32},{40,-40},{68,-40}},
      color={255,127,0}));
  connect(selEquStaPhp2.y1ReqOrAltAndAva, isPhp2AvaReqOrAltNee.u2) annotation (
      Line(points={{32,-44},{40,-44},{40,-54},{96,-54},{96,-48},{108,-48}},
        color={255,0,255}));
  connect(selEquStaPhp1.y1ReqOrAltAndAva, isPhp1AvaReqOrAltNee1.u2) annotation
    (Line(points={{32,-4},{40,-4},{40,-14},{96,-14},{96,-8},{108,-8}}, color={255,
          0,255}));
  connect(on1Or2.y, y1Php1Or2)
    annotation (Line(points={{192,-80},{220,-80}}, color={255,0,255}));
  connect(isPhp1AvaReqOrAltNee1.y, on1Or2.u1) annotation (Line(points={{132,0},{
          160,0},{160,-80},{168,-80}}, color={255,0,255}));
  connect(isPhp2AvaReqOrAltNee.y, on1Or2.u2) annotation (Line(points={{132,-40},
          {140,-40},{140,-88},{168,-88}}, color={255,0,255}));
  connect(isPhp1AvaReqOrAltNee1.y, y1HpPhp1[nHp + 1:nHp + nPhp]) annotation (
      Line(points={{132,0},{180,0},{180,80},{220,80}}, color={255,0,255}));
  connect(isHpAvaAltNee.y, enaHp.u1)
    annotation (Line(points={{132,40},{148,40}}, color={255,0,255}));
  connect(traMatStaHp.y, reqEquSta.u) annotation (Line(points={{-158,60},{-120,60},
          {-120,40},{-102,40}}, color={0,0,127}));
  connect(enaHp.y, y1Hp)
    annotation (Line(points={{172,40},{220,40}}, color={255,0,255}));
  connect(selEquStaHp.nAlt, selSorAvaHp.n) annotation (Line(points={{32,44},{40,
          44},{40,40},{68,40}}, color={255,127,0}));
  connect(selEquStaHp.y1AltAndAva, isHpAvaAltNee.u2) annotation (Line(points={{32,
          38},{38,38},{38,22},{100,22},{100,32},{108,32}}, color={255,0,255}));
  connect(selEquStaHp.y1ReqAndAva, enaHp.u2) annotation (Line(points={{32,40},{40,
          40},{40,20},{140,20},{140,32},{148,32}}, color={255,0,255}));
  connect(enaHp.y, y1HpPhp1[1:nHp]) annotation (Line(points={{172,40},{190,40},{
          190,80},{220,80}}, color={255,0,255}));
  connect(isPhp1AvaReqOrAltNee1.y, y1Php1)
    annotation (Line(points={{132,0},{220,0}}, color={255,0,255}));
  connect(isPhp2AvaReqOrAltNee.y, y1Php2)
    annotation (Line(points={{132,-40},{220,-40}}, color={255,0,255}));
  connect(uIdxSorPhp2, selSorAvaPhp2.uIdxSor) annotation (Line(points={{-220,80},
          {54,80},{54,-34},{68,-34}}, color={255,127,0}));
  connect(u1AvaPhp2, selEquStaPhp2.u1Ava) annotation (Line(points={{-220,-140},
          {4,-140},{4,-46},{8,-46}}, color={255,0,255}));
  connect(u1AvaPhp2, selSorAvaPhp2.u1Ava) annotation (Line(points={{-220,-140},
          {64,-140},{64,-46},{68,-46}}, color={255,0,255}));
annotation(defaultComponentName="enaEqu",
  Icon(coordinateSystem(preserveAspectRatio=true),
    graphics={
    Text(extent={{-150,150},{150,110}},
      textString="%name",
      textColor={0,0,255}),
              Rectangle(extent={{-100,100},{100,-100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid)}),
  Diagram(coordinateSystem(extent={{-200,-160},{200,140}})),
    Documentation(info="<html>
</html>"));
end EquipmentEnable;
