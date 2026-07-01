within Buildings.Templates.Plants.Controls.HeatPumps.Subsequences;
block EquipmentEnable
  "Equipment state and mode selection at a given stage"
  parameter Boolean have_ctlPhp = false
    "Set to true if this block is used to control polyvalent heat pumps"
    annotation(Evaluate=true);
  parameter Integer nStaHp(start=nHp)
    "Number of stages in HP staging matrix"
    annotation (Evaluate=true, Dialog(enable=not have_ctlPhp));
  parameter Real staHp[:, :](
    each final unit="1",
    each final min=0,
    each final max=1) = {min(iSta, nHp)/nHp for _ in 1:nHp, iSta in 1:nStaHp}
    "HP staging matrix – Equipment required for each stage"
    annotation (Evaluate=true, Dialog(enable=not have_ctlPhp));
  final parameter Real traStaHp[:, :]=
    {staHp[i, j] for i in 1:nStaHp, j in 1:nHp}
    "Transpose of staging matrix";
  parameter Integer nHp
    "Number of reversible heat pumps"
    annotation(Evaluate=true);
  parameter Integer nAltHp_select(start=nHp) = nHp
    "Number of reversible heat pumps subject to lead/lag alternation"
    annotation(Evaluate=true, Dialog(enable=not have_ctlPhp));
  final parameter Integer nAltHp = if have_ctlPhp then nHp else nAltHp_select
    "Number of reversible heat pumps subject to lead/lag alternation"
    annotation(Evaluate=true, Dialog(enable=not have_ctlPhp));
  parameter Integer nPhp(start=0)
    "Number of polyvalent units"
    annotation(Evaluate=true, Dialog(enable=have_ctlPhp));
  final parameter Integer nSta = if have_ctlPhp then nHp + nPhp else size(staHp, 1)
    "Number of stages";
  final parameter Integer nCol = if have_ctlPhp then nHp + 2 * nPhp else size(staHp, 2)
    "Number of columns in staging matrix";
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uIdxSorHp[nAltHp]
    if nHp > 0 "Indices of heat pumps sorted by increasing runtime" annotation
    (Placement(transformation(extent={{-240,100},{-200,140}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta "Stage index"
    annotation(Placement(transformation(extent={{-240,-20},{-200,20}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1AvaHp[nHp] if nHp > 0
    "HP available signal"
    annotation(Placement(transformation(extent={{-240,-120},{-200,-80}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput staTra[nCol,nSta] if have_ctlPhp
    "Transpose of staging matrix at current heating or cooling stage"
    annotation(Placement(transformation(extent={{-240,20},{-200,60}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
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
    extract={nHp + i for i in 1:nPhp}) if have_ctlPhp
    "Extract polyvalent units required in single mode at given stage"
    annotation(Placement(transformation(extent={{-30,-10},{-10,10}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractSignal reqPhp2Sta(
    nin=nCol,
    nout=nPhp,
    extract={nHp + nPhp + i for i in 1:nPhp}) if have_ctlPhp
    "Extract polyvalent units required in SHC mode at given stage"
    annotation(Placement(transformation(extent={{-30,-50},{-10,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uIdxSorPhp[nPhp]
    if have_ctlPhp
    "Indices of polyvalent units sorted by increasing runtime in single mode"
    annotation (Placement(transformation(extent={{-240,80},{-200,120}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1AvaPhp1[nPhp] if have_ctlPhp
    "Polyvalent HP in single mode available signal"
    annotation(Placement(transformation(extent={{-240,-140},{-200,-100}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1AvaPhp2[nPhp] if have_ctlPhp
    "Polyvalent HP in SHC mode available signal"
    annotation(Placement(transformation(extent={{-240,-160},{-200,-120}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  StagingRotation.BaseClasses.SelectSortedAvailable selSorAvaHp(final nEqu=nHp,
      final nEquAlt=nAltHp) if nHp > 0
    "Select units by priority order and availability – HP"
    annotation (Placement(transformation(extent={{70,30},{90,50}})));
  StagingRotation.BaseClasses.SelectSortedAvailable selSorAvaPhp1(final nEqu=
        nPhp, final nEquAlt=nPhp) if have_ctlPhp
    "Select units by priority order and availability – Polyvalent HP in single mode"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  StagingRotation.BaseClasses.SelectSortedAvailable selSorAvaPhp2(final nEqu=
        nPhp, final nEquAlt=nPhp) if have_ctlPhp
    "Select units by priority order and availability – Polyvalent HP in SHC mode"
    annotation (Placement(transformation(extent={{70,-50},{90,-30}})));
  Buildings.Controls.OBC.CDL.Logical.And isHpAvaAltNee[nHp] if nHp > 0
    "True if available and lead/lag alternate needed to meet stage requirement"
    annotation (Placement(transformation(extent={{110,30},{130,50}})));
  Buildings.Controls.OBC.CDL.Logical.And isPhp1AvaReqOrAltNee1[nPhp] if have_ctlPhp
    "True if available and required or indexed as lead/lag alternate and needed to meet stage requirement"
    annotation (Placement(transformation(extent={{110,-10},{130,10}})));
  Buildings.Controls.OBC.CDL.Logical.And isPhp2AvaReqOrAltNee[nPhp] if have_ctlPhp
    "Return true if equipment available and required or lead/lag alternate and needed to meet stage requirement"
    annotation (Placement(transformation(extent={{110,-50},{130,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Php1[nPhp] if have_ctlPhp
    "Polyvalent HP enable command in single mode" annotation (Placement(
        transformation(extent={{200,-20},{240,20}}), iconTransformation(extent=
            {{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Php2[nPhp] if have_ctlPhp
    "Polyvalent HP enable command in SHC mode" annotation (Placement(
        transformation(extent={{200,-60},{240,-20}}), iconTransformation(extent
          ={{100,-20},{140,20}})));
  StagingRotation.BaseClasses.SelectEquipmentAtStage selEquStaHp(final nEqu=nHp)
    if nHp > 0 "Select equipment at stage"
    annotation (Placement(transformation(extent={{10,30},{30,50}})));
  StagingRotation.BaseClasses.SelectEquipmentAtStage selEquStaPhp1(final nEqu=
        nPhp) if have_ctlPhp "Select equipment at stage"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  StagingRotation.BaseClasses.SelectEquipmentAtStage selEquStaPhp2(final nEqu=
        nPhp) if have_ctlPhp "Select equipment at stage"
    annotation (Placement(transformation(extent={{10,-50},{30,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Php1Or2[nPhp]
    if have_ctlPhp
    "True if polyvalent HP commanded on in either single mode or SHC mode"
    annotation (Placement(transformation(extent={{200,-100},{240,-60}}),
        iconTransformation(extent={{100,-100},{140,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Or on1Or2[nPhp] if have_ctlPhp
    "True if polyvalent HP commanded on in either single mode or SHC mode"
    annotation (Placement(transformation(extent={{170,-90},{190,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1HpPhp1[nHp + nPhp]
    if have_ctlPhp
    "HP enable command (up to nHp) and polyvalent HP enable command in single mode (from nHp+1)"
    annotation (Placement(transformation(extent={{200,60},{240,100}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Or enaHp[nHp] if nHp > 0
    "Enable HP required without lead/lag alternate and available or lead/lag alternate to meet stage requirement"
    annotation (Placement(transformation(extent={{150,30},{170,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant traMatStaHp[nCol,nSta](
    final k=traStaHp) if not have_ctlPhp "Transpose of HP staging matrix"
    annotation (Placement(transformation(extent={{-180,50},{-160,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uStaOpp if have_ctlPhp
                                                             "Stage index"
    annotation (Placement(transformation(extent={{-240,-266},{-200,-226}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput staTraOpp[nCol,nSta]
    if have_ctlPhp
    "Transpose of staging matrix at current heating or cooling stage"
    annotation (Placement(transformation(extent={{-240,-220},{-200,-180}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor reqEquSta1
                                                            [nCol](each final
      nin=nSta) if have_ctlPhp
    "Extract equipment required at given stage"
    annotation(Placement(transformation(extent={{-100,-210},{-80,-190}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep1(final
      nout=nCol) if have_ctlPhp
    "Replicate signal"
    annotation(Placement(transformation(extent={{-120,-250},{-100,-230}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant one1(final k=1)
    if have_ctlPhp
    "Constant"
    annotation(Placement(transformation(extent={{-180,-230},{-160,-210}})));
  Buildings.Controls.OBC.CDL.Integers.Max maxInt1 if have_ctlPhp
    "Maximum between stage index and 1"
    annotation(Placement(transformation(extent={{-150,-250},{-130,-230}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold greZer1(final t=0)
    if have_ctlPhp
    "Check if stage index is greater than zero"
    annotation(Placement(transformation(extent={{-180,-290},{-160,-270}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1(final realTrue
      =1, final realFalse=0) if have_ctlPhp
    "Cast to real"
    annotation(Placement(transformation(extent={{-150,-290},{-130,-270}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep1(final nout
      =nCol) if have_ctlPhp
    "Replicate signal"
    annotation(Placement(transformation(extent={{-120,-290},{-100,-270}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply voiStaZer1
                                                     [nCol] if have_ctlPhp
    "Void if stage is equal to zero"
    annotation(Placement(transformation(extent={{-70,-250},{-50,-230}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1AvaPhp1Opp[nPhp]
    if have_ctlPhp "Polyvalent HP in single mode available signal" annotation (
      Placement(transformation(extent={{-240,-184},{-200,-144}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractSignal reqPhp1Sta1(
    nin=nCol,
    nout=nPhp,
    extract={nHp + i for i in 1:nPhp}) if have_ctlPhp
    "Extract polyvalent units required in single mode at given stage"
    annotation(Placement(transformation(extent={{-32,-250},{-12,-230}})));
  StagingRotation.BaseClasses.SelectEquipmentAtStage selEquStaPhp3(final nEqu=
        nPhp) if have_ctlPhp "Select equipment at stage"
    annotation (Placement(transformation(extent={{10,-250},{30,-230}})));
  StagingRotation.BaseClasses.SelectSortedAvailable selSorAvaPhp3(final nEqu=
        nPhp, final nEquAlt=nPhp) if have_ctlPhp
    "Select units by priority order and availability – Polyvalent HP in single mode"
    annotation (Placement(transformation(extent={{70,-250},{90,-230}})));
  Buildings.Controls.OBC.CDL.Logical.And isPhp1AvaReqOrAltNee2[nPhp] if have_ctlPhp
    "True if available and required or indexed as lead/lag alternate and needed to meet stage requirement"
    annotation (Placement(transformation(extent={{110,-250},{130,-230}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Php1Opp[nPhp]
    if have_ctlPhp "Polyvalent HP enable command in single mode" annotation (
      Placement(transformation(extent={{200,-260},{240,-220}}),
        iconTransformation(extent={{100,20},{140,60}})));
  PolyvalentHeatPumps.ModeAlternation removeFromStagingMultiple(final nPhp=nPhp)
    if have_ctlPhp
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
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
  connect(u1AvaPhp1, selSorAvaPhp1.u1Ava)
    annotation(Line(points={{-220,-120},{62,-120},{62,-6},{68,-6}},
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
  connect(u1AvaPhp2, selEquStaPhp2.u1Ava) annotation (Line(points={{-220,-140},
          {4,-140},{4,-46},{8,-46}}, color={255,0,255}));
  connect(u1AvaPhp2, selSorAvaPhp2.u1Ava) annotation (Line(points={{-220,-140},
          {64,-140},{64,-46},{68,-46}}, color={255,0,255}));
  connect(staTraOpp, reqEquSta1.u)
    annotation (Line(points={{-220,-200},{-102,-200}}, color={0,0,127}));
  connect(one1.y, maxInt1.u1) annotation (Line(points={{-158,-220},{-154,-220},{
          -154,-234},{-152,-234}}, color={255,127,0}));
  connect(uStaOpp, maxInt1.u2) annotation (Line(points={{-220,-246},{-152,-246}},
                                                color={255,127,0}));
  connect(maxInt1.y, intScaRep1.u)
    annotation (Line(points={{-128,-240},{-122,-240}}, color={255,127,0}));
  connect(intScaRep1.y, reqEquSta1.index) annotation (Line(points={{-98,-240},{-90,
          -240},{-90,-212}}, color={255,127,0}));
  connect(greZer1.y, booToRea1.u)
    annotation (Line(points={{-158,-280},{-152,-280}}, color={255,0,255}));
  connect(booToRea1.y, reaScaRep1.u)
    annotation (Line(points={{-128,-280},{-122,-280}}, color={0,0,127}));
  connect(uStaOpp, greZer1.u) annotation (Line(points={{-220,-246},{-192,-246},
          {-192,-280},{-182,-280}},color={255,127,0}));
  connect(reqEquSta1.y, voiStaZer1.u1) annotation (Line(points={{-78,-200},{-74,
          -200},{-74,-234},{-72,-234}}, color={0,0,127}));
  connect(reaScaRep1.y, voiStaZer1.u2) annotation (Line(points={{-98,-280},{-76,
          -280},{-76,-246},{-72,-246}}, color={0,0,127}));
  connect(voiStaZer1.y, reqPhp1Sta1.u)
    annotation (Line(points={{-48,-240},{-34,-240}}, color={0,0,127}));
  connect(reqPhp1Sta1.y, selEquStaPhp3.uEquSta)
    annotation (Line(points={{-10,-240},{8,-240}}, color={0,0,127}));
  connect(u1AvaPhp1Opp, selEquStaPhp3.u1Ava) annotation (Line(points={{-220,-164},
          {0,-164},{0,-246},{8,-246}}, color={255,0,255}));
  connect(isPhp1AvaReqOrAltNee2.y, y1Php1Opp)
    annotation (Line(points={{132,-240},{220,-240}}, color={255,0,255}));
  connect(selEquStaPhp3.nTot, selSorAvaPhp3.n) annotation (Line(points={{32,-232},
          {40,-232},{40,-240},{68,-240}}, color={255,127,0}));
  connect(u1AvaPhp1Opp, selSorAvaPhp3.u1Ava) annotation (Line(points={{-220,-164},
          {60,-164},{60,-246},{68,-246}}, color={255,0,255}));
  connect(selSorAvaPhp3.y1, isPhp1AvaReqOrAltNee2.u1)
    annotation (Line(points={{92,-240},{108,-240}}, color={255,0,255}));
  connect(u1AvaPhp1Opp, isPhp1AvaReqOrAltNee2.u2) annotation (Line(points={{-220,
          -164},{100,-164},{100,-248},{108,-248}}, color={255,0,255}));
  connect(uIdxSorPhp, removeFromStagingMultiple.uIdxSor)
    annotation (Line(points={{-220,100},{-142,100}}, color={255,127,0}));
  connect(removeFromStagingMultiple.yIdxSorHea, selSorAvaPhp1.uIdxSor)
    annotation (Line(points={{-118,108},{50,108},{50,6},{68,6}}, color={255,127,
          0}));
  connect(selEquStaPhp1.nTot, removeFromStagingMultiple.nHea) annotation (Line(
        points={{32,8},{44,8},{44,130},{-160,130},{-160,108},{-142,108}}, color
        ={255,127,0}));
  connect(selEquStaPhp2.nTot, removeFromStagingMultiple.nShc) annotation (Line(
        points={{32,-32},{46,-32},{46,124},{-158,124},{-158,104},{-142,104}},
        color={255,127,0}));
  connect(selEquStaPhp3.nTot, removeFromStagingMultiple.nCoo) annotation (Line(
        points={{32,-232},{40,-232},{40,-180},{-160,-180},{-160,106},{-142,106}},
        color={255,127,0}));
  connect(y1Php1, removeFromStagingMultiple.u1Hea) annotation (Line(points={{
          220,0},{260,0},{260,114},{-150,114},{-150,96},{-142,96}}, color={255,
          0,255}));
  connect(y1Php2, removeFromStagingMultiple.u1Shc) annotation (Line(points={{
          220,-40},{252,-40},{252,112},{-150,112},{-150,92},{-142,92}}, color={
          255,0,255}));
  connect(y1Php1Opp, removeFromStagingMultiple.u1Coo) annotation (Line(points={
          {220,-240},{264,-240},{264,116},{-154,116},{-154,94},{-142,94}},
        color={255,0,255}));
  connect(removeFromStagingMultiple.yIdxSorShc, selSorAvaPhp2.uIdxSor)
    annotation (Line(points={{-118,92},{56,92},{56,-34},{68,-34}}, color={255,
          127,0}));
  connect(removeFromStagingMultiple.yIdxSorCoo, selSorAvaPhp3.uIdxSor)
    annotation (Line(points={{-118,100},{56,100},{56,-234},{68,-234}}, color={
          255,127,0}));
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
<h4>State alternation</h4>
<p>
Heat pumps are lead/lag controlled as specified in
  <a href=\"modelica://Buildings.Templates.Plants.Controls.StagingRotation.SortRuntime\">
    Buildings.Templates.Plants.Controls.StagingRotation.SortRuntime</a>,
in all operating modes.  
</p>
<p>
A single runtime point accumulates per heat pump inclusive of 
all operating mode runtimes. 
</p>
<h4>Mode alternation</h4>
<h5>Plants with reversible heat pumps</h5>
<p>
Alternation between heating and cooling mode is subject to the requirements
specified in 
  <a href=\"modelica://Buildings.Templates.Plants.Controls.HeatPumps.Subsequences.EquipmentAvailability\">
    Buildings.Templates.Plants.Controls.HeatPumps.Subsequences.EquipmentAvailability</a>.
</p>
<h5>Plants with polyvalents heat pumps</h5>
<p>
Alternation between heating-only and cooling-only mode is subject to the requirements
specified in 
  <a href=\"modelica://Buildings.Templates.Plants.Controls.HeatPumps.Subsequences.EquipmentAvailability\">
    Buildings.Templates.Plants.Controls.HeatPumps.Subsequences.EquipmentAvailability</a>.
</p>
<p>
Alternation between single mode and SHC mode is subject to the requirements
specified in 
  <a href=\"modelica://Buildings.Templates.Plants.Controls.PolyvalentHeatPumps.ModeAlternation\">
    Buildings.Templates.Plants.Controls.PolyvalentHeatPumps.RemoveFromStagingOrder</a>.
</p>
</html>"));
end EquipmentEnable;
