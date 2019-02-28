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

  CDL.Continuous.MatrixGain matGai(final K=lowDia)
    annotation (Placement(transformation(extent={{-140,170},{-120,190}})));

  CDL.Continuous.MatrixGain matGai1(final K=lowDia)
    annotation (Placement(transformation(extent={{-140,-180},{-120,-160}})));

  CDL.Interfaces.BooleanInput uStaAva[nSta] "Stage availability status"
    annotation (Placement(transformation(extent={{-300,-140},{-260,-100}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));

  CDL.Conversions.BooleanToReal booToRea[nSta]
    annotation (Placement(transformation(extent={{-220,-200},{-200,-180}})));

  CDL.Continuous.Product pro[nSta]
    "Multiplies each stage capacity with the availability status"
    annotation (Placement(transformation(extent={{-180,-180},{-160,-160}})));

  CDL.Conversions.BooleanToReal booToRea1[nSta]
    annotation (Placement(transformation(extent={{-220,140},{-200,160}})));

  CDL.Continuous.Product pro1[nSta]
    "Multiplies each stage capacity with the availability status"
    annotation (Placement(transformation(extent={{-180,170},{-160,190}})));

  CDL.Integers.Min forCurSta "Limiter for current stage capacity extraction"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));

  CDL.Integers.Max forStaDow "Limiter for stage down capacity extraction"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  CDL.Integers.Min forStaUp "Limiter for stage up capacity extraction"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));

  CDL.Conversions.IntegerToReal intToRea
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));

  CDL.Logical.MultiOr mulOr(nu=3) "Or operator on array inputs"
    annotation (Placement(transformation(extent={{180,180},{200,200}})));

//protected
  parameter Real small = 0.001
  "Small number to avoid division with zero";

  parameter Real large = staNomCap[end]*nSta*10
  "Value to avoid stage up when at the highest stage";

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staCap[nSta](
    final k=staNomCap) "Array of chiller stage nominal capacities"
    annotation (Placement(transformation(extent={{-220,180},{-200,200}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant one(
    final k=1) "Constant integer"
    annotation (Placement(transformation(extent={{-220,-30},{-200,-10}})));

  Buildings.Controls.OBC.CDL.Utilities.Assert staExc(
    final message="The provided chiller stage is not within the number of stages available")
    "Error assertion"
    annotation (Placement(transformation(extent={{220,180},{240,200}})));

  CDL.Continuous.GreaterThreshold                     greThr[3](
    final threshold = fill(-0.5, 3)) "Less than threshold"
    annotation (Placement(transformation(extent={{140,180},{160,200}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu "Equal stage 1"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaCap(
    final outOfRangeValue=-1,
    final nin=nSta)
    "Extracts the nominal capacity at the current stage"
    annotation (Placement(transformation(extent={{-40,140},{-20,160}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaLowCap(
    final outOfRangeValue=-1,
    final nin=nSta)
    "Extracts the nominal capacity of one stage lower than the current stage"
    annotation (Placement(transformation(extent={{0,100},{20,120}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi "Switch"
    annotation (Placement(transformation(extent={{140,10},{160,30}})));

  Buildings.Controls.OBC.CDL.Integers.Add addInt "Adds to index"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaUpCapMin(
    final outOfRangeValue=-1,
    final nin=nSta)
    "Extracts minimal capacity of the next higher stage"
    annotation (Placement(transformation(extent={{100,-120},{120,-100}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaUpCap(
    final outOfRangeValue=-1,
    final nin=nSta)
    "Extracts the nominal capacity of the next stage"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaCapMin(
    final outOfRangeValue=-1,
    final nin=nSta)
    "Extracts the minimum capacity of the current stage"
    annotation (Placement(transformation(extent={{100,-180},{120,-160}})));

  CDL.Continuous.Sources.Constant smaNum(
    final k=small) "Small number to prevent division with zero"
    annotation (Placement(transformation(extent={{140,-20},{160,0}})));
  CDL.Continuous.Sources.Constant larNum(
    final k=large) "Large number to prevent staging up at the highest stage"
    annotation (Placement(transformation(extent={{140,120},{160,140}})));

  CDL.Continuous.Sources.Constant minStaCap[nSta](
    final k=minStaUnlCap)
    "Array of chiller stage minimal unload capacities"
    annotation (Placement(transformation(extent={{-220,-160},{-200,-140}})));

  CDL.Integers.Add subInt(
    final k1=-1) "Subtracts from index"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));

  CDL.Integers.Sources.Constant zero(
    final k=0)
    "Constant integer"
    annotation (Placement(transformation(extent={{-220,-70},{-200,-50}})));

  CDL.Integers.Sources.Constant maxSta(
    final k=nSta) "Highest stage"
    annotation (Placement(transformation(extent={{-220,60},{-200,80}})));

  CDL.Integers.Equal intEqu1
    "Equal stage 1"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));

  CDL.Logical.Switch swi1
    "Switch"
    annotation (Placement(transformation(extent={{220,-30},{240,-10}})));

  CDL.Logical.Switch swi2
    "Switch"
    annotation (Placement(transformation(extent={{220,40},{240,60}})));

  CDL.Integers.Equal intEqu2
    "Equal stage 1"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

  CDL.Logical.Switch swi3
    "Switch"
    annotation (Placement(transformation(extent={{220,-70},{240,-50}})));

  CDL.Logical.Switch swi4
    "Switch"
    annotation (Placement(transformation(extent={{220,-120},{240,-100}})));

  CDL.Logical.Switch swi5
    "Switch"
    annotation (Placement(transformation(extent={{220,100},{240,120}})));

equation
  connect(one.y, intEqu.u2) annotation (Line(points={{-199,-20},{30,-20},{30,-18},
          {38,-18}},   color={255,127,0}));
  connect(intEqu.y, swi.u2)
    annotation (Line(points={{61,-10},{100,-10},{100,20},{138,20}},
                                                               color={255,0,255}));
  connect(extStaLowCap.y, swi.u3) annotation (Line(points={{21,110},{80,110},{80,
          12},{138,12}},  color={0,0,127}));
  connect(uSta, intEqu.u1) annotation (Line(points={{-280,0},{-130,0},{-130,-10},
          {38,-10}},color={255,127,0}));
  connect(uSta, addInt.u1) annotation (Line(points={{-280,0},{-130,0},{-130,16},
          {-102,16}}, color={255,127,0}));
  connect(one.y, addInt.u2) annotation (Line(points={{-199,-20},{-120,-20},{-120,
          4},{-102,4}},   color={255,127,0}));
  connect(extStaLowCap.y,greThr [2].u) annotation (Line(points={{21,110},{80,110},
          {80,190},{138,190}},
                             color={0,0,127}));
  connect(extStaUpCap.y,greThr [3].u) annotation (Line(points={{121,50},{130,50},
          {130,190},{138,190}},           color={0,0,127}));
  connect(extStaCap.y,greThr [1].u)
    annotation (Line(points={{-19,150},{120,150},{120,190},{138,190}},
                                                  color={0,0,127}));
  connect(matGai.y, extStaCap.u) annotation (Line(points={{-119,180},{-50,180},{
          -50,150},{-42,150}}, color={0,0,127}));
  connect(uStaAva, booToRea.u) annotation (Line(points={{-280,-120},{-240,-120},
          {-240,-190},{-222,-190}}, color={255,0,255}));
  connect(pro.y, matGai1.u)
    annotation (Line(points={{-159,-170},{-142,-170}}, color={0,0,127}));
  connect(minStaCap.y, pro.u1) annotation (Line(points={{-199,-150},{-190,-150},
          {-190,-164},{-182,-164}}, color={0,0,127}));
  connect(booToRea.y, pro.u2) annotation (Line(points={{-199,-190},{-190,-190},{
          -190,-176},{-182,-176}}, color={0,0,127}));
  connect(pro1.y, matGai.u)
    annotation (Line(points={{-159,180},{-142,180}}, color={0,0,127}));
  connect(staCap.y, pro1.u1) annotation (Line(points={{-199,190},{-190,190},{-190,
          186},{-182,186}}, color={0,0,127}));
  connect(booToRea1.y, pro1.u2) annotation (Line(points={{-199,150},{-190,150},{
          -190,174},{-182,174}}, color={0,0,127}));
  connect(uStaAva, booToRea1.u) annotation (Line(points={{-280,-120},{-240,-120},
          {-240,150},{-222,150}}, color={255,0,255}));
  connect(matGai1.y, extStaUpCapMin.u) annotation (Line(points={{-119,-170},{80,
          -170},{80,-110},{98,-110}}, color={0,0,127}));
  connect(matGai1.y, extStaCapMin.u) annotation (Line(points={{-119,-170},{98,-170}},
                                 color={0,0,127}));
  connect(uSta, subInt.u2) annotation (Line(points={{-280,0},{-160,0},{-160,34},
          {-102,34}}, color={255,127,0}));
  connect(one.y, subInt.u1) annotation (Line(points={{-199,-20},{-168,-20},{-168,
          46},{-102,46}}, color={255,127,0}));
  connect(matGai.y, extStaLowCap.u) annotation (Line(points={{-119,180},{-60,180},
          {-60,110},{-2,110}},   color={0,0,127}));
  connect(matGai.y, extStaUpCap.u) annotation (Line(points={{-119,180},{90,180},
          {90,50},{98,50}},               color={0,0,127}));
  connect(maxSta.y, forCurSta.u1) annotation (Line(points={{-199,70},{-190,70},{
          -190,136},{-102,136}},    color={255,127,0}));
  connect(uSta, forCurSta.u2) annotation (Line(points={{-280,0},{-180,0},{-180,124},
          {-102,124}}, color={255,127,0}));
  connect(addInt.y, forStaUp.u2) annotation (Line(points={{-79,10},{-70,10},{-70,
          84},{-42,84}},  color={255,127,0}));
  connect(subInt.y, forStaDow.u1) annotation (Line(points={{-79,40},{-60,40},{-60,
          36},{-42,36}}, color={255,127,0}));
  connect(forStaUp.y, extStaUpCapMin.index) annotation (Line(points={{-19,90},{20,
          90},{20,-130},{110,-130},{110,-122}}, color={255,127,0}));
  connect(forCurSta.y, extStaCapMin.index) annotation (Line(points={{-79,130},{70,
          130},{70,-190},{110,-190},{110,-182}},      color={255,127,0}));
  connect(forCurSta.y, extStaCap.index) annotation (Line(points={{-79,130},{-30,
          130},{-30,138}}, color={255,127,0}));
  connect(forStaDow.y, extStaLowCap.index) annotation (Line(points={{-19,30},{10,
          30},{10,98}},                color={255,127,0}));
  connect(forStaUp.y, extStaUpCap.index) annotation (Line(points={{-19,90},{30,90},
          {30,30},{110,30},{110,38}},                       color={255,127,0}));
  connect(minStaCap[1].y, swi.u1) annotation (Line(points={{-199,-150},{130,-150},
          {130,28},{138,28}},                        color={0,0,127}));
  connect(zero.y, intEqu1.u1) annotation (Line(points={{-199,-60},{-120.5,-60},{
          -120.5,-90},{38,-90}},   color={255,127,0}));
  connect(uSta, intEqu1.u2) annotation (Line(points={{-280,0},{-226,0},{-226,-98},
          {38,-98}},   color={255,127,0}));
  connect(yStaDowNom, swi1.y) annotation (Line(points={{270,0},{250,0},{250,-20},
          {241,-20}}, color={0,0,127}));
  connect(swi.y, swi1.u3) annotation (Line(points={{161,20},{200,20},{200,-28},{
          218,-28}}, color={0,0,127}));
  connect(intEqu1.y, swi1.u2) annotation (Line(points={{61,-90},{172,-90},{172,-20},
          {218,-20}},                        color={255,0,255}));
  connect(uSta, intEqu2.u2) annotation (Line(points={{-280,0},{-174,0},{-174,62},
          {38,62}},                      color={255,127,0}));
  connect(maxSta.y, intEqu2.u1) annotation (Line(points={{-199,70},{38,70}},
                        color={255,127,0}));
  connect(intEqu2.y, swi2.u2) annotation (Line(points={{61,70},{184,70},{184,50},
          {218,50}},                    color={255,0,255}));
  connect(larNum.y, swi2.u1) annotation (Line(points={{161,130},{200,130},{200,58},
          {218,58}}, color={0,0,127}));
  connect(swi2.y, yStaUpNom) annotation (Line(points={{241,50},{250,50},{250,40},
          {270,40}}, color={0,0,127}));
  connect(extStaUpCap.y, swi2.u3) annotation (Line(points={{121,50},{172,50},{172,
          42},{218,42}},
                     color={0,0,127}));
  connect(smaNum.y, swi1.u1)
    annotation (Line(points={{161,-10},{210,-10},{210,-12},{218,-12}},
                                                   color={0,0,127}));
  connect(intEqu1.y, swi3.u2) annotation (Line(points={{61,-90},{200,-90},{200,-60},
          {218,-60}},     color={255,0,255}));
  connect(extStaCapMin.y, swi3.u3) annotation (Line(points={{121,-170},{210,-170},
          {210,-68},{218,-68}},
                              color={0,0,127}));
  connect(zero.y, intToRea.u) annotation (Line(points={{-199,-60},{-50,-60},{-50,
          -50},{38,-50}}, color={255,127,0}));
  connect(intToRea.y, swi3.u1) annotation (Line(points={{61,-50},{140,-50},{140,
          -52},{218,-52}},
                     color={0,0,127}));
  connect(yStaMin, yStaMin)
    annotation (Line(points={{270,-40},{270,-40}}, color={0,0,127}));
  connect(swi3.y, yStaMin) annotation (Line(points={{241,-60},{250,-60},{250,-40},
          {270,-40}}, color={0,0,127}));
  connect(intEqu2.y, swi4.u2) annotation (Line(points={{61,70},{176,70},{176,-110},
          {218,-110}}, color={255,0,255}));
  connect(larNum.y, swi4.u1) annotation (Line(points={{161,130},{190,130},{190,-102},
          {218,-102}}, color={0,0,127}));
  connect(extStaUpCapMin.y, swi4.u3) annotation (Line(points={{121,-110},{140,-110},
          {140,-118},{218,-118}},  color={0,0,127}));
  connect(swi4.y, yStaUpMin) annotation (Line(points={{241,-110},{250,-110},{250,
          -80},{270,-80}}, color={0,0,127}));
  connect(extStaCap.y, swi5.u3) annotation (Line(points={{-19,150},{120,150},{120,
          102},{218,102}}, color={0,0,127}));
  connect(intEqu1.y, swi5.u2) annotation (Line(points={{61,-90},{180,-90},{180,110},
          {218,110}}, color={255,0,255}));
  connect(smaNum.y, swi5.u1) annotation (Line(points={{161,-10},{210,-10},{210,118},
          {218,118}}, color={0,0,127}));
  connect(swi5.y, yStaNom) annotation (Line(points={{241,110},{250,110},{250,80},
          {270,80}}, color={0,0,127}));
  connect(mulOr.y, staExc.u) annotation (Line(points={{201.7,190},{218,190}},
                 color={255,0,255}));
  connect(greThr.y, mulOr.u[1:3]) annotation (Line(points={{161,190},{170,190},
          {170,185.333},{178,185.333}},color={255,0,255}));
  connect(one.y, forStaDow.u2) annotation (Line(points={{-199,-20},{-60,-20},{
          -60,24},{-42,24}}, color={255,127,0}));
  connect(maxSta.y, forStaUp.u1) annotation (Line(points={{-199,70},{-80,70},{-80,
          96},{-42,96}}, color={255,127,0}));
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
          extent={{-260,-220},{260,220}})),
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
