within Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences;
block NextCoil "Find next coil to turn on"
  parameter Integer nCoi
    "Number of coils";
  CDL.Interfaces.BooleanInput                        uDXCoi[nCoi]
    "DX coil status"
    annotation (Placement(transformation(extent={{-180,-60},{-140,-20}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  CDL.Interfaces.BooleanInput                        uDXCoiAva[nCoi]
    "DX coil availability"
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  CDL.Interfaces.BooleanInput uStaUp "Stage up signal" annotation (Placement(
        transformation(extent={{-180,20},{-140,60}}), iconTransformation(extent={{-140,0},
            {-100,40}})));
  CDL.Interfaces.IntegerInput uNexCoi "Next coil to be enabled" annotation (
      Placement(transformation(extent={{-180,60},{-140,100}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  CDL.Integers.Sources.Constant conInt[nCoi](k=coiInd)
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));
  CDL.Logical.Latch latSkiOve[nCoi] "List of coils skipped over"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  CDL.Logical.Edge edg[nCoi]
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  CDL.Interfaces.BooleanOutput yDXCoiInt[nCoi]
    "Coil status signal used for internal staging index calculations"
    annotation (Placement(transformation(extent={{260,-20},{300,20}}),
        iconTransformation(extent={{100,20},{140,60}})));
  CDL.Logical.Or orDXCoiInt[nCoi]
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  CDL.Interfaces.BooleanOutput yStaUp
    "Signal indicating coil to be enabled has been found" annotation (Placement(
        transformation(extent={{260,-80},{300,-40}}), iconTransformation(extent={{100,-20},
            {140,20}})));
  CDL.Logical.And andNowAva[nCoi]
    "Coils that were skipped over, but are now available"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  CDL.Interfaces.IntegerOutput yNexCoi "Next coil to be enabled" annotation (
      Placement(transformation(extent={{260,-120},{300,-80}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  CDL.Routing.BooleanExtractor extIndBoo(nin=nCoi)
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  CDL.Logical.MultiOr mulOr(nin=nCoi)
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
  CDL.Conversions.BooleanToInteger booToInt[nCoi]
    annotation (Placement(transformation(extent={{80,70},{100,90}})));
  CDL.Integers.Multiply mulInt[nCoi]
    annotation (Placement(transformation(extent={{120,90},{140,110}})));
  CDL.Continuous.MultiMin mulMin(nin=nCoi)
    annotation (Placement(transformation(extent={{180,90},{200,110}})));
  CDL.Conversions.IntegerToReal intToRea[nCoi]
    annotation (Placement(transformation(extent={{150,90},{170,110}})));
  CDL.Conversions.RealToInteger reaToInt
    annotation (Placement(transformation(extent={{210,90},{230,110}})));
  CDL.Logical.And and2[nCoi]
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

  CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-90,90},{-70,110}})));
  CDL.Integers.Equal intEqu[nCoi]
    annotation (Placement(transformation(extent={{-50,120},{-30,140}})));
  CDL.Routing.IntegerScalarReplicator intScaRep(nout=nCoi)
    annotation (Placement(transformation(extent={{-90,60},{-70,80}})));
  CDL.Routing.BooleanScalarReplicator booScaRep(nout=nCoi)
    annotation (Placement(transformation(extent={{-50,90},{-30,110}})));
  CDL.Logical.And and1[nCoi]
    annotation (Placement(transformation(extent={{-10,110},{10,130}})));
  CDL.Logical.Switch logSwi
    annotation (Placement(transformation(extent={{220,-70},{240,-50}})));
  CDL.Integers.Switch intSwi
    annotation (Placement(transformation(extent={{220,-110},{240,-90}})));
  CDL.Routing.BooleanScalarReplicator booScaRep1(nout=nCoi)
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  CDL.Logical.And and3
    annotation (Placement(transformation(extent={{120,30},{140,50}})));
  CDL.Logical.Switch logSwi1
    annotation (Placement(transformation(extent={{140,-70},{160,-50}})));
  CDL.Integers.Switch intSwi1
    annotation (Placement(transformation(extent={{142,-130},{162,-110}})));
  CDL.Logical.Latch lat
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
  CDL.Logical.And and4
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  CDL.Logical.Edge edg1
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  CDL.Logical.Pre pre
    annotation (Placement(transformation(extent={{50,-100},{70,-80}})));
  CDL.Logical.TrueFalseHold truFalHol(trueHoldDuration=10, falseHoldDuration=0)
    annotation (Placement(transformation(extent={{190,50},{210,70}})));
  CDL.Logical.Not not2
    annotation (Placement(transformation(extent={{-40,-170},{-20,-150}})));
  CDL.Logical.And and5
    annotation (Placement(transformation(extent={{10,-170},{30,-150}})));
  CDL.Logical.Pre pre1
    annotation (Placement(transformation(extent={{50,-170},{70,-150}})));
  CDL.Integers.Change cha
    annotation (Placement(transformation(extent={{-90,-150},{-70,-130}})));
  CDL.Logical.And and6
    annotation (Placement(transformation(extent={{-30,-110},{-10,-90}})));
  CDL.Logical.Or or2
    annotation (Placement(transformation(extent={{-24,-146},{-4,-126}})));
protected
  parameter Integer coiInd[nCoi]={i for i in 1:nCoi}
    "DX coil index, {1,2,...,n}";
equation
  connect(uDXCoi, edg.u) annotation (Line(points={{-160,-40},{-122,-40},{-122,
          -30},{-82,-30}},
                       color={255,0,255}));
  connect(edg.y, latSkiOve.clr) annotation (Line(points={{-58,-30},{-8,-30},{-8,
          34},{-2,34}}, color={255,0,255}));
  connect(uDXCoi, orDXCoiInt.u2) annotation (Line(points={{-160,-40},{-120,-40},
          {-120,-8},{78,-8}},
                            color={255,0,255}));
  connect(orDXCoiInt.y, yDXCoiInt)
    annotation (Line(points={{102,0},{280,0}}, color={255,0,255}));
  connect(latSkiOve.y, andNowAva.u1)
    annotation (Line(points={{22,40},{38,40}}, color={255,0,255}));
  connect(uNexCoi, extIndBoo.index) annotation (Line(points={{-160,80},{-110,80},
          {-110,88}},                   color={255,127,0}));
  connect(uDXCoiAva, extIndBoo.u) annotation (Line(points={{-160,0},{-130,0},{
          -130,100},{-122,100}},           color={255,0,255}));
  connect(booToInt.y, mulInt.u2) annotation (Line(points={{102,80},{110,80},{
          110,94},{118,94}}, color={255,127,0}));
  connect(conInt.y, mulInt.u1) annotation (Line(points={{-98,140},{-60,140},{
          -60,150},{110,150},{110,106},{118,106}}, color={255,127,0}));
  connect(mulInt.y, intToRea.u)
    annotation (Line(points={{142,100},{148,100}}, color={255,127,0}));
  connect(intToRea.y, mulMin.u[1:nCoi])
    annotation (Line(points={{172,100},{178,100}}, color={0,0,127}));
  connect(mulMin.y, reaToInt.u) annotation (Line(points={{202,100},{208,100}},
                                           color={0,0,127}));
  connect(andNowAva.y, mulOr.u[1:nCoi])
    annotation (Line(points={{62,40},{78,40}}, color={255,0,255}));
  connect(andNowAva.y, booToInt.u) annotation (Line(points={{62,40},{70,40},{70,
          80},{78,80}},  color={255,0,255}));
  connect(latSkiOve.y, orDXCoiInt.u1) annotation (Line(points={{22,40},{34,40},
          {34,0},{78,0}},color={255,0,255}));
  connect(and2.y, latSkiOve.u)
    annotation (Line(points={{-18,40},{-2,40}}, color={255,0,255}));
  connect(uDXCoiAva, andNowAva.u2) annotation (Line(points={{-160,0},{26,0},{26,
          32},{38,32}}, color={255,0,255}));
  connect(extIndBoo.y, not1.u)
    annotation (Line(points={{-98,100},{-92,100}}, color={255,0,255}));
  connect(conInt.y, intEqu.u1) annotation (Line(points={{-98,140},{-60,140},{
          -60,130},{-52,130}}, color={255,127,0}));
  connect(uNexCoi, intScaRep.u) annotation (Line(points={{-160,80},{-110,80},{
          -110,70},{-92,70}}, color={255,127,0}));
  connect(intScaRep.y, intEqu.u2) annotation (Line(points={{-68,70},{-60,70},{
          -60,122},{-52,122}}, color={255,127,0}));
  connect(not1.y, booScaRep.u)
    annotation (Line(points={{-68,100},{-52,100}}, color={255,0,255}));
  connect(intEqu.y, and1.u1) annotation (Line(points={{-28,130},{-20,130},{-20,
          120},{-12,120}}, color={255,0,255}));
  connect(booScaRep.y, and1.u2) annotation (Line(points={{-28,100},{-20,100},{
          -20,112},{-12,112}}, color={255,0,255}));
  connect(and1.y, and2.u2) annotation (Line(points={{12,120},{20,120},{20,80},{
          -50,80},{-50,32},{-42,32}}, color={255,0,255}));
  connect(logSwi.y, yStaUp)
    annotation (Line(points={{242,-60},{280,-60}}, color={255,0,255}));
  connect(intSwi.y, yNexCoi)
    annotation (Line(points={{242,-100},{280,-100}}, color={255,127,0}));
  connect(booScaRep1.y, and2.u1)
    annotation (Line(points={{-58,40},{-42,40}}, color={255,0,255}));
  connect(reaToInt.y, intSwi.u1) annotation (Line(points={{232,100},{240,100},{
          240,20},{210,20},{210,-92},{218,-92}}, color={255,127,0}));
  connect(mulOr.y, and3.u1)
    annotation (Line(points={{102,40},{118,40}}, color={255,0,255}));
  connect(and3.y, logSwi.u2) annotation (Line(points={{142,40},{200,40},{200,
          -60},{218,-60}}, color={255,0,255}));
  connect(and3.y, intSwi.u2) annotation (Line(points={{142,40},{200,40},{200,
          -100},{218,-100}}, color={255,0,255}));
  connect(logSwi1.y, logSwi.u3) annotation (Line(points={{162,-60},{180,-60},{
          180,-68},{218,-68}}, color={255,0,255}));
  connect(intSwi1.y, intSwi.u3) annotation (Line(points={{164,-120},{180,-120},
          {180,-108},{218,-108}}, color={255,127,0}));
  connect(uNexCoi, intSwi1.u1) annotation (Line(points={{-160,80},{-126,80},{
          -126,-112},{140,-112}}, color={255,127,0}));
  connect(lat.y, logSwi1.u2)
    annotation (Line(points={{102,-60},{138,-60}}, color={255,0,255}));
  connect(and4.y, lat.u)
    annotation (Line(points={{62,-60},{78,-60}}, color={255,0,255}));
  connect(edg1.y, and4.u1)
    annotation (Line(points={{-58,-60},{38,-60}}, color={255,0,255}));
  connect(uStaUp, edg1.u) annotation (Line(points={{-160,40},{-110,40},{-110,
          -60},{-82,-60}}, color={255,0,255}));
  connect(extIndBoo.y, and4.u2) annotation (Line(points={{-98,100},{-94,100},{
          -94,-80},{30,-80},{30,-68},{38,-68}}, color={255,0,255}));
  connect(lat.y, intSwi1.u2) annotation (Line(points={{102,-60},{110,-60},{110,
          -120},{140,-120}}, color={255,0,255}));
  connect(logSwi.y, pre.u) annotation (Line(points={{242,-60},{250,-60},{250,
          -134},{40,-134},{40,-90},{48,-90}}, color={255,0,255}));
  connect(pre.y, lat.clr) annotation (Line(points={{72,-90},{76,-90},{76,-66},{
          78,-66}}, color={255,0,255}));
  connect(and3.y, truFalHol.u) annotation (Line(points={{142,40},{180,40},{180,
          60},{188,60}}, color={255,0,255}));
  connect(not2.y, and5.u1)
    annotation (Line(points={{-18,-160},{8,-160}}, color={255,0,255}));
  connect(extIndBoo.y, not2.u) annotation (Line(points={{-98,100},{-94,100},{
          -94,-80},{-50,-80},{-50,-160},{-42,-160}}, color={255,0,255}));
  connect(edg1.y, and3.u2) annotation (Line(points={{-58,-60},{0,-60},{0,-40},{
          112,-40},{112,32},{118,32}}, color={255,0,255}));
  connect(edg1.y, logSwi1.u1) annotation (Line(points={{-58,-60},{0,-60},{0,-40},
          {112,-40},{112,-52},{138,-52}}, color={255,0,255}));
  connect(edg1.y, logSwi.u1) annotation (Line(points={{-58,-60},{0,-60},{0,-40},
          {190,-40},{190,-52},{218,-52}}, color={255,0,255}));
  connect(and5.y, pre1.u)
    annotation (Line(points={{32,-160},{48,-160}}, color={255,0,255}));
  connect(pre1.y, booScaRep1.u) annotation (Line(points={{72,-160},{80,-160},{
          80,-120},{-100,-120},{-100,40},{-82,40}}, color={255,0,255}));
  connect(uNexCoi, cha.u) annotation (Line(points={{-160,80},{-126,80},{-126,
          -140},{-92,-140}}, color={255,127,0}));
  connect(cha.up, and6.u1) annotation (Line(points={{-68,-134},{-60,-134},{-60,
          -100},{-32,-100}}, color={255,0,255}));
  connect(extIndBoo.y, and6.u2) annotation (Line(points={{-98,100},{-94,100},{
          -94,-80},{-40,-80},{-40,-108},{-32,-108}}, color={255,0,255}));
  connect(and6.y, logSwi1.u3) annotation (Line(points={{-8,-100},{30,-100},{30,
          -106},{120,-106},{120,-68},{138,-68}}, color={255,0,255}));
  connect(cha.up, or2.u2) annotation (Line(points={{-68,-134},{-46,-134},{-46,
          -144},{-26,-144}}, color={255,0,255}));
  connect(edg1.y, or2.u1) annotation (Line(points={{-58,-60},{-44,-60},{-44,
          -136},{-26,-136}}, color={255,0,255}));
  connect(or2.y, and5.u2) annotation (Line(points={{-2,-136},{4,-136},{4,-168},
          {8,-168}}, color={255,0,255}));
  connect(uNexCoi, intSwi1.u3) annotation (Line(points={{-160,80},{-126,80},{
          -126,-174},{120,-174},{120,-128},{140,-128}}, color={255,127,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -180},{260,160}}),
                         graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-140,-180},{260,160}})));
end NextCoil;
