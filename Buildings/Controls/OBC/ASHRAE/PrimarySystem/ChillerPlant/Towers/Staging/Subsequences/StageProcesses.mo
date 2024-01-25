within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Subsequences;
block StageProcesses "Sequence for process of staging cells"

  parameter Integer nTowCel = 4
    "Total number of cooling tower cells";
  parameter Real chaTowCelIsoTim(
    final quantity="Time",
    final unit="s") = 90
    "Nominal time needed for open isolation valve";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChaCel[nTowCel]
    "Vector of boolean flags to show if a cell should change its status: true = the cell should change status (be enabled or disabled)"
    annotation (Placement(transformation(extent={{-240,350},{-200,390}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uIsoVal[nTowCel](
    final unit=fill("1", nTowCel),
    final min=fill(0, nTowCel),
    final max=fill(1, nTowCel)) "Cooling tower cells isolation valve position"
    annotation (Placement(transformation(extent={{-240,60},{-200,100}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTowSta[nTowCel]
    "Vector of tower cells proven on status: true=enabled tower cell"
    annotation (Placement(transformation(extent={{-240,-260},{-200,-220}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yIsoVal[nTowCel](
    final unit=fill("1", nTowCel),
    final min=fill(0, nTowCel),
    final max=fill(1, nTowCel)) "Cooling tower cells isolation valve setpoint"
    annotation (Placement(transformation(extent={{200,80},{240,120}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yTowSta[nTowCel]
    "Vector of tower cells status setpoint"
    annotation (Placement(transformation(extent={{200,-280},{240,-240}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEndSta
    "Rising edge to indicate the staging process is done"
    annotation (Placement(transformation(extent={{200,-380},{240,-340}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Switch swi2[nTowCel] "Logical switch"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim
    "Count the time after changing up-stream device status"
    annotation (Placement(transformation(extent={{-120,290},{-100,310}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con9(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-40,310},{-20,330}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con7(
    final k=chaTowCelIsoTim) "Time to change cooling tower isolation valve"
    annotation (Placement(transformation(extent={{-120,260},{-100,280}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con8(final k=1)
    "Fully open valve"
    annotation (Placement(transformation(extent={{-40,260},{-20,280}})));
  Buildings.Controls.OBC.CDL.Reals.Line lin1
    "Chilled water isolation valve setpoint"
    annotation (Placement(transformation(extent={{40,290},{60,310}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(
    final nout=nTowCel)
    "Replicate real input"
    annotation (Placement(transformation(extent={{140,220},{160,240}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi[nTowCel] "Logical switch"
    annotation (Placement(transformation(extent={{120,-30},{140,-10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=nTowCel)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys3[nTowCel](
    final uLow=fill(0.025, nTowCel),
    final uHigh=fill(0.05, nTowCel)) "Check if isolation valve is enabled"
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys4[nTowCel](
    final uLow=fill(0.925, nTowCel),
    final uHigh=fill(0.975, nTowCel)) "Check if isolation valve is open more than 95%"
    annotation (Placement(transformation(extent={{-140,-150},{-120,-130}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd fulOpe(
    final nin=nTowCel)
    "Enabled valves are fully open"
    annotation (Placement(transformation(extent={{80,-120},{100,-100}})));
  Buildings.Controls.OBC.CDL.Logical.And and5
    "Check if it has fully open the valve and the opening process time has past the threshold"
    annotation (Placement(transformation(extent={{100,-160},{120,-140}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greEquThr(
    final t=chaTowCelIsoTim)
    "Check if it has past the target time of open isolation valve "
    annotation (Placement(transformation(extent={{0,-180},{20,-160}})));
  Buildings.Controls.OBC.CDL.Logical.And and1[nTowCel]
    "True: cells should be enabled"
    annotation (Placement(transformation(extent={{20,-230},{40,-210}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(
    final nout=nTowCel)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{140,-160},{160,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[nTowCel](
    final k=fill(true, nTowCel)) "Enable cells"
    annotation (Placement(transformation(extent={{-60,-210},{-40,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Switch enaNexCel[nTowCel]
    "Enable next cells"
    annotation (Placement(transformation(extent={{80,-230},{100,-210}})));
  Buildings.Controls.OBC.CDL.Logical.And and2[nTowCel] "Logical and"
    annotation (Placement(transformation(extent={{-120,220},{-100,240}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1[nTowCel] "Logical and"
    annotation (Placement(transformation(extent={{-60,220},{-40,240}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd enaCel(
    final nin=nTowCel) "New cells should be enabled"
    annotation (Placement(transformation(extent={{-20,220},{0,240}})));
  Buildings.Controls.OBC.CDL.Reals.Switch celPosSet
    "Slowly change the opening setpoint to 1 of the enabling cells isolation valve, or change the setpoint to 0 of the disabling cells"
    annotation (Placement(transformation(extent={{100,220},{120,240}})));
  Buildings.Controls.OBC.CDL.Logical.And enaPro "Enabling cells process"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Not disCel "Disable cell"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Logical.And disPro "Disabling cells process"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Logical.Switch newTowCell[nTowCel]
    "New tower cell status"
    annotation (Placement(transformation(extent={{160,-270},{180,-250}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep2(
    final nout=nTowCel) "In the enabling process"
    annotation (Placement(transformation(extent={{80,-270},{100,-250}})));
  Buildings.Controls.OBC.CDL.Logical.Switch disExiCel[nTowCel]
    "Disable existing cells"
    annotation (Placement(transformation(extent={{80,-310},{100,-290}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep3(
    final nout=nTowCel) "In the disabling process"
    annotation (Placement(transformation(extent={{0,-310},{20,-290}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr staPro(nin=nTowCel)
    "In tower staging process"
    annotation (Placement(transformation(extent={{60,360},{80,380}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr opeVal(
    final nin=nTowCel) "Check if there is any opened valve"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Check if the opened valves are fully open"
    annotation (Placement(transformation(extent={{140,-90},{160,-70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nTowCel]
    "Convert boolean input to integer"
    annotation (Placement(transformation(extent={{0,-120},{20,-100}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1[nTowCel]
    "Convert boolean input to integer"
    annotation (Placement(transformation(extent={{0,-150},{20,-130}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nTowCel]
    "Check if the opened valves are fully open"
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep4(
    final nout=nTowCel) "In the disabling process"
    annotation (Placement(transformation(extent={{120,-350},{140,-330}})));
  Buildings.Controls.OBC.CDL.Logical.Or celChaSta[nTowCel]
    "True: there are cells changed status"
    annotation (Placement(transformation(extent={{-80,-370},{-60,-350}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg[nTowCel]
    "Check if there is any cell being disabled"
    annotation (Placement(transformation(extent={{-140,-350},{-120,-330}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg[nTowCel]
    "Check if there is any cell being enabled"
    annotation (Placement(transformation(extent={{-140,-390},{-120,-370}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr endStaPro(
    final nin=nTowCel)
    "Check if there is any cell changed status so it means that the staging process is done"
    annotation (Placement(transformation(extent={{40,-370},{60,-350}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat[nTowCel] "Change cells status"
    annotation (Placement(transformation(extent={{-120,360},{-100,380}})));
  Buildings.Controls.OBC.CDL.Logical.Edge havCha[nTowCel] "Edge"
    annotation (Placement(transformation(extent={{-180,360},{-160,380}})));
  Buildings.Controls.OBC.CDL.Logical.And and4[nTowCel]
    "True: cells should be disabled"
    annotation (Placement(transformation(extent={{-140,-270},{-120,-250}})));
  Buildings.Controls.OBC.CDL.Logical.Switch disExiCel1[nTowCel]
    "Disable existing cells"
    annotation (Placement(transformation(extent={{-60,-290},{-40,-270}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2[nTowCel](
    final k=fill(false, nTowCel))
    "Disable cells"
    annotation (Placement(transformation(extent={{-140,-220},{-120,-200}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep5(
    final nout=nTowCel)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-40,140},{-20,160}})));
  Buildings.Controls.OBC.CDL.Logical.And ideDisCel[nTowCel]
    "Identifying the cells to be disabled"
    annotation (Placement(transformation(extent={{60,140},{80,160}})));
  Buildings.Controls.OBC.CDL.Reals.Switch offVal[nTowCel]
    "Shut off valve if it is disabling cell"
    annotation (Placement(transformation(extent={{120,140},{140,160}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con3[nTowCel](
    final k=fill(0, nTowCel))
    "Constant zero"
    annotation (Placement(transformation(extent={{60,180},{80,200}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi3[nTowCel]
    "Logical switch"
    annotation (Placement(transformation(extent={{160,90},{180,110}})));
  Buildings.Controls.OBC.CDL.Logical.TrueHoldWithReset holDisPro(
    final duration=chaTowCelIsoTim)
    "Holding the disable process"
    annotation (Placement(transformation(extent={{-100,140},{-80,160}})));
  Buildings.Controls.OBC.CDL.Logical.TrueHoldWithReset truHol2[nTowCel](
    final duration=fill(chaTowCelIsoTim,nTowCel))
    "Holding the cell changing signal"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));

equation
  connect(con9.y, lin1.x1)
    annotation (Line(points={{-18,320},{30,320},{30,308},{38,308}},
      color={0,0,127}));
  connect(con7.y, lin1.x2)
    annotation (Line(points={{-98,270},{-60,270},{-60,296},{38,296}},
      color={0,0,127}));
  connect(con8.y, lin1.f2)
    annotation (Line(points={{-18,270},{0,270},{0,292},{38,292}},
      color={0,0,127}));
  connect(tim.y, lin1.u)
    annotation (Line(points={{-98,300},{38,300}}, color={0,0,127}));
  connect(reaRep.y, swi2.u1)
    annotation (Line(points={{162,230},{180,230},{180,210},{30,210},{30,38},{58,
          38}}, color={0,0,127}));
  connect(swi2.y, swi.u1)
    annotation (Line(points={{82,30},{100,30},{100,-12},{118,-12}},
      color={0,0,127}));
  connect(uIsoVal, swi2.u3)
    annotation (Line(points={{-220,80},{-160,80},{-160,22},{58,22}},
      color={0,0,127}));
  connect(booRep.y, swi.u2)
    annotation (Line(points={{-18,-10},{80,-10},{80,-20},{118,-20}},
      color={255,0,255}));
  connect(greEquThr.y, and5.u2)
    annotation (Line(points={{22,-170},{70,-170},{70,-158},{98,-158}},
      color={255,0,255}));
  connect(uIsoVal, hys4.u)
    annotation (Line(points={{-220,80},{-160,80},{-160,-140},{-142,-140}},
      color={0,0,127}));
  connect(uIsoVal, hys3.u)
    annotation (Line(points={{-220,80},{-160,80},{-160,-110},{-142,-110}},
      color={0,0,127}));
  connect(tim.y, greEquThr.u)
    annotation (Line(points={{-98,300},{-70,300},{-70,-170},{-2,-170}},
      color={0,0,127}));
  connect(and5.y, booRep1.u)
    annotation (Line(points={{122,-150},{138,-150}}, color={255,0,255}));
  connect(booRep1.y, and1.u1)
    annotation (Line(points={{162,-150},{180,-150},{180,-192},{0,-192},{0,-220},
          {18,-220}}, color={255,0,255}));
  connect(and1.y, enaNexCel.u2)
    annotation (Line(points={{42,-220},{78,-220}}, color={255,0,255}));
  connect(con1.y, enaNexCel.u1) annotation (Line(points={{-38,-200},{60,-200},{60,
          -212},{78,-212}}, color={255,0,255}));
  connect(uTowSta, enaNexCel.u3) annotation (Line(points={{-220,-240},{60,-240},
          {60,-228},{78,-228}}, color={255,0,255}));
  connect(celPosSet.y, reaRep.u)
    annotation (Line(points={{122,230},{138,230}}, color={0,0,127}));
  connect(uTowSta, and2.u2) annotation (Line(points={{-220,-240},{-180,-240},{-180,
          222},{-122,222}}, color={255,0,255}));
  connect(and2.y, not1.u)
    annotation (Line(points={{-98,230},{-62,230}}, color={255,0,255}));
  connect(not1.y, enaCel.u) annotation (Line(points={{-38,230},{-22,230}},
          color={255,0,255}));
  connect(lin1.y, celPosSet.u1) annotation (Line(points={{62,300},{80,300},{80,238},
          {98,238}}, color={0,0,127}));
  connect(enaCel.y, enaPro.u1) annotation (Line(points={{2,230},{20,230},{20,200},
          {-120,200},{-120,-60},{-62,-60}}, color={255,0,255}));
  connect(enaCel.y, disCel.u) annotation (Line(points={{2,230},{20,230},{20,200},
          {-120,200},{-120,60},{-102,60}}, color={255,0,255}));
  connect(disCel.y, disPro.u1)
    annotation (Line(points={{-78,60},{-60,60},{-60,50},{-42,50}}, color={255,0,255}));
  connect(booRep2.y, newTowCell.u2)
    annotation (Line(points={{102,-260},{158,-260}}, color={255,0,255}));
  connect(enaNexCel.y, newTowCell.u1) annotation (Line(points={{102,-220},{120,-220},
          {120,-252},{158,-252}}, color={255,0,255}));
  connect(booRep3.y, disExiCel.u2)
    annotation (Line(points={{22,-300},{78,-300}},  color={255,0,255}));
  connect(uTowSta, disExiCel.u3) annotation (Line(points={{-220,-240},{60,-240},
          {60,-308},{78,-308}}, color={255,0,255}));
  connect(disPro.y, booRep3.u) annotation (Line(points={{-18,50},{0,50},{0,12},{
          -110,12},{-110,-300},{-2,-300}}, color={255,0,255}));
  connect(enaPro.y, booRep2.u) annotation (Line(points={{-38,-60},{-30,-60},{-30,
          -260},{78,-260}}, color={255,0,255}));
  connect(disExiCel.y, newTowCell.u3) annotation (Line(points={{102,-300},{140,-300},
          {140,-268},{158,-268}}, color={255,0,255}));
  connect(newTowCell.y, yTowSta)
    annotation (Line(points={{182,-260},{220,-260}}, color={255,0,255}));
  connect(con9.y, lin1.f1) annotation (Line(points={{-18,320},{30,320},{30,304},
          {38,304}}, color={0,0,127}));
  connect(staPro.y, tim.u) annotation (Line(points={{82,370},{100,370},{100,340},
          {-140,340},{-140,300},{-122,300}}, color={255,0,255}));
  connect(staPro.y, disPro.u2) annotation (Line(points={{82,370},{100,370},{100,
          340},{-140,340},{-140,42},{-42,42}}, color={255,0,255}));
  connect(staPro.y, enaPro.u2) annotation (Line(points={{82,370},{100,370},{100,
          340},{-140,340},{-140,-68},{-62,-68}}, color={255,0,255}));
  connect(hys3.y, booToInt.u)
    annotation (Line(points={{-118,-110},{-2,-110}}, color={255,0,255}));
  connect(hys4.y, booToInt1.u)
    annotation (Line(points={{-118,-140},{-2,-140}},color={255,0,255}));
  connect(booToInt.y, intEqu.u1)
    annotation (Line(points={{22,-110},{38,-110}}, color={255,127,0}));
  connect(booToInt1.y, intEqu.u2) annotation (Line(points={{22,-140},{30,-140},{
          30,-118},{38,-118}}, color={255,127,0}));
  connect(intEqu.y, fulOpe.u)
    annotation (Line(points={{62,-110},{78,-110}}, color={255,0,255}));
  connect(hys3.y, opeVal.u) annotation (Line(points={{-118,-110},{-20,-110},{-20,
          -80},{-2,-80}}, color={255,0,255}));
  connect(opeVal.y, and3.u1)
    annotation (Line(points={{22,-80},{138,-80}}, color={255,0,255}));
  connect(fulOpe.y, and3.u2) annotation (Line(points={{102,-110},{120,-110},{120,
          -88},{138,-88}}, color={255,0,255}));
  connect(and3.y, and5.u1) annotation (Line(points={{162,-80},{180,-80},{180,-130},
          {70,-130},{70,-150},{98,-150}},color={255,0,255}));
  connect(staPro.y, booRep.u) annotation (Line(points={{82,370},{100,370},{100,340},
          {-140,340},{-140,-10},{-42,-10}}, color={255,0,255}));
  connect(uTowSta, falEdg.u) annotation (Line(points={{-220,-240},{-180,-240},{-180,
          -340},{-142,-340}}, color={255,0,255}));
  connect(uTowSta, edg.u) annotation (Line(points={{-220,-240},{-180,-240},{-180,
          -380},{-142,-380}}, color={255,0,255}));
  connect(booRep4.y, lat.clr) annotation (Line(points={{142,-340},{180,-340},{180,
          -318},{-150,-318},{-150,364},{-122,364}}, color={255,0,255}));
  connect(falEdg.y, celChaSta.u1) annotation (Line(points={{-118,-340},{-100,-340},
          {-100,-360},{-82,-360}},color={255,0,255}));
  connect(edg.y, celChaSta.u2) annotation (Line(points={{-118,-380},{-100,-380},
          {-100,-368},{-82,-368}}, color={255,0,255}));
  connect(celChaSta.y, endStaPro.u) annotation (Line(points={{-58,-360},{38,-360}},
          color={255,0,255}));
  connect(uChaCel, havCha.u) annotation (Line(points={{-220,370},{-182,370}},
          color={255,0,255}));
  connect(havCha.y, lat.u) annotation (Line(points={{-158,370},{-122,370}},
          color={255,0,255}));
  connect(endStaPro.y, yEndSta)
    annotation (Line(points={{62,-360},{220,-360}},color={255,0,255}));
  connect(endStaPro.y, booRep4.u) annotation (Line(points={{62,-360},{80,-360},{
          80,-340},{118,-340}}, color={255,0,255}));
  connect(uTowSta, and4.u2) annotation (Line(points={{-220,-240},{-180,-240},{-180,
          -268},{-142,-268}}, color={255,0,255}));
  connect(uChaCel, and4.u1) annotation (Line(points={{-220,370},{-190,370},{-190,
          -260},{-142,-260}}, color={255,0,255}));
  connect(and4.y, disExiCel1.u2) annotation (Line(points={{-118,-260},{-80,-260},
          {-80,-280},{-62,-280}}, color={255,0,255}));
  connect(uTowSta, disExiCel1.u3) annotation (Line(points={{-220,-240},{-180,-240},
          {-180,-288},{-62,-288}}, color={255,0,255}));
  connect(con2.y, disExiCel1.u1) annotation (Line(points={{-118,-210},{-70,-210},
          {-70,-272},{-62,-272}}, color={255,0,255}));
  connect(disExiCel1.y, disExiCel.u1) annotation (Line(points={{-38,-280},{50,-280},
          {50,-292},{78,-292}}, color={255,0,255}));
  connect(con9.y, celPosSet.u3) annotation (Line(points={{-18,320},{30,320},{30,
          222},{98,222}}, color={0,0,127}));
  connect(enaCel.y, celPosSet.u2)
    annotation (Line(points={{2,230},{98,230}}, color={255,0,255}));
  connect(uIsoVal, swi.u3) annotation (Line(points={{-220,80},{-160,80},{-160,-28},
          {118,-28}}, color={0,0,127}));
  connect(lat.y, staPro.u)
    annotation (Line(points={{-98,370},{58,370}}, color={255,0,255}));
  connect(lat.y, and1.u2) annotation (Line(points={{-98,370},{-80,370},{-80,350},
          {-170,350},{-170,-228},{18,-228}}, color={255,0,255}));
  connect(lat.y, swi2.u2) annotation (Line(points={{-98,370},{-80,370},{-80,350},
          {-170,350},{-170,30},{58,30}}, color={255,0,255}));
  connect(lat.y, and2.u1) annotation (Line(points={{-98,370},{-80,370},{-80,350},
          {-170,350},{-170,230},{-122,230}}, color={255,0,255}));
  connect(disPro.y, holDisPro.u) annotation (Line(points={{-18,50},{0,50},{0,130},
          {-110,130},{-110,150},{-102,150}}, color={255,0,255}));
  connect(havCha.y, truHol2.u) annotation (Line(points={{-158,370},{-130,370},{-130,
          100},{-102,100}}, color={255,0,255}));
  connect(holDisPro.y, booRep5.u)
    annotation (Line(points={{-78,150},{-42,150}}, color={255,0,255}));
  connect(booRep5.y, ideDisCel.u1)
    annotation (Line(points={{-18,150},{58,150}}, color={255,0,255}));
  connect(truHol2.y, ideDisCel.u2) annotation (Line(points={{-78,100},{20,100},{
          20,142},{58,142}}, color={255,0,255}));
  connect(ideDisCel.y, offVal.u2)
    annotation (Line(points={{82,150},{118,150}}, color={255,0,255}));
  connect(con3.y, offVal.u1) annotation (Line(points={{82,190},{100,190},{100,158},
          {118,158}}, color={0,0,127}));
  connect(uIsoVal, offVal.u3) annotation (Line(points={{-220,80},{100,80},{100,142},
          {118,142}}, color={0,0,127}));
  connect(booRep5.y, swi3.u2) annotation (Line(points={{-18,150},{40,150},{40,100},
          {158,100}}, color={255,0,255}));
  connect(offVal.y, swi3.u1) annotation (Line(points={{142,150},{150,150},{150,108},
          {158,108}}, color={0,0,127}));
  connect(swi.y, swi3.u3) annotation (Line(points={{142,-20},{150,-20},{150,92},
          {158,92}}, color={0,0,127}));
  connect(swi3.y, yIsoVal)
    annotation (Line(points={{182,100},{220,100}}, color={0,0,127}));
annotation (
  defaultComponentName="towCelStaPro",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-200,-400},{200,400}}), graphics={
          Rectangle(
          extent={{-138,-62},{178,-198}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{12,-180},{144,-204}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Check if all enabled isolation valves 
          have been fully open")}),
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
          extent={{-98,88},{-54,76}},
          textColor={255,0,255},
          textString="uChaCel"),
        Text(
          extent={{-100,6},{-62,-6}},
          textColor={0,0,127},
          textString="uIsoVal"),
        Text(
          extent={{-100,-74},{-56,-86}},
          textColor={255,0,255},
          textString="uTowSta"),
        Text(
          extent={{62,66},{100,54}},
          textColor={0,0,127},
          textString="yIsoVal"),
        Text(
          extent={{56,8},{100,-4}},
          textColor={255,0,255},
          textString="yTowSta"),
        Text(
          extent={{56,-52},{100,-64}},
          textColor={255,0,255},
          textString="yEndSta")}),
Documentation(info="<html>
<p>
This block outputs new status vector of cells. When staging up cells, the cells
should be enabled only when their supply isolation valves have been proven fully
open. It is implemented according to ASHRAE RP-1711 Advanced Sequences of Operation
for HVAC Systems Phase II – Central Plants and Hydronic Systems (Draft on March 23, 2020), 
section 5.2.12.1, item 5 and 6 which specifies the process of enabling and disabling
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
