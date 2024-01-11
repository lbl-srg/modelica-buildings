within Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences;
block NextCoil "Find next available coil to enable"

  parameter Integer nCoi(
    final min= 1)
    "Number of coils";

  parameter Real tDel(
    final unit="s",
    final quantity="Time") = 5
    "Delay between consecutive pulses that drives the available coil search logic"
    annotation(Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDXCoi[nCoi]
    "DX coil status"
    annotation (Placement(transformation(extent={{-180,-80},{-140,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDXCoiAva[nCoi]
    "DX coil availability"
    annotation (Placement(transformation(extent={{-180,-40},{-140,0}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaUp
    "Stage up signal"
    annotation (Placement(transformation(extent={{-180,0},{-140,40}}),
      iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yStaUp
    "Signal indicating coil to be enabled has been found"
    annotation (Placement(transformation(extent={{420,-20},{460,20}}),
      iconTransformation(extent={{100,20},{140,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yNexCoi
    "Next coil to be enabled"
    annotation (Placement(transformation(extent={{420,-60},{460,-20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uCoiSeq[nCoi]
    "DX coil available sequence order"
    annotation (Placement(transformation(extent={{-180,40},{-140,80}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Logical.Latch latSki[nCoi]
    "Track coils that have been skipped over"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  Buildings.Controls.OBC.CDL.Logical.Latch latSkiAva[nCoi]
    "Track coils that have been skipped over, but are now available"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));

  Buildings.Controls.OBC.CDL.Logical.And and2[nCoi]
    "Check for coils that were skipped but are now available"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg[nCoi]
    "Check for coils that become available from unavailable"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg1[nCoi]
    "Check for coils that are enabled"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerExtractor extIndIntOriSeq(
    final nin=nCoi)
    "Index of next coil to be enabled if there are no skipped coils to be prioritized"
    annotation (Placement(transformation(extent={{330,-90},{350,-70}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToIntSki[nCoi]
    "Convert skipped coils into ones"
    annotation (Placement(transformation(extent={{240,-110},{260,-90}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToIntEna[nCoi]
    "Convert enabled coils into ones"
    annotation (Placement(transformation(extent={{-120,-150},{-100,-130}})));

  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt(
    final nin=2*nCoi)
    "Sum of number of coils that have been enabled or skipped over"
    annotation (Placement(transformation(extent={{280,-130},{300,-110}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi
    "Switch to pass index of skipped coil if prioritized, or pass index of next coil as per original sequence"
    annotation (Placement(transformation(extent={{380,-50},{400,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim[nCoi]
    "Check time since coil was skipped over"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));

  Buildings.Controls.OBC.CDL.Continuous.Round rou[nCoi](
    final n=fill(0, nCoi))
    "Round off time-value to nearest second"
    annotation (Placement(transformation(extent={{40,100},{60,120}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiMax mulMax(
    final nin=nCoi) "Find maximum time for which a coil has been skipped"
    annotation (Placement(transformation(extent={{80,130},{100,150}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nCoi]
    "Convert previously-skipped, now-available coils to 1"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1[nCoi]
    "Convert skip times to integers"
    annotation (Placement(transformation(extent={{110,100},{130,120}})));

  Buildings.Controls.OBC.CDL.Integers.Multiply mulInt[nCoi]
    "Get skip times only for coils that are now available"
    annotation (Placement(transformation(extent={{160,90},{180,110}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert max skip time to integer"
    annotation (Placement(transformation(extent={{110,130},{130,150}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nCoi]
    "Check if time for coil matches max time"
    annotation (Placement(transformation(extent={{200,120},{220,140}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(
    final nout=nCoi)
    "Replicate max time for comparison block"
    annotation (Placement(transformation(extent={{160,130},{180,150}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1[nCoi]
    "Convert Boolean to integer for counting matching signals"
    annotation (Placement(transformation(extent={{230,120},{250,140}})));

  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt1(
    final nin=nCoi)
    "Find number of coils prioritized for enabling"
    annotation (Placement(transformation(extent={{260,120},{280,140}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi1
    "Switch that outputs single coil index irrespective of whether a single coil or multiple coils have been prioritized"
    annotation (Placement(transformation(extent={{332,120},{352,140}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr1(t=1)
    "Check if more then one coil has been prioritized"
    annotation (Placement(transformation(extent={{300,120},{320,140}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply mulInt1[nCoi]
    "Generate non-zero values only for coils that are prioritized for enabling"
    annotation (Placement(transformation(extent={{260,70},{280,90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nCoi](k=coiInd)
    "Coil indices"
    annotation (Placement(transformation(extent={{-120,250},{-100,270}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt2(nin=nCoi)
    "Transmit index of the only coil prioritized for enabling"
    annotation (Placement(transformation(extent={{300,70},{320,90}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1[nCoi]
    "Convert indices of prioritized coils to Real number"
    annotation (Placement(transformation(extent={{292,160},{312,180}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt3(nin=nCoi)
    "Number of skipped coils that are prioritized for enable"
    annotation (Placement(transformation(extent={{148,-50},{168,-30}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr2
    "Check if any skipped coils have been prioritized for enable"
    annotation (Placement(transformation(extent={{180,-50},{200,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin mulMin(nin=nCoi)
    "Identify lowest index between coils that were skipped at the same time"
    annotation (Placement(transformation(extent={{330,160},{350,180}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt3
    "Convert index signal back to Integer"
    annotation (Placement(transformation(extent={{360,160},{380,180}})));
  Buildings.Controls.OBC.CDL.Integers.AddParameter addPar1(p=1)
    "Sequence index of next coil to be enabled if there are no skipped coils to be prioritized"
    annotation (Placement(transformation(extent={{310,-130},{330,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Transmit true signal when a coil is available for stage up"
    annotation (Placement(transformation(extent={{150,240},{170,260}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1[nCoi]
    "Return array identifying next coil to be enabled"
    annotation (Placement(transformation(extent={{-60,260},{-40,280}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep1(nout=nCoi)
    "Change sequence index to a vector of integer values"
    annotation (Placement(transformation(extent={{360,-130},{380,-110}})));
  Buildings.Controls.OBC.CDL.Logical.And and1[nCoi]
    "Transmit True array for coils that are enabled next, and if they are currently available"
    annotation (Placement(transformation(extent={{0,240},{20,260}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(nin=nCoi)
    "Transmit True if next coil to be enabled is available"
    annotation (Placement(transformation(extent={{80,240},{100,260}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Transmit stage up signal when a coil is available for stage up"
    annotation (Placement(transformation(extent={{200,220},{220,240}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Transmit True if neither next coil or previously skipped coil is available for staging up"
    annotation (Placement(transformation(extent={{240,260},{260,280}})));
  Buildings.Controls.OBC.CDL.Logical.And and4
    "Transmit True pulse when no coil is available for staging, and pulse signal is received or generated"
    annotation (Placement(transformation(extent={{280,260},{300,280}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep(nout=nCoi)
    "Replicate staging pulse signal for use in Boolean vector"
    annotation (Placement(transformation(extent={{320,260},{340,280}})));
  Buildings.Controls.OBC.CDL.Logical.And and5[nCoi]
    "Transmit True signal for coil that is being skipped due to non-availability"
    annotation (Placement(transformation(extent={{0,280},{20,300}})));
  Buildings.Controls.OBC.CDL.Logical.VariablePulse varPul(period=tDel)
    "Generate a periodic pulse signal until coil available for enable is found"
    annotation (Placement(transformation(extent={{60,160},{80,180}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Transmit True if stage up signal is received from input interface or from internal pulse signal"
    annotation (Placement(transformation(extent={{110,210},{130,230}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr1(nin=nCoi)
    "Check if no coils got enabled because next coil is not available"
    annotation (Placement(transformation(extent={{-40,160},{-20,180}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Hold Treu signal until coil available for enable is found"
    annotation (Placement(transformation(extent={{0,160},{20,180}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(realTrue=1 - (1/
        tDel))
    "Convert Boolean signal into Real value which will determine pulse transmitter operation"
    annotation (Placement(transformation(extent={{30,160},{50,180}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre
    "Pre block to break algebraic loops"
    annotation (Placement(transformation(extent={{150,160},{170,180}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1[nCoi]
    "Pre block to break algebraic loops"
    annotation (Placement(transformation(extent={{-30,260},{-10,280}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre2[nCoi]
    "Pre block to break algebraic loops"
    annotation (Placement(transformation(extent={{348,260},{368,280}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Use not signal to move True pulse at input to end of pulse generator timeperiod"
    annotation (Placement(transformation(extent={{90,160},{110,180}})));
  Buildings.Controls.OBC.CDL.Logical.And and6
    "Transmit True pulse signal only when no coils are available for staging up"
    annotation (Placement(transformation(extent={{118,160},{138,180}})));
  Buildings.Controls.OBC.CDL.Logical.Or or3[nCoi]
    "Check if a coil either becomews unavailable or is enabled"
    annotation (Placement(transformation(extent={{8,-80},{28,-60}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg[nCoi]
    "Check if coils become unavailable"
    annotation (Placement(transformation(extent={{-40,-76},{-20,-56}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea2[nCoi]
    "Convert skip times from Integer to Real, for compatibility with mulMax block"
    annotation (Placement(transformation(extent={{40,130},{60,150}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[nCoi](
    final realTrue=fill(1e6, nCoi))
    "Convert non-available coils to high value before passing it through minimum block, so that they are not prioritized for enabling"
    annotation (Placement(transformation(extent={{232,180},{252,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2[nCoi]
    "Add large number to non-prioritized coil indices"
    annotation (Placement(transformation(extent={{310,200},{330,220}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3[nCoi]
    "Identify coils that are not on list of skipped, currently-available coils"
    annotation (Placement(transformation(extent={{160,20},{180,40}})));
  CDL.Interfaces.IntegerOutput yLasCoi "Last coil that was enabled" annotation (
     Placement(transformation(extent={{420,-220},{460,-180}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  CDL.Routing.IntegerExtractor                        extIndIntOriSeq1(final nin=
       nCoi)
    "Index of next coil to be enabled if there are no skipped coils to be prioritized"
    annotation (Placement(transformation(extent={{330,-210},{350,-190}})));
protected
  parameter Integer coiInd[nCoi]={i for i in 1:nCoi}
    "DX coil index, {1,2,...,n}";
equation
  connect(latSki.y, and2.u1)
    annotation (Line(points={{-18,30},{-2,30}}, color={255,0,255}));
  connect(uDXCoiAva, edg.u)
    annotation (Line(points={{-160,-20},{-102,-20}},color={255,0,255}));
  connect(edg.y, and2.u2) annotation (Line(points={{-78,-20},{-6,-20},{-6,22},{-2,
          22}},     color={255,0,255}));
  connect(and2.y, latSkiAva.u)
    annotation (Line(points={{22,30},{38,30}}, color={255,0,255}));
  connect(uDXCoi, edg1.u)
    annotation (Line(points={{-160,-60},{-122,-60}}, color={255,0,255}));
  connect(edg1.y, latSki.clr) annotation (Line(points={{-98,-60},{-60,-60},{-60,
          24},{-42,24}}, color={255,0,255}));
  connect(uCoiSeq, extIndIntOriSeq.u) annotation (Line(points={{-160,60},{100,60},
          {100,-80},{328,-80}},  color={255,127,0}));
  connect(latSki.y, booToIntSki.u) annotation (Line(points={{-18,30},{-10,30},{-10,
          -100},{238,-100}},
                          color={255,0,255}));
  connect(uDXCoi, booToIntEna.u) annotation (Line(points={{-160,-60},{-130,-60},
          {-130,-140},{-122,-140}},
                                  color={255,0,255}));
  connect(booToIntSki.y, mulSumInt.u[1:nCoi]) annotation (Line(points={{262,-100},
          {268,-100},{268,-118},{278,-118},{278,-120}},
                                                 color={255,127,0}));
  connect(booToIntEna.y, mulSumInt.u[nCoi+1:2*nCoi]) annotation (Line(points={{-98,
          -140},{268,-140},{268,-120},{278,-120}},
                                          color={255,127,0}));
  connect(intSwi.y, yNexCoi)
    annotation (Line(points={{402,-40},{440,-40}}, color={255,127,0}));
  connect(extIndIntOriSeq.y, intSwi.u3) annotation (Line(points={{352,-80},{360,
          -80},{360,-48},{378,-48}}, color={255,127,0}));
  connect(latSki.y, tim.u) annotation (Line(points={{-18,30},{-10,30},{-10,80},{
          -2,80}}, color={255,0,255}));
  connect(tim.y, rou.u) annotation (Line(points={{22,80},{30,80},{30,110},{38,110}},
        color={0,0,127}));
  connect(latSkiAva.y, booToInt.u) annotation (Line(points={{62,30},{70,30},{70,
          80},{78,80}}, color={255,0,255}));
  connect(rou.y, reaToInt1.u)
    annotation (Line(points={{62,110},{108,110}}, color={0,0,127}));
  connect(reaToInt1.y, mulInt.u1) annotation (Line(points={{132,110},{150,110},{
          150,106},{158,106}}, color={255,127,0}));
  connect(booToInt.y, mulInt.u2) annotation (Line(points={{102,80},{150,80},{150,
          94},{158,94}}, color={255,127,0}));
  connect(mulMax.y, reaToInt2.u) annotation (Line(points={{102,140},{108,140}},
                           color={0,0,127}));
  connect(reaToInt2.y, intScaRep.u)
    annotation (Line(points={{132,140},{158,140}}, color={255,127,0}));
  connect(intScaRep.y, intEqu.u1) annotation (Line(points={{182,140},{190,140},{
          190,130},{198,130}}, color={255,127,0}));
  connect(mulInt.y, intEqu.u2) annotation (Line(points={{182,100},{190,100},{190,
          122},{198,122}}, color={255,127,0}));
  connect(intEqu.y, booToInt1.u)
    annotation (Line(points={{222,130},{228,130}}, color={255,0,255}));
  connect(booToInt1.y, mulSumInt1.u[1:nCoi])
    annotation (Line(points={{252,130},{258,130}}, color={255,127,0}));
  connect(mulSumInt1.y, intGreThr1.u)
    annotation (Line(points={{282,130},{298,130}}, color={255,127,0}));
  connect(intGreThr1.y, intSwi1.u2)
    annotation (Line(points={{322,130},{330,130}}, color={255,0,255}));
  connect(booToInt1.y, mulInt1.u1) annotation (Line(points={{252,130},{256,130},
          {256,86},{258,86}}, color={255,127,0}));
  connect(conInt.y, mulInt1.u2) annotation (Line(points={{-98,260},{-80,260},{-80,
          10},{250,10},{250,74},{258,74}},
                         color={255,127,0}));
  connect(mulInt1.y, mulSumInt2.u[1:nCoi])
    annotation (Line(points={{282,80},{290,80},{290,80},{298,80}},
                                                 color={255,127,0}));
  connect(mulSumInt2.y, intSwi1.u3) annotation (Line(points={{322,80},{326,80},{
          326,122},{330,122}}, color={255,127,0}));
  connect(booToInt.y, mulSumInt3.u[1:nCoi]) annotation (Line(points={{102,80},{120,
          80},{120,-40},{146,-40}},                  color={255,127,0}));
  connect(mulSumInt3.y, intGreThr2.u)
    annotation (Line(points={{170,-40},{178,-40}}, color={255,127,0}));
  connect(mulInt1.y, intToRea1.u) annotation (Line(points={{282,80},{286,80},{286,
          170},{290,170}}, color={255,127,0}));
  connect(mulMin.y, reaToInt3.u)
    annotation (Line(points={{352,170},{358,170}}, color={0,0,127}));
  connect(reaToInt3.y, intSwi1.u1) annotation (Line(points={{382,170},{390,170},
          {390,152},{324,152},{324,138},{330,138}}, color={255,127,0}));
  connect(intGreThr2.y, intSwi.u2)
    annotation (Line(points={{202,-40},{378,-40}}, color={255,0,255}));
  connect(mulSumInt.y, addPar1.u)
    annotation (Line(points={{302,-120},{308,-120}}, color={255,127,0}));
  connect(addPar1.y, extIndIntOriSeq.index) annotation (Line(points={{332,-120},
          {340,-120},{340,-92}}, color={255,127,0}));
  connect(intGreThr2.y, or2.u2) annotation (Line(points={{202,-40},{220,-40},{
          220,-70},{142,-70},{142,242},{148,242}},
                                               color={255,0,255}));
  connect(addPar1.y, intScaRep1.u)
    annotation (Line(points={{332,-120},{358,-120}}, color={255,127,0}));
  connect(intScaRep1.y, intEqu1.u2) annotation (Line(points={{382,-120},{388,-120},
          {388,-160},{-72,-160},{-72,262},{-62,262}}, color={255,127,0}));
  connect(conInt.y, intEqu1.u1) annotation (Line(points={{-98,260},{-80,260},{-80,
          270},{-62,270}},                                 color={255,127,0}));
  connect(uDXCoiAva, and1.u2) annotation (Line(points={{-160,-20},{-120,-20},{-120,
          242},{-2,242}}, color={255,0,255}));
  connect(and1.y, mulOr.u[1:nCoi])
    annotation (Line(points={{22,250},{78,250}}, color={255,0,255}));
  connect(mulOr.y, or2.u1)
    annotation (Line(points={{102,250},{148,250}}, color={255,0,255}));
  connect(or2.y, and3.u1) annotation (Line(points={{172,250},{180,250},{180,230},
          {198,230}}, color={255,0,255}));
  connect(and3.y, yStaUp) annotation (Line(points={{222,230},{408,230},{408,0},
          {440,0}}, color={255,0,255}));
  connect(or2.y, not1.u) annotation (Line(points={{172,250},{180,250},{180,270},
          {238,270}}, color={255,0,255}));
  connect(not1.y, and4.u1)
    annotation (Line(points={{262,270},{278,270}}, color={255,0,255}));
  connect(and4.y, booScaRep.u)
    annotation (Line(points={{302,270},{318,270}}, color={255,0,255}));
  connect(and5.y, latSki.u) annotation (Line(points={{22,290},{40,290},{40,200},
          {-50,200},{-50,30},{-42,30}}, color={255,0,255}));
  connect(or1.y, and3.u2) annotation (Line(points={{132,220},{180,220},{180,222},
          {198,222}}, color={255,0,255}));
  connect(or1.y, and4.u2) annotation (Line(points={{132,220},{180,220},{180,210},
          {270,210},{270,262},{278,262}}, color={255,0,255}));
  connect(uStaUp, or1.u1) annotation (Line(points={{-160,20},{-100,20},{-100,220},
          {108,220}}, color={255,0,255}));
  connect(and5.y, mulOr1.u[1:nCoi]) annotation (Line(points={{22,290},{40,290},{40,
          200},{-50,200},{-50,170},{-42,170}}, color={255,0,255}));
  connect(mulOr1.y, lat.u)
    annotation (Line(points={{-18,170},{-2,170}}, color={255,0,255}));
  connect(and3.y, lat.clr) annotation (Line(points={{222,230},{232,230},{232,312},
          {-10,312},{-10,164},{-2,164}}, color={255,0,255}));
  connect(lat.y, booToRea.u)
    annotation (Line(points={{22,170},{28,170}}, color={255,0,255}));
  connect(booToRea.y, varPul.u)
    annotation (Line(points={{52,170},{58,170}}, color={0,0,127}));
  connect(intEqu1.y, pre1.u)
    annotation (Line(points={{-38,270},{-32,270}}, color={255,0,255}));
  connect(pre1.y, and5.u2) annotation (Line(points={{-8,270},{-4,270},{-4,282},
          {-2,282}}, color={255,0,255}));
  connect(pre1.y, and1.u1) annotation (Line(points={{-8,270},{-4,270},{-4,250},
          {-2,250}}, color={255,0,255}));
  connect(booScaRep.y, pre2.u)
    annotation (Line(points={{342,270},{346,270}}, color={255,0,255}));
  connect(pre2.y, and5.u1) annotation (Line(points={{370,270},{380,270},{380,
          320},{-4,320},{-4,290},{-2,290}}, color={255,0,255}));
  connect(pre.y, or1.u2) annotation (Line(points={{172,170},{180,170},{180,190},
          {100,190},{100,212},{108,212}}, color={255,0,255}));
  connect(varPul.y, not2.u)
    annotation (Line(points={{82,170},{88,170}}, color={255,0,255}));
  connect(pre.u, and6.y)
    annotation (Line(points={{148,170},{140,170}}, color={255,0,255}));
  connect(not2.y, and6.u1)
    annotation (Line(points={{112,170},{116,170}}, color={255,0,255}));
  connect(lat.y, and6.u2) annotation (Line(points={{22,170},{26,170},{26,186},{
          114,186},{114,162},{116,162}}, color={255,0,255}));
  connect(or3.y, latSkiAva.clr) annotation (Line(points={{30,-70},{34,-70},{34,
          24},{38,24}}, color={255,0,255}));
  connect(edg1.y, or3.u2) annotation (Line(points={{-98,-60},{-60,-60},{-60,-78},
          {6,-78}}, color={255,0,255}));
  connect(falEdg.y, or3.u1) annotation (Line(points={{-18,-66},{0,-66},{0,-70},
          {6,-70}}, color={255,0,255}));
  connect(uDXCoiAva, falEdg.u) annotation (Line(points={{-160,-20},{-120,-20},{
          -120,-40},{-50,-40},{-50,-66},{-42,-66}}, color={255,0,255}));
  connect(intSwi1.y, intSwi.u1) annotation (Line(points={{354,130},{370,130},{
          370,-32},{378,-32}}, color={255,127,0}));
  connect(intToRea2.y, mulMax.u[1:nCoi])
    annotation (Line(points={{62,140},{78,140}}, color={0,0,127}));
  connect(mulInt.y, intToRea2.u) annotation (Line(points={{182,100},{190,100},{190,
          126},{30,126},{30,140},{38,140}}, color={255,127,0}));
  connect(intToRea1.y, add2.u2) annotation (Line(points={{314,170},{318,170},{318,
          192},{300,192},{300,204},{308,204}}, color={0,0,127}));
  connect(booToRea1.y, add2.u1) annotation (Line(points={{254,190},{280,190},{280,
          216},{308,216}}, color={0,0,127}));
  connect(add2.y, mulMin.u[1:nCoi]) annotation (Line(points={{332,210},{340,210},{340,
          194},{320,194},{320,170},{328,170}}, color={0,0,127}));
  connect(latSkiAva.y, not3.u)
    annotation (Line(points={{62,30},{158,30}}, color={255,0,255}));
  connect(not3.y, booToRea1.u) annotation (Line(points={{182,30},{224,30},{224,190},
          {230,190}}, color={255,0,255}));
  connect(extIndIntOriSeq1.y, yLasCoi) annotation (Line(points={{352,-200},{392,
          -200},{392,-200},{440,-200}}, color={255,127,0}));
  connect(mulSumInt.y, extIndIntOriSeq1.index) annotation (Line(points={{302,-120},
          {304,-120},{304,-220},{340,-220},{340,-212}}, color={255,127,0}));
  connect(uCoiSeq, extIndIntOriSeq1.u) annotation (Line(points={{-160,60},{100,60},
          {100,-200},{328,-200}}, color={255,127,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100},{100,100}}),
      graphics={Rectangle(
        extent={{-100,100},{100,-100}},
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(
        extent={{-150,140},{150,100}},
        textString="%name",
        textColor={0,0,255})}),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-280},
            {420,340}})),
  Documentation(info="<html>
  <p>
  This is a control module for determining the next coil to be enabled, given a 
  coil staging sequence <code>uCoiSeq</code>, the current enable status of the 
  coils <code>uDXCoi</code> and the current availability of the coils <code>uDXCoiAva</code>.
  <br>
  The search logic is triggered when the module receives a Boolean <code>true</code>
  signal through the input <code>uStaUp</code>.
  When the next coil as per the defined sequence is not available, the controller
  uses pulses from the block <code>varPul</code> to drive a search logic that traverses
  through the following lists as ordered below to determine the next coil to enable.
  <ol>
  <li>
  the coils that were skipped over because thy were previously unable, but are 
  now available for enabling.
  </li>
  <li>
  the coils that are not yet enabled as per the input coil sequence, 
  and are available for enabling.
  </li>
  </ol>
  When the logic finds an appropriate coil, it outputs the coil index through the
  output <code>yNexCoi</code> and sends a Boolean stage up signal through the output
  <code>yStaUp</code>.
  </html>", revisions="<html>
  <ul>
  <li>
  August 4, 2023, by Junke Wang and Karthik Devaprasad:<br/>
  First implementation.
  </li>
  </ul>
  </html>"));
end NextCoil;
