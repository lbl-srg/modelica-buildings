within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences;
block PartLoadRatios
  "Operating and staging part load ratios with chiller type reset"

  parameter Boolean anyVsdCen = true
    "Plant contains at least one variable speed centrifugal chiller";

  parameter Integer nSta = 3
    "Number of chiller stages, does not include zero stage";

  parameter Real posDisMult(
    final unit = "1",
    final min = 0,
    final max = 1)=0.8
    "Positive displacement chiller type staging multiplier";

  parameter Real conSpeCenMult(
    final unit = "1",
    final min = 0,
    final max = 1)=0.9
    "Constant speed centrifugal chiller type staging multiplier";

  parameter Real anyOutOfScoMult(
    final unit = "1",
    final min = 0,
    final max = 1)=0.9
    "Outside of G36 recommended staging order chiller type SPLR multiplier"
    annotation(Evaluate=true, __cdl(ValueInReference=False));

  parameter Real varSpeStaMin(
    final unit = "1",
    final min = 0.1,
    final max = 1)=0.45
    "Minimum stage up or down part load ratio for variable speed centrifugal stage types"
    annotation(Evaluate=true, Dialog(enable=anyVsdCen));

  parameter Real varSpeStaMax(
    final unit = "1",
    final min = varSpeStaMin,
    final max = 1)=0.9
    "Maximum stage up or down part load ratio for variable speed centrifugal stage types"
    annotation(Evaluate=true, Dialog(enable=anyVsdCen));

  parameter Real avePer(
    final unit="s",
    final quantity="Time")=300
    "Moving mean time period for staging multiplier calculation for variable speed centrifugal stage types"
    annotation(Evaluate=true, Dialog(enable=anyVsdCen));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u(
    final min=0,
    final max=nSta) "Chiller stage"
    annotation (Placement(transformation(extent={{-420,220},{-380,260}}),
      iconTransformation(extent={{-140,-140},{-100,-100}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uUp(
    final min=0,
    final max=nSta) "Next available stage up"
    annotation (
      Placement(transformation(extent={{-420,180},{-380,220}}),
        iconTransformation(extent={{-140,-160},{-100,-120}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uDown(
    final min=0,
    final max=nSta) "Next available stage down"
    annotation (
      Placement(transformation(extent={{-420,20},{-380,60}}),
        iconTransformation(extent={{-140,-180},{-100,-140}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uTyp[nSta](
    final min=fill(1, nSta),
    final max=fill(3, nSta)) "Design chiller stage types"
    annotation (Placement(
        transformation(extent={{-420,280},{-380,320}}), iconTransformation(
          extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uUpCapDes(
    final unit="W",
    final quantity="HeatFlowRate")
    "Design capacity of the next available stage up"
    annotation (Placement(transformation(extent={{-420,-200},{-380,-160}}),
        iconTransformation(extent={{-140,80},{-100,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCapReq(
    final unit="W",
    final quantity="HeatFlowRate")
    "Chilled water cooling capacity requirement"
    annotation (Placement(transformation(extent={{-420,-30},{-380,10}}),
    iconTransformation(extent={{-140,120},{-100,160}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCapDes(
    final unit="W",
    final quantity="HeatFlowRate")
    "Design capacity of the current stage"
    annotation (Placement(transformation(extent={{-420,-100},{-380,-60}}),
        iconTransformation(extent={{-140,100},{-100,140}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uUpCapMin(
    final unit="W",
    final quantity="HeatFlowRate")
    "Minimal capacity of the next available stage up"
    annotation (Placement(transformation(extent={{-420,-300},{-380,-260}}),
        iconTransformation(extent={{-140,10},{-100,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uDowCapDes(
    final unit="W",
    final quantity="HeatFlowRate")
    "Design capacity of next available stage down"
    annotation (Placement(transformation(extent={{-420,-150},{-380,-110}}),
        iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLifMin(
    final unit="K",
    final quantity="TemperatureDifference") if anyVsdCen
    "Minimum chiller lift"
    annotation (Placement(transformation(extent={{-420,-450},{-380,-410}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLifMax(
    final unit="K",
    final quantity="TemperatureDifference") if anyVsdCen
    "Maximum chiller lift"
    annotation (Placement(transformation(extent={{-420,-380},{-380,-340}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLif(
    final unit="K",
    final quantity="TemperatureDifference") if anyVsdCen
    "Chiller lift"
    annotation (Placement(transformation(extent={{-420,-590},{-380,-550}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCapMin(
    final unit="W",
    final quantity="HeatFlowRate")
    "Minimal capacity of the current stage"
    annotation (Placement(transformation(extent={{-420,-240},{-380,-200}}),
        iconTransformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOpeUp(final unit="1",
      final min=0) "Operating part load ratio of the next higher stage"
    annotation (Placement(transformation(extent={{380,-140},{420,-100}}),
        iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOpeDow(final unit="1",
      final min=0) "Operating part load ratio of the next stage down"
    annotation (Placement(transformation(extent={{380,-100},{420,-60}}),
        iconTransformation(extent={{100,20},{140,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOpeMin(final unit="1",
      final min=0) "Minimum operating part load ratio at current stage"
    annotation (Placement(transformation(extent={{380,-220},{420,-180}}),
        iconTransformation(extent={{100,-90},{140,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOpe(
    final unit="1",
    final min=0) "Operating part load ratio of the current stage"
    annotation (
      Placement(transformation(extent={{380,-60},{420,-20}}),
        iconTransformation(extent={{100,60},{140,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaDow(
    final unit="1",
    final min = 0)
    "Staging down part load ratio"
    annotation (Placement(transformation(extent={{380,-180},{420,-140}}),
                    iconTransformation(extent={{100,-50},{140,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaUp(
    final unit="1",
    final min = 0)
    "Staging up part load ratio"
    annotation (Placement(transformation(extent={{380,-20},{420,20}}),
                    iconTransformation(extent={{100,-30},{140,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOpeUpMin(
    final unit="1",
    final min=0)
    "Minimum operating part load ratio of the next available stage up"
    annotation (Placement(transformation(extent={{380,-260},{420,-220}}),
        iconTransformation(extent={{100,-110},{140,-70}})));

protected
  final parameter Real small = Buildings.Controls.OBC.CDL.Constants.small
  "Small number to avoid division with zero";

  Buildings.Controls.OBC.CDL.Reals.Divide opePlrSta
    "Calculates operating part load ratio at the current stage"
    annotation (Placement(transformation(extent={{-200,-60},{-180,-40}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerExtractor extCurTyp(
    final nin=nSta)           "Extract current stage type"
    annotation (Placement(transformation(extent={{-120,290},{-100,310}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant one(
    final k=1) "Stage 1"
    annotation (Placement(transformation(extent={{-360,130},{-340,150}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerExtractor extUpTyp(
    final nin=nSta)
    "Extract stage type for the first higher available stage"
    annotation (Placement(transformation(extent={{-120,200},{-100,220}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerExtractor extDowTyp(
    final nin=nSta)
    "Extract stage type for the first lower available stage"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Logical switch"
    annotation (Placement(transformation(extent={{200,140},{220,160}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conSpeCenTyp(
    final k=Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.constantSpeedCentrifugal)
    "Stage type with any constant speed centrifugal chillers"
    annotation (Placement(transformation(extent={{-20,130},{0,150}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant posDisTyp(
    final k=Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement)
    "Stage type with none but positive displacement chillers"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu "Equality"
    annotation (Placement(transformation(extent={{60,160},{80,180}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant posDisTypMult(
    final k=posDisMult)
    "Positive displacement chiller type SPLR multiplier"
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conSpeCenTypMult(
    final k=conSpeCenMult)
    "Constant speed centrifugal chiller type SPLR multiplier"
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi1 "Logical switch"
    annotation (Placement(transformation(extent={{160,60},{180,80}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi2 "Logical switch"
    annotation (Placement(transformation(extent={{100,-190},{120,-170}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi3 "Logical switch"
    annotation (Placement(transformation(extent={{60,-240},{80,-220}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1 "Logical equality"
    annotation (Placement(transformation(extent={{60,100},{80,120}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2 "Logical equality"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  Buildings.Controls.OBC.CDL.Reals.Divide minOpePlrUp
   "Calculates minimum OPLR of one stage up"
    annotation (Placement(transformation(extent={{-200,-200},{-180,-180}})));

  Buildings.Controls.OBC.CDL.Reals.Divide opePlrUp
    "Calculates operating part load ratio at the next stage up"
    annotation (Placement(transformation(extent={{-200,-150},{-180,-130}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant const(
    final k=0.9) if anyVsdCen "Constant"
    annotation (Placement(transformation(extent={{-200,-360},{-180,-340}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract sub2
    if anyVsdCen "Subtract"
    annotation (Placement(transformation(extent={{-80,-420},{-60,-400}})));

  Buildings.Controls.OBC.CDL.Reals.Divide div if anyVsdCen
    "Division"
    annotation (Placement(transformation(extent={{-20,-370},{0,-350}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant const1(
    final k=0.4) if anyVsdCen "Constant"
    annotation (Placement(transformation(extent={{-200,-480},{-180,-460}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant const2(
    final k=1.4) if anyVsdCen "Constant"
    annotation (Placement(transformation(extent={{-200,-560},{-180,-540}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract sub1
    if anyVsdCen "Subtract"
    annotation (Placement(transformation(extent={{-80,-500},{-60,-480}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply mult0 if anyVsdCen "Multiplier"
    annotation (Placement(transformation(extent={{-140,-460},{-120,-440}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply mult1 if anyVsdCen "Multiplier"
    annotation (Placement(transformation(extent={{-140,-540},{-120,-520}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply mult2 if anyVsdCen "Multiplier"
    annotation (Placement(transformation(extent={{40,-440},{60,-420}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply mult3 if anyVsdCen "Multiplier"
    annotation (Placement(transformation(extent={{100,-510},{120,-490}})));

  Buildings.Controls.OBC.CDL.Reals.Add add3 if anyVsdCen "Add"
    annotation (Placement(transformation(extent={{160,-482},{180,-462}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant const3(
    final k=-1) if not anyVsdCen
    "Constant"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant const4(
    final k=-1) if not anyVsdCen
    "Constant"
    annotation (Placement(transformation(extent={{0,-260},{20,-240}})));

  Buildings.Controls.OBC.CDL.Utilities.Assert cheStaTyp(
    final message="Recommended staging order got violated or an unlisted chiller type got provided when staging up")
    "Chiller type outside of recommenation when staging up"
    annotation (Placement(transformation(extent={{300,280},{320,300}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(
    final t=-0.5)
    "Less than threshold"
    annotation (Placement(transformation(extent={{260,200},{280,220}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr1(
    final t=-0.5) "Less than threshold"
    annotation (Placement(transformation(extent={{200,-110},{220,-90}})));

  Buildings.Controls.OBC.CDL.Reals.Divide opePlrDow
    "Calculates operating part load ratio of the next stage down"
    annotation (Placement(transformation(extent={{-200,-90},{-180,-70}})));

  Buildings.Controls.OBC.CDL.Reals.Divide minOpePlr
    "Calculates minimum OPLR of the current stage"
    annotation (Placement(transformation(extent={{-200,-240},{-180,-220}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu3 "Integer equal"
    annotation (Placement(transformation(extent={{60,240},{80,260}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi4 "Switch"
    annotation (Placement(transformation(extent={{160,-170},{180,-150}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant const5(
    final k=1)
    "If staging down to stage 0 set staging down part load to 1"
    annotation (Placement(transformation(extent={{100,-150},{120,-130}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu4 "Equality"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));

  Buildings.Controls.OBC.CDL.Integers.Max maxInt "Maximum"
    annotation (Placement(transformation(extent={{-300,260},{-280,280}})));

  Buildings.Controls.OBC.CDL.Integers.Max maxIntUp "Maximum"
    annotation (Placement(transformation(extent={{-300,170},{-280,190}})));

  Buildings.Controls.OBC.CDL.Integers.Max maxIntDown "Maximum"
    annotation (Placement(transformation(extent={{-300,60},{-280,80}})));

  Buildings.Controls.OBC.CDL.Reals.Max max if anyVsdCen "Maximum"
    annotation (Placement(transformation(extent={{220,-420},{240,-400}})));

  Buildings.Controls.OBC.CDL.Reals.Min min if anyVsdCen "Minimum"
    annotation (Placement(transformation(extent={{260,-380},{280,-360}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant maxLim(
    final k=varSpeStaMax) if anyVsdCen "Constant"
    annotation (Placement(transformation(extent={{160,-360},{180,-340}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minLim(
    final k=varSpeStaMin) if anyVsdCen "Constant"
    annotation (Placement(transformation(extent={{160,-420},{180,-400}})));

  Buildings.Controls.OBC.CDL.Utilities.Assert cheStaTyp1(
    final message="Recommended staging order got violated or an unlisted chiller type got provided when staging down")
    "Chiller type outside of recommenation when staging down"
    annotation (Placement(transformation(extent={{260,-20},{280,0}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conSpeCenTypMult1(
    final k=anyOutOfScoMult)
    "Outside of G36 recommended staging order chiller type SPLR multiplier"
    annotation (Placement(transformation(extent={{200,20},{220,40}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi5
    "Logical switch"
    annotation (Placement(transformation(extent={{320,220},{340,240}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi6
    "Logical switch"
    annotation (Placement(transformation(extent={{260,-110},{280,-90}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant smaNum(
    final k=small) "Small constant"
    annotation (Placement(transformation(extent={{-360,-54},{-340,-34}})));

  Buildings.Controls.OBC.CDL.Reals.Max max1
    "Maximum output to avoid zero denominator in downstream"
    annotation (Placement(transformation(extent={{-300,-60},{-280,-40}})));

  Buildings.Controls.OBC.CDL.Reals.Max max2
    "Maximum output to avoid zero denominator in downstream"
    annotation (Placement(transformation(extent={{-300,-110},{-280,-90}})));

  Buildings.Controls.OBC.CDL.Reals.Max max3
    "Maximum output to avoid zero denominator in downstream"
    annotation (Placement(transformation(extent={{-300,-170},{-280,-150}})));

  Buildings.Controls.OBC.CDL.Reals.MovingAverage movMea(
    final delta=avePer) if anyVsdCen "Moving mean"
    annotation (Placement(transformation(extent={{300,-330},{320,-310}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr[3](
    final t=fill(nSta, 3))
    "Check if index is out of the range"
    annotation (Placement(transformation(extent={{-240,140},{-220,160}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi[3]
    "Valid index"
    annotation (Placement(transformation(extent={{-180,80},{-160,100}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[3](
    final k=fill(nSta, 3))
    "Dummy index so the extractor will not have out of range index"
    annotation (Placement(transformation(extent={{-240,230},{-220,250}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi1[3]
    "Valid value"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant con[3](
    final k=fill(-1, 3)) "Dummy stage"
    annotation (Placement(transformation(extent={{-180,160},{-160,180}})));

equation
  connect(intEqu.u2, conSpeCenTyp.y) annotation (Line(points={{58,162},{10,162},
          {10,140},{2,140}}, color={255,127,0}));
  connect(opePlrSta.y, yOpe) annotation (Line(points={{-178,-50},{0,-50},{0,-40},
          {400,-40}}, color={0,0,127}));
  connect(posDisTyp.y, intEqu1.u2) annotation (Line(points={{2,80},{10,80},{10,102},
          {58,102}}, color={255,127,0}));
  connect(intEqu1.y, swi1.u2) annotation (Line(points={{82,110},{140,110},{140,70},
          {158,70}},color={255,0,255}));
  connect(swi1.y, swi.u3) annotation (Line(points={{182,70},{190,70},{190,142},{
          198,142}}, color={0,0,127}));
  connect(posDisTyp.y, intEqu2.u2) annotation (Line(points={{2,80},{10,80},{10,22},
          {18,22}},      color={255,127,0}));
  connect(swi3.y, swi2.u3) annotation (Line(points={{82,-230},{90,-230},{90,-188},
          {98,-188}}, color={0,0,127}));
  connect(intEqu2.y, swi3.u2) annotation (Line(points={{42,30},{50,30},{50,-230},
          {58,-230}}, color={255,0,255}));
  connect(opePlrUp.y, yOpeUp) annotation (Line(points={{-178,-140},{0,-140},{0,-120},
          {400,-120}},           color={0,0,127}));
  connect(minOpePlrUp.y, yOpeUpMin) annotation (Line(points={{-178,-190},{-60,-190},
          {-60,-280},{240,-280},{240,-240},{400,-240}},        color={0,0,127}));
  connect(uLifMin, sub2.u2) annotation (Line(points={{-400,-430},{-240,-430},{-240,
          -416},{-82,-416}},  color={0,0,127}));
  connect(const.y, div.u1) annotation (Line(points={{-178,-350},{-40,-350},{-40,
          -354},{-22,-354}}, color={0,0,127}));
  connect(sub2.y, div.u2) annotation (Line(points={{-58,-410},{-40,-410},{-40,-366},
          {-22,-366}}, color={0,0,127}));
  connect(const1.y, mult0.u2) annotation (Line(points={{-178,-470},{-160,-470},{
          -160,-456},{-142,-456}}, color={0,0,127}));
  connect(uLifMax, mult0.u1) annotation (Line(points={{-400,-360},{-220,-360},{-220,
          -444},{-142,-444}},  color={0,0,127}));
  connect(uLifMin, mult1.u1) annotation (Line(points={{-400,-430},{-240,-430},{-240,
          -524},{-142,-524}},
        color={0,0,127}));
  connect(const2.y, mult1.u2) annotation (Line(points={{-178,-550},{-160,-550},{
          -160,-536},{-142,-536}}, color={0,0,127}));
  connect(mult0.y, sub1.u1) annotation (Line(points={{-118,-450},{-110,-450},{-110,
          -484},{-82,-484}},  color={0,0,127}));
  connect(mult1.y, sub1.u2) annotation (Line(points={{-118,-530},{-108,-530},{-108,
          -496},{-82,-496}},  color={0,0,127}));
  connect(div.y, mult2.u1) annotation (Line(points={{2,-360},{20,-360},{20,-424},
          {38,-424}}, color={0,0,127}));
  connect(sub1.y, mult2.u2) annotation (Line(points={{-58,-490},{20,-490},{20,-436},
          {38,-436}},       color={0,0,127}));
  connect(div.y, mult3.u1) annotation (Line(points={{2,-360},{80,-360},{80,-494},
          {98,-494}},
        color={0,0,127}));
  connect(uLif, mult3.u2) annotation (Line(points={{-400,-570},{80,-570},{80,-506},
          {98,-506}}, color={0,0,127}));
  connect(mult3.y, add3.u2) annotation (Line(points={{122,-500},{130,-500},{130,
          -478},{158,-478}}, color={0,0,127}));
  connect(mult2.y, add3.u1) annotation (Line(points={{62,-430},{140,-430},{140,-466},
          {158,-466}}, color={0,0,127}));
  connect(swi.y,greThr. u) annotation (Line(points={{222,150},{248,150},{248,210},
          {258,210}}, color={0,0,127}));
  connect(uLifMax, sub2.u1) annotation (Line(points={{-400,-360},{-220,-360},{-220,
          -404},{-82,-404}},                          color={0,0,127}));
  connect(opePlrDow.y, yOpeDow)
    annotation (Line(points={{-178,-80},{400,-80}}, color={0,0,127}));
  connect(minOpePlr.y, yOpeMin) annotation (Line(points={{-178,-230},{-40,-230},
          {-40,-200},{400,-200}}, color={0,0,127}));
  connect(conSpeCenTypMult.y, swi.u1) annotation (Line(points={{-118,-30},{0,-30},
          {0,-20},{96,-20},{96,158},{198,158}}, color={0,0,127}));
  connect(posDisTypMult.y, swi1.u1) annotation (Line(points={{-118,-110},{-20,-110},
          {-20,50},{40,50},{40,78},{158,78}},     color={0,0,127}));
  connect(posDisTypMult.y, swi3.u1) annotation (Line(points={{-118,-110},{-20,-110},
          {-20,-222},{58,-222}}, color={0,0,127}));
  connect(conSpeCenTypMult.y, swi2.u1) annotation (Line(points={{-118,-30},{40,-30},
          {40,-172},{98,-172}},color={0,0,127}));
  connect(conSpeCenTyp.y, intEqu3.u2) annotation (Line(points={{2,140},{10,140},
          {10,242},{58,242}},  color={255,127,0}));
  connect(intEqu3.y, swi2.u2) annotation (Line(points={{82,250},{90,250},{90,-180},
          {98,-180}},color={255,0,255}));
  connect(uCapMin, minOpePlr.u1) annotation (Line(points={{-400,-220},{-300,-220},
          {-300,-224},{-202,-224}}, color={0,0,127}));
  connect(uUpCapMin, minOpePlrUp.u1) annotation (Line(points={{-400,-280},{-220,
          -280},{-220,-184},{-202,-184}}, color={0,0,127}));
  connect(intEqu.y, swi.u2) annotation (Line(points={{82,170},{160,170},{160,150},
          {198,150}}, color={255,0,255}));
  connect(const4.y, swi3.u3) annotation (Line(points={{22,-250},{40,-250},{40,-238},
          {58,-238}}, color={0,0,127}));
  connect(const3.y, swi1.u3) annotation (Line(points={{122,30},{140,30},{140,62},
          {158,62}}, color={0,0,127}));
  connect(swi2.y, swi4.u3) annotation (Line(points={{122,-180},{140,-180},{140,-168},
          {158,-168}}, color={0,0,127}));
  connect(const5.y, swi4.u1) annotation (Line(points={{122,-140},{140,-140},{140,
          -152},{158,-152}}, color={0,0,127}));
  connect(u, intEqu4.u2) annotation (Line(points={{-400,240},{-330,240},{-330,2},
          {-142,2}},                        color={255,127,0}));
  connect(one.y, intEqu4.u1) annotation (Line(points={{-338,140},{-320,140},{-320,
          10},{-142,10}},                     color={255,127,0}));
  connect(intEqu4.y, swi4.u2) annotation (Line(points={{-118,10},{20,10},{20,-160},
          {158,-160}}, color={255,0,255}));
  connect(one.y, maxInt.u2) annotation (Line(points={{-338,140},{-320,140},{-320,
          264},{-302,264}}, color={255,127,0}));
  connect(u, maxInt.u1) annotation (Line(points={{-400,240},{-330,240},{-330,276},
          {-302,276}}, color={255,127,0}));
  connect(one.y, maxIntUp.u2) annotation (Line(points={{-338,140},{-320,140},{-320,
          174},{-302,174}}, color={255,127,0}));
  connect(uUp, maxIntUp.u1) annotation (Line(points={{-400,200},{-340,200},{-340,
          186},{-302,186}},      color={255,127,0}));
  connect(one.y, maxIntDown.u1) annotation (Line(points={{-338,140},{-320,140},{
          -320,76},{-302,76}},   color={255,127,0}));
  connect(uDown, maxIntDown.u2) annotation (Line(points={{-400,40},{-340,40},{-340,
          64},{-302,64}},         color={255,127,0}));
  connect(add3.y, max.u2) annotation (Line(points={{182,-472},{200,-472},{200,-416},
          {218,-416}}, color={0,0,127}));
  connect(minLim.y, max.u1) annotation (Line(points={{182,-410},{200,-410},{200,
          -404},{218,-404}}, color={0,0,127}));
  connect(max.y, min.u2) annotation (Line(points={{242,-410},{250,-410},{250,-376},
          {258,-376}}, color={0,0,127}));
  connect(maxLim.y, min.u1) annotation (Line(points={{182,-350},{220,-350},{220,
          -364},{258,-364}}, color={0,0,127}));
  connect(swi4.y, greThr1.u) annotation (Line(points={{182,-160},{192,-160},{192,
          -100},{198,-100}},     color={0,0,127}));
  connect(swi.y, swi5.u1) annotation (Line(points={{222,150},{240,150},{240,238},
          {318,238}}, color={0,0,127}));
  connect(greThr.y, swi5.u2) annotation (Line(points={{282,210},{290,210},{290,230},
          {318,230}}, color={255,0,255}));
  connect(greThr.y, cheStaTyp.u) annotation (Line(points={{282,210},{290,210},{290,
          290},{298,290}}, color={255,0,255}));
  connect(conSpeCenTypMult1.y, swi5.u3) annotation (Line(points={{222,30},{300,30},
          {300,222},{318,222}}, color={0,0,127}));
  connect(swi5.y, yStaUp) annotation (Line(points={{342,230},{354,230},{354,0},
          {400,0}},color={0,0,127}));
  connect(swi6.y, yStaDow) annotation (Line(points={{282,-100},{290,-100},{290,-160},
          {400,-160}}, color={0,0,127}));
  connect(greThr1.y, swi6.u2)
    annotation (Line(points={{222,-100},{258,-100}}, color={255,0,255}));
  connect(swi4.y, swi6.u1) annotation (Line(points={{182,-160},{240,-160},{240,-92},
          {258,-92}}, color={0,0,127}));
  connect(conSpeCenTypMult1.y, swi6.u3) annotation (Line(points={{222,30},{250,30},
          {250,-108},{258,-108}}, color={0,0,127}));
  connect(greThr1.y, cheStaTyp1.u) annotation (Line(points={{222,-100},{230,-100},
          {230,-10},{258,-10}}, color={255,0,255}));
  connect(max1.y, opePlrSta.u2) annotation (Line(points={{-278,-50},{-240,-50},
          {-240,-56},{-202,-56}}, color={0,0,127}));
  connect(smaNum.y, max1.u1) annotation (Line(points={{-338,-44},{-302,-44}},
                            color={0,0,127}));
  connect(max1.y, minOpePlr.u2) annotation (Line(points={{-278,-50},{-260,-50},{
          -260,-236},{-202,-236}},  color={0,0,127}));
  connect(max2.y, opePlrDow.u2) annotation (Line(points={{-278,-100},{-240,-100},
          {-240,-86},{-202,-86}}, color={0,0,127}));
  connect(smaNum.y, max2.u1) annotation (Line(points={{-338,-44},{-320,-44},{-320,
          -94},{-302,-94}}, color={0,0,127}));
  connect(uDowCapDes, max2.u2) annotation (Line(points={{-400,-130},{-330,-130},
          {-330,-106},{-302,-106}}, color={0,0,127}));
  connect(max3.y, opePlrUp.u2) annotation (Line(points={{-278,-160},{-240,-160},
          {-240,-146},{-202,-146}}, color={0,0,127}));
  connect(max3.y, minOpePlrUp.u2) annotation (Line(points={{-278,-160},{-240,
          -160},{-240,-196},{-202,-196},{-202,-196}}, color={0,0,127}));
  connect(smaNum.y, max3.u1) annotation (Line(points={{-338,-44},{-320,-44},{-320,
          -154},{-302,-154}}, color={0,0,127}));
  connect(uUpCapDes, max3.u2) annotation (Line(points={{-400,-180},{-320,-180},{
          -320,-166},{-302,-166}},  color={0,0,127}));
  connect(uCapDes, max1.u2) annotation (Line(points={{-400,-80},{-330,-80},{-330,
          -56},{-302,-56}},      color={0,0,127}));
  connect(uCapReq, opePlrSta.u1) annotation (Line(points={{-400,-10},{-220,-10},
          {-220,-44},{-202,-44}}, color={0,0,127}));
  connect(uCapReq, opePlrDow.u1) annotation (Line(points={{-400,-10},{-220,-10},
          {-220,-74},{-202,-74}}, color={0,0,127}));
  connect(uCapReq, opePlrUp.u1) annotation (Line(points={{-400,-10},{-220,-10},{
          -220,-134},{-202,-134}},  color={0,0,127}));
  connect(min.y, movMea.u) annotation (Line(points={{282,-370},{290,-370},{290,-320},
          {298,-320}}, color={0,0,127}));
  connect(movMea.y, swi3.u3) annotation (Line(points={{322,-320},{340,-320},{340,
          -300},{50,-300},{50,-238},{58,-238}}, color={0,0,127}));
  connect(movMea.y, swi1.u3) annotation (Line(points={{322,-320},{340,-320},{340,
          -260},{150,-260},{150,62},{158,62}}, color={0,0,127}));
  connect(uTyp, extCurTyp.u)
    annotation (Line(points={{-400,300},{-122,300}}, color={255,127,0}));
  connect(uTyp, extUpTyp.u) annotation (Line(points={{-400,300},{-140,300},{
          -140,210},{-122,210}}, color={255,127,0}));
  connect(uTyp, extDowTyp.u) annotation (Line(points={{-400,300},{-140,300},{-140,
          120},{-122,120}},      color={255,127,0}));
  connect(maxInt.y, intGreThr[1].u) annotation (Line(points={{-278,270},{-260,270},
          {-260,150},{-242,150}}, color={255,127,0}));
  connect(intGreThr.y, intSwi.u2) annotation (Line(points={{-218,150},{-190,150},
          {-190,90},{-182,90}}, color={255,0,255}));
  connect(maxInt.y, intSwi[1].u3) annotation (Line(points={{-278,270},{-200,270},
          {-200,82},{-182,82}}, color={255,127,0}));
  connect(intSwi[1].y, extCurTyp.index) annotation (Line(points={{-158,90},{-150,
          90},{-150,280},{-110,280},{-110,288}}, color={255,127,0}));
  connect(maxIntUp.y, intGreThr[2].u) annotation (Line(points={{-278,180},{-260,
          180},{-260,150},{-242,150}}, color={255,127,0}));
  connect(conInt.y, intSwi.u1) annotation (Line(points={{-218,240},{-210,240},{-210,
          98},{-182,98}}, color={255,127,0}));
  connect(intSwi[2].y, extUpTyp.index) annotation (Line(points={{-158,90},{-150,
          90},{-150,190},{-110,190},{-110,198}}, color={255,127,0}));
  connect(maxIntDown.y, intGreThr[3].u) annotation (Line(points={{-278,70},{-260,
          70},{-260,150},{-242,150}}, color={255,127,0}));
  connect(maxIntUp.y, intSwi[2].u3) annotation (Line(points={{-278,180},{-200,180},
          {-200,82},{-182,82}}, color={255,127,0}));
  connect(intSwi[3].y, extDowTyp.index) annotation (Line(points={{-158,90},{-110,
          90},{-110,108}}, color={255,127,0}));
  connect(maxIntDown.y, intSwi[3].u3) annotation (Line(points={{-278,70},{-200,70},
          {-200,82},{-182,82}}, color={255,127,0}));
  connect(intGreThr.y, intSwi1.u2)
    annotation (Line(points={{-218,150},{-82,150}}, color={255,0,255}));
  connect(con.y, intSwi1.u1) annotation (Line(points={{-158,170},{-100,170},{-100,
          158},{-82,158}}, color={255,127,0}));
  connect(extCurTyp.y, intSwi1[1].u3) annotation (Line(points={{-98,300},{-90,300},
          {-90,142},{-82,142}}, color={255,127,0}));
  connect(extUpTyp.y, intSwi1[2].u3) annotation (Line(points={{-98,210},{-90,210},
          {-90,142},{-82,142}}, color={255,127,0}));
  connect(extDowTyp.y, intSwi1[3].u3) annotation (Line(points={{-98,120},{-90,120},
          {-90,142},{-82,142}}, color={255,127,0}));
  connect(intSwi1[1].y, intEqu3.u1) annotation (Line(points={{-58,150},{-50,150},
          {-50,250},{58,250}}, color={255,127,0}));
  connect(intSwi1[1].y, intEqu1.u1) annotation (Line(points={{-58,150},{-50,150},
          {-50,110},{58,110}}, color={255,127,0}));
  connect(intSwi1[2].y, intEqu.u1) annotation (Line(points={{-58,150},{-40,150},
          {-40,170},{58,170}}, color={255,127,0}));
  connect(intSwi1[3].y, intEqu2.u1) annotation (Line(points={{-58,150},{-40,150},
          {-40,30},{18,30}}, color={255,127,0}));
  annotation (defaultComponentName = "PLRs",
  Icon(coordinateSystem(extent={{-100,-200},{100,200}}), graphics={
        Text(
          extent={{-100,240},{100,200}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
        extent={{-100,-200},{100,200}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-60,36},{64,-42}},
          textColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="PLR")}), Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-380,-600},{380,340}})),
Documentation(info="<html>
<p>
Calculates operative part load ratios (OPLR) per sections 5.20.4.5, section 5.20.4.9,
section 5.20.4.10 and stage part load ratios (SPLR, up or down) per section 5.20.4.14
of Guideline36-2021.
</p>
<p>
OPLR is a ratio of the current capacity requirement to a given design or minimal
stage capacity, such as:
</p>
<ul>
<li>
Current stage design OPLR(<sub>y</sub>).
</li>
<li>
Current stage minimal OPLR(<sub>yMin</sub>).
</li>
<li>
Next available higher stage nominal OPLR(<sub>yUp</sub>).
</li>
<li>
Next available higher stage minimal OPLR(<sub>yUpMin</sub>).
</li>
</ul>
<p>
SPLRup <code>yStaUp</code> or SPLRdown <code>yStaDown</code> value depends on the
stage type <code>staTyp</code> as indicated in the table below.
Note that the rules are prioritized by stage type column, from left to right
</p>
<p>
The stage type is determined by the
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Configurator\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Configurator</a>
subsequence based on the type of chillers staged.
</p>
<table summary=\"summary\" cellspacing=\"2\" cellpadding=\"0\" border=\"1\"><tr>
<td><b>Row: Stage / Column: Stage Type</b></td>
<td><b>Any Constant Speed Centrifugal</b></td>
<td><b>All Positive Displacement</b></td>
<td><b>Any Variable Speed and no Constant Speed Centrifugal</b></td>
</tr>
<tr>
<td>Next Available Up</td>
<td>yStaUp=conSpeCenMult</td>
<td>N/A</td>
<td>>N/A</td>
</tr>
<tr>
<td>Current</td>
<td>yStaDown=conSpeCenMult</td>
<td>yStaUp=posDisMult</td>
<td>yStaUp=f(uLif, uLifMin, uLifMax)</td>
</tr>
<tr>
<td>Next Available Down</td>
<td>N/A</td>
<td>yStaDown=posDisMult</td>
<td>yStaDown=f(uLif, uLifMin, uLifMax)</td>
</tr>
</table>
<p>
For operation outside of the recommended staging order as provided in the table
above a constant SPLRup and SPLRdown value <code>anyOutOfScoMult</code> is set to prevent
simulation interruption, accompanied with a warning.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 03, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartLoadRatios;
