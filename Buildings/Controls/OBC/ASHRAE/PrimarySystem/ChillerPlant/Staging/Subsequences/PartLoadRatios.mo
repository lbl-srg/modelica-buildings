within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block PartLoadRatios
  "Operating and staging part load ratios with chiller type reset"

  parameter Integer numSta = 2
  "Number of stages";

  parameter Real chiStaTyp[numSta] = {1,2}
  "Integer stage chiller type: 1=more than one positive displacement chiller, 2=variable speed centrifugal chillers, 3=constant speed centrifugal chillers";

  parameter Real posDisMult(unit = "1", min = 0, max = 1)=0.8
  "Positive displacement chiller type staging multiplier";

  parameter Real conSpeCenMult(unit = "1", min = 0, max = 1)=0.9
  "Constant speed centrifugal chiller type staging multiplier";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uStaUpCapNom(
    final unit="W",
    final quantity="Power")
    "Nominal capacity of the next higher stage" annotation (Placement(
        transformation(extent={{-380,-180},{-340,-140}}), iconTransformation(
          extent={{-120,20},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCapReq(
    final unit="W",
    final quantity="Power")
    "Chilled water cooling capacity requirement"
    annotation (Placement(transformation(extent={{-380,-20},{-340,20}}),
    iconTransformation(extent={{-120,60},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uStaCapNom(
    final unit="W",
    final quantity="Power")
    "Nominal capacity of the current stage"
    annotation (Placement(transformation(extent={{-382,-80},{-342,-40}}),
        iconTransformation(extent={{-120,40},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uStaUpCapMin(
    final unit="W",
    final quantity="Power") "Minimal capacity of the next higher stage"
    annotation (Placement(transformation(extent={{-380,-280},{-340,-240}}),
        iconTransformation(extent={{-120,-20},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uStaDowCapNom(
    final unit="W",
    final quantity="Power") "Nominal capacity of the next lower stage"
    annotation (Placement(transformation(extent={{-380,-140},{-340,-100}}),
        iconTransformation(extent={{-120,0},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLifMin(
    final unit="K",
    final quantity="ThermodynamicTemperature") if max(chiStaTyp) > 2.5
    "Minimum chiller lift"
    annotation (Placement(transformation(extent={{-380,-440},{-340,-400}}),
        iconTransformation(extent={{-120,-110},{-100,-90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLifMax(
    final unit="K",
    final quantity="ThermodynamicTemperature") if max(chiStaTyp) > 2.5
    "Maximum chiller lift"
    annotation (Placement(transformation(extent={{-380,-380},{-340,-340}}),
        iconTransformation(extent={{-120,-90},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLif(
    final unit="K",
    final quantity="ThermodynamicTemperature") if max(chiStaTyp) > 2.5
    "Chiller lift"
    annotation (Placement(transformation(extent={{-380,-500},{-340,-460}}),
        iconTransformation(extent={{-120,-70},{-100,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uStaCapMin(
    final unit="W",
    final quantity="Power")
    "Minimal capacity of the current stage" annotation (Placement(
        transformation(extent={{-382,-240},{-342,-200}}), iconTransformation(
          extent={{-120,-40},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yUp(
    final unit="1", min=0)
    "Operating part load ratio of the next higher stage"
    annotation (Placement(transformation(extent={{260,-130},{280,-110}}),
    iconTransformation(extent={{100,40},{120,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDow(final unit="1", min=0)
    "Operating part load ratio of the next stage down"   annotation (Placement(
        transformation(extent={{260,-90},{280,-70}}), iconTransformation(extent={{100,20},
            {120,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMin(final unit="1", min=0)
    "Minimum operating part load ratio at current stage" annotation (Placement(
        transformation(extent={{260,-210},{280,-190}}), iconTransformation(extent={
            {100,-100},{120,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final unit="1", min = 0) "Operating part load ratio of the current stage"
    annotation (Placement(transformation(extent={{260,-50},{280,-30}}),
                            iconTransformation(extent={{100,60},{120,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaDow(
    final unit="1", min = 0)
    "Stage down part load ratio"
    annotation (Placement(transformation(extent={{260,-170},{280,-150}}),
                    iconTransformation(extent={{100,-40},{120,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaUp(
    final unit="1", min = 0)
    "Stage up part load ratio"
    annotation (Placement(transformation(extent={{260,-10},{280,10}}),
                    iconTransformation(extent={{100,-20},{120,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yUpMin(final unit="1", min=0)
    "Minimum operating part load ratio at the next stage up" annotation (Placement(
        transformation(extent={{260,-250},{280,-230}}), iconTransformation(extent={
            {100,-80},{120,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Division opePlrSta
    "Calculates operating part load ratio at the current stage"
    annotation (Placement(transformation(extent={{-240,-80},{-220,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiStaType[numSta](k=chiStaTyp)
    "Chiller stage type"
    annotation (Placement(transformation(extent={{-300,260},{-280,280}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput                        uSta "Chiller stage"
    annotation (Placement(transformation(extent={{-380,220},{-340,260}}),
        iconTransformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaTyp(nin=numSta)
                                      "Extract stage type"
    annotation (Placement(transformation(extent={{-240,260},{-220,280}})));
  Buildings.Controls.OBC.CDL.Integers.Add oneUp "Adds one"
    annotation (Placement(transformation(extent={{-240,140},{-220,160}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant                        one(final k=1)
    "Constant integer"
    annotation (Placement(transformation(extent={{-300,140},{-280,160}})));
  Buildings.Controls.OBC.CDL.Integers.Add oneDown(k2=-1) "Subtracts one"
    annotation (Placement(transformation(extent={{-240,60},{-220,80}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger curStaTyp "Current stage chiller type"
    annotation (Placement(transformation(extent={{-160,260},{-140,280}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger staUpTyp "Stage up chiller type"
    annotation (Placement(transformation(extent={{-120,200},{-100,220}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaTyp1(nin=numSta)
                                       "Extract stage type"
    annotation (Placement(transformation(extent={{-160,200},{-140,220}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaTyp2(nin=numSta)
                                       "Extract stage type"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger staDowTyp1 "Stage down chiller type"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant maxSta(final k=numSta) "Maximum stage"
    annotation (Placement(transformation(extent={{-300,180},{-280,200}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant minSta(final k=1) "Minimum stage"
    annotation (Placement(transformation(extent={{-298,40},{-278,60}})));
  Buildings.Controls.OBC.CDL.Integers.Max maxInt
    annotation (Placement(transformation(extent={{-180,60},{-160,80}})));
  Buildings.Controls.OBC.CDL.Integers.Min minInt
    annotation (Placement(transformation(extent={{-180,160},{-160,180}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{142,140},{162,160}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staTyp1(final k=3) "Chiller stage type 1"
    annotation (Placement(transformation(extent={{-60,130},{-40,150}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staTyp2(final k=1) "Chiller stage type 2"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    annotation (Placement(transformation(extent={{-20,160},{0,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant posDisTypMult(k=posDisMult)
    "Positive displacement chiller type SPLR multiplier"
    annotation (Placement(transformation(extent={{-160,-140},{-140,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conSpeCenTypMult(k=conSpeCenMult)
    "Constant speed centrifugal chiller type SPLR multiplier"
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2
    annotation (Placement(transformation(extent={{62,-182},{82,-162}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi3
    annotation (Placement(transformation(extent={{22,-242},{42,-222}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1
    annotation (Placement(transformation(extent={{-20,98},{0,118}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Division minOpePlrUp "Calculates minimum OPLR of one stage up"
    annotation (Placement(transformation(extent={{-280,-210},{-260,-190}})));

  Buildings.Controls.OBC.CDL.Continuous.Division opePlrUp
    "Calculates operating part load ratio at the next stage up"
    annotation (Placement(transformation(extent={{-222,-170},{-202,-150}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const(k=0.9) if max(chiStaTyp) > 2.5 "Constant"
    annotation (Placement(transformation(extent={{-240,-360},{-220,-340}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(k2=-1) if max(chiStaTyp) > 2.5 "Subtract"
    annotation (Placement(transformation(extent={{-120,-418},{-100,-398}})));
  Buildings.Controls.OBC.CDL.Continuous.Division div if max(chiStaTyp) > 2.5
    annotation (Placement(transformation(extent={{-60,-370},{-40,-350}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const1(k=0.4) if max(chiStaTyp) > 2.5 "Constant"
    annotation (Placement(transformation(extent={{-238,-480},{-218,-460}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const2(k=1.4) if max(chiStaTyp) > 2.5 "Constant"
    annotation (Placement(transformation(extent={{-242,-560},{-222,-540}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1(k2=-1) if max(chiStaTyp) > 2.5 "Subtract"
    annotation (Placement(transformation(extent={{-138,-500},{-118,-480}})));
  Buildings.Controls.OBC.CDL.Continuous.Product mult0 if max(chiStaTyp) > 2.5 "Multiplier"
    annotation (Placement(transformation(extent={{-200,-460},{-180,-440}})));
  Buildings.Controls.OBC.CDL.Continuous.Product mult1 if max(chiStaTyp) > 2.5 "Multiplier"
    annotation (Placement(transformation(extent={{-180,-558},{-160,-538}})));
  Buildings.Controls.OBC.CDL.Continuous.Product mult2 if max(chiStaTyp) > 2.5 "Multiplier"
    annotation (Placement(transformation(extent={{22,-442},{42,-422}})));
  Buildings.Controls.OBC.CDL.Continuous.Product mult3 if max(chiStaTyp) > 2.5 "Multiplier"
    annotation (Placement(transformation(extent={{58,-514},{78,-494}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add3 if max(chiStaTyp) > 2.5 "Subtract"
    annotation (Placement(transformation(extent={{120,-482},{140,-462}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const3(k=-1) if max(chiStaTyp) < 2.5 "Constant"
    annotation (Placement(transformation(extent={{50,0},{70,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const4(k=-1) if max(chiStaTyp) < 2.5 "Constant"
    annotation (Placement(transformation(extent={{-30,-280},{-10,-260}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert                        staTyp(final message="Unlisted chiller type got selected")
    "Unlisted chiller type got selected"
    annotation (Placement(transformation(extent={{220,262},{240,282}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr(final threshold=-0.5)
                          "Less than threshold"
    annotation (Placement(transformation(extent={{180,262},{200,282}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert                        staExc1(final
      message="Unlisted chiller type got selected")
    "Unlisted chiller type got selected"
    annotation (Placement(transformation(extent={{220,210},{240,230}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr1(final threshold=-0.5)
                          "Less than threshold"
    annotation (Placement(transformation(extent={{180,210},{200,230}})));

  Buildings.Controls.OBC.CDL.Continuous.Division opePlrDow
    "Calculates operating part load ratio of the next stage down"
    annotation (Placement(transformation(extent={{-260,-110},{-240,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.Division minOpePlr "Calculates minimum OPLR of the current stage"
    annotation (Placement(transformation(extent={{-278,-270},{-258,-250}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu3
    annotation (Placement(transformation(extent={{-20,200},{0,220}})));
equation
  connect(uCapReq, opePlrSta.u1) annotation (Line(points={{-360,0},{-260,0},{-260,
          -64},{-242,-64}},    color={0,0,127}));
  connect(uStaCapNom, opePlrSta.u2) annotation (Line(points={{-362,-60},{-298,-60},
          {-298,-76},{-242,-76}},
                              color={0,0,127}));
  connect(chiStaType.y,extStaTyp. u)
    annotation (Line(points={{-279,270},{-242,270}},color={0,0,127}));
  connect(uSta,extStaTyp. index) annotation (Line(points={{-360,240},{-230,240},
          {-230,258}},
                     color={255,127,0}));
  connect(one.y, oneDown.u2) annotation (Line(points={{-279,150},{-260,150},{-260,
          64},{-242,64}},   color={255,127,0}));
  connect(extStaTyp.y, curStaTyp.u)
    annotation (Line(points={{-219,270},{-162,270}},
                                                   color={0,0,127}));
  connect(one.y, oneUp.u2) annotation (Line(points={{-279,150},{-260,150},{-260,
          144},{-242,144}}, color={255,127,0}));
  connect(uSta, oneDown.u1) annotation (Line(points={{-360,240},{-250,240},{-250,
          76},{-242,76}},   color={255,127,0}));
  connect(uSta, oneUp.u1) annotation (Line(points={{-360,240},{-250,240},{-250,156},
          {-242,156}}, color={255,127,0}));
  connect(extStaTyp1.y, staUpTyp.u)
    annotation (Line(points={{-139,210},{-122,210}},
                                                   color={0,0,127}));
  connect(chiStaType.y, extStaTyp1.u) annotation (Line(points={{-279,270},{-250,
          270},{-250,230},{-210,230},{-210,210},{-162,210}},
                                                          color={0,0,127}));
  connect(extStaTyp2.y, staDowTyp1.u)
    annotation (Line(points={{-139,110},{-122,110}},
                                                   color={0,0,127}));
  connect(extStaTyp2.u, chiStaType.y) annotation (Line(points={{-162,110},{-210,
          110},{-210,230},{-250,230},{-250,270},{-279,270}},
                                                       color={0,0,127}));
  connect(maxSta.y, minInt.u1) annotation (Line(points={{-279,190},{-230,190},{-230,
          176},{-182,176}},color={255,127,0}));
  connect(oneUp.y, minInt.u2) annotation (Line(points={{-219,150},{-200,150},{-200,
          164},{-182,164}},color={255,127,0}));
  connect(minInt.y, extStaTyp1.index) annotation (Line(points={{-159,170},{-150,
          170},{-150,198}},
                      color={255,127,0}));
  connect(oneDown.y, maxInt.u1) annotation (Line(points={{-219,70},{-200,70},{-200,
          76},{-182,76}},color={255,127,0}));
  connect(minSta.y, maxInt.u2) annotation (Line(points={{-277,50},{-200,50},{-200,
          64},{-182,64}},color={255,127,0}));
  connect(maxInt.y, extStaTyp2.index)
    annotation (Line(points={{-159,70},{-150,70},{-150,98}},
                                                           color={255,127,0}));
  connect(staUpTyp.y, intEqu.u1) annotation (Line(points={{-99,210},{-60,210},{-60,
          170},{-22,170}}, color={255,127,0}));
  connect(intEqu.u2, staTyp1.y) annotation (Line(points={{-22,162},{-32,162},{-32,
          140},{-39,140}}, color={255,127,0}));
  connect(opePlrSta.y, y) annotation (Line(points={{-219,-70},{-40,-70},{-40,-40},
          {270,-40}}, color={0,0,127}));
  connect(curStaTyp.y, intEqu1.u1) annotation (Line(points={{-139,270},{-80,270},{-80,
          108},{-22,108}},      color={255,127,0}));
  connect(staTyp2.y, intEqu1.u2) annotation (Line(points={{-39,80},{-30,80},{-30,100},
          {-22,100}},      color={255,127,0}));
  connect(intEqu1.y, swi1.u2) annotation (Line(points={{1,108},{50,108},{50,70},
          {98,70}}, color={255,0,255}));
  connect(staDowTyp1.y, intEqu2.u1) annotation (Line(points={{-99,110},{-90,110},{-90,
          30},{-22,30}},      color={255,127,0}));
  connect(swi1.y, swi.u3) annotation (Line(points={{121,70},{128,70},{128,142},{
          140,142}}, color={0,0,127}));
  connect(staTyp2.y, intEqu2.u2) annotation (Line(points={{-39,80},{-30,80},{-30,22},
          {-22,22}},              color={255,127,0}));
  connect(swi3.y, swi2.u3) annotation (Line(points={{43,-232},{50,-232},{50,-180},
          {60,-180}}, color={0,0,127}));
  connect(intEqu2.y, swi3.u2) annotation (Line(points={{1,30},{10,30},{10,-232},{20,
          -232}},     color={255,0,255}));
  connect(swi.y, yStaUp) annotation (Line(points={{163,150},{220,150},{220,0},{270,
          0}}, color={0,0,127}));
  connect(swi2.y, yStaDow) annotation (Line(points={{83,-172},{220,-172},{220,-160},
          {270,-160}}, color={0,0,127}));
  connect(uCapReq, opePlrUp.u1) annotation (Line(points={{-360,0},{-310,0},{-310,-154},
          {-224,-154}}, color={0,0,127}));
  connect(uStaUpCapNom, opePlrUp.u2) annotation (Line(points={{-360,-160},{-240,-160},
          {-240,-166},{-224,-166}}, color={0,0,127}));
  connect(opePlrUp.y, yUp) annotation (Line(points={{-201,-160},{-40,-160},{-40,-120},
          {270,-120}}, color={0,0,127}));
  connect(minOpePlrUp.y, yUpMin) annotation (Line(points={{-259,-200},{-240,-200},
          {-240,-300},{240,-300},{240,-240},{270,-240}},color={0,0,127}));
  connect(uLifMin, add2.u2) annotation (Line(points={{-360,-420},{-240,-420},{-240,
          -414},{-122,-414}}, color={0,0,127}));
  connect(const.y, div.u1) annotation (Line(points={{-219,-350},{-100,-350},{-100,
          -354},{-62,-354}}, color={0,0,127}));
  connect(add2.y, div.u2) annotation (Line(points={{-99,-408},{-80,-408},{-80,-366},
          {-62,-366}}, color={0,0,127}));
  connect(const1.y, mult0.u2) annotation (Line(points={{-217,-470},{-210,-470},{
          -210,-456},{-202,-456}}, color={0,0,127}));
  connect(uLifMax, mult0.u1) annotation (Line(points={{-360,-360},{-310,-360},{-310,
          -380},{-300,-380},{-300,-400},{-210,-400},{-210,-444},{-202,-444}},
        color={0,0,127}));
  connect(uLifMin, mult1.u1) annotation (Line(points={{-360,-420},{-286,-420},{-286,
          -428},{-258,-428},{-258,-500},{-200,-500},{-200,-542},{-182,-542}},
        color={0,0,127}));
  connect(const2.y, mult1.u2) annotation (Line(points={{-221,-550},{-200,-550},{
          -200,-554},{-182,-554}},    color={0,0,127}));
  connect(mult0.y, add1.u1) annotation (Line(points={{-179,-450},{-159.5,-450},{
          -159.5,-484},{-140,-484}}, color={0,0,127}));
  connect(mult1.y, add1.u2) annotation (Line(points={{-159,-548},{-148,-548},{-148,
          -496},{-140,-496}}, color={0,0,127}));
  connect(div.y, mult2.u1) annotation (Line(points={{-39,-360},{-20,-360},{-20,-426},
          {20,-426}},                       color={0,0,127}));
  connect(add1.y, mult2.u2) annotation (Line(points={{-117,-490},{-20,-490},{-20,
          -438},{20,-438}}, color={0,0,127}));
  connect(div.y, mult3.u1) annotation (Line(points={{-39,-360},{56,-360},{56,-498}},
        color={0,0,127}));
  connect(uLif, mult3.u2) annotation (Line(points={{-360,-480},{-330,-480},{-330,
          -482},{-300,-482},{-300,-580},{40,-580},{40,-510},{56,-510}}, color={0,
          0,127}));
  connect(mult3.y, add3.u2) annotation (Line(points={{79,-504},{96.5,-504},{96.5,
          -478},{118,-478}}, color={0,0,127}));
  connect(mult2.y, add3.u1) annotation (Line(points={{43,-432},{100,-432},{100,-466},
          {118,-466}}, color={0,0,127}));
  connect(add3.y, swi3.u3) annotation (Line(points={{141,-472},{160,-472},{160,-280},
          {10,-280},{10,-240},{20,-240}}, color={0,0,127}));
  connect(add3.y, swi1.u3) annotation (Line(points={{141,-472},{160,-472},{160,26},
          {80,26},{80,62},{98,62}}, color={0,0,127}));
  connect(staTyp.u,lesThr. y)
    annotation (Line(points={{218,272},{201,272}},
                                              color={255,0,255}));
  connect(const3.y, swi1.u3) annotation (Line(points={{71,10},{80,10},{80,62},{98,62}},
                color={0,0,127}));
  connect(const4.y, swi3.u3)
    annotation (Line(points={{-9,-270},{0,-270},{0,-240},{20,-240}},
                                                           color={0,0,127}));
  connect(swi.y, lesThr.u) annotation (Line(points={{163,150},{170,150},{170,
          272},{178,272}}, color={0,0,127}));
  connect(swi3.y, lesThr1.u) annotation (Line(points={{43,-232},{170,-232},{170,
          220},{178,220}}, color={0,0,127}));
  connect(uLifMax, add2.u1) annotation (Line(points={{-360,-360},{-260,-360},{-260,
          -388},{-140,-388},{-140,-402},{-122,-402}}, color={0,0,127}));
  connect(uCapReq, opePlrDow.u1) annotation (Line(points={{-360,0},{-280,0},{-280,
          -94},{-262,-94}},
                       color={0,0,127}));
  connect(uStaDowCapNom, opePlrDow.u2) annotation (Line(points={{-360,-120},{-280,
          -120},{-280,-106},{-262,-106}},
                                    color={0,0,127}));
  connect(opePlrDow.y, yDow) annotation (Line(points={{-239,-100},{200,-100},{200,-80},
          {270,-80}}, color={0,0,127}));
  connect(minOpePlr.y, yMin) annotation (Line(points={{-257,-260},{-48,-260},{
          -48,-200},{270,-200}},                   color={0,0,127}));
  connect(conSpeCenTypMult.y, swi.u1) annotation (Line(points={{-139,-30},{40,-30},
          {40,158},{140,158}}, color={0,0,127}));
  connect(posDisTypMult.y, swi1.u1) annotation (Line(points={{-139,-130},{-60,-130},
          {-60,50},{60,50},{60,78},{98,78}},  color={0,0,127}));
  connect(posDisTypMult.y, swi3.u1) annotation (Line(points={{-139,-130},{-60,-130},
          {-60,-224},{20,-224}}, color={0,0,127}));
  connect(conSpeCenTypMult.y, swi2.u1) annotation (Line(points={{-139,-30},{0,-30},
          {0,-164},{60,-164}}, color={0,0,127}));
  connect(staTyp1.y, intEqu3.u2) annotation (Line(points={{-39,140},{-32,140},{-32,
          202},{-22,202}}, color={255,127,0}));
  connect(curStaTyp.y, intEqu3.u1) annotation (Line(points={{-139,270},{-32,270},{-32,
          210},{-22,210}}, color={255,127,0}));
  connect(intEqu3.y, swi2.u2) annotation (Line(points={{1,210},{28,210},{28,-172},{
          60,-172}}, color={255,0,255}));
  connect(uStaCapMin, minOpePlr.u1) annotation (Line(points={{-362,-220},{-300,
          -220},{-300,-254},{-280,-254}}, color={0,0,127}));
  connect(uStaCapNom, minOpePlr.u2) annotation (Line(points={{-362,-60},{-320,
          -60},{-320,-266},{-280,-266}}, color={0,0,127}));
  connect(uStaUpCapMin, minOpePlrUp.u1) annotation (Line(points={{-360,-260},{
          -312,-260},{-312,-194},{-282,-194}}, color={0,0,127}));
  connect(uStaUpCapNom, minOpePlrUp.u2) annotation (Line(points={{-360,-160},{
          -290,-160},{-290,-206},{-282,-206}}, color={0,0,127}));
  connect(lesThr1.y, staExc1.u)
    annotation (Line(points={{201,220},{218,220}}, color={255,0,255}));
  connect(intEqu.y, swi.u2) annotation (Line(points={{1,170},{120,170},{120,150},
          {140,150}}, color={255,0,255}));
  annotation (defaultComponentName = "PLRs",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}), Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-340,-600},{260,320}}), graphics={Text(
          extent={{80,56},{142,24}},
          lineColor={28,108,200},
          textString="lift 
formula"), Text(
          extent={{2,-246},{64,-278}},
          lineColor={28,108,200},
          textString="lift 
formula")}),
Documentation(info="<html>
<p>
Fixme: This is a development version of the staging part load ratio 
calculation with chiller type reset. Finalize after obtaining answer from 
Steve on 

OPLR - Operating part load ratio refers to any ratio of current capacity requirement
to a nominal or minimal stage capacity.

SPLR - Stage part load ratio (up or down) is defined separately for each stage chiller type.
It is used in deciding whether to stage up or down when compared with OPLRs of the current 
and first stage down, respectively.

Set stage chiller type to:

1 if the stage has more than one positive displacement chiller
2 if the stage contains any variable speed centrifugal chillers
3 if the stage contains any constant speed centrifugal chillers

If more than one condition applies for a single stage, use the determination with the highest integer.

Recomended staging order: more than one positive displacement, variable speed contrifugal, constant speed centrifugal

add test for centrifugal later, after we clarify why both up and down SPLR equations look the same, at that time also add check for 
chiller type = 3.

</p>
</html>",
revisions="<html>
<ul>
<li>
October 13, 2018, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartLoadRatios;
