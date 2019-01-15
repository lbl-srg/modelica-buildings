within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block Capacities "Returns nominal capacities at current and one lower stage"

  parameter Integer numSta = 2
  "Highest chiller stage";

  parameter Modelica.SIunits.Power staNomCap[numSta + 1] = {small, 5e5, 1e6}
  "Nominal capacity at all chiller stages, starting with 0 stage";

  parameter Real min_plr1(final unit="1") = 0.1
  "Minimum part load ratio for the first stage";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta "Chiller stage"
    annotation (Placement(transformation(extent={{-200,-20},{-160,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySta(
    final unit="W",
    final quantity="Power") "Nominal capacity of the current stage"
    annotation (
      Placement(transformation(extent={{160,30},{180,50}}), iconTransformation(
          extent={{100,30},{120,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yLowSta(
    final unit="W",
    final quantity="Power") "Nominal capacity of the first lower stage"
    annotation (Placement(transformation(extent={{160,-30},{180,-10}}),
        iconTransformation(extent={{100,-50},{120,-30}})));

//protected
  parameter Real small = 0.001
  "Small number to avoid division with zero";

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staCap[numSta + 1](
    final k=staNomCap)
    "Array of chiller stage nominal capacities starting with stage 0"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staLow(final k=1)
    "One stage lower"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage0(
    final k=0) "Stage 0"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));

  Buildings.Controls.OBC.CDL.Utilities.Assert staExc(
    final message="The provided chiller stage is not within the number of stages available")
    annotation (Placement(transformation(extent={{20,60},{40,80}})));

  CDL.Continuous.LessThreshold lesThr(
    final threshold=-0.5) "Less than threshold"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));

  CDL.Integers.Equal intEqu "Equal stage 1"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Product pro "Product"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));

  CDL.Routing.RealExtractor extStaCap(
    final outOfRangeValue=-1,
    final nin=numSta + 1)
    "Extracts the nominal capacity at the current stage"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));

  CDL.Integers.Add addInt(k1=1, final k2=-1)
                 "Adder"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));

  CDL.Routing.RealExtractor extStaLowCap(
    final outOfRangeValue=-1,
    final nin=numSta + 1)
    "Extracts the nominal capacity of one stage lower than the current stage"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  CDL.Integers.Max maxInt "Maximum"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

  CDL.Continuous.Sources.Constant minPlrSta1(
    final k=min_plr1)
    "Minimum part load ratio of the first stage"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));

  CDL.Logical.Switch swi "Switch"
    annotation (Placement(transformation(extent={{102,-30},{122,-10}})));

equation
  connect(extStaCap.y, lesThr.u) annotation (Line(points={{-39,70},{-22,70}},
     color={0,0,127}));
  connect(staExc.u, lesThr.y)
    annotation (Line(points={{18,70},{1,70}}, color={255,0,255}));
  connect(staCap.y,extStaCap. u)
    annotation (Line(points={{-79,70},{-62,70}}, color={0,0,127}));
  connect(uSta,extStaCap. index)
    annotation (Line(points={{-180,0},{-110,0},{-110,40},{-50,40},{-50,58}},
    color={255,127,0}));
  connect(staLow.y, addInt.u2) annotation (Line(points={{-119,-60},{-110,-60},{
          -110,-26},{-102,-26}},
                            color={255,127,0}));
  connect(uSta, addInt.u1) annotation (Line(points={{-180,0},{-110,0},{-110,-14},
          {-102,-14}}, color={255,127,0}));
  connect(staCap.y, extStaLowCap.u) annotation (Line(points={{-79,70},{-70,70},
          {-70,20},{-34,20},{-34,0},{-22,0}},
                                  color={0,0,127}));
  connect(staLow.y, intEqu.u2) annotation (Line(points={{-119,-60},{20,-60},{20,
          -28},{38,-28}},  color={255,127,0}));
  connect(stage0.y,maxInt. u2) annotation (Line(points={{-79,-80},{-70,-80},{
          -70,-46},{-62,-46}},    color={255,127,0}));
  connect(addInt.y,maxInt. u1) annotation (Line(points={{-79,-20},{-70,-20},{
          -70,-34},{-62,-34}},color={255,127,0}));
  connect(maxInt.y, extStaLowCap.index) annotation (Line(points={{-39,-40},{-10,
          -40},{-10,-12}},color={255,127,0}));
  connect(extStaCap.y, ySta) annotation (Line(points={{-39,70},{-30,70},{-30,40},
          {170,40}},                   color={0,0,127}));
  connect(pro.u2, minPlrSta1.y) annotation (Line(points={{38,-66},{30,-66},{30,
          -80},{21,-80}},  color={0,0,127}));
  connect(intEqu.y, swi.u2)
    annotation (Line(points={{61,-20},{100,-20}}, color={255,0,255}));
  connect(pro.y, swi.u1) annotation (Line(points={{61,-60},{86,-60},{86,-12},{
          100,-12}},color={0,0,127}));
  connect(extStaCap.y, pro.u1) annotation (Line(points={{-39,70},{-30,70},{-30,
          -54},{38,-54}},color={0,0,127}));
  connect(extStaLowCap.y, swi.u3) annotation (Line(points={{1,0},{80,0},{80,-28},
          {100,-28}},     color={0,0,127}));
  connect(swi.y, yLowSta) annotation (Line(points={{123,-20},{170,-20}},
                      color={0,0,127}));
  connect(uSta, intEqu.u1) annotation (Line(points={{-180,0},{-40,0},{-40,-20},
          {38,-20}}, color={255,127,0}));
  annotation (defaultComponentName = "staCap",
        Icon(coordinateSystem(extent={{-160,-100},{160,100}}),
             graphics={
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
          extent={{-160,-100},{160,100}})),
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
