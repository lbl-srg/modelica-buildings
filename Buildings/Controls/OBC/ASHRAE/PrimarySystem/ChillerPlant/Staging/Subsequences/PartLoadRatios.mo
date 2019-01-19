within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block PartLoadRatios
  "Stage operating part load ratios (current, up, down and minimum) with reset based on stage chiller type"

  parameter Integer numSta = 2
  "Number of stages";

  parameter Real chiStaTyp[numSta] = {1,1}
  "Integer stage chiller type: 1=any constant speed centrifugal, 2=all positive displacement, 3=any variable speed centrifugal";

  parameter Real posDisMult(unit = "1", min = 0, max = 1)=0.8
  "Positive displacement chiller type staging multiplier";

  parameter Real conSpeCenMult(unit = "1", min = 0, max = 1)=0.9
  "Constant speed centrifugal chiller type staging multiplier";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCapReq(
    final unit="W",
    final quantity="Power")
    "Chilled water cooling capacity requirement"
    annotation (Placement(transformation(extent={{-382,-120},{-342,-80}}),
    iconTransformation(extent={{-120,-50},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uStaCapNom(
    final unit="W",
    final quantity="Power")
    "Nominal capacity of the current stage"
    annotation (Placement(transformation(extent={{-382,-80},{-342,-40}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uStaUpCapMin(
    final unit="W",
    final quantity="Power") "Minimal capacity of the next higher stage"
    annotation (Placement(transformation(extent={{-382,-200},{-342,-160}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uStaDowCapNom(
    final unit="W",
    final quantity="Power") "Nominal capacity of the next lower stage"
    annotation (Placement(transformation(extent={{-382,-160},{-342,-120}}),
        iconTransformation(extent={{-120,-30},{-100,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLifMin(
    final unit="K",
    final quantity="ThermodynamicTemperature") if max(chiStaTyp) > 2.5
    "Minimum chiller lift"
    annotation (Placement(transformation(extent={{-380,-360},{-340,-320}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLifMax(
    final unit="K",
    final quantity="ThermodynamicTemperature") if max(chiStaTyp) > 2.5
    "Maximum chiller lift"
    annotation (Placement(transformation(extent={{-380,-320},{-340,-280}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLif(
    final unit="K",
    final quantity="ThermodynamicTemperature") if max(chiStaTyp) > 2.5
    "Chiller lift"
    annotation (Placement(transformation(extent={{-380,-400},{-340,-360}}),
        iconTransformation(extent={{-120,-30},{-100,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final unit="1", min = 0)
    "Operating part load ratio"
    annotation (Placement(transformation(extent={{262,-70},{282,-50}}),
                            iconTransformation(extent={{100,50},{120,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaDow(
    final unit="1", min = 0)
    "Stage down part load ratio"
    annotation (Placement(transformation(extent={{262,-130},{282,-110}}),
                    iconTransformation(extent={{100,50},{120,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaUp(
    final unit="1", min = 0)
    "Stage up part load ratio"
    annotation (Placement(transformation(extent={{262,-10},{282,10}}),
                    iconTransformation(extent={{100,50},{120,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaUpMin(
    final unit="1", min = 0)
    "Stage up minimal part load ratio"
    annotation (Placement(transformation(extent={{260,-230},{280,-210}}),
                    iconTransformation(extent={{100,50},{120,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Division opePlrSta
    "Calculates operating part load ratio at the current stage"
    annotation (Placement(transformation(extent={{-236,-82},{-216,-62}})));

  CDL.Continuous.Division staDowPlr "Calculates stage down part load ratio"
    annotation (Placement(transformation(extent={{-98,-448},{-78,-428}})));
  CDL.Continuous.Product staUpPlr "Calculates stage up part load ratio"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  CDL.Continuous.Sources.Constant chiStaType[numSta](k=chiStaTyp)
    "Chiller stage type"
    annotation (Placement(transformation(extent={{-300,260},{-280,280}})));

  CDL.Interfaces.IntegerInput                        uSta "Chiller stage"
    annotation (Placement(transformation(extent={{-380,220},{-340,260}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  CDL.Routing.RealExtractor extStaTyp "Extract stage type"
    annotation (Placement(transformation(extent={{-240,260},{-220,280}})));
  CDL.Integers.Add oneUp "Adds one"
    annotation (Placement(transformation(extent={{-240,140},{-220,160}})));
  CDL.Integers.Sources.Constant                        one(final k=1)
    "Constant integer"
    annotation (Placement(transformation(extent={{-300,140},{-280,160}})));
  CDL.Integers.Add oneDown(k2=-1) "Subtracts one"
    annotation (Placement(transformation(extent={{-240,60},{-220,80}})));
  CDL.Conversions.RealToInteger curStaTyp "Current stage chiller type"
    annotation (Placement(transformation(extent={{-160,260},{-140,280}})));
  CDL.Conversions.RealToInteger staUpTyp "Stage up chiller type"
    annotation (Placement(transformation(extent={{-120,200},{-100,220}})));
  CDL.Routing.RealExtractor extStaTyp1 "Extract stage type"
    annotation (Placement(transformation(extent={{-160,200},{-140,220}})));
  CDL.Routing.RealExtractor extStaTyp2 "Extract stage type"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));
  CDL.Conversions.RealToInteger staDowTyp1 "Stage down chiller type"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  CDL.Integers.Sources.Constant maxSta(final k=numSta) "Maximum stage"
    annotation (Placement(transformation(extent={{-300,180},{-280,200}})));
  CDL.Integers.Sources.Constant minSta(final k=0) "Minimum stage"
    annotation (Placement(transformation(extent={{-298,40},{-278,60}})));
  CDL.Integers.Max maxInt
    annotation (Placement(transformation(extent={{-180,60},{-160,80}})));
  CDL.Integers.Min minInt
    annotation (Placement(transformation(extent={{-180,160},{-160,180}})));
  CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{142,140},{162,160}})));
  CDL.Integers.Sources.Constant staTyp1(final k=1) "Chiller stage type 1"
    annotation (Placement(transformation(extent={{-62,130},{-42,150}})));
  CDL.Integers.Sources.Constant staTyp2(final k=2) "Chiller stage type 2"
    annotation (Placement(transformation(extent={{-62,70},{-42,90}})));
  CDL.Integers.Equal intEqu
    annotation (Placement(transformation(extent={{-20,160},{0,180}})));
  CDL.Continuous.Sources.Constant posDisTypMult(k=chiStaTyp)
    "Positive displacement chiller type SPLR multiplier"
    annotation (Placement(transformation(extent={{-180,-140},{-160,-120}})));
  CDL.Continuous.Sources.Constant conSpeCenTypMult(k=conSpeCenMult)
    "Constant speed centrifugal chiller type SPLR multiplier"
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));
  CDL.Logical.Switch swi1
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
  CDL.Logical.Switch swi2
    annotation (Placement(transformation(extent={{62,-182},{82,-162}})));
  CDL.Logical.Switch swi3
    annotation (Placement(transformation(extent={{22,-242},{42,-222}})));
  CDL.Logical.Switch swi4
    annotation (Placement(transformation(extent={{36,-428},{56,-408}})));
  CDL.Logical.Switch swi5
    annotation (Placement(transformation(extent={{62,-456},{82,-436}})));
  CDL.Integers.Equal intEqu1
    annotation (Placement(transformation(extent={{-22,98},{-2,118}})));
  CDL.Continuous.Product staUpPlr1 "Calculates stage up part load ratio"
    annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));
  CDL.Integers.Equal intEqu2
    annotation (Placement(transformation(extent={{-18,10},{2,30}})));
  CDL.Integers.Equal intEqu3
    annotation (Placement(transformation(extent={{-20,-160},{0,-140}})));
  CDL.Continuous.Product staDowPlr1 "Calculates stage down part load ratio"
    annotation (Placement(transformation(extent={{-120,-220},{-100,-200}})));
  CDL.Continuous.Product staDowPlr2 "Calculates stage down part load ratio"
    annotation (Placement(transformation(extent={{-120,-300},{-100,-280}})));
  CDL.Continuous.Division                        opePlrSta1
    "Calculates minimum PLR of one stage up"
    annotation (Placement(transformation(extent={{-280,-200},{-260,-180}})));
equation
  connect(uCapReq, opePlrSta.u1) annotation (Line(points={{-362,-100},{-280,-100},
          {-280,-66},{-238,-66}},
                               color={0,0,127}));
  connect(uStaCapNom, opePlrSta.u2) annotation (Line(points={{-362,-60},{-298,-60},
          {-298,-78},{-238,-78}},
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
  connect(staUpTyp.y, intEqu.u1) annotation (Line(points={{-99,210},{-60,210},{
          -60,170},{-22,170}}, color={255,127,0}));
  connect(intEqu.u2, staTyp1.y) annotation (Line(points={{-22,162},{-32,162},{
          -32,140},{-41,140}}, color={255,127,0}));
  connect(intEqu.y, swi.u2) annotation (Line(points={{1,170},{18,170},{18,150},
          {140,150}}, color={255,0,255}));
  connect(opePlrSta.y, y) annotation (Line(points={{-215,-72},{-38,-72},{-38,
          -60},{272,-60}}, color={0,0,127}));
  connect(conSpeCenTypMult.y, staUpPlr.u2) annotation (Line(points={{-139,-30},
          {-132,-30},{-132,-16},{-122,-16}}, color={0,0,127}));
  connect(staUpPlr.y, swi.u1) annotation (Line(points={{-99,-10},{32,-10},{32,
          158},{140,158}}, color={0,0,127}));
  connect(uStaCapNom, staUpPlr.u1) annotation (Line(points={{-362,-60},{-300,
          -60},{-300,-4},{-122,-4}}, color={0,0,127}));
  connect(curStaTyp.y, intEqu1.u1) annotation (Line(points={{-139,270},{-80,270},
          {-80,108},{-24,108}}, color={255,127,0}));
  connect(staTyp2.y, intEqu1.u2) annotation (Line(points={{-41,80},{-30,80},{
          -30,100},{-24,100}}, color={255,127,0}));
  connect(intEqu1.y, swi1.u2) annotation (Line(points={{-1,108},{40,108},{40,70},
          {98,70}}, color={255,0,255}));
  connect(posDisTypMult.y, staUpPlr1.u2) annotation (Line(points={{-159,-130},{
          -142,-130},{-142,-116},{-122,-116}}, color={0,0,127}));
  connect(uStaCapNom, staUpPlr1.u1) annotation (Line(points={{-362,-60},{-298,
          -60},{-298,-104},{-122,-104}}, color={0,0,127}));
  connect(staUpPlr1.y, swi1.u1) annotation (Line(points={{-99,-110},{-50,-110},
          {-50,-106},{40,-106},{40,78},{98,78}}, color={0,0,127}));
  connect(staDowTyp1.y, intEqu2.u1) annotation (Line(points={{-99,110},{-90,110},
          {-90,20},{-20,20}}, color={255,127,0}));
  connect(swi1.y, swi.u3) annotation (Line(points={{121,70},{128,70},{128,142},
          {140,142}}, color={0,0,127}));
  connect(staTyp1.y, intEqu3.u2) annotation (Line(points={{-41,140},{-34,140},{
          -34,-158},{-22,-158}}, color={255,127,0}));
  connect(curStaTyp.y, intEqu3.u1) annotation (Line(points={{-139,270},{-80,270},
          {-80,-150},{-22,-150}}, color={255,127,0}));
  connect(intEqu3.y, swi2.u2) annotation (Line(points={{1,-150},{20,-150},{20,
          -172},{60,-172}}, color={255,0,255}));
  connect(uStaDowCapNom, staDowPlr1.u1) annotation (Line(points={{-362,-140},{
          -241,-140},{-241,-204},{-122,-204}}, color={0,0,127}));
  connect(uStaDowCapNom, staDowPlr2.u1) annotation (Line(points={{-362,-140},{
          -242,-140},{-242,-284},{-122,-284}}, color={0,0,127}));
  connect(conSpeCenTypMult.y, staDowPlr1.u2) annotation (Line(points={{-139,-30},
          {-130,-30},{-130,-216},{-122,-216}}, color={0,0,127}));
  connect(posDisTypMult.y, staDowPlr2.u2) annotation (Line(points={{-159,-130},
          {-142,-130},{-142,-296},{-122,-296}}, color={0,0,127}));
  connect(staDowPlr1.y, swi2.u1) annotation (Line(points={{-99,-210},{-80,-210},
          {-80,-180},{38,-180},{38,-164},{60,-164}}, color={0,0,127}));
  connect(staTyp2.y, intEqu2.u2) annotation (Line(points={{-41,80},{-41,78},{
          -30,78},{-30,12},{-20,12}}, color={255,127,0}));
  connect(swi3.y, swi2.u3) annotation (Line(points={{43,-232},{50,-232},{50,
          -180},{60,-180}}, color={0,0,127}));
  connect(intEqu2.y, swi3.u2) annotation (Line(points={{3,20},{10,20},{10,-232},
          {20,-232}}, color={255,0,255}));
  connect(staDowPlr2.y, swi3.u1) annotation (Line(points={{-99,-290},{-40,-290},
          {-40,-224},{20,-224}}, color={0,0,127}));
  connect(swi.y, yStaUp) annotation (Line(points={{163,150},{218,150},{218,0},{
          272,0}}, color={0,0,127}));
  connect(swi2.y, yStaDow) annotation (Line(points={{83,-172},{218,-172},{218,
          -120},{272,-120}}, color={0,0,127}));
  connect(uCapReq, opePlrSta1.u1) annotation (Line(points={{-362,-100},{-306,
          -100},{-306,-184},{-282,-184}}, color={0,0,127}));
  connect(uStaUpCapMin, opePlrSta1.u2) annotation (Line(points={{-362,-180},{
          -326,-180},{-326,-196},{-282,-196}}, color={0,0,127}));
  annotation (defaultComponentName = "staChaPosDis",
        Icon(coordinateSystem(extent={{-340,-400},{260,320}}),
             graphics={
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
        extent={{-340,-400},{260,320}}), graphics={Text(
          extent={{80,56},{142,24}},
          lineColor={28,108,200},
          textString="lift 
formula"), Text(
          extent={{-2,-250},{60,-282}},
          lineColor={28,108,200},
          textString="lift 
formula")}),
Documentation(info="<html>
<p>
Fixme: This is a development version of the staging part load ratio 
calculation with chiller type reset.

Explain SPLR

Set stage chiller type to:

1 if the stage contains any constant speed centrifugal chiller
2 if the stage consists of positive displacement chillers
3 if the stage contains any variable speed centrifugal chiller

If more than one condition applies for a single stage, use the determination with the highest integer.

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
