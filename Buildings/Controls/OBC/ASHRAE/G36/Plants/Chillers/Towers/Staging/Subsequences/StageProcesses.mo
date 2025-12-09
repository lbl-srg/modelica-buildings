within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.Staging.Subsequences;
block StageProcesses "Sequence for process of staging cells"

  parameter Integer nTowCel = 4
    "Total number of cooling tower cells";
  parameter Boolean have_endSwi=false
    "True: tower cells isolation valve have end switch";
  parameter Boolean have_outIsoVal=false
    "True: tower cells also have outlet isolation valve"
    annotation (Dialog(enable=have_endSwi));
  parameter Real chaTowCelIsoTim(unit="s")=90
    "Nominal time needed for open or close isolation valve"
    annotation (Dialog(enable=not have_endSwi));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChaCel[nTowCel]
    "Vector of boolean flags to show if a cell should change its status: true = the cell should change status (be enabled or disabled)"
    annotation (Placement(transformation(extent={{-240,390},{-200,430}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1InlIsoValOpe[nTowCel]
    if have_endSwi
    "Tower cells inlet isolation valve open end switch. True: the isolation valve is fully open"
    annotation (Placement(transformation(extent={{-240,120},{-200,160}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1OutIsoValOpe[nTowCel]
    if have_endSwi and have_outIsoVal
    "Tower cells outlet isolation valve open end switch. True: the isolation valve is fully open"
    annotation (Placement(transformation(extent={{-240,40},{-200,80}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1InlIsoValClo[nTowCel]
    if have_endSwi
    "Tower cells inlet isolation valve close end switch. True: the isolation valve is fully closed"
    annotation (Placement(transformation(extent={{-240,0},{-200,40}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1OutIsoValClo[nTowCel]
    if have_endSwi and have_outIsoVal
    "Tower cells outlet isolation valve close end switch. True: the isolation valve is fully closed"
    annotation (Placement(transformation(extent={{-240,-80},{-200,-40}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTowSta[nTowCel]
    "Vector of tower cells proven on status: true=enabled tower cell"
    annotation (Placement(transformation(extent={{-240,-260},{-200,-220}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1IsoVal[nTowCel]
    "Cooling tower cells isolation valve command"
    annotation (Placement(transformation(extent={{200,280},{240,320}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yTowSta[nTowCel]
    "Vector of tower cells command"
    annotation (Placement(transformation(extent={{200,-230},{240,-190}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEndSta
    "Rising edge to indicate the staging process is done"
    annotation (Placement(transformation(extent={{200,-420},{240,-380}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

protected
  Buildings.Controls.OBC.CDL.Logical.And and1[nTowCel]
    "True: cells should be enabled"
    annotation (Placement(transformation(extent={{40,-180},{60,-160}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[nTowCel](
    final k=fill(true, nTowCel)) "Enable cells"
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Switch enaNexCel[nTowCel]
    "Enable next cells"
    annotation (Placement(transformation(extent={{100,-180},{120,-160}})));
  Buildings.Controls.OBC.CDL.Logical.And and2[nTowCel] "Logical and"
    annotation (Placement(transformation(extent={{-120,310},{-100,330}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1[nTowCel] "Logical and"
    annotation (Placement(transformation(extent={{-60,310},{-40,330}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd enaCel(
    final nin=nTowCel) "New cells should be enabled"
    annotation (Placement(transformation(extent={{-20,310},{0,330}})));
  Buildings.Controls.OBC.CDL.Logical.And enaPro "Enabling cells process"
    annotation (Placement(transformation(extent={{-60,-220},{-40,-200}})));
  Buildings.Controls.OBC.CDL.Logical.Not disCel "Disable cell"
    annotation (Placement(transformation(extent={{-100,210},{-80,230}})));
  Buildings.Controls.OBC.CDL.Logical.And disPro "Disabling cells process"
    annotation (Placement(transformation(extent={{-20,200},{0,220}})));
  Buildings.Controls.OBC.CDL.Logical.Switch newTowCell[nTowCel]
    "New tower cell status"
    annotation (Placement(transformation(extent={{160,-220},{180,-200}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep2(
    final nout=nTowCel) "In the enabling process"
    annotation (Placement(transformation(extent={{-20,-220},{0,-200}})));
  Buildings.Controls.OBC.CDL.Logical.Switch disExiCel[nTowCel]
    "Disable existing cells"
    annotation (Placement(transformation(extent={{100,-330},{120,-310}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep3(
    final nout=nTowCel) "In the disabling process"
    annotation (Placement(transformation(extent={{0,-330},{20,-310}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr staPro(nin=nTowCel)
    "In tower staging process"
    annotation (Placement(transformation(extent={{60,400},{80,420}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep4(
    final nout=nTowCel) "In the disabling process"
    annotation (Placement(transformation(extent={{120,-380},{140,-360}})));
  Buildings.Controls.OBC.CDL.Logical.Or celChaSta[nTowCel]
    "True: there are cells changed status"
    annotation (Placement(transformation(extent={{-80,-410},{-60,-390}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg[nTowCel]
    "Check if there is any cell being disabled"
    annotation (Placement(transformation(extent={{-140,-390},{-120,-370}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg[nTowCel]
    "Check if there is any cell being enabled"
    annotation (Placement(transformation(extent={{-140,-430},{-120,-410}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr endStaPro(
    final nin=nTowCel)
    "Check if there is any cell changed status so it means that the staging process is done"
    annotation (Placement(transformation(extent={{40,-410},{60,-390}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat[nTowCel] "Change cells status"
    annotation (Placement(transformation(extent={{-120,400},{-100,420}})));
  Buildings.Controls.OBC.CDL.Logical.Edge havCha[nTowCel] "Edge"
    annotation (Placement(transformation(extent={{-180,400},{-160,420}})));
  Buildings.Controls.OBC.CDL.Logical.And and4[nTowCel]
    "True: cells should be disabled"
    annotation (Placement(transformation(extent={{-80,-280},{-60,-260}})));
  Buildings.Controls.OBC.CDL.Logical.Switch disExiCel1[nTowCel]
    "Disable existing cells"
    annotation (Placement(transformation(extent={{40,-300},{60,-280}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2[nTowCel](
    final k=fill(false, nTowCel))
    "Disable cells"
    annotation (Placement(transformation(extent={{-20,-280},{0,-260}})));
  Buildings.Controls.OBC.CDL.Logical.Not disCelVec[nTowCel]
    "New cell command when it is to disable cell"
    annotation (Placement(transformation(extent={{40,260},{60,280}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(
    final nout=nTowCel)
    "In the enabling process"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep5(
    final nout=nTowCel)
    "In the enabling process"
    annotation (Placement(transformation(extent={{-20,-150},{0,-130}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal opeValFla[nTowCel] if have_endSwi
    "1: cell is fully open"
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cloValFla[nTowCel] if have_endSwi
    "1: cell is fully closed"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum totOpe(
    final nin=nTowCel) if have_endSwi
    "Total number of open valves"
    annotation (Placement(transformation(extent={{-60,130},{-40,150}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum totClo(
    final nin=nTowCel) if have_endSwi
    "Total number of closed valves"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch celVec[nTowCel]
    "New cell command"
    annotation (Placement(transformation(extent={{160,290},{180,310}})));
  Buildings.Controls.OBC.CDL.Logical.Or enaCelVec[nTowCel]
    "New cell command when it is to enable cell"
    annotation (Placement(transformation(extent={{60,340},{80,360}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep(
    final nout=nTowCel)
    "Duplicate boolean"
    annotation (Placement(transformation(extent={{60,290},{80,310}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger chaValSta[nTowCel]
    "1: valve status should be changed"
    annotation (Placement(transformation(extent={{-60,240},{-40,260}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1[nTowCel]
    "Check if inputs equal"
    annotation (Placement(transformation(extent={{0,260},{20,280}})));
  Buildings.Controls.OBC.CDL.Logical.Switch celVec1[nTowCel]
    "New cell command"
    annotation (Placement(transformation(extent={{100,190},{120,210}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep1(
    final nout=nTowCel)
    "Duplicate boolean"
    annotation (Placement(transformation(extent={{40,200},{60,220}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger enaCelSta[nTowCel]
    "1: cell is fully open"
    annotation (Placement(transformation(extent={{-100,260},{-80,280}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay newValCha(
    final delayTime=chaTowCelIsoTim)
    if not have_endSwi
    "New valve status being fully changed"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam if have_endSwi
    "Number of fully open valves at the moment when the valve status needs change"
    annotation (Placement(transformation(extent={{0,130},{20,150}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam1 if have_endSwi
    "Number of fully closed valves at the moment when the valve status needs change"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Controls.OBC.CDL.Reals.Greater newFulOpe if have_endSwi
    "New fully open isolation valve"
    annotation (Placement(transformation(extent={{60,150},{80,170}})));
  Buildings.Controls.OBC.CDL.Reals.Greater newFulClo if have_endSwi
    "New fully closed isolation valve"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger opeValFla1[nTowCel]
    if have_endSwi and have_outIsoVal "1: cell is fully open"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger opeValFla2[nTowCel]
    if have_endSwi and have_outIsoVal "1: cell is fully open"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger cloValFla1[nTowCel]
    if have_endSwi and have_outIsoVal "1: cell is fully closed"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger cloValFla2[nTowCel]
    if have_endSwi and have_outIsoVal "1: cell is fully closed"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2[nTowCel]
    if have_endSwi and have_outIsoVal
    "Check if inputs equal"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu3[nTowCel]
    if have_endSwi and have_outIsoVal
    "Check if inputs equal"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd botOpe(nin=nTowCel) if have_endSwi and have_outIsoVal
    "Inlet and outlet valves have the same switch end"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd botClo(nin=nTowCel) if have_endSwi and have_outIsoVal
    "Inlet and outlet valves have the same switch end"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Logical.And newFulOpe1 if have_endSwi
    "New fully open isolation valve"
    annotation (Placement(transformation(extent={{120,150},{140,170}})));
  Buildings.Controls.OBC.CDL.Logical.And newFulClo1
    if have_endSwi and not have_outIsoVal
    "New fully closed isolation valve"
    annotation (Placement(transformation(extent={{120,30},{140,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=true) if have_endSwi and not have_outIsoVal
    "Constant true"
    annotation (Placement(transformation(extent={{60,110},{80,130}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con3(
    final k=true) if have_endSwi and not have_outIsoVal
    "Constant true"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));
  Buildings.Controls.OBC.CDL.Logical.Not difCloEnd if have_endSwi and have_outIsoVal
    "Inlet and outlet valves have the different switch end"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Or newFulClo2
    if have_endSwi and have_outIsoVal
    "New fully closed isolation valve"
    annotation (Placement(transformation(extent={{120,-30},{140,-10}})));

equation
  connect(and1.y, enaNexCel.u2)
    annotation (Line(points={{62,-170},{98,-170}}, color={255,0,255}));
  connect(con1.y, enaNexCel.u1) annotation (Line(points={{62,-130},{80,-130},{80,
          -162},{98,-162}}, color={255,0,255}));
  connect(uTowSta, enaNexCel.u3) annotation (Line(points={{-220,-240},{80,-240},
          {80,-178},{98,-178}}, color={255,0,255}));
  connect(uTowSta, and2.u2) annotation (Line(points={{-220,-240},{-180,-240},{-180,
          312},{-122,312}}, color={255,0,255}));
  connect(and2.y, not1.u)
    annotation (Line(points={{-98,320},{-62,320}}, color={255,0,255}));
  connect(not1.y, enaCel.u) annotation (Line(points={{-38,320},{-22,320}},
          color={255,0,255}));
  connect(enaCel.y, enaPro.u1) annotation (Line(points={{2,320},{20,320},{20,300},
          {-120,300},{-120,-210},{-62,-210}}, color={255,0,255}));
  connect(enaCel.y, disCel.u) annotation (Line(points={{2,320},{20,320},{20,300},
          {-120,300},{-120,220},{-102,220}}, color={255,0,255}));
  connect(disCel.y, disPro.u1)
    annotation (Line(points={{-78,220},{-40,220},{-40,210},{-22,210}}, color={255,0,255}));
  connect(booRep2.y, newTowCell.u2)
    annotation (Line(points={{2,-210},{158,-210}},   color={255,0,255}));
  connect(enaNexCel.y, newTowCell.u1) annotation (Line(points={{122,-170},{140,-170},
          {140,-202},{158,-202}}, color={255,0,255}));
  connect(booRep3.y, disExiCel.u2)
    annotation (Line(points={{22,-320},{98,-320}},  color={255,0,255}));
  connect(uTowSta, disExiCel.u3) annotation (Line(points={{-220,-240},{80,-240},
          {80,-328},{98,-328}}, color={255,0,255}));
  connect(disPro.y, booRep3.u) annotation (Line(points={{2,210},{20,210},{20,180},
          {-110,180},{-110,-320},{-2,-320}}, color={255,0,255}));
  connect(enaPro.y, booRep2.u) annotation (Line(points={{-38,-210},{-22,-210}},
          color={255,0,255}));
  connect(disExiCel.y, newTowCell.u3) annotation (Line(points={{122,-320},{140,-320},
          {140,-218},{158,-218}}, color={255,0,255}));
  connect(newTowCell.y, yTowSta)
    annotation (Line(points={{182,-210},{220,-210}}, color={255,0,255}));
  connect(staPro.y, disPro.u2) annotation (Line(points={{82,410},{100,410},{100,
          370},{-140,370},{-140,202},{-22,202}}, color={255,0,255}));
  connect(staPro.y, enaPro.u2) annotation (Line(points={{82,410},{100,410},{100,
          370},{-140,370},{-140,-218},{-62,-218}}, color={255,0,255}));
  connect(uTowSta, falEdg.u) annotation (Line(points={{-220,-240},{-180,-240},{-180,
          -380},{-142,-380}}, color={255,0,255}));
  connect(uTowSta, edg.u) annotation (Line(points={{-220,-240},{-180,-240},{-180,
          -420},{-142,-420}}, color={255,0,255}));
  connect(booRep4.y, lat.clr) annotation (Line(points={{142,-370},{160,-370},{160,
          -340},{-150,-340},{-150,404},{-122,404}}, color={255,0,255}));
  connect(falEdg.y, celChaSta.u1) annotation (Line(points={{-118,-380},{-100,-380},
          {-100,-400},{-82,-400}},color={255,0,255}));
  connect(edg.y, celChaSta.u2) annotation (Line(points={{-118,-420},{-100,-420},
          {-100,-408},{-82,-408}}, color={255,0,255}));
  connect(celChaSta.y, endStaPro.u) annotation (Line(points={{-58,-400},{38,-400}},
          color={255,0,255}));
  connect(uChaCel, havCha.u) annotation (Line(points={{-220,410},{-182,410}},
          color={255,0,255}));
  connect(havCha.y, lat.u) annotation (Line(points={{-158,410},{-122,410}},
          color={255,0,255}));
  connect(endStaPro.y, yEndSta)
    annotation (Line(points={{62,-400},{220,-400}},color={255,0,255}));
  connect(endStaPro.y, booRep4.u) annotation (Line(points={{62,-400},{80,-400},{
          80,-370},{118,-370}}, color={255,0,255}));
  connect(uTowSta, disExiCel1.u3) annotation (Line(points={{-220,-240},{-180,-240},
          {-180,-298},{38,-298}}, color={255,0,255}));
  connect(con2.y, disExiCel1.u1) annotation (Line(points={{2,-270},{20,-270},{20,
          -282},{38,-282}}, color={255,0,255}));
  connect(disExiCel1.y, disExiCel.u1) annotation (Line(points={{62,-290},{90,-290},
          {90,-312},{98,-312}}, color={255,0,255}));
  connect(lat.y, staPro.u)
    annotation (Line(points={{-98,410},{58,410}}, color={255,0,255}));
  connect(lat.y, and1.u2) annotation (Line(points={{-98,410},{-80,410},{-80,380},
          {-170,380},{-170,-178},{38,-178}}, color={255,0,255}));
  connect(lat.y, and2.u1) annotation (Line(points={{-98,410},{-80,410},{-80,380},
          {-170,380},{-170,320},{-122,320}}, color={255,0,255}));
  connect(u1InlIsoValClo, cloValFla.u)
    annotation (Line(points={{-220,20},{-102,20}}, color={255,0,255}));
  connect(lat.y, enaCelVec.u1) annotation (Line(points={{-98,410},{-80,410},{-80,
          380},{-170,380},{-170,350},{58,350}}, color={255,0,255}));
  connect(enaCel.y, booScaRep.u) annotation (Line(points={{2,320},{20,320},{20,300},
          {58,300}}, color={255,0,255}));
  connect(booScaRep.y, celVec.u2)
    annotation (Line(points={{82,300},{158,300}}, color={255,0,255}));
  connect(enaCelVec.y, celVec.u1) annotation (Line(points={{82,350},{100,350},{100,
          308},{158,308}}, color={255,0,255}));
  connect(lat.y, chaValSta.u) annotation (Line(points={{-98,410},{-80,410},{-80,
          380},{-170,380},{-170,250},{-62,250}},  color={255,0,255}));
  connect(chaValSta.y, intEqu1.u2) annotation (Line(points={{-38,250},{-20,250},
          {-20,262},{-2,262}},  color={255,127,0}));
  connect(intEqu1.y, disCelVec.u)
    annotation (Line(points={{22,270},{38,270}},color={255,0,255}));
  connect(uTowSta, enaCelVec.u2) annotation (Line(points={{-220,-240},{-180,-240},
          {-180,342},{58,342}}, color={255,0,255}));
  connect(disPro.y, booScaRep1.u)
    annotation (Line(points={{2,210},{38,210}}, color={255,0,255}));
  connect(booScaRep1.y, celVec1.u2) annotation (Line(points={{62,210},{70,210},{
          70,200},{98,200}}, color={255,0,255}));
  connect(disCelVec.y, celVec1.u1) annotation (Line(points={{62,270},{80,270},{80,
          208},{98,208}}, color={255,0,255}));
  connect(celVec1.y, celVec.u3) annotation (Line(points={{122,200},{140,200},{140,
          292},{158,292}}, color={255,0,255}));
  connect(uTowSta, celVec1.u3) annotation (Line(points={{-220,-240},{-180,-240},
          {-180,192},{98,192}}, color={255,0,255}));
  connect(u1InlIsoValOpe, opeValFla.u)
    annotation (Line(points={{-220,140},{-102,140}}, color={255,0,255}));
  connect(enaCelSta.y, intEqu1.u1)
    annotation (Line(points={{-78,270},{-2,270}},  color={255,127,0}));
  connect(uTowSta, enaCelSta.u) annotation (Line(points={{-220,-240},{-180,-240},
          {-180,270},{-102,270}}, color={255,0,255}));
  connect(celVec.y, y1IsoVal)
    annotation (Line(points={{182,300},{220,300}}, color={255,0,255}));
  connect(cloValFla.y, totClo.u)
    annotation (Line(points={{-78,20},{-62,20}}, color={0,0,127}));
  connect(opeValFla.y, totOpe.u)
    annotation (Line(points={{-78,140},{-62,140}}, color={0,0,127}));
  connect(totOpe.y, triSam.u)
    annotation (Line(points={{-38,140},{-2,140}}, color={0,0,127}));
  connect(totClo.y, triSam1.u)
    annotation (Line(points={{-38,20},{-2,20}}, color={0,0,127}));
  connect(staPro.y, triSam.trigger) annotation (Line(points={{82,410},{100,410},
          {100,370},{-140,370},{-140,120},{10,120},{10,128}}, color={255,0,255}));
  connect(staPro.y, triSam1.trigger) annotation (Line(points={{82,410},{100,410},
          {100,370},{-140,370},{-140,0},{10,0},{10,8}}, color={255,0,255}));
  connect(totOpe.y, newFulOpe.u1) annotation (Line(points={{-38,140},{-20,140},{
          -20,160},{58,160}}, color={0,0,127}));
  connect(totClo.y, newFulClo.u1) annotation (Line(points={{-38,20},{-20,20},{-20,
          40},{38,40}}, color={0,0,127}));
  connect(staPro.y, newValCha.u) annotation (Line(points={{82,410},{100,410},{100,
          370},{-140,370},{-140,-100},{-102,-100}}, color={255,0,255}));
  connect(newValCha.y, booRep1.u)
    annotation (Line(points={{-78,-100},{-22,-100}}, color={255,0,255}));
  connect(booRep1.y, and1.u1) annotation (Line(points={{2,-100},{20,-100},{20,-170},
          {38,-170}}, color={255,0,255}));
  connect(newValCha.y, booRep5.u) annotation (Line(points={{-78,-100},{-50,-100},
          {-50,-140},{-22,-140}}, color={255,0,255}));
  connect(booRep5.y, and4.u1) annotation (Line(points={{2,-140},{10,-140},{10,-170},
          {-100,-170},{-100,-270},{-82,-270}}, color={255,0,255}));
  connect(lat.y, and4.u2) annotation (Line(points={{-98,410},{-80,410},{-80,380},
          {-170,380},{-170,-278},{-82,-278}}, color={255,0,255}));
  connect(triSam.y, newFulOpe.u2) annotation (Line(points={{22,140},{40,140},{40,
          152},{58,152}}, color={0,0,127}));
  connect(triSam1.y, newFulClo.u2) annotation (Line(points={{22,20},{30,20},{30,
          32},{38,32}}, color={0,0,127}));
  connect(u1InlIsoValOpe, opeValFla1.u) annotation (Line(points={{-220,140},{-160,
          140},{-160,100},{-102,100}}, color={255,0,255}));
  connect(u1OutIsoValOpe, opeValFla2.u)
    annotation (Line(points={{-220,60},{-102,60}}, color={255,0,255}));
  connect(u1InlIsoValClo, cloValFla1.u) annotation (Line(points={{-220,20},{-160,
          20},{-160,-20},{-102,-20}}, color={255,0,255}));
  connect(u1OutIsoValClo, cloValFla2.u)
    annotation (Line(points={{-220,-60},{-102,-60}}, color={255,0,255}));
  connect(cloValFla1.y, intEqu3.u1)
    annotation (Line(points={{-78,-20},{-42,-20}},
      color={255,127,0}));
  connect(cloValFla2.y, intEqu3.u2) annotation (Line(points={{-78,-60},{-60,-60},
          {-60,-28},{-42,-28}}, color={255,127,0}));
  connect(opeValFla1.y, intEqu2.u1)
    annotation (Line(points={{-78,100},{-42,100}}, color={255,127,0}));
  connect(opeValFla2.y, intEqu2.u2) annotation (Line(points={{-78,60},{-60,60},{
          -60,92},{-42,92}}, color={255,127,0}));
  connect(intEqu2.y, botOpe.u)
    annotation (Line(points={{-18,100},{-2,100}}, color={255,0,255}));
  connect(intEqu3.y, botClo.u)
    annotation (Line(points={{-18,-20},{-2,-20}}, color={255,0,255}));
  connect(botOpe.y, newFulOpe1.u2) annotation (Line(points={{22,100},{100,100},{
          100,152},{118,152}}, color={255,0,255}));
  connect(newFulOpe.y, newFulOpe1.u1)
    annotation (Line(points={{82,160},{118,160}}, color={255,0,255}));
  connect(newFulClo.y, newFulClo1.u1)
    annotation (Line(points={{62,40},{118,40}}, color={255,0,255}));
  connect(newFulOpe1.y, booRep1.u) annotation (Line(points={{142,160},{160,160},
          {160,-80},{-40,-80},{-40,-100},{-22,-100}}, color={255,0,255}));
  connect(newFulClo1.y, booRep5.u) annotation (Line(points={{142,40},{150,40},{150,
          -70},{-50,-70},{-50,-140},{-22,-140}}, color={255,0,255}));
  connect(con.y, newFulOpe1.u2) annotation (Line(points={{82,120},{100,120},{100,
          152},{118,152}}, color={255,0,255}));
  connect(con3.y, newFulClo1.u2) annotation (Line(points={{102,10},{110,10},{110,
          32},{118,32}}, color={255,0,255}));
  connect(botClo.y, difCloEnd.u)
    annotation (Line(points={{22,-20},{38,-20}}, color={255,0,255}));
  connect(difCloEnd.y, newFulClo2.u1)
    annotation (Line(points={{62,-20},{118,-20}}, color={255,0,255}));
  connect(newFulClo.y, newFulClo2.u2) annotation (Line(points={{62,40},{70,40},{
          70,-28},{118,-28}}, color={255,0,255}));
  connect(newFulClo2.y, booRep5.u) annotation (Line(points={{142,-20},{150,-20},
          {150,-70},{-50,-70},{-50,-140},{-22,-140}}, color={255,0,255}));
  connect(lat.y, disExiCel1.u2) annotation (Line(points={{-98,410},{-80,410},{
          -80,380},{-170,380},{-170,-290},{38,-290}}, color={255,0,255}));
annotation (
  defaultComponentName="towCelStaPro",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-200,-440},{200,440}})),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-102,88},{-58,76}},
          textColor={255,0,255},
          textString="uChaCel"),
        Text(
          extent={{-100,-74},{-56,-86}},
          textColor={255,0,255},
          textString="uTowSta"),
        Text(
          extent={{56,8},{100,-4}},
          textColor={255,0,255},
          textString="yTowSta"),
        Text(
          extent={{56,-52},{100,-64}},
          textColor={255,0,255},
          textString="yEndSta"),
        Text(
          extent={{56,66},{100,54}},
          textColor={255,0,255},
          textString="y1IsoVal"),
        Text(
          extent={{-96,50},{-40,32}},
          textColor={255,0,255},
          visible=have_endSwi,
          textString="u1InlIsoValOpe"),
        Text(
          extent={{-96,-12},{-40,-28}},
          textColor={255,0,255},
          visible=have_endSwi,
          textString="u1InlIsoValClo"),
        Text(
          extent={{-96,28},{-36,12}},
          textColor={255,0,255},
          visible=have_endSwi and have_outIsoVal,
          textString="u1OutIsoValOpe"),
        Text(
          extent={{-96,-32},{-38,-48}},
          textColor={255,0,255},
          visible=have_endSwi and have_outIsoVal,
          textString="u1OutIsoValClo")}),
Documentation(info="<html>
<p>
This block outputs new status vector of cells. When staging up cells, the cells
should be enabled only when their supply isolation valves have been proven fully
open. It is implemented according to ASHRAE Guideline 36-2021, 
section 5.20.12.1, item e and f which specifies the process of enabling and disabling
tower fan cells.
</p>
<ul>
<li>
When tower fan cells need to be enabled, which means that it is in the staging process
(not all <code>uChaCel</code> are false) and the cells that should change status (<code>uChaCel=true</code>)
are not enabled (<code>uTowSta=true</code>), the supply isolation valves position
(<code>uIsoVal</code>) of the enabling cells should change to
fully open with moving time (nominal valve timing) <code>chaTowCelIsoTim</code>.
Once the enabling supply isolation valves have been fully open, then enable
the additional fans.
</li>
<li>
When disabling tower cells, command the fan off and shut its supply isolation
valve, and outlet isolation valves if provided.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
September 12, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end StageProcesses;
