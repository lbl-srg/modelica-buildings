within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic;
block Capacities "Returns nominal capacities at current and one lower stage"

  parameter Integer numSta = 2
  "Highest chiller stage";

  parameter Modelica.SIunits.Power staNomCap[numSta + 1] = {small, 5e5, 1e6}
  "Nominal capacity at all chiller stages, starting with stage 0";

  parameter Real minPlr[numSta + 1](final unit="1") = {0, 0.2, 0.2}
  "Nominal part load ratio for at all chiller stages, starting with stage 0";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta "Chiller stage"
    annotation (Placement(transformation(extent={{-200,-20},{-160,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySta(
    final unit="W",
    final quantity="Power") "Nominal capacity of the current stage"
    annotation (
      Placement(transformation(extent={{160,70},{180,90}}), iconTransformation(
          extent={{100,30},{120,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaLow(
    final unit="W",
    final quantity="Power") "Nominal capacity of the first lower stage"
    annotation (Placement(transformation(extent={{160,10},{180,30}}),
        iconTransformation(extent={{100,-50},{120,-30}})));

//protected
  parameter Real small = 0.001
  "Small number to avoid division with zero";

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staCap[numSta + 1](
    final k=staNomCap)
    "Array of chiller stage nominal capacities starting with stage 0"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staLow(final k=1)
    "One stage lower"
    annotation (Placement(transformation(extent={{-150,-30},{-130,-10}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage0(final k=1)
    "Index at Stage 0"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));

  Buildings.Controls.OBC.CDL.Utilities.Assert staExc(
    final message="The provided chiller stage is not within the number of stages available")
    annotation (Placement(transformation(extent={{20,100},{40,120}})));

  CDL.Continuous.LessThreshold lesThr(
    final threshold=-0.5) "Less than threshold"
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));

  CDL.Integers.Equal intEqu "Equal stage 1"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Product pro "Product"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));

  CDL.Routing.RealExtractor extStaCap(
    final outOfRangeValue=-1,
    final nin=numSta + 1)
    "Extracts the nominal capacity at the current stage"
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));

  CDL.Routing.RealExtractor extStaLowCap(
    final outOfRangeValue=-1,
    final nin=numSta + 1)
    "Extracts the nominal capacity of one stage lower than the current stage"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));

  CDL.Integers.Max maxInt "Maximum"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  CDL.Continuous.Sources.Constant minPlrSta1(final k=minPlr[2])
    "Minimum part load ratio of the first stage"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));

  CDL.Logical.Switch swi "Switch"
    annotation (Placement(transformation(extent={{120,10},{140,30}})));

  CDL.Integers.Add addInt
    "Aligns indexes (stage starts with 0, indexes with 1)"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  CDL.Continuous.Sources.Constant minPLR[numSta + 1](final k=minPlr)
    "Array of chiller stage minimal part load ratios"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  CDL.Continuous.Product pro1[numSta + 1] "Product"
    annotation (Placement(transformation(extent={{-52,-100},{-32,-80}})));
  CDL.Continuous.MultiSum mulSum(nin=3, k=fill(1, uSta + 1))
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
  CDL.Interfaces.RealOutput yStaMin(final unit="W", final quantity="Power")
    "Minimum capacity of the current stage" annotation (Placement(
        transformation(extent={{160,-100},{180,-80}}), iconTransformation(
          extent={{100,-50},{120,-30}})));
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
          {-70,60},{-40,60},{-40,40},{-22,40}},
                                  color={0,0,127}));
  connect(staLow.y, intEqu.u2) annotation (Line(points={{-129,-20},{20,-20},{20,
          12},{38,12}},    color={255,127,0}));
  connect(stage0.y,maxInt. u2) annotation (Line(points={{-79,-40},{-70,-40},{-70,
          -6},{-62,-6}},          color={255,127,0}));
  connect(maxInt.y, extStaLowCap.index) annotation (Line(points={{-39,0},{-10,0},
          {-10,28}},      color={255,127,0}));
  connect(extStaCap.y, ySta) annotation (Line(points={{-39,110},{-30,110},{-30,80},
          {170,80}},                   color={0,0,127}));
  connect(pro.u2, minPlrSta1.y) annotation (Line(points={{38,-26},{30,-26},{30,-40},
          {21,-40}},       color={0,0,127}));
  connect(intEqu.y, swi.u2)
    annotation (Line(points={{61,20},{118,20}},   color={255,0,255}));
  connect(pro.y, swi.u1) annotation (Line(points={{61,-20},{86,-20},{86,28},{118,
          28}},     color={0,0,127}));
  connect(extStaCap.y, pro.u1) annotation (Line(points={{-39,110},{-30,110},{-30,
          -14},{38,-14}},color={0,0,127}));
  connect(extStaLowCap.y, swi.u3) annotation (Line(points={{1,40},{80,40},{80,12},
          {118,12}},      color={0,0,127}));
  connect(swi.y,yStaLow)  annotation (Line(points={{141,20},{170,20}},
                      color={0,0,127}));
  connect(uSta, intEqu.u1) annotation (Line(points={{-180,0},{-110,0},{-110,20},
          {38,20}}, color={255,127,0}));
  connect(uSta, maxInt.u1) annotation (Line(points={{-180,0},{-110,0},{-110,6},{
          -62,6}},         color={255,127,0}));
  connect(addInt.y, extStaCap.index) annotation (Line(points={{-79,70},{-50,70},
          {-50,98}},     color={255,127,0}));
  connect(uSta, addInt.u1) annotation (Line(points={{-180,0},{-130,0},{-130,76},
          {-102,76}},     color={255,127,0}));
  connect(staLow.y, addInt.u2) annotation (Line(points={{-129,-20},{-120,-20},{-120,
          64},{-102,64}},       color={255,127,0}));
  connect(staCap.y, pro1.u1) annotation (Line(points={{-79,110},{-68,110},{
          -68,-84},{-54,-84}}, color={0,0,127}));
  connect(minPLR.y, pro1.u2) annotation (Line(points={{-79,-90},{-66,-90},{
          -66,-96},{-54,-96}}, color={0,0,127}));
  connect(pro1.y, mulSum.u[1:3]) annotation (Line(points={{-31,-90},{-16,-90},
          {-16,-91.3333},{-2,-91.3333}}, color={0,0,127}));
  connect(mulSum.y, yStaMin)
    annotation (Line(points={{21,-90},{170,-90}}, color={0,0,127}));
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
