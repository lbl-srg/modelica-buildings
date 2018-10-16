within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Stage;
block Capacities
  "Returns nominal capacities at current and one lower stage"

  parameter Modelica.SIunits.Power nomCapSta1 = 10000000
  "Nominal capacity of the first stage";

  parameter Modelica.SIunits.Power nomCapSta2 = 10000000
  "Nominal capacity of the second stage";

  parameter Real min_plr1(final unit="1") = 0.1
  "Minimum part load ratio for the first stage";

  parameter Real small = 0.00000001
  "Small number to avoid division with zero";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta "Chiller stage"
    annotation (Placement(transformation(extent={{-200,-20},{-160,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCapNomSta(
    final unit="W",
    final quantity="Power") "Nominal capacity of the current stage"
    annotation (Placement(transformation(extent={{160,30},{180,50}}),
        iconTransformation(extent={{100,30},{120,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCapNomLowSta(
    final unit="W",
    final quantity="Power") "Nominal capacity of the first lower stage"
    annotation (Placement(transformation(extent={{160,-50},{180,-30}}),
        iconTransformation(extent={{100,-50},{120,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiSta1(k=nomCapSta1)
    "Nominal capacity of the first chiller stage"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiSta2(k=nomCapSta2)
    "Nominal capacity of the second chiller stage"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant   stage1(k=1) "Stage 1"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant   stage2(k=2) "Stage 2"
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant   stage0(k=0) "Stage 0"
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi2
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert staExc(
    message="The provided chiller stage is higher than the number of stages available")
    annotation (Placement(transformation(extent={{120,80},{140,100}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(threshold=0.5)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));

  Buildings.Controls.OBC.CDL.Integers.LessEqual intLesEqu
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swiLowSta1
    annotation (Placement(transformation(extent={{80,-50},{100,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Product pro
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swiLowSta0
    annotation (Placement(transformation(extent={{120,-80},{140,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi0
    annotation (Placement(transformation(extent={{20,30},{40,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiSta0(final k=small)
    "Nominal capacity of the 0th chiller stage"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minPlrSta1(final k=min_plr1)
    "Minimum part load ratio of the first stage"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

  CDL.Routing.RealExtractSignal extSig
    annotation (Placement(transformation(extent={{-174,50},{-154,70}})));
  CDL.Routing.RealExtractor extIndSig
    annotation (Placement(transformation(extent={{-210,-62},{-190,-42}})));
equation
  connect(uChiSta, intEqu.u1)
    annotation (Line(points={{-180,0},{-90,0},{-90,-90},{-82,-90}},
                                                color={255,127,0}));
  connect(stage0.y, intEqu.u2) annotation (Line(points={{-119,-110},{-90,-110},{
          -90,-98},{-82,-98}},
                         color={255,127,0}));
  connect(stage2.y, intEqu2.u2) annotation (Line(points={{-119,-30},{-110,-30},{
          -110,-18},{-82,-18}}, color={255,127,0}));
  connect(stage1.y, intEqu1.u2) annotation (Line(points={{-119,-70},{-100,-70},{
          -100,-58},{-82,-58}}, color={255,127,0}));
  connect(intEqu2.y, swi2.u2) annotation (Line(points={{-59,-10},{-48,-10},{-48,
          20},{-70,20},{-70,90},{-62,90}},
                    color={255,0,255}));
  connect(swi2.y, greThr.u) annotation (Line(points={{-39,90},{78,90}},
                 color={0,0,127}));
  connect(greThr.y,staExc. u)
    annotation (Line(points={{101,90},{118,90}},   color={255,0,255}));
  connect(uChiSta, intEqu1.u1) annotation (Line(points={{-180,0},{-100,0},{-100,
          -50},{-82,-50}},
                      color={255,127,0}));
  connect(uChiSta, intEqu2.u1) annotation (Line(points={{-180,0},{-104,0},{-104,
          -10},{-82,-10}}, color={255,127,0}));
  connect(stage1.y, intLesEqu.u2) annotation (Line(points={{-119,-70},{-60,-70},
          {-60,-78},{-2,-78}}, color={255,127,0}));
  connect(uChiSta, intLesEqu.u1) annotation (Line(points={{-180,0},{-108,0},{-108,
          -30},{-20,-30},{-20,-70},{-2,-70}}, color={255,127,0}));
  connect(intLesEqu.y, swiLowSta1.u2) annotation (Line(points={{21,-70},{40,-70},
          {40,-40},{78,-40}}, color={255,0,255}));
  connect(chiSta1.y, swiLowSta1.u3) annotation (Line(points={{-99,70},{-36,70},{
          -36,-48},{78,-48}},
                          color={0,0,127}));
  connect(pro.u2, minPlrSta1.y) annotation (Line(points={{38,-16},{30,-16},{30,-30},
          {21,-30}},      color={0,0,127}));
  connect(chiSta1.y, pro.u1) annotation (Line(points={{-99,70},{-80,70},{-80,40},
          {-20,40},{-20,-4},{38,-4}},
                     color={0,0,127}));
  connect(swiLowSta1.u1, pro.y) annotation (Line(points={{78,-32},{70,-32},{70,-10},
          {61,-10}},      color={0,0,127}));
  connect(yCapNomLowSta, swiLowSta0.y) annotation (Line(points={{170,-40},{150,-40},
          {150,-70},{141,-70}}, color={0,0,127}));
  connect(swiLowSta1.y, swiLowSta0.u3) annotation (Line(points={{101,-40},{110,-40},
          {110,-78},{118,-78}}, color={0,0,127}));
  connect(intEqu.y, swiLowSta0.u2) annotation (Line(points={{-59,-90},{100,-90},
          {100,-70},{118,-70}}, color={255,0,255}));
  connect(chiSta0.y, swiLowSta0.u1) annotation (Line(points={{-99,110},{70,110},
          {70,0},{114,0},{114,-62},{118,-62}}, color={0,0,127}));
  connect(chiSta0.y, swi2.u3) annotation (Line(points={{-99,110},{-80,110},{-80,
          82},{-62,82}}, color={0,0,127}));
  connect(chiSta2.y, swi2.u1) annotation (Line(points={{-99,30},{-90,30},{-90,98},
          {-62,98}}, color={0,0,127}));
  connect(swi2.y, swi1.u3) annotation (Line(points={{-39,90},{-30,90},{-30,52},{
          -22,52}}, color={0,0,127}));
  connect(chiSta1.y, swi1.u1) annotation (Line(points={{-99,70},{-62,70},{-62,68},
          {-22,68}}, color={0,0,127}));
  connect(intEqu1.y, swi1.u2) annotation (Line(points={{-59,-50},{-40,-50},{-40,
          60},{-22,60}}, color={255,0,255}));
  connect(swi1.y, swi0.u3) annotation (Line(points={{1,60},{10,60},{10,32},{18,32}},
        color={0,0,127}));
  connect(chiSta0.y, swi0.u1) annotation (Line(points={{-99,110},{-34,110},{-34,
          48},{18,48}}, color={0,0,127}));
  connect(swi0.y, yCapNomSta)
    annotation (Line(points={{41,40},{170,40}}, color={0,0,127}));
  connect(intEqu.y, swi0.u2) annotation (Line(points={{-59,-90},{-10,-90},{-10,40},
          {18,40}}, color={255,0,255}));
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
Fixme
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
end Capacities;
