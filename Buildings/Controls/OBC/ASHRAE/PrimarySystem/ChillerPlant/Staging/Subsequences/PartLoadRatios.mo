within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block PartLoadRatios
  "Operating and staging part load ratios with chiller type reset"

  parameter Integer nPosDis = 2
  "Number of chiller stages of positive displacement chiller type";

  parameter Integer nVsdCen = 0
  "Number of chiller stages of variable speed centrifugal chiller type";

  parameter Integer nConCen = 0
  "Number of chiller stages of constant speed centrifugal chiller type";

  final parameter Integer nSta = nPosDis + nVsdCen + nConCen
  "Number of stages";

  final parameter Integer chiStaTyp[nSta] = cat(1, {1 for i in 1:nPosDis}, {2 for j in 1:nVsdCen}, {3 for k in 1:nConCen})
  "Integer stage chiller type populated in order: positive displacement stage type, variable speed centrifugal stage type, constant speed centrifugal stage type";

  parameter Real posDisMult(unit = "1", min = 0, max = 1)=0.8
  "Positive displacement chiller type staging multiplier";

  parameter Real conSpeCenMult(unit = "1", min = 0, max = 1)=0.9
  "Constant speed centrifugal chiller type staging multiplier";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta "Chiller stage"
    annotation (Placement(transformation(extent={{-380,220},{-340,260}}),
        iconTransformation(extent={{-120,80},{-100,100}})));

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
    final quantity="ThermodynamicTemperature") if nVsdCen>0
    "Minimum chiller lift"
    annotation (Placement(transformation(extent={{-380,-440},{-340,-400}}),
        iconTransformation(extent={{-120,-110},{-100,-90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLifMax(
    final unit="K",
    final quantity="ThermodynamicTemperature") if nVsdCen>0
    "Maximum chiller lift"
    annotation (Placement(transformation(extent={{-380,-380},{-340,-340}}),
        iconTransformation(extent={{-120,-90},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLif(
    final unit="K",
    final quantity="ThermodynamicTemperature") if nVsdCen>0
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
    final unit="1", final min=0)
    "Operating part load ratio of the next higher stage"
    annotation (Placement(transformation(extent={{260,-130},{280,-110}}),
    iconTransformation(extent={{100,40},{120,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDow(
    final unit="1",
    final min=0)
    "Operating part load ratio of the next stage down"
    annotation (Placement(
        transformation(extent={{260,-90},{280,-70}}), iconTransformation(extent={{100,20},
            {120,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMin(
    final unit="1",
    final min=0)
    "Minimum operating part load ratio at current stage"
    annotation (Placement(
        transformation(extent={{260,-210},{280,-190}}), iconTransformation(extent={
            {100,-100},{120,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final unit="1",
    final min = 0) "Operating part load ratio of the current stage"
    annotation (Placement(transformation(extent={{260,-50},{280,-30}}),
                            iconTransformation(extent={{100,60},{120,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaDow(
    final unit="1",
    final min = 0) "Staging down part load ratio"
    annotation (Placement(transformation(extent={{260,-170},{280,-150}}),
                    iconTransformation(extent={{100,-40},{120,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaUp(
    final unit="1",
    final min = 0) "Staging up part load ratio"
    annotation (Placement(transformation(extent={{260,-10},{280,10}}),
                    iconTransformation(extent={{100,-20},{120,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yUpMin(
    final unit="1",
    final min=0)
    "Minimum operating part load ratio at the next stage up"
    annotation (Placement(
        transformation(extent={{260,-250},{280,-230}}), iconTransformation(extent={
            {100,-80},{120,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Division opePlrSta
    "Calculates operating part load ratio at the current stage"
    annotation (Placement(transformation(extent={{-240,-60},{-220,-40}})));

  CDL.Integers.Sources.Constant chiStaType[nSta](
    final k=chiStaTyp)
    "Chiller stage type"
    annotation (Placement(transformation(extent={{-340,260},{-320,280}})));


  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaTyp(
    final nin=nSta, outOfRangeValue=-1)
    "Extract stage type"
    annotation (Placement(transformation(extent={{-240,260},{-220,280}})));

  Buildings.Controls.OBC.CDL.Integers.Add oneUp "Adds one"
    annotation (Placement(transformation(extent={{-240,140},{-220,160}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant one(final k=1)
    "Constant integer"
    annotation (Placement(transformation(extent={{-300,140},{-280,160}})));

  Buildings.Controls.OBC.CDL.Integers.Add oneDown(k2=-1) "Subtracts one"
    annotation (Placement(transformation(extent={{-240,60},{-220,80}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger curStaTyp "Current stage chiller type"
    annotation (Placement(transformation(extent={{-120,260},{-100,280}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger staUpTyp "Stage up chiller type"
    annotation (Placement(transformation(extent={{-120,200},{-100,220}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaTyp1(nin=nSta,
      outOfRangeValue=-1)
    "Extract stage type"
    annotation (Placement(transformation(extent={{-160,200},{-140,220}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaTyp2(nin=nSta)
    "Extract stage type"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger staDowTyp1 "Stage down chiller type"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant maxSta(final k=nSta) "Maximum stage"
    annotation (Placement(transformation(extent={{-300,180},{-280,200}})));

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

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant posDisTypMult(
    final k=posDisMult)
    "Positive displacement chiller type SPLR multiplier"
    annotation (Placement(transformation(extent={{-180,-120},{-160,-100}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conSpeCenTypMult(
    final k=conSpeCenMult)
    "Constant speed centrifugal chiller type SPLR multiplier"
    annotation (Placement(transformation(extent={{-180,-40},{-160,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    annotation (Placement(transformation(extent={{100,60},{120,80}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi2
    annotation (Placement(transformation(extent={{60,-190},{80,-170}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi3
    annotation (Placement(transformation(extent={{20,-240},{40,-220}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1
    annotation (Placement(transformation(extent={{-20,98},{0,118}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Division minOpePlrUp
   "Calculates minimum OPLR of one stage up"
    annotation (Placement(transformation(extent={{-240,-200},{-220,-180}})));

  Buildings.Controls.OBC.CDL.Continuous.Division opePlrUp
    "Calculates operating part load ratio at the next stage up"
    annotation (Placement(transformation(extent={{-240,-150},{-220,-130}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const(k=0.9) if nVsdCen>0 "Constant"
    annotation (Placement(transformation(extent={{-240,-360},{-220,-340}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add2(k2=-1) if nVsdCen>0 "Subtract"
    annotation (Placement(transformation(extent={{-120,-420},{-100,-400}})));

  Buildings.Controls.OBC.CDL.Continuous.Division div if nVsdCen>0
    annotation (Placement(transformation(extent={{-60,-370},{-40,-350}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const1(k=0.4) if nVsdCen>0 "Constant"
    annotation (Placement(transformation(extent={{-240,-480},{-220,-460}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const2(k=1.4) if nVsdCen>0 "Constant"
    annotation (Placement(transformation(extent={{-240,-560},{-220,-540}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add1(k2=-1) if nVsdCen>0 "Subtract"
    annotation (Placement(transformation(extent={{-120,-500},{-100,-480}})));

  Buildings.Controls.OBC.CDL.Continuous.Product mult0 if nVsdCen>0 "Multiplier"
    annotation (Placement(transformation(extent={{-180,-460},{-160,-440}})));

  Buildings.Controls.OBC.CDL.Continuous.Product mult1 if nVsdCen>0 "Multiplier"
    annotation (Placement(transformation(extent={{-180,-560},{-160,-540}})));

  Buildings.Controls.OBC.CDL.Continuous.Product mult2 if nVsdCen>0 "Multiplier"
    annotation (Placement(transformation(extent={{0,-440},{20,-420}})));

  Buildings.Controls.OBC.CDL.Continuous.Product mult3 if nVsdCen>0 "Multiplier"
    annotation (Placement(transformation(extent={{60,-510},{80,-490}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add3 if nVsdCen>0 "Subtract"
    annotation (Placement(transformation(extent={{120,-482},{140,-462}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const3(k=-1) if nVsdCen == 0
    "Constant"
    annotation (Placement(transformation(extent={{50,0},{70,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const4(k=-1) if nVsdCen == 0
    "Constant"
    annotation (Placement(transformation(extent={{-40,-270},{-20,-250}})));

  Buildings.Controls.OBC.CDL.Utilities.Assert staTyp(
    final message="Unlisted chiller type got selected")
    "Unlisted chiller type got selected"
    annotation (Placement(transformation(extent={{220,250},{240,270}})));

  CDL.Continuous.GreaterThreshold                     greThr(
    final threshold=-0.5)
    "Less than threshold"
    annotation (Placement(transformation(extent={{180,250},{200,270}})));

  Buildings.Controls.OBC.CDL.Utilities.Assert staExc1(
    final message="Unlisted chiller type got selected")
    "Unlisted chiller type got selected"
    annotation (Placement(transformation(extent={{220,200},{240,220}})));

  CDL.Continuous.GreaterThreshold                     greThr1(
    final threshold=-0.5) "Less than threshold"
    annotation (Placement(transformation(extent={{180,200},{200,220}})));

  Buildings.Controls.OBC.CDL.Continuous.Division opePlrDow
    "Calculates operating part load ratio of the next stage down"
    annotation (Placement(transformation(extent={{-240,-90},{-220,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.Division minOpePlr
    "Calculates minimum OPLR of the current stage"
    annotation (Placement(transformation(extent={{-240,-240},{-220,-220}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu3
    annotation (Placement(transformation(extent={{-20,200},{0,220}})));

  CDL.Conversions.IntegerToReal intToRea[nSta]
    annotation (Placement(transformation(extent={{-300,260},{-280,280}})));

  CDL.Logical.Switch swi4
    annotation (Placement(transformation(extent={{120,-170},{140,-150}})));

  CDL.Continuous.Sources.Constant const5(k=1) if  nVsdCen == 0
    "If staging from 1 to 0 staging down part load ratio is 1"
    annotation (Placement(transformation(extent={{80,-152},{100,-132}})));

  CDL.Integers.Equal intEqu4
    annotation (Placement(transformation(extent={{-178,0},{-158,20}})));

equation
  connect(uCapReq, opePlrSta.u1) annotation (Line(points={{-360,0},{-260,0},{-260,
          -44},{-242,-44}}, color={0,0,127}));
  connect(uStaCapNom, opePlrSta.u2) annotation (Line(points={{-362,-60},{-290,-60},
          {-290,-56},{-242,-56}}, color={0,0,127}));
  connect(uSta,extStaTyp. index) annotation (Line(points={{-360,240},{-230,240},
          {-230,258}}, color={255,127,0}));
  connect(one.y, oneDown.u2) annotation (Line(points={{-279,150},{-260,150},{-260,
          64},{-242,64}},   color={255,127,0}));
  connect(extStaTyp.y, curStaTyp.u)
    annotation (Line(points={{-219,270},{-122,270}}, color={0,0,127}));
  connect(one.y, oneUp.u2) annotation (Line(points={{-279,150},{-260,150},{-260,
          144},{-242,144}}, color={255,127,0}));
  connect(uSta, oneDown.u1) annotation (Line(points={{-360,240},{-250,240},{-250,
          76},{-242,76}},   color={255,127,0}));
  connect(uSta, oneUp.u1) annotation (Line(points={{-360,240},{-250,240},{-250,156},
          {-242,156}}, color={255,127,0}));
  connect(extStaTyp1.y, staUpTyp.u)
    annotation (Line(points={{-139,210},{-122,210}}, color={0,0,127}));
  connect(extStaTyp2.y, staDowTyp1.u)
    annotation (Line(points={{-139,110},{-122,110}}, color={0,0,127}));
  connect(maxSta.y, minInt.u1) annotation (Line(points={{-279,190},{-230,190},{-230,
          176},{-182,176}},color={255,127,0}));
  connect(oneUp.y, minInt.u2) annotation (Line(points={{-219,150},{-200,150},{-200,
          164},{-182,164}},color={255,127,0}));
  connect(minInt.y, extStaTyp1.index) annotation (Line(points={{-159,170},{-150,
          170},{-150,198}}, color={255,127,0}));
  connect(oneDown.y, maxInt.u1) annotation (Line(points={{-219,70},{-200,70},{-200,
          76},{-182,76}},color={255,127,0}));
  connect(maxInt.y, extStaTyp2.index)
    annotation (Line(points={{-159,70},{-150,70},{-150,98}}, color={255,127,0}));
  connect(staUpTyp.y, intEqu.u1) annotation (Line(points={{-99,210},{-60,210},{-60,
          170},{-22,170}}, color={255,127,0}));
  connect(intEqu.u2, staTyp1.y) annotation (Line(points={{-22,162},{-32,162},{-32,
          140},{-39,140}}, color={255,127,0}));
  connect(opePlrSta.y, y) annotation (Line(points={{-219,-50},{-40,-50},{-40,-40},
          {270,-40}}, color={0,0,127}));
  connect(curStaTyp.y, intEqu1.u1) annotation (Line(points={{-99,270},{-80,270},
          {-80,108},{-22,108}}, color={255,127,0}));
  connect(staTyp2.y, intEqu1.u2) annotation (Line(points={{-39,80},{-30,80},{-30,100},
          {-22,100}},      color={255,127,0}));
  connect(intEqu1.y, swi1.u2) annotation (Line(points={{1,108},{50,108},{50,70},
          {98,70}}, color={255,0,255}));
  connect(staDowTyp1.y, intEqu2.u1) annotation (Line(points={{-99,110},{-90,110},{-90,
          30},{-22,30}},      color={255,127,0}));
  connect(swi1.y, swi.u3) annotation (Line(points={{121,70},{130,70},{130,142},{
          140,142}}, color={0,0,127}));
  connect(staTyp2.y, intEqu2.u2) annotation (Line(points={{-39,80},{-30,80},{-30,22},
          {-22,22}},              color={255,127,0}));
  connect(swi3.y, swi2.u3) annotation (Line(points={{41,-230},{50,-230},{50,-188},
          {58,-188}}, color={0,0,127}));
  connect(intEqu2.y, swi3.u2) annotation (Line(points={{1,30},{10,30},{10,-230},
          {18,-230}}, color={255,0,255}));
  connect(swi.y, yStaUp) annotation (Line(points={{163,150},{220,150},{220,0},{270,
          0}}, color={0,0,127}));
  connect(uCapReq, opePlrUp.u1) annotation (Line(points={{-360,0},{-300,0},{-300,
          -134},{-242,-134}},
                        color={0,0,127}));
  connect(uStaUpCapNom, opePlrUp.u2) annotation (Line(points={{-360,-160},{-280,
          -160},{-280,-146},{-242,-146}},
                                    color={0,0,127}));
  connect(opePlrUp.y, yUp) annotation (Line(points={{-219,-140},{-40,-140},{-40,
          -120},{270,-120}},
                       color={0,0,127}));
  connect(minOpePlrUp.y, yUpMin) annotation (Line(points={{-219,-190},{-120,-190},
          {-120,-290},{240,-290},{240,-240},{270,-240}},color={0,0,127}));
  connect(uLifMin, add2.u2) annotation (Line(points={{-360,-420},{-240,-420},{-240,
          -416},{-122,-416}}, color={0,0,127}));
  connect(const.y, div.u1) annotation (Line(points={{-219,-350},{-100,-350},{-100,
          -354},{-62,-354}}, color={0,0,127}));
  connect(add2.y, div.u2) annotation (Line(points={{-99,-410},{-80,-410},{-80,-366},
          {-62,-366}}, color={0,0,127}));
  connect(const1.y, mult0.u2) annotation (Line(points={{-219,-470},{-190,-470},{
          -190,-456},{-182,-456}}, color={0,0,127}));
  connect(uLifMax, mult0.u1) annotation (Line(points={{-360,-360},{-300,-360},{-300,
          -400},{-190,-400},{-190,-444},{-182,-444}},
        color={0,0,127}));
  connect(uLifMin, mult1.u1) annotation (Line(points={{-360,-420},{-260,-420},{-260,
          -500},{-200,-500},{-200,-544},{-182,-544}},
        color={0,0,127}));
  connect(const2.y, mult1.u2) annotation (Line(points={{-219,-550},{-200,-550},{
          -200,-556},{-182,-556}},    color={0,0,127}));
  connect(mult0.y, add1.u1) annotation (Line(points={{-159,-450},{-150,-450},{-150,
          -484},{-122,-484}},        color={0,0,127}));
  connect(mult1.y, add1.u2) annotation (Line(points={{-159,-550},{-148,-550},{-148,
          -496},{-122,-496}}, color={0,0,127}));
  connect(div.y, mult2.u1) annotation (Line(points={{-39,-360},{-20,-360},{-20,-424},
          {-2,-424}},                       color={0,0,127}));
  connect(add1.y, mult2.u2) annotation (Line(points={{-99,-490},{-20,-490},{-20,
          -436},{-2,-436}}, color={0,0,127}));
  connect(div.y, mult3.u1) annotation (Line(points={{-39,-360},{40,-360},{40,-494},
          {58,-494}},
        color={0,0,127}));
  connect(uLif, mult3.u2) annotation (Line(points={{-360,-480},{-300,-480},{-300,
          -580},{40,-580},{40,-506},{58,-506}},                         color={0,
          0,127}));
  connect(mult3.y, add3.u2) annotation (Line(points={{81,-500},{90,-500},{90,-478},
          {118,-478}},       color={0,0,127}));
  connect(mult2.y, add3.u1) annotation (Line(points={{21,-430},{100,-430},{100,-466},
          {118,-466}}, color={0,0,127}));
  connect(staTyp.u,greThr. y)
    annotation (Line(points={{218,260},{201,260}},
                                              color={255,0,255}));
  connect(swi.y,greThr. u) annotation (Line(points={{163,150},{170,150},{170,
          260},{178,260}}, color={0,0,127}));
  connect(swi3.y,greThr1. u) annotation (Line(points={{41,-230},{170,-230},{170,
          210},{178,210}}, color={0,0,127}));
  connect(uLifMax, add2.u1) annotation (Line(points={{-360,-360},{-260,-360},{-260,
          -388},{-140,-388},{-140,-404},{-122,-404}}, color={0,0,127}));
  connect(uCapReq, opePlrDow.u1) annotation (Line(points={{-360,0},{-280,0},{-280,
          -74},{-242,-74}},
                       color={0,0,127}));
  connect(uStaDowCapNom, opePlrDow.u2) annotation (Line(points={{-360,-120},{-280,
          -120},{-280,-86},{-242,-86}},
                                    color={0,0,127}));
  connect(opePlrDow.y, yDow) annotation (Line(points={{-219,-80},{270,-80}},
                      color={0,0,127}));
  connect(minOpePlr.y, yMin) annotation (Line(points={{-219,-230},{-80,-230},{-80,
          -200},{270,-200}},                       color={0,0,127}));
  connect(conSpeCenTypMult.y, swi.u1) annotation (Line(points={{-159,-30},{40,
          -30},{40,158},{140,158}},
                               color={0,0,127}));
  connect(posDisTypMult.y, swi1.u1) annotation (Line(points={{-159,-110},{-60,
          -110},{-60,60},{0,60},{0,78},{98,78}},
                                              color={0,0,127}));
  connect(posDisTypMult.y, swi3.u1) annotation (Line(points={{-159,-110},{-60,
          -110},{-60,-222},{18,-222}},
                                 color={0,0,127}));
  connect(conSpeCenTypMult.y, swi2.u1) annotation (Line(points={{-159,-30},{0,
          -30},{0,-172},{58,-172}},
                               color={0,0,127}));
  connect(staTyp1.y, intEqu3.u2) annotation (Line(points={{-39,140},{-32,140},{-32,
          202},{-22,202}}, color={255,127,0}));
  connect(curStaTyp.y, intEqu3.u1) annotation (Line(points={{-99,270},{-32,270},
          {-32,210},{-22,210}},
                           color={255,127,0}));
  connect(intEqu3.y, swi2.u2) annotation (Line(points={{1,210},{30,210},{30,-180},
          {58,-180}},color={255,0,255}));
  connect(uStaCapMin, minOpePlr.u1) annotation (Line(points={{-362,-220},{-280,-220},
          {-280,-224},{-242,-224}},       color={0,0,127}));
  connect(uStaCapNom, minOpePlr.u2) annotation (Line(points={{-362,-60},{-320,-60},
          {-320,-236},{-242,-236}},      color={0,0,127}));
  connect(uStaUpCapMin, minOpePlrUp.u1) annotation (Line(points={{-360,-260},{-300,
          -260},{-300,-184},{-242,-184}},      color={0,0,127}));
  connect(uStaUpCapNom, minOpePlrUp.u2) annotation (Line(points={{-360,-160},{-280,
          -160},{-280,-196},{-242,-196}},      color={0,0,127}));
  connect(greThr1.y, staExc1.u)
    annotation (Line(points={{201,210},{218,210}}, color={255,0,255}));
  connect(intEqu.y, swi.u2) annotation (Line(points={{1,170},{120,170},{120,150},
          {140,150}}, color={255,0,255}));
  connect(chiStaType.y, intToRea.u)
    annotation (Line(points={{-319,270},{-302,270}}, color={255,127,0}));
  connect(intToRea.y, extStaTyp.u)
    annotation (Line(points={{-279,270},{-242,270}}, color={0,0,127}));
  connect(intToRea.y, extStaTyp1.u) annotation (Line(points={{-279,270},{-260,270},
          {-260,210},{-162,210}}, color={0,0,127}));
  connect(intToRea.y, extStaTyp2.u) annotation (Line(points={{-279,270},{-260,270},
          {-260,210},{-200,210},{-200,110},{-162,110}}, color={0,0,127}));
  connect(const4.y, swi3.u3) annotation (Line(points={{-19,-260},{0,-260},{0,-238},
          {18,-238}}, color={0,0,127}));
  connect(const3.y, swi1.u3) annotation (Line(points={{71,10},{80,10},{80,62},{98,
          62}}, color={0,0,127}));
  connect(add3.y, swi3.u3) annotation (Line(points={{141,-472},{150,-472},{150,-260},
          {10,-260},{10,-238},{18,-238}},
                                        color={0,0,127}));
  connect(add3.y, swi1.u3) annotation (Line(points={{141,-472},{150,-472},{150,20},
          {88,20},{88,62},{98,62}}, color={0,0,127}));
  connect(swi4.y, yStaDow)
    annotation (Line(points={{141,-160},{270,-160}}, color={0,0,127}));
  connect(swi2.y, swi4.u3) annotation (Line(points={{81,-180},{100,-180},{100,-168},
          {118,-168}}, color={0,0,127}));
  connect(const5.y, swi4.u1) annotation (Line(points={{101,-142},{110,-142},{110,
          -152},{118,-152}}, color={0,0,127}));
  connect(one.y, maxInt.u2) annotation (Line(points={{-279,150},{-268,150},{-268,
          50},{-192,50},{-192,64},{-182,64}}, color={255,127,0}));
  connect(uSta, intEqu4.u2) annotation (Line(points={{-360,240},{-338,240},{
          -338,236},{-320,236},{-320,12},{-238,12},{-238,2},{-180,2}},
                                                                  color={255,127,
          0}));
  connect(one.y, intEqu4.u1) annotation (Line(points={{-279,150},{-268,150},{
          -268,20},{-220,20},{-220,10},{-180,10}},
                                              color={255,127,0}));
  connect(intEqu4.y, swi4.u2) annotation (Line(points={{-157,10},{-10,10},{-10,
          -160},{118,-160}},
                       color={255,0,255}));
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
          textString="%name"),
        Text(
          extent={{-82,26},{40,-138}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="PLR")}),   Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-340,-600},{260,320}}), graphics={Text(
          extent={{80,56},{142,24}},
          lineColor={28,108,200},
          textString="lift 
formula")}),
Documentation(info="<html>
<p>
OPLR - Operating part load ratio refers to any ratio of current capacity requirement
to a nominal or minimal stage capacity.

SPLR - Stage part load ratio (up or down) is defined separately for each stage chiller type.
It is used in deciding whether to stage up or down when compared with OPLRs of the current 
and first stage down, respectively.

Set stage chiller type to:

1: Positive displacement - if the stage has more than one positive displacement chiller
2: Variable speed centrifugal - if the stage contains any variable speed centrifugal chillers
3: Constant speed centrifugal - if the stage contains any constant speed centrifugal chillers

If more than one condition applies for a single stage, use the determination with the highest integer.

Recomended staging order: more than one positive displacement, variable speed centrifugal, constant speed centrifugal

fixme: add test for centrifugal later, after we clarify why both up and down SPLR equations look the same.
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
