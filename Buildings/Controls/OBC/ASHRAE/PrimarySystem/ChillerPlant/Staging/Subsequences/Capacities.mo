within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block Capacities "Returns nominal and minimal capacities for calculating all operating part load ratios"

  parameter Integer nSta = 3
    "Total number of stages";

  parameter Modelica.SIunits.Power staNomCap[nSta] = fill(5e5, nSta)
    "Array of nominal capacities at each individual stage";

  parameter Modelica.SIunits.Power minStaUnlCap[nSta] = fill(0.2*staNomCap[1], nSta)
    "Array of unload capacities at each individual stage";

  final parameter Real lowDia[nSta, nSta] = {if i<= j then 1 else 0 for i in 1:nSta, j in 1:nSta}
    "Lower diagonal unit matrix";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaAva[nSta]
    "Stage availability status"
    annotation (Placement(transformation(extent={{-300,-100},{-260,-60}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta(
    final min = 0,
    final max = nSta) "Chiller stage"
    annotation (Placement(transformation(extent={{-300,20},{-260,60}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaNom(
    final unit="W",
    final quantity="Power") "Nominal capacity of the current stage"
    annotation (Placement(transformation(extent={{260,110},{280,130}}),
      iconTransformation(extent={{100,60},{120,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaDowNom(
    final unit="W",
    final quantity="Power") "Nominal capacity of the first stage down"
    annotation (Placement(transformation(extent={{260,30},{280,50}}),
      iconTransformation(extent={{100,-20},{120,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaUpNom(
    final unit="W",
    final quantity="Power")
    "Nominal capacity of the next higher stage" annotation (Placement(
      transformation(extent={{260,70},{280,90}}), iconTransformation(extent={{100,20},
            {120,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaMin(
    final unit="W",
    final quantity="Power")
    "Minimum capacity of the current stage" annotation (Placement(
      transformation(extent={{260,-10},{280,10}}),  iconTransformation(extent={{100,-90},
        {120,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaUpMin(
    final unit="W",
    final quantity="Power") "Minimum capacity of the next higher stage"
      annotation (Placement(transformation(extent={{260,-50},{280,-30}}),
      iconTransformation(extent={{100,-70}, {120,-50}})));

//protected
  parameter Real small = 0.001
  "Small number to avoid division with zero";

  parameter Real large = staNomCap[end]*nSta*10
  "Value to avoid stage up when at the highest stage";

  final parameter Integer staRan[nSta] = {i for i in 1:nSta}
  "Range with all possible stage values";

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staCap[nSta](
    final k=staNomCap) "Array of chiller stage nominal capacities"
    annotation (Placement(transformation(extent={{-220,230},{-200,250}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant one(
    final k=1) "Constant integer"
    annotation (Placement(transformation(extent={{-220,-50},{-200,-30}})));

  Buildings.Controls.OBC.CDL.Utilities.Assert staExc(
    final message="The provided chiller stage is not within the number of stages available")
    "Error assertion"
    annotation (Placement(transformation(extent={{220,220},{240,240}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr[3](
    final threshold = fill(-0.5, 3)) "Less than threshold"
    annotation (Placement(transformation(extent={{140,220},{160,240}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaCap(
    final outOfRangeValue=-1,
    final nin=nSta)
    "Extracts the nominal capacity at the current stage"
    annotation (Placement(transformation(extent={{-40,160},{-20,180}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaLowCap(
    final outOfRangeValue=-1,
    final nin=nSta,
    allowOutOfRange=true)
    "Extracts the nominal capacity of one stage lower than the current stage"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));

  Buildings.Controls.OBC.CDL.Integers.Add addInt "Adds to index"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaUpCapMin(
    final nin=nSta,
    final allowOutOfRange=true,
    final outOfRangeValue=large)
    "Extracts minimal capacity of the next higher stage"
    annotation (Placement(transformation(extent={{100,-80},{120,-60}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaUpCap(
    final nin=nSta,
    final allowOutOfRange=true,
    final outOfRangeValue=large)
    "Extracts the nominal capacity of the next stage"
    annotation (Placement(transformation(extent={{100,90},{120,110}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaCapMin(
    final nin=nSta,
    final outOfRangeValue=0,
    final allowOutOfRange=true)
    "Extracts the minimum capacity of the current stage"
    annotation (Placement(transformation(extent={{100,-140},{120,-120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant smaNum(
    final k=small) "Small number to prevent division with zero"
    annotation (Placement(transformation(extent={{120,50},{140,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant larNum(
    final k=large) "Large number to prevent staging up at the highest stage"
    annotation (Placement(transformation(extent={{140,180},{160,200}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minStaCap[nSta](
    final k=minStaUnlCap)
    "Array of chiller stage minimal unload capacities"
    annotation (Placement(transformation(extent={{-220,-120},{-200,-100}})));

  Buildings.Controls.OBC.CDL.Integers.Add subInt(
    final k1=-1) "Subtracts from index"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant maxSta(
    final k=nSta) "Highest stage"
    annotation (Placement(transformation(extent={{-220,50},{-200,70}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi2
    "Switch"
    annotation (Placement(transformation(extent={{220,80},{240,100}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi4
    "Switch"
    annotation (Placement(transformation(extent={{220,-80},{240,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(
    final nin=nSta, final k=fill(1, nSta))
    "Sums all input vector elements"
    annotation (Placement(transformation(extent={{-140,240},{-120,260}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add2(
    final k2=-1) "Adder"
    annotation (Placement(transformation(extent={{40,240},{60,260}})));

  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr(
    final threshold=small) "Less threshold"
    annotation (Placement(transformation(extent={{80,240},{100,260}})));

  Buildings.Controls.OBC.CDL.Continuous.Max forStaDowNom
    "To avoid division zero downstream"
    annotation (Placement(transformation(extent={{220,30},{240,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Max forStaNom
    "To avoid division zero downstream"
    annotation (Placement(transformation(extent={{220,140},{240,160}})));

  Buildings.Controls.OBC.CDL.Continuous.Max forStaDowNom1
    "To avoid division zero downstream"
    annotation (Placement(transformation(extent={{160,10},{180,30}})));

  Buildings.Controls.OBC.CDL.Continuous.MatrixGain matGai(final K=lowDia)
    annotation (Placement(transformation(extent={{-140,200},{-120,220}})));

  Buildings.Controls.OBC.CDL.Continuous.MatrixGain matGai1(final K=lowDia)
    annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nSta]
    annotation (Placement(transformation(extent={{-220,-160},{-200,-140}})));

  Buildings.Controls.OBC.CDL.Continuous.Product pro[nSta]
    "Multiplies each stage capacity with the availability status"
    annotation (Placement(transformation(extent={{-180,-140},{-160,-120}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[nSta]
    "Type converter"
    annotation (Placement(transformation(extent={{-220,170},{-200,190}})));

  Buildings.Controls.OBC.CDL.Continuous.Product pro1[nSta]
    "Multiplies each stage capacity with the availability status"
    annotation (Placement(transformation(extent={{-180,200},{-160,220}})));

  Buildings.Controls.OBC.CDL.Integers.Min forCurSta
    "Limiter for current stage capacity extraction"
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(nu=3)
    "Or operator on array inputs"
    annotation (Placement(transformation(extent={{180,220},{200,240}})));

  CDL.Integers.Sources.Constant stages[nSta](final k=staRan)
    "Range with all possible stages"
    annotation (Placement(transformation(extent={{-220,-270},{-200,-250}})));
  CDL.Conversions.BooleanToInteger booToInt[nSta]
    annotation (Placement(transformation(extent={{-100,-220},{-80,-200}})));
  CDL.Integers.MultiSum mulSumInt(nin=1)
    annotation (Placement(transformation(extent={{-60,-220},{-40,-200}})));
  CDL.Integers.Equal intEqu
    annotation (Placement(transformation(extent={{0,-220},{20,-200}})));
  CDL.Integers.LessEqual intLesEqu[nSta]
    annotation (Placement(transformation(extent={{-180,-242},{-160,-222}})));
  CDL.Routing.IntegerReplicator intRep(nout=nSta)
    annotation (Placement(transformation(extent={{-220,-220},{-200,-200}})));
  CDL.Logical.And and2[nSta]
    annotation (Placement(transformation(extent={{-140,-220},{-120,-200}})));
  CDL.Interfaces.BooleanOutput lowSta "Operating at the lowest available stage"
    annotation (Placement(transformation(extent={{260,-190},{280,-170}}),
        iconTransformation(extent={{-304,-74},{-284,-54}})));
equation
  connect(uSta, addInt.u1) annotation (Line(points={{-280,40},{-130,40},{-130,-4},
          {-102,-4}}, color={255,127,0}));
  connect(one.y, addInt.u2) annotation (Line(points={{-199,-40},{-120,-40},{-120,
          -16},{-102,-16}},
                          color={255,127,0}));
  connect(extStaLowCap.y,greThr [2].u) annotation (Line(points={{21,100},{80,100},
          {80,230},{138,230}},
                             color={0,0,127}));
  connect(extStaUpCap.y,greThr [3].u) annotation (Line(points={{121,100},{130,100},
          {130,230},{138,230}},           color={0,0,127}));
  connect(extStaCap.y,greThr [1].u)
    annotation (Line(points={{-19,170},{120,170},{120,230},{138,230}},
                                                  color={0,0,127}));
  connect(matGai.y, extStaCap.u) annotation (Line(points={{-119,210},{-50,210},{
          -50,170},{-42,170}}, color={0,0,127}));
  connect(uStaAva, booToRea.u) annotation (Line(points={{-280,-80},{-240,-80},{-240,
          -150},{-222,-150}},       color={255,0,255}));
  connect(pro.y, matGai1.u)
    annotation (Line(points={{-159,-130},{-142,-130}}, color={0,0,127}));
  connect(minStaCap.y, pro.u1) annotation (Line(points={{-199,-110},{-190,-110},
          {-190,-124},{-182,-124}}, color={0,0,127}));
  connect(booToRea.y, pro.u2) annotation (Line(points={{-199,-150},{-190,-150},{
          -190,-136},{-182,-136}}, color={0,0,127}));
  connect(pro1.y, matGai.u)
    annotation (Line(points={{-159,210},{-142,210}}, color={0,0,127}));
  connect(staCap.y, pro1.u1) annotation (Line(points={{-199,240},{-190,240},{-190,
          216},{-182,216}}, color={0,0,127}));
  connect(booToRea1.y, pro1.u2) annotation (Line(points={{-199,180},{-190,180},{
          -190,204},{-182,204}}, color={0,0,127}));
  connect(uStaAva, booToRea1.u) annotation (Line(points={{-280,-80},{-240,-80},{
          -240,180},{-222,180}},  color={255,0,255}));
  connect(matGai1.y, extStaUpCapMin.u) annotation (Line(points={{-119,-130},{80,
          -130},{80,-70},{98,-70}},   color={0,0,127}));
  connect(matGai1.y, extStaCapMin.u) annotation (Line(points={{-119,-130},{98,-130}},
                                 color={0,0,127}));
  connect(uSta, subInt.u2) annotation (Line(points={{-280,40},{-130,40},{-130,14},
          {-102,14}}, color={255,127,0}));
  connect(one.y, subInt.u1) annotation (Line(points={{-199,-40},{-140,-40},{-140,
          26},{-102,26}}, color={255,127,0}));
  connect(matGai.y, extStaLowCap.u) annotation (Line(points={{-119,210},{-60,210},
          {-60,100},{-2,100}},   color={0,0,127}));
  connect(matGai.y, extStaUpCap.u) annotation (Line(points={{-119,210},{90,210},
          {90,100},{98,100}},             color={0,0,127}));
  connect(maxSta.y, forCurSta.u1) annotation (Line(points={{-199,60},{-190,60},{
          -190,126},{-102,126}},    color={255,127,0}));
  connect(uSta, forCurSta.u2) annotation (Line(points={{-280,40},{-180,40},{-180,
          114},{-102,114}},
                       color={255,127,0}));
  connect(forCurSta.y, extStaCapMin.index) annotation (Line(points={{-79,120},{60,
          120},{60,-160},{110,-160},{110,-142}},      color={255,127,0}));
  connect(forCurSta.y, extStaCap.index) annotation (Line(points={{-79,120},{-30,
          120},{-30,158}}, color={255,127,0}));
  connect(larNum.y, swi2.u1) annotation (Line(points={{161,190},{200,190},{200,98},
          {218,98}}, color={0,0,127}));
  connect(swi2.y, yStaUpNom) annotation (Line(points={{241,90},{250,90},{250,80},
          {270,80}}, color={0,0,127}));
  connect(extStaUpCap.y, swi2.u3) annotation (Line(points={{121,100},{172,100},{
          172,82},{218,82}},
                     color={0,0,127}));
  connect(yStaMin, yStaMin)
    annotation (Line(points={{270,0},{270,0}},     color={0,0,127}));
  connect(larNum.y, swi4.u1) annotation (Line(points={{161,190},{190,190},{190,-62},
          {218,-62}},  color={0,0,127}));
  connect(extStaUpCapMin.y, swi4.u3) annotation (Line(points={{121,-70},{140,-70},
          {140,-78},{218,-78}},    color={0,0,127}));
  connect(swi4.y, yStaUpMin) annotation (Line(points={{241,-70},{250,-70},{250,-40},
          {270,-40}},      color={0,0,127}));
  connect(mulOr.y, staExc.u) annotation (Line(points={{201.7,230},{218,230}},
                 color={255,0,255}));
  connect(greThr.y, mulOr.u[1:3]) annotation (Line(points={{161,230},{170,230},
          {170,225.333},{178,225.333}},color={255,0,255}));
  connect(extStaCapMin.y, yStaMin) annotation (Line(points={{121,-130},{180,-130},
          {180,0},{270,0}},     color={0,0,127}));
  connect(mulSum.y, add2.u1) annotation (Line(points={{-119,250},{-100,250},{-100,
          256},{38,256}}, color={0,0,127}));
  connect(add2.y, lesThr.u)
    annotation (Line(points={{61,250},{78,250}}, color={0,0,127}));
  connect(lesThr.y, swi2.u2) annotation (Line(points={{101,250},{110,250},{110,140},
          {208,140},{208,90},{218,90}},                  color={255,0,255}));
  connect(lesThr.y, swi4.u2) annotation (Line(points={{101,250},{110,250},{110,140},
          {208,140},{208,-70},{218,-70}},  color={255,0,255}));
  connect(extStaCap.y, add2.u2) annotation (Line(points={{-19,170},{0,170},{0,244},
          {38,244}},      color={0,0,127}));
  connect(pro1.y, mulSum.u) annotation (Line(points={{-159,210},{-156,210},{-156,
          250},{-142,250}},               color={0,0,127}));
  connect(extStaCap.y, forStaNom.u1) annotation (Line(points={{-19,170},{0,170},
          {0,156},{218,156}}, color={0,0,127}));
  connect(forStaNom.y, yStaNom) annotation (Line(points={{241,150},{250,150},{250,
          120},{270,120}},   color={0,0,127}));
  connect(forStaNom.u2, smaNum.y) annotation (Line(points={{218,144},{160,144},{
          160,60},{141,60}},  color={0,0,127}));
  connect(forStaDowNom.y, yStaDowNom)
    annotation (Line(points={{241,40},{270,40}},
                                               color={0,0,127}));
  connect(smaNum.y, forStaDowNom.u1) annotation (Line(points={{141,60},{200,60},
          {200,46},{218,46}},
                            color={0,0,127}));
  connect(extStaLowCap.y, forStaDowNom1.u1) annotation (Line(points={{21,100},{69.5,
          100},{69.5,26},{158,26}},       color={0,0,127}));
  connect(extStaCapMin.y, forStaDowNom1.u2) annotation (Line(points={{121,-130},
          {130,-130},{130,14},{158,14}},   color={0,0,127}));
  connect(forStaDowNom1.y, forStaDowNom.u2) annotation (Line(points={{181,20},{200,
          20},{200,34},{218,34}},       color={0,0,127}));
  connect(addInt.y, extStaUpCap.index) annotation (Line(points={{-79,-10},{110,-10},
          {110,88}},      color={255,127,0}));
  connect(subInt.y, extStaLowCap.index)
    annotation (Line(points={{-79,20},{10,20},{10,88}},   color={255,127,0}));
  connect(addInt.y, extStaUpCapMin.index) annotation (Line(points={{-79,-10},{40,
          -10},{40,-100},{110,-100},{110,-82}},     color={255,127,0}));
  connect(one.y, intEqu.u2) annotation (Line(points={{-199,-40},{-20,-40},{-20,
          -218},{-2,-218}}, color={255,127,0}));
  connect(mulSumInt.y, intEqu.u1) annotation (Line(points={{-38.3,-210},{-2,
          -210},{-2,-210}}, color={255,127,0}));
  connect(booToInt.y, mulSumInt.u[1])
    annotation (Line(points={{-79,-210},{-62,-210}}, color={255,127,0}));
  connect(stages.y, intLesEqu.u2) annotation (Line(points={{-199,-260},{-190,
          -260},{-190,-240},{-182,-240}}, color={255,127,0}));
  connect(uSta, intRep.u) annotation (Line(points={{-280,40},{-250,40},{-250,
          -210},{-222,-210}}, color={255,127,0}));
  connect(intRep.y, intLesEqu.u1) annotation (Line(points={{-199,-210},{-190,
          -210},{-190,-232},{-182,-232}}, color={255,127,0}));
  connect(and2.y, booToInt.u)
    annotation (Line(points={{-119,-210},{-102,-210}}, color={255,0,255}));
  connect(uStaAva, and2.u1) annotation (Line(points={{-280,-80},{-240,-80},{
          -240,-190},{-150,-190},{-150,-210},{-142,-210}}, color={255,0,255}));
  connect(intLesEqu.y, and2.u2) annotation (Line(points={{-159,-232},{-150,-232},
          {-150,-218},{-142,-218}}, color={255,0,255}));
  connect(intEqu.y, lowSta) annotation (Line(points={{21,-210},{240,-210},{240,
          -180},{270,-180}}, color={255,0,255}));
  annotation (defaultComponentName = "staCap",
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
          extent={{-260,-280},{260,280}})),
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
