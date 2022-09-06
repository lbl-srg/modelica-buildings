within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctColdDuctMin.Subsequences;
block Overrides "Software switches to override setpoints"

  parameter Real VMin_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone minimum airflow setpoint";
  parameter Real VCooMax_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone cooling maximum airflow rate";
  parameter Real VHeaMax_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone heating maximum airflow rate";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput oveFloSet
    "Index of overriding flow setpoint, 1: set to zero; 2: set to cooling maximum; 3: set to minimum flow; 4: set to heating maximum"
    annotation (Placement(transformation(extent={{-180,200},{-140,240}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActSet_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active airflow setpoint"
    annotation (Placement(transformation(extent={{-180,0},{-140,40}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput oveCooDamPos
    "Index of overriding cooling damper position, 1: set to close; 2: set to open"
    annotation (Placement(transformation(extent={{-180,-40},{-140,0}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCooDam(
    final min=0,
    final unit="1")
    "Cooling damper commanded position"
    annotation (Placement(transformation(extent={{-180,-130},{-140,-90}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput oveHeaDamPos
    "Index of overriding heating damper position, 1: set to close; 2: set to open"
    annotation (Placement(transformation(extent={{-180,-160},{-140,-120}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaDam(
    final min=0,
    final unit="1")
    "Heating damper commanded position"
    annotation (Placement(transformation(extent={{-180,-250},{-140,-210}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VSet_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Airflow setpoint after considering override"
    annotation (Placement(transformation(extent={{140,20},{180,60}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooDam(
    final min=0,
    final unit="1")
    "Cooling damper commanded position, after considering override"
    annotation (Placement(transformation(extent={{140,-100},{180,-60}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaDam(
    final min=0,
    final unit="1")
    "Heating damper commanded position, after considering override"
    annotation (Placement(transformation(extent={{140,-220},{180,-180}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=1)
    "Constant 1"
    annotation (Placement(transformation(extent={{-120,190},{-100,210}})));
  Buildings.Controls.OBC.CDL.Integers.Equal forZerFlo "Check if forcing zone airflow setpoint to zero"
    annotation (Placement(transformation(extent={{-80,210},{-60,230}})));
  Buildings.Controls.OBC.CDL.Integers.Equal forCooMax
    "Check if forcing zone airflow setpoint to cooling maximum"
    annotation (Placement(transformation(extent={{-80,170},{-60,190}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=2)
    "Constant 2"
    annotation (Placement(transformation(extent={{-120,150},{-100,170}})));
  Buildings.Controls.OBC.CDL.Integers.Equal forMinFlo
    "Check if forcing zone airflow setpoint to minimum flow"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(
    final k=3)
    "Constant 3"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal zerFlo(
    final realTrue=0)
    "Force zone airflow setpoint to zero"
    annotation (Placement(transformation(extent={{-40,210},{-20,230}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cooMax(
    final realTrue=VCooMax_flow)
    "Force zone airflow setpoint to cooling maximum"
    annotation (Placement(transformation(extent={{-40,170},{-20,190}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal minFlo(
    final realTrue=VMin_flow)
    "Force zone airflow setpoint to zone minimum flow"
    annotation (Placement(transformation(extent={{-40,130},{-20,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2 "Add up two inputs"
    annotation (Placement(transformation(extent={{28,150},{48,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1 "Add up inputs"
    annotation (Placement(transformation(extent={{62,190},{82,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi "Airflow setpoint after considering override"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or3 "Check if the airflow setpoint should be overrided"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3(
    final k=1)
    "Constant 1"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu3
    "Check if forcing damper to full close"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu4
    "Check if forcing damper to full open"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4(
    final k=2)
    "Constant 2"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cloDam(
    final realTrue=0)
    "Full closed damper position"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal opeDam(
    final realTrue=1)
    "Full open damper position"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add3 "Add up inputs"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Check if the damper setpoint position should be overrided"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi1
    "Damper setpoint position after considering override"
    annotation (Placement(transformation(extent={{80,-90},{100,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt5(
    final k=4)
    "Constant 4"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Integers.Equal forMinFlo1
    "Check if forcing zone airflow setpoint to minimum flow"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal heaMax(
    final realTrue=VHeaMax_flow)
    "Force zone airflow setpoint to zone heating maximum flow"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add4
    "Add up two inputs"
    annotation (Placement(transformation(extent={{-6,110},{14,130}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Check if the airflow setpoint should be overrided"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt6(
    final k=1)
    "Constant 1"
    annotation (Placement(transformation(extent={{-120,-170},{-100,-150}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1
    "Check if forcing damper to full close"
    annotation (Placement(transformation(extent={{-80,-150},{-60,-130}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2
    "Check if forcing damper to full open"
    annotation (Placement(transformation(extent={{-80,-190},{-60,-170}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt7(
    final k=2)
    "Constant 2"
    annotation (Placement(transformation(extent={{-120,-210},{-100,-190}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cloDam1(
    final realTrue=0)
    "Full closed damper position"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal opeDam1(
    final realTrue=1)
    "Full open damper position"
    annotation (Placement(transformation(extent={{-40,-190},{-20,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add5
    "Add up inputs"
    annotation (Placement(transformation(extent={{20,-170},{40,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Or or4
    "Check if the damper setpoint position should be overrided"
    annotation (Placement(transformation(extent={{0,-210},{20,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi2
    "Damper setpoint position after considering override"
    annotation (Placement(transformation(extent={{80,-210},{100,-190}})));

equation
  connect(oveFloSet, forZerFlo.u1)
    annotation (Line(points={{-160,220},{-82,220}}, color={255,127,0}));
  connect(conInt.y, forZerFlo.u2) annotation (Line(points={{-98,200},{-90,200},{
          -90,212},{-82,212}}, color={255,127,0}));
  connect(oveFloSet, forCooMax.u1) annotation (Line(points={{-160,220},{-130,220},
          {-130,180},{-82,180}}, color={255,127,0}));
  connect(conInt1.y, forCooMax.u2) annotation (Line(points={{-98,160},{-90,160},
          {-90,172},{-82,172}}, color={255,127,0}));
  connect(oveFloSet, forMinFlo.u1) annotation (Line(points={{-160,220},{-130,220},
          {-130,140},{-82,140}}, color={255,127,0}));
  connect(conInt2.y, forMinFlo.u2) annotation (Line(points={{-98,120},{-90,120},
          {-90,132},{-82,132}}, color={255,127,0}));
  connect(forZerFlo.y, zerFlo.u)
    annotation (Line(points={{-58,220},{-42,220}}, color={255,0,255}));
  connect(forCooMax.y, cooMax.u)
    annotation (Line(points={{-58,180},{-42,180}}, color={255,0,255}));
  connect(forMinFlo.y, minFlo.u)
    annotation (Line(points={{-58,140},{-42,140}}, color={255,0,255}));
  connect(cooMax.y, add2.u1) annotation (Line(points={{-18,180},{0,180},{0,166},
          {26,166}},color={0,0,127}));
  connect(zerFlo.y, add1.u1) annotation (Line(points={{-18,220},{20,220},{20,206},
          {60,206}}, color={0,0,127}));
  connect(forZerFlo.y, or3.u1) annotation (Line(points={{-58,220},{-50,220},{-50,
          68},{-22,68}},color={255,0,255}));
  connect(forCooMax.y, or3.u2) annotation (Line(points={{-58,180},{-50,180},{-50,
          60},{-22,60}},color={255,0,255}));
  connect(forMinFlo.y, or3.u3) annotation (Line(points={{-58,140},{-50,140},{-50,
          52},{-22,52}}, color={255,0,255}));
  connect(add1.y, swi.u1) annotation (Line(points={{84,200},{90,200},{90,48},{98,
          48}}, color={0,0,127}));
  connect(VActSet_flow, swi.u3) annotation (Line(points={{-160,20},{80,20},{80,32},
          {98,32}}, color={0,0,127}));
  connect(swi.y, VSet_flow)
    annotation (Line(points={{122,40},{160,40}}, color={0,0,127}));
  connect(conInt3.y, intEqu3.u2) annotation (Line(points={{-98,-40},{-90,-40},{-90,
          -28},{-82,-28}}, color={255,127,0}));
  connect(conInt4.y,intEqu4. u2) annotation (Line(points={{-98,-80},{-90,-80},{-90,
          -68},{-82,-68}},      color={255,127,0}));
  connect(oveCooDamPos, intEqu3.u1)
    annotation (Line(points={{-160,-20},{-82,-20}}, color={255,127,0}));
  connect(oveCooDamPos, intEqu4.u1) annotation (Line(points={{-160,-20},{-130,-20},
          {-130,-60},{-82,-60}}, color={255,127,0}));
  connect(intEqu3.y, cloDam.u)
    annotation (Line(points={{-58,-20},{-42,-20}}, color={255,0,255}));
  connect(intEqu4.y, opeDam.u)
    annotation (Line(points={{-58,-60},{-42,-60}}, color={255,0,255}));
  connect(cloDam.y, add3.u1) annotation (Line(points={{-18,-20},{0,-20},{0,-34},
          {18,-34}}, color={0,0,127}));
  connect(opeDam.y, add3.u2) annotation (Line(points={{-18,-60},{0,-60},{0,-46},
          {18,-46}}, color={0,0,127}));
  connect(intEqu3.y, or2.u1) annotation (Line(points={{-58,-20},{-50,-20},{-50,-80},
          {-2,-80}},  color={255,0,255}));
  connect(intEqu4.y, or2.u2) annotation (Line(points={{-58,-60},{-50,-60},{-50,-88},
          {-2,-88}},  color={255,0,255}));
  connect(add3.y, swi1.u1) annotation (Line(points={{42,-40},{60,-40},{60,-72},{
          78,-72}}, color={0,0,127}));
  connect(or2.y, swi1.u2)
    annotation (Line(points={{22,-80},{78,-80}},   color={255,0,255}));
  connect(uCooDam, swi1.u3) annotation (Line(points={{-160,-110},{60,-110},{60,-88},
          {78,-88}}, color={0,0,127}));
  connect(swi1.y, yCooDam)
    annotation (Line(points={{102,-80},{160,-80}}, color={0,0,127}));
  connect(oveFloSet, forMinFlo1.u1) annotation (Line(points={{-160,220},{-130,220},
          {-130,100},{-82,100}}, color={255,127,0}));
  connect(conInt5.y, forMinFlo1.u2) annotation (Line(points={{-98,80},{-90,80},{
          -90,92},{-82,92}}, color={255,127,0}));
  connect(forMinFlo1.y, heaMax.u)
    annotation (Line(points={{-58,100},{-42,100}}, color={255,0,255}));
  connect(add2.y, add1.u2) annotation (Line(points={{50,160},{54,160},{54,194},{
          60,194}}, color={0,0,127}));
  connect(minFlo.y, add4.u1) annotation (Line(points={{-18,140},{-12,140},{-12,126},
          {-8,126}}, color={0,0,127}));
  connect(heaMax.y, add4.u2) annotation (Line(points={{-18,100},{-12,100},{-12,114},
          {-8,114}},color={0,0,127}));
  connect(add4.y, add2.u2) annotation (Line(points={{16,120},{22,120},{22,154},{
          26,154}}, color={0,0,127}));
  connect(or3.y, or1.u1) annotation (Line(points={{2,60},{20,60},{20,40},{38,40}},
        color={255,0,255}));
  connect(forMinFlo1.y, or1.u2) annotation (Line(points={{-58,100},{-50,100},{-50,
          32},{38,32}}, color={255,0,255}));
  connect(or1.y, swi.u2)
    annotation (Line(points={{62,40},{98,40}}, color={255,0,255}));
  connect(conInt6.y,intEqu1. u2) annotation (Line(points={{-98,-160},{-90,-160},
          {-90,-148},{-82,-148}}, color={255,127,0}));
  connect(conInt7.y,intEqu2. u2) annotation (Line(points={{-98,-200},{-90,-200},
          {-90,-188},{-82,-188}}, color={255,127,0}));
  connect(oveHeaDamPos, intEqu1.u1)
    annotation (Line(points={{-160,-140},{-82,-140}}, color={255,127,0}));
  connect(oveHeaDamPos, intEqu2.u1) annotation (Line(points={{-160,-140},{-130,-140},
          {-130,-180},{-82,-180}}, color={255,127,0}));
  connect(intEqu1.y, cloDam1.u)
    annotation (Line(points={{-58,-140},{-42,-140}}, color={255,0,255}));
  connect(intEqu2.y, opeDam1.u)
    annotation (Line(points={{-58,-180},{-42,-180}}, color={255,0,255}));
  connect(cloDam1.y, add5.u1) annotation (Line(points={{-18,-140},{0,-140},{0,-154},
          {18,-154}}, color={0,0,127}));
  connect(opeDam1.y, add5.u2) annotation (Line(points={{-18,-180},{0,-180},{0,-166},
          {18,-166}}, color={0,0,127}));
  connect(intEqu1.y,or4. u1) annotation (Line(points={{-58,-140},{-50,-140},{-50,
          -200},{-2,-200}}, color={255,0,255}));
  connect(intEqu2.y,or4. u2) annotation (Line(points={{-58,-180},{-50,-180},{-50,
          -208},{-2,-208}}, color={255,0,255}));
  connect(add5.y,swi2. u1) annotation (Line(points={{42,-160},{60,-160},{60,-192},
          {78,-192}}, color={0,0,127}));
  connect(or4.y,swi2. u2)
    annotation (Line(points={{22,-200},{78,-200}}, color={255,0,255}));
  connect(uHeaDam, swi2.u3) annotation (Line(points={{-160,-230},{60,-230},{60,-208},
          {78,-208}}, color={0,0,127}));
  connect(swi2.y, yHeaDam)
    annotation (Line(points={{102,-200},{160,-200}}, color={0,0,127}));

annotation (defaultComponentName="ove",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
        extent={{-100,140},{100,100}},
        textString="%name",
        textColor={0,0,255}),
        Text(
          extent={{-98,56},{-40,42}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActSet_flow"),
        Text(
          extent={{-98,88},{-48,74}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="oveFloSet"),
        Text(
          extent={{-100,-22},{-46,-36}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCooDam"),
        Text(
          extent={{-96,10},{-26,-6}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="oveCooDamPos"),
        Text(
          extent={{50,8},{100,-6}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yCooDam"),
        Text(
          extent={{58,68},{98,56}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VSet_flow"),
        Text(
          extent={{-100,-82},{-46,-96}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uHeaDam"),
        Text(
          extent={{-96,-50},{-26,-66}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="oveHeaDamPos"),
        Text(
          extent={{50,-52},{100,-66}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yHeaDam")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-240},{140,240}})),
Documentation(info="<html>
<p>
This block considers the overrides to the setpoints for dual-duct terminal unit
with cold-duct minimum control.
The implementation is according to the Section 5.14.7 of ASHRAE Guideline 36,
May 2020.
</p>
<p>
Provide software switches that interlock to a system-level point to:
</p>
<ol>
<li>
when <code>oveFloSet</code> equals to 1, force the zone airflow setpoint
<code>VSet_flow</code> to zero,
</li>
<li>
when <code>oveFloSet</code> equals to 2, force the zone airflow setpoint
<code>VSet_flow</code> to zone cooling maximum airflow rate
<code>VCooMax_flow</code>,
</li>
<li>
when <code>oveFloSet</code> equals to 3, force the zone airflow setpoint
<code>VSet_flow</code> to zone minimum airflow setpoint
<code>VMin_flow</code>.
</li>
<li>
when <code>oveFloSet</code> equals to 4, force the zone airflow setpoint
<code>VSet_flow</code> to zone heating maximum airflow setpoint
<code>VHeaMax_flow</code>.
</li>
<li>
when <code>oveCooDamPos</code> equals to 1, force the cooling damper to full closed by setting
<code>yCooDam</code> to 0,
</li>
<li>
when <code>oveCooDamPos</code> equals to 2, force the cooling damper to full open by setting
<code>yCooDam</code> to 1.
</li>
<li>
when <code>oveHeaDamPos</code> equals to 1, force the heating damper to full closed by setting
<code>yHeaDam</code> to 0,
</li>
<li>
when <code>oveHeaDamPos</code> equals to 2, force the heating damper to full open by setting
<code>yHeaDam</code> to 1.
</li>
</ol>
</html>",revisions="<html>
<ul>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Overrides;
