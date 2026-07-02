within Buildings.Templates.Plants.Controls.HeatPumps.Subsequences;
block SelectModeState
  "Equipment state and mode selection at a given stage"
  parameter Boolean have_chiWat
    "Set to true for plants that provide CHW"
    annotation(Evaluate=true);
  parameter Integer nStaHp(start=nHp)
    "Number of stages in HP staging matrix"
    annotation (Evaluate=true, Dialog(enable=nPhp == 0));
  parameter Real staHp[:, :](
    each final unit="1",
    each final min=0,
    each final max=1) = {min(iSta, nHp)/nHp for _ in 1:nHp, iSta in 1:nStaHp}
    "HP staging matrix – Equipment required for each stage"
    annotation (Evaluate=true, Dialog(enable=nPhp == 0));
  final parameter Real traStaHp[:, :]=
    {staHp[i, j] for i in 1:nStaHp, j in 1:nHp}
    "Transpose of staging matrix";
  parameter Integer nHp
    "Number of reversible heat pumps"
    annotation(Evaluate=true);
  parameter Integer nAltHp_select(start=nHp) = nHp
    "Number of reversible heat pumps subject to lead/lag alternation"
    annotation(Evaluate=true, Dialog(enable=nPhp == 0));
  final parameter Integer nAltHp = if nPhp > 0 then nHp else nAltHp_select
    "Number of reversible heat pumps subject to lead/lag alternation"
    annotation(Evaluate=true, Dialog(enable=nPhp == 0));
  parameter Integer nPhp
    "Number of polyvalent units"
    annotation(Evaluate=true);
  final parameter Integer nSta = if nPhp > 0 then nHp + nPhp else size(staHp, 1)
    "Number of stages";
  final parameter Integer nCol = if nPhp > 0 then nHp + 2 * nPhp else size(staHp, 2)
    "Number of columns in staging matrix";
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uIdxSorHp[nAltHp]
    if nHp > 0 "Indices of heat pumps sorted by increasing runtime" annotation
    (Placement(transformation(extent={{-260,100},{-220,140}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uStaHea
    "Heating stage index" annotation (Placement(transformation(extent={{-260,-20},
            {-220,20}}), iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1AvaHeaHp[nHp] if nHp > 0
    "HP heating mode available signal" annotation (Placement(transformation(
          extent={{-260,-220},{-220,-180}}), iconTransformation(extent={{-140,-40},
            {-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput staTraHea[nCol,nSta]
    if nPhp > 0
    "Transpose of heating staging matrix at current cooling stage" annotation (
      Placement(transformation(extent={{-260,20},{-220,60}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1HeaHp[nHp] if nHp > 0
    "HP heating mode command" annotation (Placement(transformation(extent={{220,100},
            {260,140}}),      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor reqEquStaHea[nCol](each
      final nin=nSta) "Extract equipment required at given heating stage"
    annotation (Placement(transformation(extent={{-104,30},{-84,50}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(
    final nout=nCol)
    "Replicate signal"
    annotation(Placement(transformation(extent={{-140,-10},{-120,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant one(final k=1)
    "Constant"
    annotation(Placement(transformation(extent={{-200,10},{-180,30}})));
  Buildings.Controls.OBC.CDL.Integers.Max maxInt
    "Maximum between stage index and 1"
    annotation(Placement(transformation(extent={{-170,-10},{-150,10}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold greZer(final t=0)
    "Check if stage index is greater than zero"
    annotation(Placement(transformation(extent={{-200,-50},{-180,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    final realTrue=1,
    final realFalse=0)
    "Cast to real"
    annotation(Placement(transformation(extent={{-170,-50},{-150,-30}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(
    final nout=nCol)
    "Replicate signal"
    annotation(Placement(transformation(extent={{-140,-50},{-120,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply voiStaZer[nCol]
    "Void if stage is equal to zero"
    annotation(Placement(transformation(extent={{-70,-10},{-50,10}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractSignal reqHpStaHea(
    nin=nCol,
    nout=nHp,
    extract={i for i in 1:nHp}) if nHp > 0
    "Extract heat pumps required at given heating stage"
    annotation (Placement(transformation(extent={{-32,130},{-12,150}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractSignal reqPhp1Sta(
    nin=nCol,
    nout=nPhp,
    extract={nHp + i for i in 1:nPhp}) if nPhp > 0
    "Extract polyvalent units required in single mode at given stage"
    annotation(Placement(transformation(extent={{-32,-10},{-12,10}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractSignal reqPhp2Sta(
    nin=nCol,
    nout=nPhp,
    extract={nHp + nPhp + i for i in 1:nPhp}) if nPhp > 0
    "Extract polyvalent units required in SHC mode at given stage"
    annotation(Placement(transformation(extent={{-32,-50},{-12,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uIdxSorPhp[nPhp]
    if nPhp > 0 "Indices of polyvalent units sorted by increasing runtime"
    annotation (Placement(transformation(extent={{-260,80},{-220,120}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1AvaHeaPhp[nPhp]
    if nPhp > 0 "Polyvalent HP heating-only mode available signal"
    annotation (Placement(transformation(extent={{-260,-260},{-220,-220}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1AvaShcPhp[nPhp]
    if nPhp > 0 "Polyvalent HP SHC mode available signal" annotation (
      Placement(transformation(extent={{-260,-300},{-220,-260}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  StagingRotation.BaseClasses.SelectSortedAvailable selSorAvaHeaHp(final nEqu=
        nHp, final nEquAlt=nAltHp) if nHp > 0
    "Select units by priority order and availability – HP"
    annotation (Placement(transformation(extent={{88,110},{108,130}})));
  StagingRotation.BaseClasses.SelectSortedAvailable selSorAvaPhp1(final nEqu=
        nPhp, final nEquAlt=nPhp) if nPhp > 0
    "Select units by priority order and availability – Polyvalent HP in single mode"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  StagingRotation.BaseClasses.SelectSortedAvailable selSorAvaPhp2(final nEqu=
        nPhp, final nEquAlt=nPhp) if nPhp > 0
    "Select units by priority order and availability – Polyvalent HP in SHC mode"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
  Buildings.Controls.OBC.CDL.Logical.And isHpAvaAltNee[nHp] if nHp > 0
    "True if available and lead/lag alternate needed to meet stage requirement"
    annotation (Placement(transformation(extent={{130,110},{150,130}})));
  Buildings.Controls.OBC.CDL.Logical.And isPhp1AvaReqOrAltNee1[nPhp] if nPhp > 0
    "True if available and required or indexed as lead/lag alternate and needed to meet stage requirement"
    annotation (Placement(transformation(extent={{130,-10},{150,10}})));
  Buildings.Controls.OBC.CDL.Logical.And isPhp2AvaReqOrAltNee[nPhp] if nPhp > 0
    "Return true if equipment available and required or lead/lag alternate and needed to meet stage requirement"
    annotation (Placement(transformation(extent={{130,-50},{150,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1HeaPhp[nPhp]
    if nPhp > 0 "Polyvalent HP heating-only mode command" annotation (
      Placement(transformation(extent={{220,-20},{260,20}}), iconTransformation(
          extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ShcPhp[nPhp]
    if nPhp > 0 "Polyvalent HP SHC mode command" annotation (Placement(
        transformation(extent={{220,-60},{260,-20}}), iconTransformation(extent={{100,-60},
            {140,-20}})));
  StagingRotation.BaseClasses.SelectEquipmentAtStage selEquStaHp(final nEqu=nHp)
    if nHp > 0 "Select equipment at stage"
    annotation (Placement(transformation(extent={{8,130},{28,150}})));
  StagingRotation.BaseClasses.SelectEquipmentAtStage selEquStaPhp1(final nEqu=
        nPhp) if nPhp > 0 "Select equipment at stage"
    annotation (Placement(transformation(extent={{8,-10},{28,10}})));
  StagingRotation.BaseClasses.SelectEquipmentAtStage selEquStaPhp2(final nEqu=
        nPhp) if nPhp > 0 "Select equipment at stage"
    annotation (Placement(transformation(extent={{8,-50},{28,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1HeaOrShcPhp[nPhp]
    if nPhp > 0
    "True if polyvalent HP commanded on in heating-only or SHC mode"
    annotation (Placement(transformation(extent={{220,-100},{260,-60}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Or on1Or2[nPhp] if nPhp > 0
    "True if polyvalent HP commanded on in either single mode or SHC mode"
    annotation (Placement(transformation(extent={{170,-90},{190,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1HeaHpPhp[nHp + nPhp]
    "Heating mode command – HP (up to nHp) and polyvalent HP (from nHp+1)"
    annotation (Placement(transformation(extent={{220,80},{260,120}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Logical.Or enaHeaHp[nHp] if nHp > 0
    "Enable HP required without lead/lag alternate and available or lead/lag alternate to meet stage requirement"
    annotation (Placement(transformation(extent={{170,110},{190,130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant traMatStaHp[nCol,nSta](
    final k=traStaHp) if nPhp == 0 "Transpose of HP staging matrix"
    annotation (Placement(transformation(extent={{-200,50},{-180,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uStaCoo if have_chiWat
    "Cooling stage index"
    annotation (Placement(transformation(extent={{-260,-140},{-220,-100}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput staTraCoo[nCol,nSta]
    if nPhp > 0
    "Transpose of cooling staging matrix at current heating stage"
    annotation (Placement(transformation(extent={{-260,-100},{-220,-60}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor reqEquStaCoo[nCol](each
      final nin=nSta) if have_chiWat
    "Extract equipment required at given cooling stage"
    annotation (Placement(transformation(extent={{-104,-90},{-84,-70}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep1(final
      nout=nCol) if have_chiWat
    "Replicate signal"
    annotation(Placement(transformation(extent={{-140,-130},{-120,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Max maxInt1 if have_chiWat
    "Maximum between stage index and 1"
    annotation(Placement(transformation(extent={{-170,-130},{-150,-110}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold greZer1(final t=0)
    if have_chiWat
    "Check if stage index is greater than zero"
    annotation(Placement(transformation(extent={{-200,-170},{-180,-150}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1(final realTrue
      =1, final realFalse=0) if have_chiWat
    "Cast to real"
    annotation(Placement(transformation(extent={{-170,-170},{-150,-150}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep1(final nout
      =nCol) if have_chiWat
    "Replicate signal"
    annotation(Placement(transformation(extent={{-140,-170},{-120,-150}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply voiStaZer1
                                                     [nCol] if have_chiWat
    "Void if stage is equal to zero"
    annotation(Placement(transformation(extent={{-72,-130},{-52,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1AvaCooPhp[nPhp]
    if nPhp > 0 "Polyvalent HP cooling-only mode available signal"
    annotation (Placement(transformation(extent={{-260,-280},{-220,-240}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractSignal reqPhp1Sta1(
    nin=nCol,
    nout=nPhp,
    extract={nHp + i for i in 1:nPhp}) if nPhp > 0
    "Extract polyvalent units required in single mode at given stage"
    annotation(Placement(transformation(extent={{-34,-130},{-14,-110}})));
  StagingRotation.BaseClasses.SelectEquipmentAtStage selEquStaPhp3(final nEqu=
        nPhp) if nPhp > 0 "Select equipment at stage"
    annotation (Placement(transformation(extent={{8,-130},{28,-110}})));
  StagingRotation.BaseClasses.SelectSortedAvailable selSorAvaPhp3(final nEqu=
        nPhp, final nEquAlt=nPhp) if nPhp > 0
    "Select units by priority order and availability – Polyvalent HP in single mode"
    annotation (Placement(transformation(extent={{90,-130},{110,-110}})));
  Buildings.Controls.OBC.CDL.Logical.And isPhp1AvaReqOrAltNee2[nPhp] if nPhp > 0
    "True if available and required or indexed as lead/lag alternate and needed to meet stage requirement"
    annotation (Placement(transformation(extent={{130,-130},{150,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1CooPhp[nPhp]
    if nPhp > 0 "Polyvalent HP cooling-only mode command" annotation (
      Placement(transformation(extent={{220,-140},{260,-100}}),
        iconTransformation(extent={{100,-40},{140,0}})));
  PolyvalentHeatPumps.ModeAlternation selModPhp(final nPhp=nPhp) if nPhp > 0
    "Mode selection for polyvalent HP"
    annotation (Placement(transformation(extent={{50,-170},{70,-150}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractSignal reqHpStaCoo(
    nin=nCol,
    nout=nHp,
    extract={i for i in 1:nHp}) if nHp > 0 and have_chiWat
    "Extract heat pumps required at given cooling stage"
    annotation (Placement(transformation(extent={{-32,70},{-12,90}})));
  StagingRotation.BaseClasses.SelectSortedAvailable selSorAvaCooHp(final nEqu=
        nHp, final nEquAlt=nAltHp) if nHp > 0 and have_chiWat
    "Select units by priority order and availability – HP"
    annotation (Placement(transformation(extent={{88,70},{108,90}})));
  Buildings.Controls.OBC.CDL.Logical.And isHpAvaAltNee1
                                                      [nHp]
    if nHp > 0 and have_chiWat
    "True if available and lead/lag alternate needed to meet stage requirement"
    annotation (Placement(transformation(extent={{130,70},{150,90}})));
  StagingRotation.BaseClasses.SelectEquipmentAtStage selEquStaHp1(final nEqu=
        nHp) if nHp > 0 and have_chiWat
               "Select equipment at stage"
    annotation (Placement(transformation(extent={{8,70},{28,90}})));
  Buildings.Controls.OBC.CDL.Logical.Or enaCooHp[nHp] if nHp > 0 and
    have_chiWat
    "Enable HP required without lead/lag alternate and available or lead/lag alternate to meet stage requirement"
    annotation (Placement(transformation(extent={{170,70},{190,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1CooHp[nHp]
    if nHp > 0 and have_chiWat
    "HP cooling mode command" annotation (Placement(transformation(extent={{220,60},
            {260,100}}),     iconTransformation(extent={{100,18},{140,58}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1CooHpPhp[nHp + nPhp]
    if have_chiWat
    "Cooling mode command – HP (up to nHp) and polyvalent HP (from nHp+1)"
    annotation (Placement(transformation(extent={{220,40},{260,80}}),
        iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1AvaCooHp[nHp]
    if nHp > 0 and have_chiWat
    "HP cooling mode available signal" annotation (Placement(transformation(
          extent={{-260,-240},{-220,-200}}), iconTransformation(extent={{-140,
            -60},{-100,-20}})));
equation
  connect(intScaRep.y, reqEquStaHea.index)
    annotation (Line(points={{-118,0},{-94,0},{-94,28}}, color={255,127,0}));
  connect(one.y, maxInt.u1)
    annotation(Line(points={{-178,20},{-174,20},{-174,6},{-172,6}},
      color={255,127,0}));
  connect(uStaHea, maxInt.u2) annotation (Line(points={{-240,0},{-180,0},{-180,
          -6},{-172,-6}},
                      color={255,127,0}));
  connect(maxInt.y, intScaRep.u)
    annotation(Line(points={{-148,0},{-142,0}},
      color={255,127,0}));
  connect(uStaHea, greZer.u) annotation (Line(points={{-240,0},{-210,0},{-210,-40},
          {-202,-40}}, color={255,127,0}));
  connect(greZer.y, booToRea.u)
    annotation(Line(points={{-178,-40},{-172,-40}},
      color={255,0,255}));
  connect(booToRea.y, reaScaRep.u)
    annotation(Line(points={{-148,-40},{-142,-40}},
      color={0,0,127}));
  connect(reqEquStaHea.y, voiStaZer.u1) annotation (Line(points={{-82,40},{-80,
          40},{-80,6},{-72,6}}, color={0,0,127}));
  connect(reaScaRep.y, voiStaZer.u2)
    annotation(Line(points={{-118,-40},{-80,-40},{-80,-6},{-72,-6}},
      color={0,0,127}));
  connect(staTraHea, reqEquStaHea.u)
    annotation (Line(points={{-240,40},{-106,40}}, color={0,0,127}));
  connect(voiStaZer.y, reqHpStaHea.u) annotation (Line(points={{-48,0},{-40,0},{
          -40,140},{-34,140}}, color={0,0,127}));
  connect(voiStaZer.y, reqPhp1Sta.u)
    annotation(Line(points={{-48,0},{-34,0}},
      color={0,0,127}));
  connect(voiStaZer.y, reqPhp2Sta.u)
    annotation(Line(points={{-48,0},{-40,0},{-40,-40},{-34,-40}},
      color={0,0,127}));
  connect(uIdxSorHp, selSorAvaHeaHp.uIdxSor) annotation (Line(points={{-240,120},
          {60,120},{60,126},{86,126}}, color={255,127,0}));
  connect(u1AvaHeaHp, selSorAvaHeaHp.u1Ava) annotation (Line(points={{-240,-200},
          {78,-200},{78,114},{86,114}}, color={255,0,255}));
  connect(u1AvaHeaPhp, selSorAvaPhp1.u1Ava) annotation (Line(points={{-240,-240},
          {82,-240},{82,-6},{88,-6}}, color={255,0,255}));
  connect(selSorAvaHeaHp.y1, isHpAvaAltNee.u1)
    annotation (Line(points={{110,120},{128,120}}, color={255,0,255}));
  connect(selSorAvaPhp1.y1, isPhp1AvaReqOrAltNee1.u1)
    annotation (Line(points={{112,0},{128,0}},color={255,0,255}));
  connect(selSorAvaPhp2.y1, isPhp2AvaReqOrAltNee.u1)
    annotation (Line(points={{112,-40},{128,-40}},color={255,0,255}));
  connect(reqHpStaHea.y, selEquStaHp.uEquSta)
    annotation (Line(points={{-10,140},{6,140}},color={0,0,127}));
  connect(reqPhp1Sta.y, selEquStaPhp1.uEquSta)
    annotation(Line(points={{-10,0},{6,0}},
      color={0,0,127}));
  connect(reqPhp2Sta.y, selEquStaPhp2.uEquSta)
    annotation(Line(points={{-10,-40},{6,-40}},
      color={0,0,127}));
  connect(u1AvaHeaHp, selEquStaHp.u1Ava) annotation (Line(points={{-240,-200},{
          -4,-200},{-4,134},{6,134}},
                                  color={255,0,255}));
  connect(u1AvaHeaPhp, selEquStaPhp1.u1Ava) annotation (Line(points={{-240,-240},
          {0,-240},{0,-6},{6,-6}}, color={255,0,255}));
  connect(selEquStaPhp1.nTot, selSorAvaPhp1.n)
    annotation(Line(points={{30,8},{32,8},{32,0},{88,0}},
      color={255,127,0}));
  connect(selEquStaPhp2.nTot, selSorAvaPhp2.n)
    annotation(Line(points={{30,-32},{34,-32},{34,-40},{88,-40}},
      color={255,127,0}));
  connect(selEquStaPhp2.y1ReqOrAltAndAva, isPhp2AvaReqOrAltNee.u2) annotation (
      Line(points={{30,-44},{40,-44},{40,-56},{120,-56},{120,-48},{128,-48}},
        color={255,0,255}));
  connect(selEquStaPhp1.y1ReqOrAltAndAva, isPhp1AvaReqOrAltNee1.u2) annotation
    (Line(points={{30,-4},{40,-4},{40,-16},{120,-16},{120,-8},{128,-8}},
                                                                       color={255,
          0,255}));
  connect(on1Or2.y, y1HeaOrShcPhp)
    annotation (Line(points={{192,-80},{240,-80}},   color={255,0,255}));
  connect(isPhp1AvaReqOrAltNee1.y, on1Or2.u1) annotation (Line(points={{152,0},{
          160,0},{160,-80},{168,-80}}, color={255,0,255}));
  connect(isPhp2AvaReqOrAltNee.y, on1Or2.u2) annotation (Line(points={{152,-40},
          {156,-40},{156,-88},{168,-88}}, color={255,0,255}));
  connect(isPhp1AvaReqOrAltNee1.y, y1HeaHpPhp[nHp + 1:nHp + nPhp]) annotation (
      Line(points={{152,0},{200,0},{200,100},{240,100}}, color={255,0,255}));
  connect(isHpAvaAltNee.y, enaHeaHp.u1)
    annotation (Line(points={{152,120},{168,120}}, color={255,0,255}));
  connect(traMatStaHp.y, reqEquStaHea.u) annotation (Line(points={{-178,60},{-110,
          60},{-110,40},{-106,40}}, color={0,0,127}));
  connect(enaHeaHp.y, y1HeaHp)
    annotation (Line(points={{192,120},{240,120}}, color={255,0,255}));
  connect(selEquStaHp.nAlt, selSorAvaHeaHp.n) annotation (Line(points={{30,144},
          {38,144},{38,120},{86,120}}, color={255,127,0}));
  connect(selEquStaHp.y1AltAndAva, isHpAvaAltNee.u2) annotation (Line(points={{30,138},
          {56,138},{56,102},{118,102},{118,112},{128,112}},color={255,0,255}));
  connect(selEquStaHp.y1ReqAndAva, enaHeaHp.u2) annotation (Line(points={{30,140},
          {58,140},{58,100},{160,100},{160,112},{168,112}}, color={255,0,255}));
  connect(enaHeaHp.y, y1HeaHpPhp[1:nHp]) annotation (Line(points={{192,120},{
          200,120},{200,100},{240,100}}, color={255,0,255}));
  connect(isPhp1AvaReqOrAltNee1.y, y1HeaPhp)
    annotation (Line(points={{152,0},{240,0}}, color={255,0,255}));
  connect(isPhp2AvaReqOrAltNee.y, y1ShcPhp)
    annotation (Line(points={{152,-40},{240,-40}}, color={255,0,255}));
  connect(u1AvaShcPhp, selEquStaPhp2.u1Ava) annotation (Line(points={{-240,-280},
          {2,-280},{2,-46},{6,-46}}, color={255,0,255}));
  connect(u1AvaShcPhp, selSorAvaPhp2.u1Ava) annotation (Line(points={{-240,-280},
          {84,-280},{84,-46},{88,-46}}, color={255,0,255}));
  connect(staTraCoo, reqEquStaCoo.u)
    annotation (Line(points={{-240,-80},{-106,-80}}, color={0,0,127}));
  connect(uStaCoo, maxInt1.u2) annotation (Line(points={{-240,-120},{-180,-120},
          {-180,-126},{-172,-126}},             color={255,127,0}));
  connect(maxInt1.y, intScaRep1.u)
    annotation (Line(points={{-148,-120},{-142,-120}}, color={255,127,0}));
  connect(intScaRep1.y, reqEquStaCoo.index) annotation (Line(points={{-118,-120},
          {-94,-120},{-94,-92}}, color={255,127,0}));
  connect(greZer1.y, booToRea1.u)
    annotation (Line(points={{-178,-160},{-172,-160}}, color={255,0,255}));
  connect(booToRea1.y, reaScaRep1.u)
    annotation (Line(points={{-148,-160},{-142,-160}}, color={0,0,127}));
  connect(uStaCoo, greZer1.u) annotation (Line(points={{-240,-120},{-212,-120},{
          -212,-160},{-202,-160}}, color={255,127,0}));
  connect(reqEquStaCoo.y, voiStaZer1.u1) annotation (Line(points={{-82,-80},{-80,
          -80},{-80,-114},{-74,-114}}, color={0,0,127}));
  connect(reaScaRep1.y, voiStaZer1.u2) annotation (Line(points={{-118,-160},{-100,
          -160},{-100,-126},{-74,-126}},color={0,0,127}));
  connect(voiStaZer1.y, reqPhp1Sta1.u)
    annotation (Line(points={{-50,-120},{-36,-120}}, color={0,0,127}));
  connect(reqPhp1Sta1.y, selEquStaPhp3.uEquSta)
    annotation (Line(points={{-12,-120},{6,-120}}, color={0,0,127}));
  connect(u1AvaCooPhp, selEquStaPhp3.u1Ava) annotation (Line(points={{-240,-260},
          {4,-260},{4,-126},{6,-126}}, color={255,0,255}));
  connect(isPhp1AvaReqOrAltNee2.y, y1CooPhp)
    annotation (Line(points={{152,-120},{240,-120}}, color={255,0,255}));
  connect(selEquStaPhp3.nTot, selSorAvaPhp3.n) annotation (Line(points={{30,-112},
          {38,-112},{38,-120},{88,-120}}, color={255,127,0}));
  connect(u1AvaCooPhp, selSorAvaPhp3.u1Ava) annotation (Line(points={{-240,-260},
          {88,-260},{88,-126}},           color={255,0,255}));
  connect(selSorAvaPhp3.y1, isPhp1AvaReqOrAltNee2.u1)
    annotation (Line(points={{112,-120},{128,-120}},color={255,0,255}));
  connect(uIdxSorPhp,selModPhp. uIdxSor) annotation (Line(points={{-240,100},{36,
          100},{36,-160},{48,-160}},color={255,127,0}));
  connect(selModPhp.yIdxSorHea, selSorAvaPhp1.uIdxSor) annotation (Line(points={{72,-152},
          {74,-152},{74,6},{88,6}},         color={255,127,0}));
  connect(selEquStaPhp3.nTot,selModPhp. nCoo) annotation (Line(points={{30,-112},
          {38,-112},{38,-154},{48,-154}},                      color={255,127,0}));
  connect(y1HeaPhp,selModPhp. u1Hea) annotation (Line(points={{240,0},{210,0},{210,
          -180},{40,-180},{40,-164},{48,-164}},color={255,0,255}));
  connect(y1ShcPhp,selModPhp. u1Shc) annotation (Line(points={{240,-40},{206,-40},
          {206,-176},{44,-176},{44,-168},{48,-168}},color={255,0,255}));
  connect(y1CooPhp,selModPhp. u1Coo) annotation (Line(points={{240,-120},{208,-120},
          {208,-178},{42,-178},{42,-166},{48,-166}},color={255,0,255}));
  connect(selModPhp.yIdxSorShc, selSorAvaPhp2.uIdxSor) annotation (Line(points={{72,-168},
          {76,-168},{76,-34},{88,-34}},         color={255,127,0}));
  connect(selModPhp.yIdxSorCoo, selSorAvaPhp3.uIdxSor) annotation (Line(points={{72,-160},
          {86,-160},{86,-114},{88,-114}},         color={255,127,0}));
  connect(uIdxSorHp, selSorAvaCooHp.uIdxSor) annotation (Line(points={{-240,120},
          {60,120},{60,86},{86,86}}, color={255,127,0}));
  connect(selSorAvaCooHp.y1, isHpAvaAltNee1.u1)
    annotation (Line(points={{110,80},{128,80}}, color={255,0,255}));
  connect(reqHpStaCoo.y, selEquStaHp1.uEquSta)
    annotation (Line(points={{-10,80},{6,80}},color={0,0,127}));
  connect(isHpAvaAltNee1.y, enaCooHp.u1)
    annotation (Line(points={{152,80},{168,80}}, color={255,0,255}));
  connect(selEquStaHp1.nAlt, selSorAvaCooHp.n) annotation (Line(points={{30,84},
          {38,84},{38,80},{86,80}}, color={255,127,0}));
  connect(selEquStaHp1.y1AltAndAva, isHpAvaAltNee1.u2) annotation (Line(points={{30,78},
          {56,78},{56,62},{118,62},{118,72},{128,72}},         color={255,0,255}));
  connect(selEquStaHp1.y1ReqAndAva, enaCooHp.u2) annotation (Line(points={{30,80},
          {58,80},{58,60},{160,60},{160,72},{168,72}}, color={255,0,255}));
  connect(selEquStaPhp1.nTot,selModPhp. nHea) annotation (Line(points={{30,8},{32,
          8},{32,-152},{48,-152}},                    color={255,127,0}));
  connect(selEquStaPhp2.nTot,selModPhp. nShc) annotation (Line(points={{30,-32},
          {34,-32},{34,-156},{48,-156}},                    color={255,127,0}));
  connect(enaCooHp.y, y1CooHp)
    annotation (Line(points={{192,80},{240,80}}, color={255,0,255}));
  connect(u1AvaCooHp, selSorAvaCooHp.u1Ava) annotation (Line(points={{-240,-220},
          {80,-220},{80,74},{86,74}}, color={255,0,255}));
  connect(traMatStaHp.y, reqEquStaCoo.u) annotation (Line(points={{-178,60},{-110,
          60},{-110,-80},{-106,-80}}, color={0,0,127}));
  connect(one.y, maxInt1.u1) annotation (Line(points={{-178,20},{-174,20},{-174,
          -114},{-172,-114}}, color={255,127,0}));
  connect(voiStaZer1.y, reqHpStaCoo.u) annotation (Line(points={{-50,-120},{-44,
          -120},{-44,80},{-34,80}}, color={0,0,127}));
  connect(selEquStaPhp3.y1ReqOrAltAndAva, isPhp1AvaReqOrAltNee2.u2) annotation
    (Line(points={{30,-124},{40,-124},{40,-136},{120,-136},{120,-128},{128,-128}},
        color={255,0,255}));
  connect(enaCooHp.y, y1CooHpPhp[1:nHp]) annotation (Line(points={{192,80},{202,
          80},{202,60},{240,60}}, color={255,0,255}));
  connect(isPhp1AvaReqOrAltNee2.y, y1CooHpPhp[nHp + 1:nHp + nPhp]) annotation (
      Line(points={{152,-120},{202,-120},{202,60},{240,60}}, color={255,0,255}));
  connect(u1AvaCooHp, selEquStaHp1.u1Ava) annotation (Line(points={{-240,-220},
          {-2,-220},{-2,74},{6,74}}, color={255,0,255}));
annotation(defaultComponentName="selMod",
  Icon(coordinateSystem(preserveAspectRatio=true),
    graphics={
    Text(extent={{-150,150},{150,110}},
      textString="%name",
      textColor={0,0,255}),
              Rectangle(extent={{-100,100},{100,-100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid)}),
  Diagram(coordinateSystem(extent={{-220,-300},{220,160}}, grid={2,2})),
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
end SelectModeState;
