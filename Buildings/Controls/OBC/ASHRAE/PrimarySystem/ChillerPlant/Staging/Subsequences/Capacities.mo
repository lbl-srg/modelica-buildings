within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block Capacities "Returns nominal and minimal capacities for calculating all operating part load ratios"

  parameter Integer nSta = 3
    "Total number of stages";

  parameter Modelica.SIunits.Power chiNomCap[nChi]
    "Nominal chiller capacities";

  parameter Modelica.SIunits.Power chiMinCap[nChi]
    "Chiller unload capacities";

  final parameter Real lowDia[nSta, nSta] = {if i<=j then 1 else 0 for i in 1:nSta, j in 1:nSta}
    "Lower diagonal unit matrix";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u(
    final min=0,
    final max=nSta) "Chiller stage"
    annotation (Placement(transformation(extent={{-300,
            100},{-260,140}}), iconTransformation(extent={{-120,20},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaNom(
    final unit="W",
    final quantity="Power") "Nominal capacity of the current stage"
    annotation (Placement(transformation(extent={{260,90},{280,110}}),
      iconTransformation(extent={{100,60},{120,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaDowNom(
    final unit="W",
    final quantity="Power") "Nominal capacity of the first stage down"
    annotation (Placement(transformation(extent={{260,10},{280,30}}),
      iconTransformation(extent={{100,-20},{120,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaUpNom(
    final unit="W",
    final quantity="Power") "Nominal capacity of the next higher stage"
                                                annotation (Placement(
      transformation(extent={{260,50},{280,70}}),
      iconTransformation(extent={{100,20},{120,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaMin(
    final unit="W",
    final quantity="Power")
    "Minimum capacity of the current stage" annotation (Placement(
      transformation(extent={{260,-30},{280,-10}}), iconTransformation(extent={{100,-80},
            {120,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaUpMin(
    final unit="W",
    final quantity="Power") "Minimum capacity of the next higher stage"
      annotation (Placement(transformation(extent={{260,-70},{280,-50}}),
      iconTransformation(extent={{100,-60},{120,-40}})));

//protected
  final parameter Real small = 0.001
  "Small number to avoid division with zero";

  final parameter Real large = staNomCap[end]*nSta*10
  "Value to avoid stage up when at the highest stage";

  final parameter Integer staRan[nSta] = {i for i in 1:nSta}
  "Range with all possible stage values";

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant one(
    final k=1) "Constant integer"
    annotation (Placement(transformation(extent={{-240,30},{-220,50}})));

  Buildings.Controls.OBC.CDL.Utilities.Assert staExc(
    final message="The provided chiller stage is not within the number of stages available")
    "Error assertion"
    annotation (Placement(transformation(extent={{220,200},{240,220}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr[2](final
      threshold=fill(-0.5, 2)) "Less than threshold"
    annotation (Placement(transformation(extent={{140,200},{160,220}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaCap(
    final outOfRangeValue=-1,
    final nin=nSta)
    "Extracts the nominal capacity at the current stage"
    annotation (Placement(transformation(extent={{-40,140},{-20,160}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaLowCap(
    final outOfRangeValue=-1,
    final nin=nSta,
    allowOutOfRange=true)
    "Extracts the nominal capacity of one stage lower than the current stage"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaUpCapMin(
    final nin=nSta,
    final allowOutOfRange=true,
    final outOfRangeValue=large)
    "Extracts minimal capacity of the next higher stage"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaUpCap(
    final nin=nSta,
    final allowOutOfRange=true,
    final outOfRangeValue=large)
    "Extracts the nominal capacity of the next stage"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaCapMin(
    final nin=nSta,
    final outOfRangeValue=0,
    final allowOutOfRange=true)
    "Extracts the minimum capacity of the current stage"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant smaNum(
    final k=small) "Small number to prevent division with zero downstream"
    annotation (Placement(transformation(extent={{140,100},{160,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant larNum(
    final k=large) "Large number to prevent staging up at the highest stage"
    annotation (Placement(transformation(extent={{140,160},{160,180}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi2
    "Switch"
    annotation (Placement(transformation(extent={{220,60},{240,80}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi4
    "Switch"
    annotation (Placement(transformation(extent={{220,-100},{240,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.Max forStaDowNom
    "To avoid division zero downstream"
    annotation (Placement(transformation(extent={{220,10},{240,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Max forStaNom
    "To avoid division zero downstream"
    annotation (Placement(transformation(extent={{220,120},{240,140}})));

  Modelica.Blocks.Logical.Switch swi1
    "Use minimum stage capacity for nominal stage down capacity if operating in the lowest available stage"
    annotation (Placement(transformation(extent={{160,-10},{180,10}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(nu=2)
    "Or operator on array inputs"
    annotation (Placement(transformation(extent={{180,200},{200,220}})));

  CDL.Interfaces.RealInput uNomCap[nSta](final quantity="Power", final unit="W")
    "Nominal stage capacities considering the chiller availability" annotation (
     Placement(transformation(extent={{-300,180},{-260,220}}),
        iconTransformation(extent={{-120,80},{-100,100}})));
  CDL.Interfaces.RealInput uMinCap[nSta](final quantity="Power", final unit="W")
    "Unload stage capacities considering the chiller availability" annotation (
      Placement(transformation(extent={{-300,-240},{-260,-200}}),
        iconTransformation(extent={{-120,60},{-100,80}})));
  CDL.Interfaces.IntegerInput uUp(final min=0, final max=nSta)
    "Next higher available stage" annotation (Placement(transformation(extent={{
            -300,40},{-260,80}}), iconTransformation(extent={{-120,0},{-100,20}})));
  CDL.Interfaces.IntegerInput                        uDown(final min=0, final
      max=nSta) "Next lower available stage"
    annotation (Placement(transformation(extent={{-300,-20},{-260,20}}),
      iconTransformation(extent={{-120,-20},{-100,0}})));
  CDL.Integers.Max maxInt
    annotation (Placement(transformation(extent={{-180,100},{-160,120}})));
  CDL.Integers.Max maxIntUp
    annotation (Placement(transformation(extent={{-180,60},{-160,80}})));
  CDL.Integers.Max maxIntDown
    annotation (Placement(transformation(extent={{-180,0},{-160,20}})));
  CDL.Interfaces.BooleanInput uLow "Current stage is the lowest stage"
    annotation (Placement(transformation(extent={{-300,-120},{-260,-80}}),
        iconTransformation(extent={{-120,-100},{-100,-80}})));
  CDL.Interfaces.BooleanInput uHigh "Current stage is the highest stage"
    annotation (Placement(transformation(extent={{-300,-180},{-260,-140}}),
        iconTransformation(extent={{-120,-80},{-100,-60}})));
equation
  connect(larNum.y, swi2.u1) annotation (Line(points={{161,170},{200,170},{200,78},
          {218,78}}, color={0,0,127}));
  connect(swi2.y, yStaUpNom) annotation (Line(points={{241,70},{250,70},{250,60},
          {270,60}}, color={0,0,127}));
  connect(extStaUpCap.y, swi2.u3) annotation (Line(points={{121,80},{172,80},{172,
          62},{218,62}},
                     color={0,0,127}));
  connect(yStaMin, yStaMin)
    annotation (Line(points={{270,-20},{270,-20}}, color={0,0,127}));
  connect(larNum.y, swi4.u1) annotation (Line(points={{161,170},{190,170},{190,-82},
          {218,-82}},  color={0,0,127}));
  connect(extStaUpCapMin.y, swi4.u3) annotation (Line(points={{121,-30},{140,-30},
          {140,-98},{218,-98}},    color={0,0,127}));
  connect(swi4.y, yStaUpMin) annotation (Line(points={{241,-90},{250,-90},{250,-60},
          {270,-60}},      color={0,0,127}));
  connect(mulOr.y, staExc.u) annotation (Line(points={{201.7,210},{218,210}},
                 color={255,0,255}));
  connect(extStaCapMin.y, yStaMin) annotation (Line(points={{121,-90},{180,-90},
          {180,-20},{270,-20}}, color={0,0,127}));
  connect(extStaCap.y, forStaNom.u1) annotation (Line(points={{-19,150},{0,150},
          {0,136},{218,136}}, color={0,0,127}));
  connect(forStaNom.y, yStaNom) annotation (Line(points={{241,130},{250,130},{250,
          100},{270,100}},   color={0,0,127}));
  connect(forStaNom.u2, smaNum.y) annotation (Line(points={{218,124},{180,124},{
          180,110},{161,110}},color={0,0,127}));
  connect(forStaDowNom.y, yStaDowNom)
    annotation (Line(points={{241,20},{270,20}},
                                               color={0,0,127}));
  connect(smaNum.y, forStaDowNom.u1) annotation (Line(points={{161,110},{180,110},
          {180,26},{218,26}},
                            color={0,0,127}));
  connect(swi1.y, forStaDowNom.u2) annotation (Line(points={{181,0},{200,0},{200,
          14},{218,14}}, color={0,0,127}));
  connect(extStaLowCap.y, swi1.u3) annotation (Line(points={{-19,80},{50,80},{50,
          -8},{158,-8}}, color={0,0,127}));
  connect(extStaCapMin.y, swi1.u1) annotation (Line(points={{121,-90},{130,-90},
          {130,8},{158,8}},   color={0,0,127}));
  connect(extStaCap.y, greThr[1].u) annotation (Line(points={{-19,150},{60,150},
          {60,210},{138,210}}, color={0,0,127}));
  connect(extStaLowCap.y, greThr[2].u) annotation (Line(points={{-19,80},{70,80},
          {70,210},{138,210}}, color={0,0,127}));
  connect(greThr.y, mulOr.u[1:2]) annotation (Line(points={{161,210},{170,210},{
          170,206.5},{178,206.5}}, color={255,0,255}));
  connect(uMinCap, extStaUpCapMin.u) annotation (Line(points={{-280,-220},{-110,
          -220},{-110,-140},{20,-140},{20,-30},{98,-30}},
                                                        color={0,0,127}));
  connect(uMinCap, extStaCapMin.u) annotation (Line(points={{-280,-220},{40,-220},
          {40,-90},{98,-90}},                                      color={0,0,
          127}));
  connect(uNomCap, extStaCap.u) annotation (Line(points={{-280,200},{-160,200},{
          -160,150},{-42,150}},  color={0,0,127}));
  connect(uNomCap, extStaLowCap.u) annotation (Line(points={{-280,200},{-220,200},
          {-220,128},{-60,128},{-60,80},{-42,80}},       color={0,0,127}));
  connect(uNomCap, extStaUpCap.u) annotation (Line(points={{-280,200},{80,200},{
          80,80},{98,80}},             color={0,0,127}));
  connect(one.y, maxIntDown.u1) annotation (Line(points={{-219,40},{-200,40},{-200,
          16},{-182,16}}, color={255,127,0}));
  connect(uDown, maxIntDown.u2) annotation (Line(points={{-280,0},{-200,0},{-200,
          4},{-182,4}}, color={255,127,0}));
  connect(maxInt.y, extStaCap.index) annotation (Line(points={{-159,110},{-30,110},
          {-30,138}}, color={255,127,0}));
  connect(maxIntUp.y, extStaUpCap.index) annotation (Line(points={{-159,70},{-140,
          70},{-140,60},{110,60},{110,68}}, color={255,127,0}));
  connect(maxIntDown.y, extStaLowCap.index)
    annotation (Line(points={{-159,10},{-30,10},{-30,68}}, color={255,127,0}));
  connect(maxIntUp.y, extStaUpCapMin.index) annotation (Line(points={{-159,70},{
          -140,70},{-140,60},{40,60},{40,-50},{110,-50},{110,-42}}, color={255,127,
          0}));
  connect(maxIntDown.y, extStaCapMin.index) annotation (Line(points={{-159,10},{
          -30,10},{-30,-110},{110,-110},{110,-102}}, color={255,127,0}));
  connect(uLow, swi1.u2) annotation (Line(points={{-280,-100},{0,-100},{0,0},{158,
          0}}, color={255,0,255}));
  connect(uHigh, swi2.u2) annotation (Line(points={{-280,-160},{210,-160},{210,70},
          {218,70}}, color={255,0,255}));
  connect(uHigh, swi4.u2) annotation (Line(points={{-280,-160},{210,-160},{210,-90},
          {218,-90}}, color={255,0,255}));
  connect(one.y, maxInt.u2) annotation (Line(points={{-219,40},{-200,40},{-200,104},
          {-182,104}}, color={255,127,0}));
  connect(u, maxInt.u1) annotation (Line(points={{-280,120},{-220,120},{-220,116},
          {-182,116}}, color={255,127,0}));
  connect(one.y, maxIntUp.u2) annotation (Line(points={{-219,40},{-200,40},{-200,
          64},{-182,64}}, color={255,127,0}));
  connect(uUp, maxIntUp.u1) annotation (Line(points={{-280,60},{-220,60},{-220,76},
          {-182,76}}, color={255,127,0}));
  annotation (defaultComponentName = "cap",
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
        Rectangle(extent={{-80,-30},{-20,-42}}, lineColor={0,0,127}),
        Rectangle(extent={{-80,-48},{-20,-60}}, lineColor={0,0,127}),
        Rectangle(extent={{-76,-42},{-72,-48}}, lineColor={0,0,127}),
        Rectangle(extent={{-28,-42},{-24,-48}}, lineColor={0,0,127}),
        Rectangle(extent={{0,-10},{80,-30}}, lineColor={0,0,127}),
        Rectangle(extent={{0,-40},{80,-60}}, lineColor={0,0,127}),
        Rectangle(extent={{6,-30},{12,-40}}, lineColor={0,0,127}),
        Rectangle(extent={{68,-30},{74,-40}}, lineColor={0,0,127}),
        Rectangle(extent={{-80,10},{-20,-2}}, lineColor={0,0,127}),
        Rectangle(extent={{-80,-8},{-20,-20}}, lineColor={0,0,127}),
        Rectangle(extent={{-76,-2},{-72,-8}}, lineColor={0,0,127}),
        Rectangle(extent={{-28,-2},{-24,-8}}, lineColor={0,0,127})}),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-260,-240},{260,240}})),
Documentation(info="<html>
<p>
Based on the current chiller stage and nominal stage capacities returns the
nominal capacity of the current and one lower stage for the purpose of
calculating the operative part load ratio (OPLR).
</p>
</html>",
revisions="<html>
<ul>
<li>
January 13, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Capacities;
