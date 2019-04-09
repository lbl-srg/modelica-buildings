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

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta(
    final min = 0,
    final max = nSta) "Chiller stage"
    annotation (Placement(transformation(extent={{-300,-20},{-260,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaNom(
    final unit="W",
    final quantity="Power") "Nominal capacity of the current stage"
    annotation (Placement(transformation(extent={{260,70},{280,90}}),
      iconTransformation(extent={{100,60},{120,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaDowNom(
    final unit="W",
    final quantity="Power") "Nominal capacity of the first stage down"
    annotation (Placement(transformation(extent={{260,-10},{280,10}}),
      iconTransformation(extent={{100,-20},{120,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaUpNom(
    final unit="W",
    final quantity="Power")
    "Nominal capacity of the next higher stage" annotation (Placement(
      transformation(extent={{260,30},{280,50}}), iconTransformation(extent={{100,20},
            {120,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaMin(
    final unit="W",
    final quantity="Power")
    "Minimum capacity of the current stage" annotation (Placement(
      transformation(extent={{260,-50},{280,-30}}), iconTransformation(extent={{100,-90},
        {120,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaUpMin(
    final unit="W",
    final quantity="Power") "Minimum capacity of the next higher stage"
      annotation (Placement(transformation(extent={{260,-90},{280,-70}}),
      iconTransformation(extent={{100,-70}, {120,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.MatrixGain matGai(final K=lowDia)
    annotation (Placement(transformation(extent={{-140,160},{-120,180}})));

  Buildings.Controls.OBC.CDL.Continuous.MatrixGain matGai1(final K=lowDia)
    annotation (Placement(transformation(extent={{-140,-180},{-120,-160}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaAva[nSta] "Stage availability status"
    annotation (Placement(transformation(extent={{-300,-140},{-260,-100}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nSta]
    annotation (Placement(transformation(extent={{-220,-200},{-200,-180}})));

  Buildings.Controls.OBC.CDL.Continuous.Product pro[nSta]
    "Multiplies each stage capacity with the availability status"
    annotation (Placement(transformation(extent={{-180,-180},{-160,-160}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[nSta] "Type converter"
    annotation (Placement(transformation(extent={{-220,130},{-200,150}})));

  Buildings.Controls.OBC.CDL.Continuous.Product pro1[nSta]
    "Multiplies each stage capacity with the availability status"
    annotation (Placement(transformation(extent={{-180,160},{-160,180}})));

  Buildings.Controls.OBC.CDL.Integers.Min forCurSta
    "Limiter for current stage capacity extraction"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(nu=3)
    "Or operator on array inputs"
    annotation (Placement(transformation(extent={{180,180},{200,200}})));

//protected
  parameter Real small = 0.001
  "Small number to avoid division with zero";

  parameter Real large = staNomCap[end]*nSta*10
  "Value to avoid stage up when at the highest stage";

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staCap[nSta](
    final k=staNomCap) "Array of chiller stage nominal capacities"
    annotation (Placement(transformation(extent={{-220,190},{-200,210}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant one(
    final k=1) "Constant integer"
    annotation (Placement(transformation(extent={{-220,-90},{-200,-70}})));

  Buildings.Controls.OBC.CDL.Utilities.Assert staExc(
    final message="The provided chiller stage is not within the number of stages available")
    "Error assertion"
    annotation (Placement(transformation(extent={{220,180},{240,200}})));

  CDL.Continuous.GreaterThreshold greThr[3](
    final threshold = fill(-0.5, 3)) "Less than threshold"
    annotation (Placement(transformation(extent={{140,180},{160,200}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaCap(
    final outOfRangeValue=-1,
    final nin=nSta)
    "Extracts the nominal capacity at the current stage"
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaLowCap(
    final outOfRangeValue=-1,
    final nin=nSta,
    allowOutOfRange=true)
    "Extracts the nominal capacity of one stage lower than the current stage"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));

  Buildings.Controls.OBC.CDL.Integers.Add addInt "Adds to index"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaUpCapMin(
    final nin=nSta,
    allowOutOfRange=true,
    final outOfRangeValue=large)
    "Extracts minimal capacity of the next higher stage"
    annotation (Placement(transformation(extent={{100,-120},{120,-100}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaUpCap(
    final nin=nSta,
    allowOutOfRange=true,
    final outOfRangeValue=large)
    "Extracts the nominal capacity of the next stage"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaCapMin(
    final nin=nSta,
    final outOfRangeValue=0,
    allowOutOfRange=true)
    "Extracts the minimum capacity of the current stage"
    annotation (Placement(transformation(extent={{100,-180},{120,-160}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant smaNum(
    final k=small) "Small number to prevent division with zero"
    annotation (Placement(transformation(extent={{120,10},{140,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant larNum(
    final k=large) "Large number to prevent staging up at the highest stage"
    annotation (Placement(transformation(extent={{140,140},{160,160}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minStaCap[nSta](
    final k=minStaUnlCap)
    "Array of chiller stage minimal unload capacities"
    annotation (Placement(transformation(extent={{-220,-160},{-200,-140}})));

  Buildings.Controls.OBC.CDL.Integers.Add subInt(
    final k1=-1) "Subtracts from index"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant maxSta(
    final k=nSta) "Highest stage"
    annotation (Placement(transformation(extent={{-220,10},{-200,30}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi2
    "Switch"
    annotation (Placement(transformation(extent={{220,40},{240,60}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi4
    "Switch"
    annotation (Placement(transformation(extent={{220,-120},{240,-100}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(
    final nin=nSta, final k=fill(1, nSta))
    "Sums all input vector elements"
    annotation (Placement(transformation(extent={{-140,200},{-120,220}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add2(
    final k2=-1) "Adder"
    annotation (Placement(transformation(extent={{40,200},{60,220}})));

  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr(
    final threshold=small) "Less threshold"
    annotation (Placement(transformation(extent={{80,200},{100,220}})));

  CDL.Continuous.Max forStaDowNom "To avoid division zero downstream"
    annotation (Placement(transformation(extent={{220,-10},{240,10}})));
  CDL.Continuous.Max forStaNom "To avoid division zero downstream"
    annotation (Placement(transformation(extent={{220,100},{240,120}})));
  CDL.Continuous.Max forStaDowNom1 "To avoid division zero downstream"
    annotation (Placement(transformation(extent={{160,-30},{180,-10}})));
equation
  connect(uSta, addInt.u1) annotation (Line(points={{-280,0},{-130,0},{-130,-44},
          {-102,-44}},color={255,127,0}));
  connect(one.y, addInt.u2) annotation (Line(points={{-199,-80},{-120,-80},{
          -120,-56},{-102,-56}},
                          color={255,127,0}));
  connect(extStaLowCap.y,greThr [2].u) annotation (Line(points={{21,60},{80,60},
          {80,190},{138,190}},
                             color={0,0,127}));
  connect(extStaUpCap.y,greThr [3].u) annotation (Line(points={{121,60},{130,60},
          {130,190},{138,190}},           color={0,0,127}));
  connect(extStaCap.y,greThr [1].u)
    annotation (Line(points={{-19,130},{120,130},{120,190},{138,190}},
                                                  color={0,0,127}));
  connect(matGai.y, extStaCap.u) annotation (Line(points={{-119,170},{-50,170},
          {-50,130},{-42,130}},color={0,0,127}));
  connect(uStaAva, booToRea.u) annotation (Line(points={{-280,-120},{-240,-120},
          {-240,-190},{-222,-190}}, color={255,0,255}));
  connect(pro.y, matGai1.u)
    annotation (Line(points={{-159,-170},{-142,-170}}, color={0,0,127}));
  connect(minStaCap.y, pro.u1) annotation (Line(points={{-199,-150},{-190,-150},
          {-190,-164},{-182,-164}}, color={0,0,127}));
  connect(booToRea.y, pro.u2) annotation (Line(points={{-199,-190},{-190,-190},{
          -190,-176},{-182,-176}}, color={0,0,127}));
  connect(pro1.y, matGai.u)
    annotation (Line(points={{-159,170},{-142,170}}, color={0,0,127}));
  connect(staCap.y, pro1.u1) annotation (Line(points={{-199,200},{-190,200},{
          -190,176},{-182,176}},
                            color={0,0,127}));
  connect(booToRea1.y, pro1.u2) annotation (Line(points={{-199,140},{-190,140},
          {-190,164},{-182,164}},color={0,0,127}));
  connect(uStaAva, booToRea1.u) annotation (Line(points={{-280,-120},{-240,-120},
          {-240,140},{-222,140}}, color={255,0,255}));
  connect(matGai1.y, extStaUpCapMin.u) annotation (Line(points={{-119,-170},{80,
          -170},{80,-110},{98,-110}}, color={0,0,127}));
  connect(matGai1.y, extStaCapMin.u) annotation (Line(points={{-119,-170},{98,-170}},
                                 color={0,0,127}));
  connect(uSta, subInt.u2) annotation (Line(points={{-280,0},{-130,0},{-130,-26},
          {-102,-26}},color={255,127,0}));
  connect(one.y, subInt.u1) annotation (Line(points={{-199,-80},{-140,-80},{
          -140,-14},{-102,-14}},
                          color={255,127,0}));
  connect(matGai.y, extStaLowCap.u) annotation (Line(points={{-119,170},{-60,
          170},{-60,60},{-2,60}},color={0,0,127}));
  connect(matGai.y, extStaUpCap.u) annotation (Line(points={{-119,170},{90,170},
          {90,60},{98,60}},               color={0,0,127}));
  connect(maxSta.y, forCurSta.u1) annotation (Line(points={{-199,20},{-190,20},
          {-190,86},{-102,86}},     color={255,127,0}));
  connect(uSta, forCurSta.u2) annotation (Line(points={{-280,0},{-180,0},{-180,
          74},{-102,74}},
                       color={255,127,0}));
  connect(forCurSta.y, extStaCapMin.index) annotation (Line(points={{-79,80},{
          60,80},{60,-200},{110,-200},{110,-182}},    color={255,127,0}));
  connect(forCurSta.y, extStaCap.index) annotation (Line(points={{-79,80},{-30,
          80},{-30,118}},  color={255,127,0}));
  connect(larNum.y, swi2.u1) annotation (Line(points={{161,150},{200,150},{200,
          58},{218,58}},
                     color={0,0,127}));
  connect(swi2.y, yStaUpNom) annotation (Line(points={{241,50},{250,50},{250,40},
          {270,40}}, color={0,0,127}));
  connect(extStaUpCap.y, swi2.u3) annotation (Line(points={{121,60},{172,60},{
          172,42},{218,42}},
                     color={0,0,127}));
  connect(yStaMin, yStaMin)
    annotation (Line(points={{270,-40},{270,-40}}, color={0,0,127}));
  connect(larNum.y, swi4.u1) annotation (Line(points={{161,150},{190,150},{190,
          -102},{218,-102}},
                       color={0,0,127}));
  connect(extStaUpCapMin.y, swi4.u3) annotation (Line(points={{121,-110},{140,-110},
          {140,-118},{218,-118}},  color={0,0,127}));
  connect(swi4.y, yStaUpMin) annotation (Line(points={{241,-110},{250,-110},{250,
          -80},{270,-80}}, color={0,0,127}));
  connect(mulOr.y, staExc.u) annotation (Line(points={{201.7,190},{218,190}},
                 color={255,0,255}));
  connect(greThr.y, mulOr.u[1:3]) annotation (Line(points={{161,190},{170,190},
          {170,185.333},{178,185.333}},color={255,0,255}));
  connect(extStaCapMin.y, yStaMin) annotation (Line(points={{121,-170},{180,
          -170},{180,-40},{270,-40}},
                                color={0,0,127}));
  connect(mulSum.y, add2.u1) annotation (Line(points={{-119,210},{-100,210},{
          -100,216},{38,216}},
                          color={0,0,127}));
  connect(add2.y, lesThr.u)
    annotation (Line(points={{61,210},{78,210}}, color={0,0,127}));
  connect(lesThr.y, swi2.u2) annotation (Line(points={{101,210},{110,210},{110,
          100},{208,100},{208,50},{218,50}},             color={255,0,255}));
  connect(lesThr.y, swi4.u2) annotation (Line(points={{101,210},{110,210},{110,
          100},{208,100},{208,-110},{218,-110}},
                                           color={255,0,255}));
  connect(extStaCap.y, add2.u2) annotation (Line(points={{-19,130},{0,130},{0,
          204},{38,204}}, color={0,0,127}));
  connect(pro1.y, mulSum.u) annotation (Line(points={{-159,170},{-156,170},{
          -156,210},{-142,210}},          color={0,0,127}));
  connect(extStaCap.y, forStaNom.u1) annotation (Line(points={{-19,130},{0,130},
          {0,116},{218,116}}, color={0,0,127}));
  connect(forStaNom.y, yStaNom) annotation (Line(points={{241,110},{250,110},{
          250,80},{270,80}}, color={0,0,127}));
  connect(forStaNom.u2, smaNum.y) annotation (Line(points={{218,104},{160,104},
          {160,20},{141,20}}, color={0,0,127}));
  connect(forStaDowNom.y, yStaDowNom)
    annotation (Line(points={{241,0},{270,0}}, color={0,0,127}));
  connect(smaNum.y, forStaDowNom.u1) annotation (Line(points={{141,20},{200,20},
          {200,6},{218,6}}, color={0,0,127}));
  connect(extStaLowCap.y, forStaDowNom1.u1) annotation (Line(points={{21,60},{
          69.5,60},{69.5,-14},{158,-14}}, color={0,0,127}));
  connect(extStaCapMin.y, forStaDowNom1.u2) annotation (Line(points={{121,-170},
          {130,-170},{130,-26},{158,-26}}, color={0,0,127}));
  connect(forStaDowNom1.y, forStaDowNom.u2) annotation (Line(points={{181,-20},
          {200,-20},{200,-6},{218,-6}}, color={0,0,127}));
  connect(addInt.y, extStaUpCap.index) annotation (Line(points={{-79,-50},{110,
          -50},{110,48}}, color={255,127,0}));
  connect(subInt.y, extStaLowCap.index)
    annotation (Line(points={{-79,-20},{10,-20},{10,48}}, color={255,127,0}));
  connect(addInt.y, extStaUpCapMin.index) annotation (Line(points={{-79,-50},{
          40,-50},{40,-140},{110,-140},{110,-122}}, color={255,127,0}));
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
