within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences;
block Overrides "Software switches to override setpoints"

  parameter Real VZonMin_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone minimum airflow setpoint";
  parameter Real VCooZonMax_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone cooling maximum airflow rate";
  parameter Real VHeaZonMax_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone heating maximum airflow rate";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput oveFloSet
    "Index of overriding flow setpoint, 1: set to zero; 2: set to cooling maximum; 3: set to minimum flow; 4: set to heating maximum"
    annotation (Placement(transformation(extent={{-180,180},{-140,220}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActSet_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active airflow setpoint"
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput oveDamPos
    "Index of overriding damper position, 1: set to close; 2: set to open"
    annotation (Placement(transformation(extent={{-180,-60},{-140,-20}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uDamSet(
    final min=0,
    final unit="1") "Damper position setpoint"
    annotation (Placement(transformation(extent={{-180,-150},{-140,-110}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaOff
    "Override heating valve position, true: close heating valve"
    annotation (Placement(transformation(extent={{-180,-180},{-140,-140}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uValSet(
    final min=0,
    final unit="1")
    "Heating valve position setpoint"
    annotation (Placement(transformation(extent={{-180,-220},{-140,-180}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VSet_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Airflow setpoint after considering override"
    annotation (Placement(transformation(extent={{140,0},{180,40}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDamSet(
    final min=0,
    final unit="1")
    "Damper position setpoint after considering override"
    annotation (Placement(transformation(extent={{140,-120},{180,-80}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValSet(
    final min=0,
    final unit="1")
    "Heating valve position setpoint after considering override"
    annotation (Placement(transformation(extent={{140,-200},{180,-160}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=1)
    "Constant 1"
    annotation (Placement(transformation(extent={{-120,170},{-100,190}})));
  Buildings.Controls.OBC.CDL.Integers.Equal forZerFlo "Check if forcing zone airflow setpoint to zero"
    annotation (Placement(transformation(extent={{-80,190},{-60,210}})));
  Buildings.Controls.OBC.CDL.Integers.Equal forCooMax
    "Check if forcing zone airflow setpoint to cooling maximum"
    annotation (Placement(transformation(extent={{-80,150},{-60,170}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=2)
    "Constant 2"
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));
  Buildings.Controls.OBC.CDL.Integers.Equal forMinFlo
    "Check if forcing zone airflow setpoint to minimum flow"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(
    final k=3)
    "Constant 3"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal zerFlo(
    final realTrue=0)
    "Force zone airflow setpoint to zero"
    annotation (Placement(transformation(extent={{-40,190},{-20,210}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cooMax(
    final realTrue=VCooZonMax_flow)
    "Force zone airflow setpoint to cooling maximum"
    annotation (Placement(transformation(extent={{-40,150},{-20,170}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal minFlo(
    final realTrue=VZonMin_flow)
    "Force zone airflow setpoint to zone minimum flow"
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2 "Add up two inputs"
    annotation (Placement(transformation(extent={{28,130},{48,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1 "Add up inputs"
    annotation (Placement(transformation(extent={{62,170},{82,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi "Airflow setpoint after considering override"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or3 "Check if the airflow setpoint should be overrided"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3(
    final k=1)
    "Constant 1"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu3
    "Check if forcing damper to full close"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu4
    "Check if forcing damper to full open"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4(
    final k=2)
    "Constant 2"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cloDam(
    final realTrue=0)
    "Full closed damper position"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal opeDam(
    final realTrue=1)
    "Full open damper position"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add3 "Add up inputs"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Check if the damper setpoint position should be overrided"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi1
    "Damper setpoint position after considering override"
    annotation (Placement(transformation(extent={{80,-110},{100,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt5(
    final k=4)
    "Constant 4"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Integers.Equal forMinFlo1
    "Check if forcing zone airflow setpoint to minimum flow"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal heaMax(
    final realTrue=VHeaZonMax_flow)
    "Force zone airflow setpoint to zone heating maximum flow"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add4
    "Add up two inputs"
    annotation (Placement(transformation(extent={{-6,90},{14,110}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Check if the airflow setpoint should be overrided"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply pro
    "Valve position setpoint after considering override"
    annotation (Placement(transformation(extent={{80,-190},{100,-170}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    final realTrue=0,
    final realFalse=1)
    "Convert boolean true to real 0"
    annotation (Placement(transformation(extent={{-80,-170},{-60,-150}})));

equation
  connect(oveFloSet, forZerFlo.u1)
    annotation (Line(points={{-160,200},{-82,200}}, color={255,127,0}));
  connect(conInt.y, forZerFlo.u2) annotation (Line(points={{-98,180},{-90,180},{
          -90,192},{-82,192}}, color={255,127,0}));
  connect(oveFloSet, forCooMax.u1) annotation (Line(points={{-160,200},{-130,200},
          {-130,160},{-82,160}}, color={255,127,0}));
  connect(conInt1.y, forCooMax.u2) annotation (Line(points={{-98,140},{-90,140},
          {-90,152},{-82,152}}, color={255,127,0}));
  connect(oveFloSet, forMinFlo.u1) annotation (Line(points={{-160,200},{-130,200},
          {-130,120},{-82,120}}, color={255,127,0}));
  connect(conInt2.y, forMinFlo.u2) annotation (Line(points={{-98,100},{-90,100},
          {-90,112},{-82,112}}, color={255,127,0}));
  connect(forZerFlo.y, zerFlo.u)
    annotation (Line(points={{-58,200},{-42,200}}, color={255,0,255}));
  connect(forCooMax.y, cooMax.u)
    annotation (Line(points={{-58,160},{-42,160}}, color={255,0,255}));
  connect(forMinFlo.y, minFlo.u)
    annotation (Line(points={{-58,120},{-42,120}}, color={255,0,255}));
  connect(cooMax.y, add2.u1) annotation (Line(points={{-18,160},{0,160},{0,146},
          {26,146}},color={0,0,127}));
  connect(zerFlo.y, add1.u1) annotation (Line(points={{-18,200},{20,200},{20,186},
          {60,186}}, color={0,0,127}));
  connect(forZerFlo.y, or3.u1) annotation (Line(points={{-58,200},{-50,200},{-50,
          48},{-22,48}},color={255,0,255}));
  connect(forCooMax.y, or3.u2) annotation (Line(points={{-58,160},{-50,160},{-50,
          40},{-22,40}},color={255,0,255}));
  connect(forMinFlo.y, or3.u3) annotation (Line(points={{-58,120},{-50,120},{-50,
          32},{-22,32}}, color={255,0,255}));
  connect(add1.y, swi.u1) annotation (Line(points={{84,180},{90,180},{90,28},{98,
          28}}, color={0,0,127}));
  connect(VActSet_flow, swi.u3) annotation (Line(points={{-160,0},{80,0},{80,12},
          {98,12}}, color={0,0,127}));
  connect(swi.y, VSet_flow)
    annotation (Line(points={{122,20},{160,20}}, color={0,0,127}));
  connect(conInt3.y, intEqu3.u2) annotation (Line(points={{-98,-60},{-90,-60},{-90,
          -48},{-82,-48}}, color={255,127,0}));
  connect(conInt4.y,intEqu4. u2) annotation (Line(points={{-98,-100},{-90,-100},
          {-90,-88},{-82,-88}}, color={255,127,0}));
  connect(oveDamPos, intEqu3.u1)
    annotation (Line(points={{-160,-40},{-82,-40}}, color={255,127,0}));
  connect(oveDamPos, intEqu4.u1) annotation (Line(points={{-160,-40},{-130,-40},
          {-130,-80},{-82,-80}}, color={255,127,0}));
  connect(intEqu3.y, cloDam.u)
    annotation (Line(points={{-58,-40},{-42,-40}}, color={255,0,255}));
  connect(intEqu4.y, opeDam.u)
    annotation (Line(points={{-58,-80},{-42,-80}}, color={255,0,255}));
  connect(cloDam.y, add3.u1) annotation (Line(points={{-18,-40},{0,-40},{0,-54},
          {18,-54}}, color={0,0,127}));
  connect(opeDam.y, add3.u2) annotation (Line(points={{-18,-80},{0,-80},{0,-66},
          {18,-66}}, color={0,0,127}));
  connect(intEqu3.y, or2.u1) annotation (Line(points={{-58,-40},{-50,-40},{-50,-100},
          {-2,-100}}, color={255,0,255}));
  connect(intEqu4.y, or2.u2) annotation (Line(points={{-58,-80},{-50,-80},{-50,-108},
          {-2,-108}}, color={255,0,255}));
  connect(add3.y, swi1.u1) annotation (Line(points={{42,-60},{60,-60},{60,-92},{
          78,-92}}, color={0,0,127}));
  connect(or2.y, swi1.u2)
    annotation (Line(points={{22,-100},{78,-100}}, color={255,0,255}));
  connect(uDamSet, swi1.u3) annotation (Line(points={{-160,-130},{60,-130},{60,-108},
          {78,-108}}, color={0,0,127}));
  connect(swi1.y, yDamSet)
    annotation (Line(points={{102,-100},{160,-100}}, color={0,0,127}));
  connect(oveFloSet, forMinFlo1.u1) annotation (Line(points={{-160,200},{-130,200},
          {-130,80},{-82,80}}, color={255,127,0}));
  connect(conInt5.y, forMinFlo1.u2) annotation (Line(points={{-98,60},{-90,60},{
          -90,72},{-82,72}}, color={255,127,0}));
  connect(forMinFlo1.y, heaMax.u)
    annotation (Line(points={{-58,80},{-42,80}}, color={255,0,255}));
  connect(add2.y, add1.u2) annotation (Line(points={{50,140},{54,140},{54,174},{
          60,174}}, color={0,0,127}));
  connect(minFlo.y, add4.u1) annotation (Line(points={{-18,120},{-12,120},{-12,106},
          {-8,106}}, color={0,0,127}));
  connect(heaMax.y, add4.u2) annotation (Line(points={{-18,80},{-12,80},{-12,94},
          {-8,94}}, color={0,0,127}));
  connect(add4.y, add2.u2) annotation (Line(points={{16,100},{22,100},{22,134},{
          26,134}}, color={0,0,127}));
  connect(or3.y, or1.u1) annotation (Line(points={{2,40},{20,40},{20,20},{38,20}},
        color={255,0,255}));
  connect(forMinFlo1.y, or1.u2) annotation (Line(points={{-58,80},{-50,80},{-50,
          12},{38,12}}, color={255,0,255}));
  connect(or1.y, swi.u2)
    annotation (Line(points={{62,20},{98,20}}, color={255,0,255}));
  connect(uHeaOff, booToRea.u)
    annotation (Line(points={{-160,-160},{-82,-160}}, color={255,0,255}));
  connect(booToRea.y, pro.u1) annotation (Line(points={{-58,-160},{60,-160},{60,
          -174},{78,-174}}, color={0,0,127}));
  connect(uValSet, pro.u2) annotation (Line(points={{-160,-200},{60,-200},{60,-186},
          {78,-186}}, color={0,0,127}));
  connect(pro.y,yValSet)
    annotation (Line(points={{102,-180},{160,-180}}, color={0,0,127}));

annotation (defaultComponentName="rehBoxOve",
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
        lineColor={0,0,255}),
        Text(
          extent={{-100,56},{-42,42}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActSet_flow"),
        Text(
          extent={{-98,88},{-48,74}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="oveFloSet"),
        Text(
          extent={{-98,-14},{-58,-26}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uDamSet"),
        Text(
          extent={{-98,28},{-48,14}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="oveFloSet"),
        Text(
          extent={{58,6},{98,-6}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yDamSet"),
        Text(
          extent={{58,68},{98,56}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VSet_flow"),
        Text(
          extent={{-98,-82},{-58,-94}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uValSet"),
        Text(
          extent={{-98,-54},{-58,-66}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uHeaOff"),
        Text(
          extent={{58,-52},{98,-64}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yValSet")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-220},{140,220}})),
Documentation(info="<html>
<p>
This block considers the overrides to the setpoints for terminal unit with reheat.
The implementation is according to the Section 5.6.7 of ASHRAE Guideline 36,
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
<code>VCooZonMax_flow</code>,
</li>
<li>
when <code>oveFloSet</code> equals to 3, force the zone airflow setpoint
<code>VSet_flow</code> to zone minimum airflow setpoint
<code>VZonMin_flow</code>.
</li>
<li>
when <code>oveFloSet</code> equals to 4, force the zone airflow setpoint
<code>VSet_flow</code> to zone heating maximum airflow setpoint
<code>VHeaZonMax_flow</code>.
</li>
<li>
when <code>oveDamPos</code> equals to 1, force the damper to full closed by setting
<code>yDamSet</code> to 0,
</li>
<li>
when <code>oveDamPos</code> equals to 2, force the damper to full open by setting
<code>yDamSet</code> to 1.
</li>
<li>
when <code>uHeaOff</code> equals to <code>true</code>, force the heating valve to
full closed by setting <code>yValSet</code> to 0.
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
