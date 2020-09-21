within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences;
block PartLoadRatios
  "Operating and staging part load ratios with chiller type reset"

  parameter Boolean anyVsdCen = true
    "Plant contains at least one variable speed centrifugal chiller";

  parameter Integer nSta = 3
    "Total number of chiller stages";

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

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u(
    final min=0,
    final max=nSta) "Chiller stage"
    annotation (Placement(transformation(extent={{-380,
            220},{-340,260}}), iconTransformation(extent={{-140,-140},{-100,
            -100}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uUp(
    final min=0,
    final max=nSta) "Next available stage up"
    annotation (
      Placement(transformation(extent={{-380,160},{-340,200}}),
        iconTransformation(extent={{-140,-160},{-100,-120}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uDown(
    final min=0,
    final max=nSta) "Next available stage down"
    annotation (
      Placement(transformation(extent={{-380,100},{-340,140}}),
        iconTransformation(extent={{-140,-180},{-100,-140}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uTyp[nSta](
    final min=fill(1, nSta),
    final max=fill(3, nSta)) "Design chiller stage types"
    annotation (Placement(
        transformation(extent={{-380,280},{-340,320}}), iconTransformation(
          extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uUpCapDes(
    final unit="W",
    final quantity="Power")
    "Design capacity of the next available stage up"
    annotation (Placement(transformation(extent={{-380,-180},{-340,-140}}),
        iconTransformation(extent={{-140,80},{-100,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCapReq(
    final unit="W",
    final quantity="Power")
    "Chilled water cooling capacity requirement"
    annotation (Placement(transformation(extent={{-380,-30},{-340,10}}),
    iconTransformation(extent={{-140,120},{-100,160}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCapDes(
    final unit="W",
    final quantity="Power")
    "Design capacity of the current stage"
    annotation (Placement(transformation(extent={{-380,-70},{-340,-30}}),
        iconTransformation(extent={{-140,100},{-100,140}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uUpCapMin(
    final unit="W",
    final quantity="Power")
    "Minimal capacity of the next available stage up"
    annotation (Placement(transformation(extent={{-380,-300},{-340,-260}}),
        iconTransformation(extent={{-140,10},{-100,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uDowCapDes(
    final unit="W",
    final quantity="Power")
    "Design capacity of next available stage down"
    annotation (Placement(transformation(extent={{-380,-120},{-340,-80}}),
        iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLifMin(
    final unit="K",
    final quantity="TemperatureDifference") if anyVsdCen
    "Minimum chiller lift"
    annotation (Placement(transformation(extent={{-380,-440},{-340,-400}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLifMax(
    final unit="K",
    final quantity="TemperatureDifference") if anyVsdCen
    "Maximum chiller lift"
    annotation (Placement(transformation(extent={{-380,-380},{-340,-340}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLif(
    final unit="K",
    final quantity="TemperatureDifference") if anyVsdCen
    "Chiller lift"
    annotation (Placement(transformation(extent={{-380,-500},{-340,-460}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCapMin(
    final unit="W",
    final quantity="Power")
    "Minimal capacity of the current stage"
    annotation (Placement(transformation(extent={{-380,-240},{-340,-200}}),
        iconTransformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOpeUp(final unit="1",
      final min=0) "Operating part load ratio of the next higher stage"
    annotation (Placement(transformation(extent={{340,-140},{380,-100}}),
        iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOpeDow(final unit="1",
      final min=0) "Operating part load ratio of the next stage down"
    annotation (Placement(transformation(extent={{340,-100},{380,-60}}),
        iconTransformation(extent={{100,20},{140,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOpeMin(final unit="1",
      final min=0) "Minimum operating part load ratio at current stage"
    annotation (Placement(transformation(extent={{340,-220},{380,-180}}),
        iconTransformation(extent={{100,-90},{140,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOpe(
    final unit="1",
    final min=0) "Operating part load ratio of the current stage"
    annotation (
      Placement(transformation(extent={{340,-60},{380,-20}}),
        iconTransformation(extent={{100,60},{140,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaDow(
    final unit="1",
    final min = 0)
    "Staging down part load ratio"
    annotation (Placement(transformation(extent={{340,-180},{380,-140}}),
                    iconTransformation(extent={{100,-50},{140,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaUp(
    final unit="1",
    final min = 0)
    "Staging up part load ratio"
    annotation (Placement(transformation(extent={{340,-20},{380,20}}),
                    iconTransformation(extent={{100,-30},{140,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOpeUpMin(
    final unit="1",
    final min=0)
    "Minimum operating part load ratio of the next available stage up"
    annotation (Placement(transformation(extent={{340,-260},{380,-220}}),
        iconTransformation(extent={{100,-110},{140,-70}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Division opePlrSta
    "Calculates operating part load ratio at the current stage"
    annotation (Placement(transformation(extent={{-240,-60},{-220,-40}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extCurTyp(
    final nin=nSta,
    final outOfRangeValue=-1) "Extract current stage type"
    annotation (Placement(transformation(extent={{-160,290},{-140,310}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant one(
    final k=1) "Stage 1"
    annotation (Placement(transformation(extent={{-300,140},{-280,160}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger curStaTyp
    "Current stage chiller type"
    annotation (Placement(transformation(extent={{-120,290},{-100,310}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger staUpTyp
    "Stage up chiller type"
    annotation (Placement(transformation(extent={{-120,200},{-100,220}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extUpTyp(
    final nin=nSta,
    final outOfRangeValue=-1)
    "Extract stage type for the first higher available stage"
    annotation (Placement(transformation(extent={{-160,200},{-140,220}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extDowTyp(
    final nin=nSta,
    final outOfRangeValue=-1)
    "Extract stage type for the first lower available stage"
    annotation (Placement(transformation(extent={{-160,120},{-140,140}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger staDowTyp1
    "Stage down chiller type"
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Logical switch"
    annotation (Placement(transformation(extent={{160,140},{180,160}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conSpeCenTyp(
    final k=Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.constantSpeedCentrifugal)
    "Stage type with any constant speed centrifugal chillers"
    annotation (Placement(transformation(extent={{-60,130},{-40,150}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant posDisTyp(
    final k=Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement)
    "Stage type with none but positive displacement chillers"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu "Equality"
    annotation (Placement(transformation(extent={{20,160},{40,180}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant posDisTypMult(
    final k=posDisMult)
    "Positive displacement chiller type SPLR multiplier"
    annotation (Placement(transformation(extent={{-180,-120},{-160,-100}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conSpeCenTypMult(
    final k=conSpeCenMult)
    "Constant speed centrifugal chiller type SPLR multiplier"
    annotation (Placement(transformation(extent={{-180,-40},{-160,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi1 "Logical switch"
    annotation (Placement(transformation(extent={{120,60},{140,80}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi2 "Logical switch"
    annotation (Placement(transformation(extent={{60,-190},{80,-170}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi3 "Logical switch"
    annotation (Placement(transformation(extent={{20,-240},{40,-220}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1 "Logical equality"
    annotation (Placement(transformation(extent={{20,100},{40,120}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2 "Logical equality"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Division minOpePlrUp
   "Calculates minimum OPLR of one stage up"
    annotation (Placement(transformation(extent={{-240,-200},{-220,-180}})));

  Buildings.Controls.OBC.CDL.Continuous.Division opePlrUp
    "Calculates operating part load ratio at the next stage up"
    annotation (Placement(transformation(extent={{-240,-150},{-220,-130}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const(
    final k=0.9) if anyVsdCen "Constant"
    annotation (Placement(transformation(extent={{-240,-360},{-220,-340}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add2(
    final k2=-1) if anyVsdCen "Subtract"
    annotation (Placement(transformation(extent={{-120,-420},{-100,-400}})));

  Buildings.Controls.OBC.CDL.Continuous.Division div if anyVsdCen
    "Division"
    annotation (Placement(transformation(extent={{-60,-370},{-40,-350}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const1(
    final k=0.4) if anyVsdCen "Constant"
    annotation (Placement(transformation(extent={{-240,-480},{-220,-460}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const2(
    final k=1.4) if anyVsdCen "Constant"
    annotation (Placement(transformation(extent={{-240,-560},{-220,-540}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add1(
    final k2=-1) if anyVsdCen "Subtract"
    annotation (Placement(transformation(extent={{-120,-500},{-100,-480}})));

  Buildings.Controls.OBC.CDL.Continuous.Product mult0 if anyVsdCen "Multiplier"
    annotation (Placement(transformation(extent={{-180,-460},{-160,-440}})));

  Buildings.Controls.OBC.CDL.Continuous.Product mult1 if anyVsdCen "Multiplier"
    annotation (Placement(transformation(extent={{-180,-540},{-160,-520}})));

  Buildings.Controls.OBC.CDL.Continuous.Product mult2 if anyVsdCen "Multiplier"
    annotation (Placement(transformation(extent={{0,-440},{20,-420}})));

  Buildings.Controls.OBC.CDL.Continuous.Product mult3 if anyVsdCen "Multiplier"
    annotation (Placement(transformation(extent={{60,-510},{80,-490}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add3 if anyVsdCen "Subtract"
    annotation (Placement(transformation(extent={{120,-482},{140,-462}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const3(
    final k=-1) if not anyVsdCen
    "Constant"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const4(
    final k=-1) if not anyVsdCen
    "Constant"
    annotation (Placement(transformation(extent={{-40,-260},{-20,-240}})));

  Buildings.Controls.OBC.CDL.Utilities.Assert cheStaTyp(final message="Recommended staging order got violated or an unlisted chiller type got provided when staging up")
    "Chiller type outside of recommenation when staging up"
    annotation (Placement(transformation(extent={{260,280},{280,300}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=-0.5)
    "Less than threshold"
    annotation (Placement(transformation(extent={{220,200},{240,220}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1(
    final t=-0.5) "Less than threshold"
    annotation (Placement(transformation(extent={{160,-110},{180,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.Division opePlrDow
    "Calculates operating part load ratio of the next stage down"
    annotation (Placement(transformation(extent={{-240,-90},{-220,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.Division minOpePlr
    "Calculates minimum OPLR of the current stage"
    annotation (Placement(transformation(extent={{-240,-240},{-220,-220}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu3 "Integer equal"
    annotation (Placement(transformation(extent={{20,240},{40,260}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nSta]
    "Type conversion"
    annotation (Placement(transformation(extent={{-300,290},{-280,310}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi4 "Switch"
    annotation (Placement(transformation(extent={{120,-170},{140,-150}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const5(
    final k=1)
    "If staging down to stage 0 set staging down part load to 1"
    annotation (Placement(transformation(extent={{60,-150},{80,-130}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu4 "Equality"
    annotation (Placement(transformation(extent={{-180,0},{-160,20}})));

  Buildings.Controls.OBC.CDL.Integers.Max maxInt "Maximum"
    annotation (Placement(transformation(extent={{-240,260},{-220,280}})));

  Buildings.Controls.OBC.CDL.Integers.Max maxIntUp "Maximum"
    annotation (Placement(transformation(extent={{-240,160},{-220,180}})));

  Buildings.Controls.OBC.CDL.Integers.Max maxIntDown "Maximum"
    annotation (Placement(transformation(extent={{-240,100},{-220,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Max max if anyVsdCen "Maximum"
    annotation (Placement(transformation(extent={{180,-420},{200,-400}})));

  Buildings.Controls.OBC.CDL.Continuous.Min min if anyVsdCen "Minimum"
    annotation (Placement(transformation(extent={{220,-380},{240,-360}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxLim(
    final k=varSpeStaMax) if anyVsdCen "Constant"
    annotation (Placement(transformation(extent={{120,-360},{140,-340}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minLim(
    final k=varSpeStaMin) if anyVsdCen "Constant"
    annotation (Placement(transformation(extent={{120,-420},{140,-400}})));

  Buildings.Controls.OBC.CDL.Utilities.Assert cheStaTyp1(
    final message="Recommended staging order got violated or an unlisted chiller type got provided when staging down")
    "Chiller type outside of recommenation when staging down"
    annotation (Placement(transformation(extent={{220,-20},{240,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conSpeCenTypMult1(
    final k=anyOutOfScoMult)
    "Outside of G36 recommended staging order chiller type SPLR multiplier"
    annotation (Placement(transformation(extent={{160,20},{180,40}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi5
    "Logical switch"
    annotation (Placement(transformation(extent={{280,220},{300,240}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi6
    "Logical switch"
    annotation (Placement(transformation(extent={{220,-110},{240,-90}})));

equation
  connect(uCapReq, opePlrSta.u1) annotation (Line(points={{-360,-10},{-260,-10},
          {-260,-44},{-242,-44}},
                            color={0,0,127}));
  connect(uCapDes, opePlrSta.u2) annotation (Line(points={{-360,-50},{-290,-50},
          {-290,-56},{-242,-56}}, color={0,0,127}));
  connect(extCurTyp.y, curStaTyp.u)
    annotation (Line(points={{-138,300},{-122,300}}, color={0,0,127}));
  connect(extUpTyp.y, staUpTyp.u)
    annotation (Line(points={{-138,210},{-122,210}}, color={0,0,127}));
  connect(extDowTyp.y, staDowTyp1.u)
    annotation (Line(points={{-138,130},{-122,130}}, color={0,0,127}));
  connect(staUpTyp.y, intEqu.u1) annotation (Line(points={{-98,210},{-60,210},{-60,
          170},{18,170}},  color={255,127,0}));
  connect(intEqu.u2, conSpeCenTyp.y) annotation (Line(points={{18,162},{-30,162},
          {-30,140},{-38,140}}, color={255,127,0}));
  connect(opePlrSta.y, yOpe) annotation (Line(points={{-218,-50},{-40,-50},{-40,
          -40},{360,-40}}, color={0,0,127}));
  connect(curStaTyp.y, intEqu1.u1) annotation (Line(points={{-98,300},{-80,300},
          {-80,110},{18,110}},  color={255,127,0}));
  connect(posDisTyp.y, intEqu1.u2) annotation (Line(points={{-38,80},{-30,80},{-30,
          102},{18,102}}, color={255,127,0}));
  connect(intEqu1.y, swi1.u2) annotation (Line(points={{42,110},{100,110},{100,70},
          {118,70}},color={255,0,255}));
  connect(staDowTyp1.y, intEqu2.u1) annotation (Line(points={{-98,130},{-90,130},
          {-90,30},{-22,30}}, color={255,127,0}));
  connect(swi1.y, swi.u3) annotation (Line(points={{142,70},{150,70},{150,142},{
          158,142}}, color={0,0,127}));
  connect(posDisTyp.y, intEqu2.u2) annotation (Line(points={{-38,80},{-30,80},{-30,
          22},{-22,22}}, color={255,127,0}));
  connect(swi3.y, swi2.u3) annotation (Line(points={{42,-230},{50,-230},{50,-188},
          {58,-188}}, color={0,0,127}));
  connect(intEqu2.y, swi3.u2) annotation (Line(points={{2,30},{10,30},{10,-230},
          {18,-230}}, color={255,0,255}));
  connect(uCapReq, opePlrUp.u1) annotation (Line(points={{-360,-10},{-300,-10},
          {-300,-134},{-242,-134}},
                              color={0,0,127}));
  connect(uUpCapDes, opePlrUp.u2) annotation (Line(points={{-360,-160},{-280,-160},
          {-280,-146},{-242,-146}}, color={0,0,127}));
  connect(opePlrUp.y, yOpeUp) annotation (Line(points={{-218,-140},{-40,-140},{
          -40,-120},{360,-120}}, color={0,0,127}));
  connect(minOpePlrUp.y, yOpeUpMin) annotation (Line(points={{-218,-190},{-100,
          -190},{-100,-280},{200,-280},{200,-240},{360,-240}}, color={0,0,127}));
  connect(uLifMin, add2.u2) annotation (Line(points={{-360,-420},{-240,-420},{-240,
          -416},{-122,-416}}, color={0,0,127}));
  connect(const.y, div.u1) annotation (Line(points={{-218,-350},{-80,-350},{-80,
          -354},{-62,-354}}, color={0,0,127}));
  connect(add2.y, div.u2) annotation (Line(points={{-98,-410},{-80,-410},{-80,-366},
          {-62,-366}}, color={0,0,127}));
  connect(const1.y, mult0.u2) annotation (Line(points={{-218,-470},{-190,-470},{
          -190,-456},{-182,-456}}, color={0,0,127}));
  connect(uLifMax, mult0.u1) annotation (Line(points={{-360,-360},{-300,-360},{-300,
          -400},{-190,-400},{-190,-444},{-182,-444}}, color={0,0,127}));
  connect(uLifMin, mult1.u1) annotation (Line(points={{-360,-420},{-260,-420},{
          -260,-500},{-200,-500},{-200,-524},{-182,-524}},
        color={0,0,127}));
  connect(const2.y, mult1.u2) annotation (Line(points={{-218,-550},{-200,-550},{
          -200,-536},{-182,-536}}, color={0,0,127}));
  connect(mult0.y, add1.u1) annotation (Line(points={{-158,-450},{-150,-450},{-150,
          -484},{-122,-484}}, color={0,0,127}));
  connect(mult1.y, add1.u2) annotation (Line(points={{-158,-530},{-148,-530},{-148,
          -496},{-122,-496}}, color={0,0,127}));
  connect(div.y, mult2.u1) annotation (Line(points={{-38,-360},{-20,-360},{-20,-424},
          {-2,-424}}, color={0,0,127}));
  connect(add1.y, mult2.u2) annotation (Line(points={{-98,-490},{-20,-490},{-20,
          -436},{-2,-436}}, color={0,0,127}));
  connect(div.y, mult3.u1) annotation (Line(points={{-38,-360},{40,-360},{40,-494},
          {58,-494}},
        color={0,0,127}));
  connect(uLif, mult3.u2) annotation (Line(points={{-360,-480},{-300,-480},{-300,
          -580},{40,-580},{40,-506},{58,-506}}, color={0,
          0,127}));
  connect(mult3.y, add3.u2) annotation (Line(points={{82,-500},{90,-500},{90,-478},
          {118,-478}}, color={0,0,127}));
  connect(mult2.y, add3.u1) annotation (Line(points={{22,-430},{100,-430},{100,-466},
          {118,-466}}, color={0,0,127}));
  connect(swi.y,greThr. u) annotation (Line(points={{182,150},{208,150},{208,210},
          {218,210}}, color={0,0,127}));
  connect(uLifMax, add2.u1) annotation (Line(points={{-360,-360},{-260,-360},{-260,
          -388},{-140,-388},{-140,-404},{-122,-404}}, color={0,0,127}));
  connect(uCapReq, opePlrDow.u1) annotation (Line(points={{-360,-10},{-280,-10},
          {-280,-74},{-242,-74}},
                            color={0,0,127}));
  connect(uDowCapDes, opePlrDow.u2) annotation (Line(points={{-360,-100},{-280,
          -100},{-280,-86},{-242,-86}}, color={0,0,127}));
  connect(opePlrDow.y, yOpeDow)
    annotation (Line(points={{-218,-80},{360,-80}}, color={0,0,127}));
  connect(minOpePlr.y, yOpeMin) annotation (Line(points={{-218,-230},{-80,-230},
          {-80,-200},{360,-200}}, color={0,0,127}));
  connect(conSpeCenTypMult.y, swi.u1) annotation (Line(points={{-158,-30},{-40,-30},
          {-40,-20},{56,-20},{56,158},{158,158}},
                               color={0,0,127}));
  connect(posDisTypMult.y, swi1.u1) annotation (Line(points={{-158,-110},{-60,
          -110},{-60,50},{0,50},{0,78},{118,78}}, color={0,0,127}));
  connect(posDisTypMult.y, swi3.u1) annotation (Line(points={{-158,-110},{-60,-110},
          {-60,-222},{18,-222}}, color={0,0,127}));
  connect(conSpeCenTypMult.y, swi2.u1) annotation (Line(points={{-158,-30},{0,-30},
          {0,-172},{58,-172}}, color={0,0,127}));
  connect(conSpeCenTyp.y, intEqu3.u2) annotation (Line(points={{-38,140},{-30,140},
          {-30,242},{18,242}}, color={255,127,0}));
  connect(curStaTyp.y, intEqu3.u1) annotation (Line(points={{-98,300},{-30,300},
          {-30,250},{18,250}}, color={255,127,0}));
  connect(intEqu3.y, swi2.u2) annotation (Line(points={{42,250},{50,250},{50,
          -180},{58,-180}},
                     color={255,0,255}));
  connect(uCapMin, minOpePlr.u1) annotation (Line(points={{-360,-220},{-280,-220},
          {-280,-224},{-242,-224}}, color={0,0,127}));
  connect(uCapDes, minOpePlr.u2) annotation (Line(points={{-360,-50},{-320,-50},
          {-320,-236},{-242,-236}}, color={0,0,127}));
  connect(uUpCapMin, minOpePlrUp.u1) annotation (Line(points={{-360,-280},{-300,
          -280},{-300,-184},{-242,-184}}, color={0,0,127}));
  connect(uUpCapDes, minOpePlrUp.u2) annotation (Line(points={{-360,-160},{-280,
          -160},{-280,-196},{-242,-196}}, color={0,0,127}));
  connect(intEqu.y, swi.u2) annotation (Line(points={{42,170},{120,170},{120,150},
          {158,150}}, color={255,0,255}));
  connect(intToRea.y,extCurTyp. u)
    annotation (Line(points={{-278,300},{-162,300}}, color={0,0,127}));
  connect(intToRea.y, extUpTyp.u) annotation (Line(points={{-278,300},{-200,300},
          {-200,210},{-162,210}}, color={0,0,127}));
  connect(intToRea.y, extDowTyp.u) annotation (Line(points={{-278,300},{-200,300},
          {-200,130},{-162,130}}, color={0,0,127}));
  connect(const4.y, swi3.u3) annotation (Line(points={{-18,-250},{0,-250},{0,-238},
          {18,-238}}, color={0,0,127}));
  connect(const3.y, swi1.u3) annotation (Line(points={{82,30},{100,30},{100,62},
          {118,62}}, color={0,0,127}));
  connect(swi2.y, swi4.u3) annotation (Line(points={{82,-180},{100,-180},{100,-168},
          {118,-168}}, color={0,0,127}));
  connect(const5.y, swi4.u1) annotation (Line(points={{82,-140},{100,-140},{100,
          -152},{118,-152}}, color={0,0,127}));
  connect(u, intEqu4.u2) annotation (Line(points={{-360,240},{-320,240},{-320,2},
          {-182,2}},                        color={255,127,0}));
  connect(one.y, intEqu4.u1) annotation (Line(points={{-278,150},{-270,150},{-270,
          20},{-220,20},{-220,10},{-182,10}}, color={255,127,0}));
  connect(intEqu4.y, swi4.u2) annotation (Line(points={{-158,10},{-20,10},{-20,
          -160},{118,-160}},
                       color={255,0,255}));
  connect(one.y, maxInt.u2) annotation (Line(points={{-278,150},{-270,150},{-270,
          264},{-242,264}}, color={255,127,0}));
  connect(u, maxInt.u1) annotation (Line(points={{-360,240},{-280,240},{-280,276},
          {-242,276}}, color={255,127,0}));
  connect(maxInt.y,extCurTyp. index) annotation (Line(points={{-218,270},{-150,270},
          {-150,288}},  color={255,127,0}));
  connect(uTyp, intToRea.u) annotation (Line(points={{-360,300},{-302,300},{-302,
          300}}, color={255,127,0}));
  connect(one.y, maxIntUp.u2) annotation (Line(points={{-278,150},{-260,150},{-260,
          164},{-242,164}}, color={255,127,0}));
  connect(uUp, maxIntUp.u1) annotation (Line(points={{-360,180},{-280,180},{
          -280,176},{-242,176}}, color={255,127,0}));
  connect(maxIntUp.y, extUpTyp.index) annotation (Line(points={{-218,170},{-150,
          170},{-150,198}}, color={255,127,0}));
  connect(one.y, maxIntDown.u1) annotation (Line(points={{-278,150},{-270,150},{
          -270,116},{-242,116}}, color={255,127,0}));
  connect(uDown, maxIntDown.u2) annotation (Line(points={{-360,120},{-290,120},{
          -290,104},{-242,104}},  color={255,127,0}));
  connect(maxIntDown.y, extDowTyp.index) annotation (Line(points={{-218,110},{-150,
          110},{-150,118}}, color={255,127,0}));
  connect(add3.y, max.u2) annotation (Line(points={{142,-472},{160,-472},{160,-416},
          {178,-416}}, color={0,0,127}));
  connect(minLim.y, max.u1) annotation (Line(points={{142,-410},{160,-410},{160,
          -404},{178,-404}}, color={0,0,127}));
  connect(max.y, min.u2) annotation (Line(points={{202,-410},{210,-410},{210,-376},
          {218,-376}}, color={0,0,127}));
  connect(maxLim.y, min.u1) annotation (Line(points={{142,-350},{180,-350},{180,
          -364},{218,-364}}, color={0,0,127}));
  connect(min.y, swi3.u3) annotation (Line(points={{242,-370},{260,-370},{260,-300},
          {10,-300},{10,-238},{18,-238}}, color={0,0,127}));
  connect(min.y, swi1.u3) annotation (Line(points={{242,-370},{260,-370},{260,
          -70},{110,-70},{110,62},{118,62}},
                                        color={0,0,127}));
  connect(swi4.y, greThr1.u) annotation (Line(points={{142,-160},{152,-160},{152,
          -100},{158,-100}},     color={0,0,127}));
  connect(swi.y, swi5.u1) annotation (Line(points={{182,150},{200,150},{200,238},
          {278,238}}, color={0,0,127}));
  connect(greThr.y, swi5.u2) annotation (Line(points={{242,210},{250,210},{250,230},
          {278,230}}, color={255,0,255}));
  connect(greThr.y, cheStaTyp.u) annotation (Line(points={{242,210},{250,210},{250,
          290},{258,290}}, color={255,0,255}));
  connect(conSpeCenTypMult1.y, swi5.u3) annotation (Line(points={{182,30},{260,30},
          {260,222},{278,222}}, color={0,0,127}));
  connect(swi5.y, yStaUp) annotation (Line(points={{302,230},{312,230},{312,0},{
          360,0}}, color={0,0,127}));
  connect(swi6.y, yStaDow) annotation (Line(points={{242,-100},{250,-100},{250,-160},
          {360,-160}}, color={0,0,127}));
  connect(greThr1.y, swi6.u2)
    annotation (Line(points={{182,-100},{218,-100}}, color={255,0,255}));
  connect(swi4.y, swi6.u1) annotation (Line(points={{142,-160},{200,-160},{200,-92},
          {218,-92}}, color={0,0,127}));
  connect(conSpeCenTypMult1.y, swi6.u3) annotation (Line(points={{182,30},{210,30},
          {210,-108},{218,-108}}, color={0,0,127}));
  connect(greThr1.y, cheStaTyp1.u) annotation (Line(points={{182,-100},{190,-100},
          {190,-10},{218,-10}}, color={255,0,255}));
  annotation (defaultComponentName = "PLRs",
        Icon(graphics={
        Text(
          extent={{-118,204},{102,166}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-60,36},{64,-42}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="PLR")}), Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-340,-600},{340,340}})),
        Documentation(info="<html>
<p>Calculates operative part load ratios (OPLR) per sections 5.2.4.5., 9., 10. and stage part load ratios (SPLR, up or down) per section 5.2.4.5.13 (July Draft). </p>
<p>OPLR is a ratio of the current capacity requirement to a given design or minimal stage capacity, such as: </p>
<ul>
<li>Current stage design OPLR (<span style=\"font-family: monospace;\">y</span>). </li>
<li>Current stage minimal OPLR (<span style=\"font-family: monospace;\">yMin</span>). </li>
<li>Next available higher stage nominal OPLR (<span style=\"font-family: monospace;\">yUp</span>). </li>
<li>Next available higher stage minimal OPLR (<span style=\"font-family: monospace;\">yUpMin</span>). </li>
</ul>
<p>
SPLRup <code>yStaUp</code> or SPLRdown <code>yStaDown</code> value depends on the stage type <code>staTyp</code> as indicated in the table below.
Note that the rules are prioritized by stage type column, from left to right</p><p>The stage type is determined by the
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Configurator\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Configurator</a> subsequence based on the type of chillers staged.
<br></br>
</p>
<table summary=\"summary\" cellspacing=\"2\" cellpadding=\"0\" border=\"1\"><tr>
<td><p align=\"center\"><b>Row: Stage / Column: Stage Type</b></p></td>
<td><p align=\"center\"><b>Any Constant Speed Centrifugal</b></p></td>
<td><p align=\"center\"><b>All Positive Displacement</b></p></td>
<td><p align=\"center\"><b>Any Variable Speed and no Constant Speed Centrifugal </b></p></td>
</tr>
<tr>
<td><p align=\"center\">Next Available Up</p></td>
<td><p align=\"center\"><span style=\"font-family: monospace;\">yStaUp=conSpeCenMult</span></p></td>
<td><p align=\"center\"><span style=\"font-family: monospace;\">N/A </span></p></td>
<td><p align=\"center\"><span style=\"font-family: monospace;\">N/A </span></p></td>
</tr>
<tr>
<td><p align=\"center\">Current</p></td>
<td><p align=\"center\"><span style=\"font-family: monospace;\">yStaDown=conSpeCenMult</span></p></td>
<td><p align=\"center\"><span style=\"font-family: monospace;\">yStaUp=posDisMult</span></p></td>
<td><p align=\"center\"><span style=\"font-family: monospace;\">yStaUp=f(uLif, uLifMin, uLifMax)</span></p></td>
</tr>
<tr>
<td><p align=\"center\">Next Available Down</p></td>
<td><p align=\"center\"><span style=\"font-family: monospace;\">N/A</span></p></td>
<td><p align=\"center\"><span style=\"font-family: monospace;\">yStaDown=posDisMult</span></p></td>
<td><p align=\"center\"><span style=\"font-family: monospace;\">yStaDown=f(uLif, uLifMin, uLifMax)</span></p></td>
</tr>
</table>
<p>For operation outside of the recommended staging order as provided in the table above a constant
SPLRup and SPLRdown value <code>anyOutOfScoMult</code> is set to prevent
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
