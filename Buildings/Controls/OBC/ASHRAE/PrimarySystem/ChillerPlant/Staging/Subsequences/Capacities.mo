within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block Capacities "Returns nominal and minimal capacities for calculating all operating part load ratios"

  parameter Integer nSta = 2
  "Total number of stages";

  parameter Modelica.SIunits.Power staNomCap[nSta] = {5e5, 1e6}
  "Stage nominal capacity (cumulative)";

  parameter Modelica.SIunits.Power minStaUnlCap[nSta] = {0.2*staNomCap[1], 0.2*staNomCap[2]}
    "Stage minimal unload capacity (cumulative)";

  final parameter Real lowDia[nSta, nSta] = {if i<= j then 1 else 0 for i in 1:nSta, j in 1:nSta};

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta(
    final min = 0,
    final max = nSta) "Chiller stage"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaNom(
    final unit="W",
    final quantity="Power") "Nominal capacity of the current stage"
    annotation (Placement(transformation(extent={{180,70},{200,90}}),
      iconTransformation(extent={{100,60},{120,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaDowNom(
    final unit="W",
    final quantity="Power") "Nominal capacity of the first stage down"
    annotation (Placement(transformation(extent={{180,-10},{200,10}}),
        iconTransformation(extent={{100,-20},{120,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaUpNom(
    final unit="W",
    final quantity="Power")
    "Nominal capacity of the next higher stage" annotation (Placement(
        transformation(extent={{180,30},{200,50}}),   iconTransformation(extent={{100,20},
            {120,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaMin(
    final unit="W",
    final quantity="Power")
    "Minimum capacity of the current stage" annotation (Placement(
        transformation(extent={{180,-50},{200,-30}}), iconTransformation(extent={{100,-90},
            {120,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaUpMin(
    final unit="W",
    final quantity="Power") "Minimum capacity of the next higher stage"
      annotation (Placement(transformation(extent={{180,-90},{200,-70}}),
      iconTransformation(extent={{100,-70}, {120,-50}})));

  CDL.Continuous.MatrixGain matGai(K=lowDia)
    annotation (Placement(transformation(extent={{-140,110},{-120,130}})));
protected
  parameter Real small = 0.001
  "Small number to avoid division with zero";

  parameter Real large = staNomCap[nSta]*2
  "Value to avoid stage up when at the highest stage";

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staCap[nSta](final k=
        staNomCap) "Array of chiller stage nominal capacities"
    annotation (Placement(transformation(extent={{-180,110},{-160,130}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minStaUnl[nSta + 2](final k=
        cat(
        1,
        {0},
        minStaUnlCap,
        {large}))
    "Array of chiller stage minimal unload capacities"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant one(
    final k=1) "Constant integer"
    annotation (Placement(transformation(extent={{-160,-30},{-140,-10}})));

  Buildings.Controls.OBC.CDL.Utilities.Assert staExc(
    final message="The provided chiller stage is not within the number of stages available")
    annotation (Placement(transformation(extent={{140,100},{160,120}})));

  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr[3](
    final threshold={-0.5,-0.5,-0.5})
    "Less than threshold"
    annotation (Placement(transformation(extent={{60,100},{80,120}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu "Equal stage 1"
    annotation (Placement(transformation(extent={{50,20},{70,40}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaCap(
    final outOfRangeValue=-1,
    final nin=nSta + 2)
    "Extracts the nominal capacity at the current stage"
    annotation (Placement(transformation(extent={{-50,100},{-30,120}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaLowCap(
    final outOfRangeValue=-1,
    final nin=nSta + 2)
    "Extracts the nominal capacity of one stage lower than the current stage"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));

  Buildings.Controls.OBC.CDL.Integers.Max maxInt "Maximum"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi "Switch"
    annotation (Placement(transformation(extent={{120,10},{140,30}})));

  Buildings.Controls.OBC.CDL.Integers.Add addInt
    "Aligns indexes (stage starts with 0, indexes with 1)"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extMinUnlCap(
    final outOfRangeValue=-1,
    final nin=nSta + 2) "Extracts minimal capacity of the next higher stage"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));

  Buildings.Controls.OBC.CDL.Integers.Add addInt1(final k2=+1)
    "Adds a stage"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaUpCap(
    final outOfRangeValue=-1,
    final nin=nSta + 2) "Extracts the nominal capacity of the next stage"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaCapMin(
    final outOfRangeValue=-1,
    final nin= nSta + 2) "Extracts the minimum capacity of the current stage"
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));

  Buildings.Controls.OBC.CDL.Logical.Or3 or1
    annotation (Placement(transformation(extent={{100,100},{120,120}})));

  CDL.Continuous.Sources.Constant smaNum(final k=small) "Small number"
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));
  CDL.Continuous.Sources.Constant larNum(final k=large) "Large number"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));

equation
  connect(one.y, intEqu.u2) annotation (Line(points={{-139,-20},{-50,-20},{-50,
          22},{48,22}},color={255,127,0}));
  connect(maxInt.y, extStaLowCap.index) annotation (Line(points={{-79,10},{-60,
          10},{-60,36},{-10,36},{-10,48}},color={255,127,0}));
  connect(extStaCap.y, yStaNom) annotation (Line(points={{-29,110},{10,110},{10,
          80},{190,80}},    color={0,0,127}));
  connect(intEqu.y, swi.u2)
    annotation (Line(points={{71,30},{84,30},{84,20},{118,20}},color={255,0,255}));
  connect(extStaLowCap.y, swi.u3) annotation (Line(points={{1,60},{80,60},{80,12},
          {118,12}},      color={0,0,127}));
  connect(swi.y, yStaDowNom)
    annotation (Line(points={{141,20},{170,20},{170,0},{190,0}},color={0,0,127}));
  connect(uSta, intEqu.u1) annotation (Line(points={{-200,0},{-110,0},{-110,30},
          {48,30}}, color={255,127,0}));
  connect(uSta, maxInt.u1) annotation (Line(points={{-200,0},{-110,0},{-110,16},
          {-102,16}}, color={255,127,0}));
  connect(addInt.y, extStaCap.index) annotation (Line(points={{-79,70},{-40,70},
          {-40,98}}, color={255,127,0}));
  connect(uSta, addInt.u1) annotation (Line(points={{-200,0},{-130,0},{-130,76},
          {-102,76}}, color={255,127,0}));
  connect(one.y, addInt.u2) annotation (Line(points={{-139,-20},{-120,-20},{
          -120,64},{-102,64}},
                          color={255,127,0}));
  connect(minStaUnl.y, extMinUnlCap.u)
    annotation (Line(points={{-99,-90},{-62,-90}}, color={0,0,127}));
  connect(minStaUnl[2].y, swi.u1) annotation (Line(points={{-99,-90},{-90,-90},{
          -90,-52},{100,-52},{100,28},{118,28}},  color={0,0,127}));
  connect(extMinUnlCap.y, yStaUpMin)
    annotation (Line(points={{-39,-90},{90,-90},{90,-80},{190,-80}},
                                                   color={0,0,127}));
  connect(one.y, maxInt.u2) annotation (Line(points={{-139,-20},{-106,-20},{
          -106,4},{-102,4}},
                     color={255,127,0}));
  connect(addInt.y, addInt1.u1) annotation (Line(points={{-79,70},{-40,70},{-40,
          6},{-22,6}},     color={255,127,0}));
  connect(one.y, addInt1.u2) annotation (Line(points={{-139,-20},{-40,-20},{-40,
          -6},{-22,-6}},   color={255,127,0}));
  connect(extStaUpCap.y, yStaUpNom) annotation (Line(points={{71,0},{110,0},{110,
          40},{190,40}},        color={0,0,127}));
  connect(addInt.y, extStaCapMin.index) annotation (Line(points={{-79,70},{-70,
          70},{-70,-130},{50,-130},{50,-122}},
                                           color={255,127,0}));
  connect(minStaUnl.y, extStaCapMin.u) annotation (Line(points={{-99,-90},{-90,-90},
          {-90,-110},{38,-110}},                     color={0,0,127}));
  connect(extStaCapMin.y, yStaMin) annotation (Line(points={{61,-110},{160,-110},
          {160,-40},{190,-40}}, color={0,0,127}));
  connect(addInt1.y, extStaUpCap.index) annotation (Line(points={{1,0},{20,0},{20,
          -30},{60,-30},{60,-12}}, color={255,127,0}));
  connect(addInt1.y, extMinUnlCap.index) annotation (Line(points={{1,0},{10,0},{
          10,-120},{-50,-120},{-50,-102}}, color={255,127,0}));
  connect(extStaLowCap.y, lesThr[2].u) annotation (Line(points={{1,60},{20,60},{
          20,110},{58,110}}, color={0,0,127}));
  connect(extStaUpCap.y, lesThr[3].u) annotation (Line(points={{71,0},{90,0},{90,
          70},{40,70},{40,110},{58,110}}, color={0,0,127}));
  connect(extStaCap.y, lesThr[1].u)
    annotation (Line(points={{-29,110},{58,110}}, color={0,0,127}));
  connect(or1.y, staExc.u)
    annotation (Line(points={{121,110},{138,110}}, color={255,0,255}));
  connect(lesThr[1].y, or1.u1) annotation (Line(points={{81,110},{90,110},{90,118},
          {98,118}}, color={255,0,255}));
  connect(lesThr[2].y, or1.u2)
    annotation (Line(points={{81,110},{98,110}}, color={255,0,255}));
  connect(lesThr[3].y, or1.u3) annotation (Line(points={{81,110},{90,110},{90,102},
          {98,102}}, color={255,0,255}));
  connect(staCap.y, matGai.u) annotation (Line(points={{-159,120},{-142,120}},
                            color={0,0,127}));
  connect(matGai.y, extStaCap.u) annotation (Line(points={{-119,120},{-70,120},{
          -70,110},{-52,110}}, color={0,0,127}));
  connect(smaNum.y, extStaCap.u[1]) annotation (Line(points={{-79,140},{-60,140},
          {-60,110},{-52,110}}, color={0,0,127}));
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
          extent={{-180,-160},{180,160}})),
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
