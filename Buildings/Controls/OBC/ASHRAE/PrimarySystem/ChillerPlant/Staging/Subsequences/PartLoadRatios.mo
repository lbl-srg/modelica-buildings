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
    annotation (Placement(transformation(extent={{262,-230},{282,-210}}),
                    iconTransformation(extent={{100,50},{120,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Division opePlrSta
    "Calculates operating part load ratio at the current stage"
    annotation (Placement(transformation(extent={{-236,-82},{-216,-62}})));

  CDL.Continuous.Division staDowPlr "Calculates stage down part load ratio"
    annotation (Placement(transformation(extent={{-98,-448},{-78,-428}})));
  CDL.Continuous.Product staUpPlr "Calculates stage up part load ratio"
    annotation (Placement(transformation(extent={{-198,-120},{-178,-100}})));
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
    annotation (Placement(transformation(extent={{30,-242},{50,-222}})));
  CDL.Integers.Sources.Constant staTyp1(final k=1) "Chiller stage type 1"
    annotation (Placement(transformation(extent={{-100,-180},{-80,-160}})));
  CDL.Integers.Sources.Constant staTyp2(final k=2) "Chiller stage type 2"
    annotation (Placement(transformation(extent={{-100,-220},{-80,-200}})));
  CDL.Integers.Sources.Constant staTyp3(final k=3) "Chiller stage type 3"
    annotation (Placement(transformation(extent={{-100,-260},{-80,-240}})));
  CDL.Integers.Equal intEqu
    annotation (Placement(transformation(extent={{46,-176},{66,-156}})));
  CDL.Continuous.Sources.Constant posDisTypMult(k=chiStaTyp)
    "Positive displacement chiller type SPLR multiplier"
    annotation (Placement(transformation(extent={{-240,-160},{-220,-140}})));
  CDL.Continuous.Sources.Constant conSpeCenTypMult(k=conSpeCenMult)
    "Constant speed centrifugal chiller type SPLR multiplier"
    annotation (Placement(transformation(extent={{-240,-220},{-220,-200}})));
  CDL.Logical.Switch swi1
    annotation (Placement(transformation(extent={{60,-272},{80,-252}})));
  CDL.Logical.Switch swi2
    annotation (Placement(transformation(extent={{86,-300},{106,-280}})));
  CDL.Logical.Switch swi3
    annotation (Placement(transformation(extent={{6,-398},{26,-378}})));
  CDL.Logical.Switch swi4
    annotation (Placement(transformation(extent={{36,-428},{56,-408}})));
  CDL.Logical.Switch swi5
    annotation (Placement(transformation(extent={{62,-456},{82,-436}})));
equation
  connect(uCapReq, opePlrSta.u1) annotation (Line(points={{-362,-100},{-280,-100},
          {-280,-66},{-238,-66}},
                               color={0,0,127}));
  connect(uStaCapNom, opePlrSta.u2) annotation (Line(points={{-362,-60},{-298,-60},
          {-298,-78},{-238,-78}},
                              color={0,0,127}));
  connect(opePlrSta.y, staUpPlr.u1) annotation (Line(points={{-215,-72},{-208,-72},
          {-208,-104},{-200,-104}},
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
  connect(staUpPlr.y, y) annotation (Line(points={{-177,-110},{0,-110},{0,-60},
          {272,-60}}, color={0,0,127}));
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
        extent={{-340,-400},{260,320}})),
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
