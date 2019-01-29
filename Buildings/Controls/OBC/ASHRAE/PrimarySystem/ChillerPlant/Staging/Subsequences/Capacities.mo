within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block Capacities "Returns nominal and minimal capacities for calculating all operating part load ratios"

  parameter Integer numSta = 2
  "Total number of stages";

  parameter Modelica.SIunits.Power staNomCap[numSta] = {5e5, 1e6}
  "Stage nominal capacity (cumulative)";

  parameter Modelica.SIunits.Power minStaUnlCap[numSta] = {0.2*staNomCap[1], 0.2*staNomCap[2]}
    "Stage minimal unload capacity (cumulative)";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta "Chiller stage"
    annotation (Placement(transformation(extent={{-200,-20},{-160,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaNom(
    final unit="W",
    final quantity="Power") "Nominal capacity of the current stage"
    annotation (Placement(transformation(extent={{160,70},{180,90}}),
        iconTransformation(extent={{100,60},{120,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaDowNom(
    final unit="W",
    final quantity="Power") "Nominal capacity of the first stage down"
    annotation (Placement(transformation(extent={{160,-10},{180,10}}),
        iconTransformation(extent={{100,-20},{120,0}})));

//protected
  parameter Real small[1] = {0.001}
  "Small number to avoid division with zero";

  parameter Real large[1] = {staNomCap[numSta]*2}
  "Value to avoid stage up when at the highest stage";

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staCap[numSta + 1](
    final k=cat(1,small, staNomCap))
    "Array of chiller stage nominal capacities starting with stage 0"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minStaUnl[numSta + 2](
    final k=cat(1, {0}, minStaUnlCap, large))
    "Array of chiller stage minimal unload capacities"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant one(
    final k=1) "Constant integer"
    annotation (Placement(transformation(extent={{-150,-30},{-130,-10}})));

  Buildings.Controls.OBC.CDL.Utilities.Assert staExc(
    final message="The provided chiller stage is not within the number of stages available")
    annotation (Placement(transformation(extent={{20,100},{40,120}})));

  CDL.Continuous.LessThreshold lesThr(
    final threshold=-0.5) "Less than threshold"
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));

  CDL.Integers.Equal intEqu "Equal stage 1"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));

  CDL.Routing.RealExtractor extStaCap(
    final outOfRangeValue=-1,
    final nin=numSta + 1) "Extracts the nominal capacity at the current stage"
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));

  CDL.Routing.RealExtractor extStaLowCap(
    final outOfRangeValue=-1,
    final nin=numSta + 1)
    "Extracts the nominal capacity of one stage lower than the current stage"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));

  CDL.Integers.Max maxInt "Maximum"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  CDL.Logical.Switch swi "Switch"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));

  CDL.Integers.Add addInt
    "Aligns indexes (stage starts with 0, indexes with 1)"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));

  CDL.Interfaces.RealOutput yStaUpMin(
    final unit="W",
    final quantity="Power") "Minimum capacity of the next higher stage"
                                                annotation (Placement(
        transformation(extent={{160,-90},{180,-70}}), iconTransformation(extent={{100,-70},
            {120,-50}})));

  CDL.Routing.RealExtractor extMinUnlCap(
    final outOfRangeValue=-1,
    final nin=numSta + 2) "Extracts minimal capacity of the next higher stage"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));

  CDL.Integers.Add addInt1 "Adds a stage"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  CDL.Interfaces.RealOutput yStaUpNom(final unit="W", final quantity="Power")
    "Nominal capacity of the next higher stage" annotation (Placement(
        transformation(extent={{160,30},{180,50}}),   iconTransformation(extent={{100,20},
            {120,40}})));
  CDL.Routing.RealExtractor extStaUpCap(final outOfRangeValue=-1, final nin=
        numSta + 1) "Extracts the nominal capacity of the next stage"
    annotation (Placement(transformation(extent={{50,-30},{70,-10}})));
  CDL.Integers.Min minInt "Maximum"
    annotation (Placement(transformation(extent={{30,-60},{50,-40}})));
  CDL.Integers.Sources.Constant staMax(final k=numSta + 1)
    "Index of the maximal stage"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  CDL.Interfaces.RealOutput yStaMin(final unit="W", final quantity="Power")
    "Minimum capacity of the current stage" annotation (Placement(
        transformation(extent={{160,-50},{180,-30}}), iconTransformation(extent={{100,-90},
            {120,-70}})));
  CDL.Routing.RealExtractor extStaCapMin(final outOfRangeValue=-1, final nin=
        numSta + 2) "Extracts the minimum capacity of the current stage"
    annotation (Placement(transformation(extent={{40,-110},{60,-90}})));
equation
  connect(extStaCap.y, lesThr.u) annotation (Line(points={{-39,110},{-22,110}},
     color={0,0,127}));
  connect(staExc.u, lesThr.y)
    annotation (Line(points={{18,110},{1,110}},
                                              color={255,0,255}));
  connect(staCap.y,extStaCap. u)
    annotation (Line(points={{-79,110},{-62,110}},
                                                 color={0,0,127}));
  connect(staCap.y, extStaLowCap.u) annotation (Line(points={{-79,110},{-70,110},
          {-70,40},{-22,40}},     color={0,0,127}));
  connect(one.y, intEqu.u2) annotation (Line(points={{-129,-20},{0,-20},{0,12},{
          38,12}}, color={255,127,0}));
  connect(maxInt.y, extStaLowCap.index) annotation (Line(points={{-39,0},{-10,0},
          {-10,28}},      color={255,127,0}));
  connect(extStaCap.y, yStaNom) annotation (Line(points={{-39,110},{-30,110},{-30,
          80},{170,80}}, color={0,0,127}));
  connect(intEqu.y, swi.u2)
    annotation (Line(points={{61,20},{90,20},{90,0},{118,0}},
                                                  color={255,0,255}));
  connect(extStaLowCap.y, swi.u3) annotation (Line(points={{1,40},{80,40},{80,-8},
          {118,-8}},      color={0,0,127}));
  connect(swi.y, yStaDowNom)
    annotation (Line(points={{141,0},{170,0}}, color={0,0,127}));
  connect(uSta, intEqu.u1) annotation (Line(points={{-180,0},{-110,0},{-110,20},
          {38,20}}, color={255,127,0}));
  connect(uSta, maxInt.u1) annotation (Line(points={{-180,0},{-110,0},{-110,6},{
          -62,6}},         color={255,127,0}));
  connect(addInt.y, extStaCap.index) annotation (Line(points={{-79,70},{-50,70},
          {-50,98}},     color={255,127,0}));
  connect(uSta, addInt.u1) annotation (Line(points={{-180,0},{-130,0},{-130,76},
          {-102,76}},     color={255,127,0}));
  connect(one.y, addInt.u2) annotation (Line(points={{-129,-20},{-120,-20},{-120,
          64},{-102,64}}, color={255,127,0}));
  connect(minStaUnl.y, extMinUnlCap.u)
    annotation (Line(points={{-79,-80},{-62,-80}}, color={0,0,127}));
  connect(minStaUnl[2].y, swi.u1) annotation (Line(points={{-79,-80},{-70,-80},
          {-70,-60},{100,-60},{100,8},{118,8}},   color={0,0,127}));
  connect(extMinUnlCap.y, yStaUpMin)
    annotation (Line(points={{-39,-80},{170,-80}}, color={0,0,127}));
  connect(one.y, maxInt.u2) annotation (Line(points={{-129,-20},{-70,-20},{-70,-6},
          {-62,-6}}, color={255,127,0}));
  connect(addInt.y, addInt1.u1) annotation (Line(points={{-79,70},{-30,70},{-30,
          -34},{-22,-34}}, color={255,127,0}));
  connect(one.y, addInt1.u2) annotation (Line(points={{-129,-20},{-70,-20},{-70,
          -46},{-22,-46}}, color={255,127,0}));
  connect(addInt1.y, extMinUnlCap.index) annotation (Line(points={{1,-40},{12,-40},
          {12,-100},{-50,-100},{-50,-92}}, color={255,127,0}));
  connect(staCap.y, extStaUpCap.u) annotation (Line(points={{-79,110},{-70,110},
          {-70,20},{20,20},{20,-20},{48,-20}}, color={0,0,127}));
  connect(extStaUpCap.y, yStaUpNom) annotation (Line(points={{71,-20},{96,-20},{
          96,40},{170,40}},     color={0,0,127}));
  connect(staMax.y, minInt.u2) annotation (Line(points={{1,-70},{10,-70},{10,-56},
          {28,-56}}, color={255,127,0}));
  connect(addInt1.y, minInt.u1) annotation (Line(points={{1,-40},{10,-40},{10,-44},
          {28,-44}}, color={255,127,0}));
  connect(minInt.y, extStaUpCap.index)
    annotation (Line(points={{51,-50},{60,-50},{60,-32}}, color={255,127,0}));
  connect(addInt.y, extStaCapMin.index) annotation (Line(points={{-79,70},{-74,
          70},{-74,-120},{50,-120},{50,-112}},
                                           color={255,127,0}));
  connect(minStaUnl.y, extStaCapMin.u) annotation (Line(points={{-79,-80},{-70,-80},
          {-70,-110},{28,-110},{28,-100},{38,-100}}, color={0,0,127}));
  connect(extStaCapMin.y, yStaMin) annotation (Line(points={{61,-100},{140,-100},
          {140,-40},{170,-40}}, color={0,0,127}));
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
          textString="%name")}),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-160,-140},{160,140}})),
Documentation(info="<html>
<p>
Based on the current chiller stage and nominal stage capacities returns the
nominal capacity of the current and one lower stage for the purpose of 
calculating the operative part load ratio (OPLR).

fixme: if we'd like to implement skipping unavailable stages, we'd need a multiple
extracter with an input and zip.sum.
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
