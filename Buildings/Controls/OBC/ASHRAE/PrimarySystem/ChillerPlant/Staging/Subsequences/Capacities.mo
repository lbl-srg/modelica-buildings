within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block Capacities "Returns nominal and minimal capacities for calculating all operating part load ratios"

  parameter Integer nSta = 2
  "Total number of stages";

  parameter Modelica.SIunits.Power staNomCap[nSta] = {5e5, 5e5}
  "Stage nominal capacity (cumulative)";

  parameter Modelica.SIunits.Power minStaUnlCap[nSta] = {0.2*staNomCap[1], 0.2*staNomCap[2]}
    "Stage minimal unload capacity (cumulative)";

  final parameter Real lowDia[nSta, nSta] = {if i<= j then 1 else 0 for i in 1:nSta, j in 1:nSta};

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta(
    final min = 0,
    final max = nSta) "Chiller stage"
    annotation (Placement(transformation(extent={{-300,-20},{-260,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaNom(
    final unit="W",
    final quantity="Power") "Nominal capacity of the current stage"
    annotation (Placement(transformation(extent={{220,70},{240,90}}),
      iconTransformation(extent={{100,60},{120,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaDowNom(
    final unit="W",
    final quantity="Power") "Nominal capacity of the first stage down"
    annotation (Placement(transformation(extent={{220,-10},{240,10}}),
        iconTransformation(extent={{100,-20},{120,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaUpNom(
    final unit="W",
    final quantity="Power")
    "Nominal capacity of the next higher stage" annotation (Placement(
        transformation(extent={{220,30},{240,50}}),   iconTransformation(extent={{100,20},
            {120,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaMin(
    final unit="W",
    final quantity="Power")
    "Minimum capacity of the current stage" annotation (Placement(
        transformation(extent={{220,-50},{240,-30}}), iconTransformation(extent={{100,-90},
            {120,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaUpMin(
    final unit="W",
    final quantity="Power") "Minimum capacity of the next higher stage"
      annotation (Placement(transformation(extent={{220,-90},{240,-70}}),
      iconTransformation(extent={{100,-70}, {120,-50}})));

  CDL.Continuous.MatrixGain matGai(K=lowDia)
    annotation (Placement(transformation(extent={{-140,170},{-120,190}})));
  CDL.Continuous.MatrixGain matGai1(K=lowDia)
    annotation (Placement(transformation(extent={{-140,-170},{-120,-150}})));
  CDL.Interfaces.BooleanInput u[nSta] "Stage availability status" annotation (
      Placement(transformation(extent={{-300,-140},{-260,-100}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  CDL.Conversions.BooleanToReal booToRea[nSta]
    annotation (Placement(transformation(extent={{-220,-190},{-200,-170}})));
  CDL.Continuous.Product pro[nSta]
    "Multiplies each stage capacity with the availability status"
    annotation (Placement(transformation(extent={{-180,-170},{-160,-150}})));
  CDL.Conversions.BooleanToReal booToRea1[nSta]
    annotation (Placement(transformation(extent={{-230,130},{-210,150}})));
  CDL.Continuous.Product pro1[nSta]
    "Multiplies each stage capacity with the availability status"
    annotation (Placement(transformation(extent={{-180,170},{-160,190}})));
  CDL.Integers.Min forCurSta "Limiter for current stage capacity extraction"
    annotation (Placement(transformation(extent={{-140,120},{-120,140}})));
  CDL.Integers.Max forStaDow "Limiter for stage down capacity extraction"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  CDL.Integers.Min forStaUp "Limiter for stage up capacity extraction"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  CDL.Conversions.IntegerToReal intToRea
    annotation (Placement(transformation(extent={{40,-66},{60,-46}})));
protected
  parameter Real small = 0.001
  "Small number to avoid division with zero";

  parameter Real large = staNomCap[end]*nSta*10
  "Value to avoid stage up when at the highest stage";

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staCap[nSta](final k=
        staNomCap) "Array of chiller stage nominal capacities"
    annotation (Placement(transformation(extent={{-240,180},{-220,200}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant one(
    final k=1) "Constant integer"
    annotation (Placement(transformation(extent={{-220,-30},{-200,-10}})));

  Buildings.Controls.OBC.CDL.Utilities.Assert staExc(
    final message="The provided chiller stage is not within the number of stages available")
    annotation (Placement(transformation(extent={{180,160},{200,180}})));

  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr[3](
    final threshold={-0.5,-0.5,-0.5})
    "Less than threshold"
    annotation (Placement(transformation(extent={{100,160},{120,180}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu "Equal stage 1"
    annotation (Placement(transformation(extent={{-20,18},{0,38}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaCap(
    final outOfRangeValue=-1, final nin=nSta)
    "Extracts the nominal capacity at the current stage"
    annotation (Placement(transformation(extent={{-40,140},{-20,160}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaLowCap(
    final outOfRangeValue=-1, final nin=nSta)
    "Extracts the nominal capacity of one stage lower than the current stage"
    annotation (Placement(transformation(extent={{-2,100},{18,120}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi "Switch"
    annotation (Placement(transformation(extent={{120,10},{140,30}})));

  Buildings.Controls.OBC.CDL.Integers.Add addInt
    "Aligns indexes (stage starts with 0, indexes with 1)"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaUpCapMin(final
      outOfRangeValue=-1, final nin=nSta)
    "Extracts minimal capacity of the next higher stage"
    annotation (Placement(transformation(extent={{-50,-84},{-30,-64}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaUpCap(
    final outOfRangeValue=-1, final nin=nSta)
                        "Extracts the nominal capacity of the next stage"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaCapMin(
    final outOfRangeValue=-1, final nin=nSta)
                         "Extracts the minimum capacity of the current stage"
    annotation (Placement(transformation(extent={{22,-120},{42,-100}})));

  Buildings.Controls.OBC.CDL.Logical.Or3 or1
    annotation (Placement(transformation(extent={{140,160},{160,180}})));

  CDL.Continuous.Sources.Constant smaNum(final k=small) "Small number"
    annotation (Placement(transformation(extent={{120,-22},{140,-2}})));
  CDL.Continuous.Sources.Constant larNum(final k=large) "Large number"
    annotation (Placement(transformation(extent={{98,116},{118,136}})));

  CDL.Continuous.Sources.Constant minStaCap[nSta](final k=minStaUnlCap)
    "Array of chiller stage minimal unload capacities"
    annotation (Placement(transformation(extent={{-220,-140},{-200,-120}})));
  CDL.Integers.Add                        addInt1(k1=-1)
    "Aligns indexes (stage starts with 0, indexes with 1)"
    annotation (Placement(transformation(extent={{-150,40},{-130,60}})));
  CDL.Integers.Sources.Constant                        zero(final k=0)
    "Constant integer"
    annotation (Placement(transformation(extent={{-220,-60},{-200,-40}})));
  CDL.Integers.Sources.Constant maxSta(final k=nSta) "Highest stage"
    annotation (Placement(transformation(extent={{-220,70},{-200,90}})));
  CDL.Integers.Sources.Constant maxSta1(final k=nSta + 1) "Highest stage"
    annotation (Placement(transformation(extent={{-220,102},{-200,122}})));
  CDL.Integers.Equal                        intEqu1
                                                   "Equal stage 1"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  CDL.Logical.Switch                        swi1
                                                "Switch"
    annotation (Placement(transformation(extent={{160,-30},{180,-10}})));
  CDL.Logical.Switch                        swi2
                                                "Switch"
    annotation (Placement(transformation(extent={{160,40},{180,60}})));
  CDL.Integers.Equal                        intEqu2
                                                   "Equal stage 1"
    annotation (Placement(transformation(extent={{52,62},{72,82}})));
  CDL.Logical.Switch                        swi3
                                                "Switch"
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  CDL.Logical.Switch                        swi4
                                                "Switch"
    annotation (Placement(transformation(extent={{160,-120},{180,-100}})));
  CDL.Logical.Switch                        swi5
                                                "Switch"
    annotation (Placement(transformation(extent={{180,110},{200,130}})));
equation
  connect(one.y, intEqu.u2) annotation (Line(points={{-199,-20},{-50,-20},{-50,20},
          {-22,20}},   color={255,127,0}));
  connect(intEqu.y, swi.u2)
    annotation (Line(points={{1,28},{84,28},{84,20},{118,20}}, color={255,0,255}));
  connect(extStaLowCap.y, swi.u3) annotation (Line(points={{19,110},{80,110},{80,
          12},{118,12}},  color={0,0,127}));
  connect(uSta, intEqu.u1) annotation (Line(points={{-280,0},{-154,0},{-154,28},
          {-22,28}},color={255,127,0}));
  connect(uSta, addInt.u1) annotation (Line(points={{-280,0},{-152,0},{-152,6},{
          -142,6}},   color={255,127,0}));
  connect(one.y, addInt.u2) annotation (Line(points={{-199,-20},{-150,-20},{-150,
          -6},{-142,-6}}, color={255,127,0}));
  connect(extStaLowCap.y, lesThr[2].u) annotation (Line(points={{19,110},{60,110},
          {60,170},{98,170}},color={0,0,127}));
  connect(extStaUpCap.y, lesThr[3].u) annotation (Line(points={{71,0},{90,0},{90,
          70},{80,70},{80,170},{98,170}}, color={0,0,127}));
  connect(extStaCap.y, lesThr[1].u)
    annotation (Line(points={{-19,150},{70,150},{70,170},{98,170}},
                                                  color={0,0,127}));
  connect(or1.y, staExc.u)
    annotation (Line(points={{161,170},{178,170}}, color={255,0,255}));
  connect(lesThr[1].y, or1.u1) annotation (Line(points={{121,170},{130,170},{130,
          178},{138,178}},
                     color={255,0,255}));
  connect(lesThr[2].y, or1.u2)
    annotation (Line(points={{121,170},{138,170}},
                                                 color={255,0,255}));
  connect(lesThr[3].y, or1.u3) annotation (Line(points={{121,170},{130,170},{130,
          162},{138,162}},
                     color={255,0,255}));
  connect(matGai.y, extStaCap.u) annotation (Line(points={{-119,180},{-70,180},{
          -70,150},{-42,150}}, color={0,0,127}));
  connect(u, booToRea.u) annotation (Line(points={{-280,-120},{-240,-120},{-240,
          -180},{-222,-180}}, color={255,0,255}));
  connect(pro.y, matGai1.u)
    annotation (Line(points={{-159,-160},{-142,-160}}, color={0,0,127}));
  connect(minStaCap.y, pro.u1) annotation (Line(points={{-199,-130},{-190,-130},
          {-190,-154},{-182,-154}}, color={0,0,127}));
  connect(booToRea.y, pro.u2) annotation (Line(points={{-199,-180},{-190,-180},{
          -190,-166},{-182,-166}}, color={0,0,127}));
  connect(pro1.y, matGai.u)
    annotation (Line(points={{-159,180},{-142,180}}, color={0,0,127}));
  connect(staCap.y, pro1.u1) annotation (Line(points={{-219,190},{-194,190},{-194,
          186},{-182,186}}, color={0,0,127}));
  connect(booToRea1.y, pro1.u2) annotation (Line(points={{-209,140},{-196,140},{
          -196,174},{-182,174}}, color={0,0,127}));
  connect(u, booToRea1.u) annotation (Line(points={{-280,-120},{-240,-120},{-240,
          140},{-232,140}}, color={255,0,255}));
  connect(matGai1.y, extStaUpCapMin.u) annotation (Line(points={{-119,-160},{-60,
          -160},{-60,-74},{-52,-74}}, color={0,0,127}));
  connect(matGai1.y, extStaCapMin.u) annotation (Line(points={{-119,-160},{-20,-160},
          {-20,-110},{20,-110}}, color={0,0,127}));
  connect(uSta, addInt1.u2) annotation (Line(points={{-280,0},{-160,0},{-160,44},
          {-152,44}}, color={255,127,0}));
  connect(one.y, addInt1.u1) annotation (Line(points={{-199,-20},{-170,-20},{-170,
          56},{-152,56}}, color={255,127,0}));
  connect(matGai.y, extStaLowCap.u) annotation (Line(points={{-119,180},{-76.5,180},
          {-76.5,110},{-4,110}}, color={0,0,127}));
  connect(matGai.y, extStaUpCap.u) annotation (Line(points={{-119,180},{34,180},
          {34,18},{32,18},{32,0},{48,0}}, color={0,0,127}));
  connect(maxSta.y, forCurSta.u1) annotation (Line(points={{-199,80},{-170.5,80},
          {-170.5,136},{-142,136}}, color={255,127,0}));
  connect(uSta, forCurSta.u2) annotation (Line(points={{-280,0},{-180,0},{-180,124},
          {-142,124}}, color={255,127,0}));
  connect(maxSta1.y, forStaUp.u1) annotation (Line(points={{-199,112},{-152,112},
          {-152,96},{-102,96}}, color={255,127,0}));
  connect(addInt.y, forStaUp.u2) annotation (Line(points={{-119,0},{-110,0},{-110,
          84},{-102,84}}, color={255,127,0}));
  connect(addInt1.y, forStaDow.u1) annotation (Line(points={{-129,50},{-96,50},{
          -96,56},{-62,56}}, color={255,127,0}));
  connect(zero.y, forStaDow.u2) annotation (Line(points={{-199,-50},{-142,-50},{
          -142,-30},{-86,-30},{-86,44},{-62,44}}, color={255,127,0}));
  connect(forStaUp.y, extStaUpCapMin.index) annotation (Line(points={{-79,90},{-72,
          90},{-72,-100},{-40,-100},{-40,-86}}, color={255,127,0}));
  connect(forCurSta.y, extStaCapMin.index) annotation (Line(points={{-119,130},{
          -110,130},{-110,-130},{32,-130},{32,-122}}, color={255,127,0}));
  connect(forCurSta.y, extStaCap.index) annotation (Line(points={{-119,130},{-30,
          130},{-30,138}}, color={255,127,0}));
  connect(forStaDow.y, extStaLowCap.index) annotation (Line(points={{-39,50},{-18,
          50},{-18,54},{8,54},{8,98}}, color={255,127,0}));
  connect(forStaUp.y, extStaUpCap.index) annotation (Line(points={{-79,90},{-30,
          90},{-30,82},{28,82},{28,-26},{60,-26},{60,-12}}, color={255,127,0}));
  connect(minStaCap[1].y, swi.u1) annotation (Line(points={{-199,-130},{-160,-130},
          {-160,-136},{108,-136},{108,28},{118,28}}, color={0,0,127}));
  connect(zero.y, intEqu1.u1) annotation (Line(points={{-199,-50},{-170.5,-50},{
          -170.5,-70},{-142,-70}}, color={255,127,0}));
  connect(uSta, intEqu1.u2) annotation (Line(points={{-280,0},{-226,0},{-226,-78},
          {-142,-78}}, color={255,127,0}));
  connect(yStaDowNom, swi1.y) annotation (Line(points={{230,0},{206,0},{206,-20},
          {181,-20}}, color={0,0,127}));
  connect(swi.y, swi1.u3) annotation (Line(points={{141,20},{150,20},{150,-28},{
          158,-28}}, color={0,0,127}));
  connect(intEqu1.y, swi1.u2) annotation (Line(points={{-119,-70},{-100,-70},{-100,
          -52},{30,-52},{30,-20},{158,-20}}, color={255,0,255}));
  connect(uSta, intEqu2.u2) annotation (Line(points={{-280,0},{-190,0},{-190,-16},
          {-100,-16},{-100,64},{50,64}}, color={255,127,0}));
  connect(maxSta.y, intEqu2.u1) annotation (Line(points={{-199,80},{-76,80},{-76,
          72},{50,72}}, color={255,127,0}));
  connect(intEqu2.y, swi2.u2) annotation (Line(points={{73,72},{90,72},{90,100},
          {150,100},{150,50},{158,50}}, color={255,0,255}));
  connect(larNum.y, swi2.u1) annotation (Line(points={{119,126},{140,126},{140,58},
          {158,58}}, color={0,0,127}));
  connect(swi2.y, yStaUpNom) annotation (Line(points={{181,50},{200,50},{200,40},
          {230,40}}, color={0,0,127}));
  connect(extStaUpCap.y, swi2.u3) annotation (Line(points={{71,0},{100,0},{100,42},
          {158,42}}, color={0,0,127}));
  connect(smaNum.y, swi1.u1)
    annotation (Line(points={{141,-12},{158,-12}}, color={0,0,127}));
  connect(intEqu1.y, swi3.u2) annotation (Line(points={{-119,-70},{-100,-70},{-100,
          -90},{78,-90}}, color={255,0,255}));
  connect(extStaCapMin.y, swi3.u3) annotation (Line(points={{43,-110},{60,-110},
          {60,-98},{78,-98}}, color={0,0,127}));
  connect(zero.y, intToRea.u) annotation (Line(points={{-199,-50},{-80,-50},{-80,
          -56},{38,-56}}, color={255,127,0}));
  connect(intToRea.y, swi3.u1) annotation (Line(points={{61,-56},{70,-56},{70,-82},
          {78,-82}}, color={0,0,127}));
  connect(yStaMin, yStaMin)
    annotation (Line(points={{230,-40},{230,-40}}, color={0,0,127}));
  connect(swi3.y, yStaMin) annotation (Line(points={{101,-90},{140,-90},{140,-40},
          {230,-40}}, color={0,0,127}));
  connect(intEqu2.y, swi4.u2) annotation (Line(points={{73,72},{116,72},{116,-110},
          {158,-110}}, color={255,0,255}));
  connect(larNum.y, swi4.u1) annotation (Line(points={{119,126},{144,126},{144,-102},
          {158,-102}}, color={0,0,127}));
  connect(extStaUpCapMin.y, swi4.u3) annotation (Line(points={{-29,-74},{64.5,-74},
          {64.5,-118},{158,-118}}, color={0,0,127}));
  connect(swi4.y, yStaUpMin) annotation (Line(points={{181,-110},{200,-110},{200,
          -80},{230,-80}}, color={0,0,127}));
  connect(extStaCap.y, swi5.u3) annotation (Line(points={{-19,150},{72,150},{72,
          112},{178,112}}, color={0,0,127}));
  connect(intEqu1.y, swi5.u2) annotation (Line(points={{-119,-70},{24,-70},{24,120},
          {178,120}}, color={255,0,255}));
  connect(smaNum.y, swi5.u1) annotation (Line(points={{141,-12},{160,-12},{160,128},
          {178,128}}, color={0,0,127}));
  connect(swi5.y, yStaNom) annotation (Line(points={{201,120},{210,120},{210,80},
          {230,80}}, color={0,0,127}));
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
          extent={{-260,-220},{220,220}})),
Documentation(info="<html>
<p>
Based on the current chiller stage and nominal stage capacities returns the
nominal capacity of the current and one lower stage for the purpose of 
calculating the operative part load ratio (OPLR).

fixme: implement skipping unavailable stages using:
lower_triangle * avail_sta * sta_cap

  parameter Real lower_triangle[nSta,nSta] = {if i<= j then 1 else 0 for i in 1:nSta, j in 1:nSta};
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
