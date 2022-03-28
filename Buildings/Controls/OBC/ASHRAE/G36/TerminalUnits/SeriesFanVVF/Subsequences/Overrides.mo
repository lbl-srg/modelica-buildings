within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanVVF.Subsequences;
block Overrides "Software switches to override setpoints"

  parameter Real VZonMin_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone minimum airflow setpoint";
  parameter Real VZonCooMax_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone cooling maximum airflow rate";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput oveFloSet
    "Index of overriding flow setpoint, 1: set to zero; 2: set to cooling maximum; 3: set to minimum flow; 4: set to heating maximum"
    annotation (Placement(transformation(extent={{-180,210},{-140,250}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActSet_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active airflow setpoint"
    annotation (Placement(transformation(extent={{-180,70},{-140,110}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput oveDamPos
    "Index of overriding damper position, 1: set to close; 2: set to open"
    annotation (Placement(transformation(extent={{-180,40},{-140,80}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uDamSet(
    final min=0,
    final unit="1") "Damper position setpoint"
    annotation (Placement(transformation(extent={{-180,-50},{-140,-10}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaOff
    "Override heating valve position, true: close heating valve"
    annotation (Placement(transformation(extent={{-180,-80},{-140,-40}}),
        iconTransformation(extent={{-140,-38},{-100,2}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uValSet(
    final min=0,
    final unit="1")
    "Heating valve position setpoint"
    annotation (Placement(transformation(extent={{-180,-120},{-140,-80}}),
        iconTransformation(extent={{-140,-58},{-100,-18}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput oveFan
    "Index of overriding fan status, 1: turn fan off; 2: turn fan on"
    annotation (Placement(transformation(extent={{-180,-170},{-140,-130}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFan "Terminal fan status"
    annotation (Placement(transformation(extent={{-180,-260},{-140,-220}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VSet_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Airflow setpoint after considering override"
    annotation (Placement(transformation(extent={{140,100},{180,140}}),
        iconTransformation(extent={{100,50},{140,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDamSet(
    final min=0,
    final unit="1") "Damper position setpoint after considering override"
    annotation (Placement(transformation(extent={{140,-20},{180,20}}),
        iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValSet(
    final min=0,
    final unit="1")
    "Heating valve position setpoint after considering override"
    annotation (Placement(transformation(extent={{140,-100},{180,-60}}),
        iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yFanStaSet
    "Fan status after considering override"
    annotation (Placement(transformation(extent={{140,-170},{180,-130}}),
        iconTransformation(extent={{100,-90},{140,-50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=1)
    "Constant 1"
    annotation (Placement(transformation(extent={{-120,200},{-100,220}})));
  Buildings.Controls.OBC.CDL.Integers.Equal forZerFlo
    "Check if forcing zone airflow setpoint to zero"
    annotation (Placement(transformation(extent={{-80,220},{-60,240}})));
  Buildings.Controls.OBC.CDL.Integers.Equal forCooMax
    "Check if forcing zone airflow setpoint to cooling maximum"
    annotation (Placement(transformation(extent={{-80,180},{-60,200}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=2)
    "Constant 2"
    annotation (Placement(transformation(extent={{-120,160},{-100,180}})));
  Buildings.Controls.OBC.CDL.Integers.Equal forMinFlo
    "Check if forcing zone airflow setpoint to minimum flow"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(
    final k=3)
    "Constant 3"
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal zerFlo(
    final realTrue=0)
    "Force zone airflow setpoint to zero"
    annotation (Placement(transformation(extent={{-40,220},{-20,240}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cooMax(
    final realTrue=VZonCooMax_flow)
    "Force zone airflow setpoint to cooling maximum"
    annotation (Placement(transformation(extent={{-40,180},{-20,200}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal minFlo(
    final realTrue=VZonMin_flow)
    "Force zone airflow setpoint to zone minimum flow"
    annotation (Placement(transformation(extent={{-40,140},{-20,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2 "Add up two inputs"
    annotation (Placement(transformation(extent={{20,160},{40,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1 "Add up inputs"
    annotation (Placement(transformation(extent={{60,200},{80,220}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Airflow setpoint after considering override"
    annotation (Placement(transformation(extent={{100,110},{120,130}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or3
    "Check if the airflow setpoint should be overrided"
    annotation (Placement(transformation(extent={{20,110},{40,130}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3(
    final k=1)
    "Constant 1"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu3
    "Check if forcing damper to full close"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu4
    "Check if forcing damper to full open"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4(
    final k=2)
    "Constant 2"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cloDam(
    final realTrue=0) "Full closed damper position"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal opeDam(
    final realTrue=1) "Full open damper position"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add3 "Add up inputs"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Check if the damper setpoint position should be overrided"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi1
    "Damper setpoint position after considering override"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply pro
    "Valve position setpoint after considering override"
    annotation (Placement(transformation(extent={{80,-90},{100,-70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    final realTrue=0,
    final realFalse=1)
    "Convert boolean true to real 0"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt5(
    final k=1)
    "Constant 1"
    annotation (Placement(transformation(extent={{-120,-180},{-100,-160}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1
    "Check if forcing fan to turn  off"
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2
    "Check if forcing fan to turn on"
    annotation (Placement(transformation(extent={{-60,-210},{-40,-190}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt6(
    final k=2)
    "Constant 2"
    annotation (Placement(transformation(extent={{-120,-230},{-100,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi
    "Fan status after considering override"
    annotation (Placement(transformation(extent={{80,-160},{100,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=false)
    "Turn fan off"
    annotation (Placement(transformation(extent={{0,-130},{20,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi1
    "Logical switch"
    annotation (Placement(transformation(extent={{20,-210},{40,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    final k=true)
    "Turn fan on"
    annotation (Placement(transformation(extent={{-20,-180},{0,-160}})));

equation
  connect(oveFloSet, forZerFlo.u1)
    annotation (Line(points={{-160,230},{-82,230}}, color={255,127,0}));
  connect(conInt.y, forZerFlo.u2) annotation (Line(points={{-98,210},{-90,210},{
          -90,222},{-82,222}}, color={255,127,0}));
  connect(oveFloSet, forCooMax.u1) annotation (Line(points={{-160,230},{-130,230},
          {-130,190},{-82,190}}, color={255,127,0}));
  connect(conInt1.y, forCooMax.u2) annotation (Line(points={{-98,170},{-90,170},
          {-90,182},{-82,182}}, color={255,127,0}));
  connect(oveFloSet, forMinFlo.u1) annotation (Line(points={{-160,230},{-130,230},
          {-130,150},{-82,150}}, color={255,127,0}));
  connect(conInt2.y, forMinFlo.u2) annotation (Line(points={{-98,130},{-90,130},
          {-90,142},{-82,142}}, color={255,127,0}));
  connect(forZerFlo.y, zerFlo.u)
    annotation (Line(points={{-58,230},{-42,230}}, color={255,0,255}));
  connect(forCooMax.y, cooMax.u)
    annotation (Line(points={{-58,190},{-42,190}}, color={255,0,255}));
  connect(forMinFlo.y, minFlo.u)
    annotation (Line(points={{-58,150},{-42,150}}, color={255,0,255}));
  connect(cooMax.y, add2.u1) annotation (Line(points={{-18,190},{0,190},{0,176},
          {18,176}},color={0,0,127}));
  connect(zerFlo.y, add1.u1) annotation (Line(points={{-18,230},{20,230},{20,216},
          {58,216}}, color={0,0,127}));
  connect(forZerFlo.y, or3.u1) annotation (Line(points={{-58,230},{-50,230},{-50,
          128},{18,128}}, color={255,0,255}));
  connect(forCooMax.y, or3.u2) annotation (Line(points={{-58,190},{-50,190},{-50,
          120},{18,120}}, color={255,0,255}));
  connect(forMinFlo.y, or3.u3) annotation (Line(points={{-58,150},{-50,150},{-50,
          112},{18,112}},color={255,0,255}));
  connect(add1.y, swi.u1) annotation (Line(points={{82,210},{90,210},{90,128},{98,
          128}},color={0,0,127}));
  connect(VActSet_flow, swi.u3) annotation (Line(points={{-160,90},{80,90},{80,112},
          {98,112}},color={0,0,127}));
  connect(swi.y, VSet_flow)
    annotation (Line(points={{122,120},{160,120}}, color={0,0,127}));
  connect(conInt3.y, intEqu3.u2) annotation (Line(points={{-98,40},{-90,40},{-90,
          52},{-82,52}},   color={255,127,0}));
  connect(conInt4.y,intEqu4. u2) annotation (Line(points={{-98,0},{-90,0},{-90,12},
          {-82,12}}, color={255,127,0}));
  connect(oveDamPos, intEqu3.u1)
    annotation (Line(points={{-160,60},{-82,60}}, color={255,127,0}));
  connect(oveDamPos, intEqu4.u1) annotation (Line(points={{-160,60},{-130,60},{-130,
          20},{-82,20}}, color={255,127,0}));
  connect(intEqu3.y, cloDam.u)
    annotation (Line(points={{-58,60},{-42,60}}, color={255,0,255}));
  connect(intEqu4.y, opeDam.u)
    annotation (Line(points={{-58,20},{-42,20}}, color={255,0,255}));
  connect(cloDam.y, add3.u1) annotation (Line(points={{-18,60},{0,60},{0,46},{18,
          46}},      color={0,0,127}));
  connect(opeDam.y, add3.u2) annotation (Line(points={{-18,20},{0,20},{0,34},{18,
          34}},      color={0,0,127}));
  connect(intEqu3.y, or2.u1) annotation (Line(points={{-58,60},{-50,60},{-50,0},
          {-2,0}},    color={255,0,255}));
  connect(intEqu4.y, or2.u2) annotation (Line(points={{-58,20},{-50,20},{-50,-8},
          {-2,-8}},   color={255,0,255}));
  connect(add3.y, swi1.u1) annotation (Line(points={{42,40},{60,40},{60,8},{78,8}},
                    color={0,0,127}));
  connect(or2.y, swi1.u2)
    annotation (Line(points={{22,0},{78,0}}, color={255,0,255}));
  connect(uDamSet, swi1.u3) annotation (Line(points={{-160,-30},{60,-30},{60,-8},
          {78,-8}},   color={0,0,127}));
  connect(swi1.y, yDamSet)
    annotation (Line(points={{102,0},{160,0}}, color={0,0,127}));
  connect(add2.y, add1.u2) annotation (Line(points={{42,170},{50,170},{50,204},{
          58,204}}, color={0,0,127}));
  connect(uHeaOff, booToRea.u)
    annotation (Line(points={{-160,-60},{-82,-60}}, color={255,0,255}));
  connect(booToRea.y, pro.u1) annotation (Line(points={{-58,-60},{60,-60},{60,-74},
          {78,-74}}, color={0,0,127}));
  connect(uValSet, pro.u2) annotation (Line(points={{-160,-100},{60,-100},{60,-86},
          {78,-86}},  color={0,0,127}));
  connect(pro.y,yValSet)
    annotation (Line(points={{102,-80},{160,-80}}, color={0,0,127}));
  connect(minFlo.y, add2.u2) annotation (Line(points={{-18,150},{0,150},{0,164},
          {18,164}}, color={0,0,127}));
  connect(or3.y, swi.u2)
    annotation (Line(points={{42,120},{98,120}}, color={255,0,255}));
  connect(conInt5.y,intEqu1. u2) annotation (Line(points={{-98,-170},{-80,-170},
          {-80,-158},{-62,-158}}, color={255,127,0}));
  connect(conInt6.y,intEqu2. u2) annotation (Line(points={{-98,-220},{-80,-220},
          {-80,-208},{-62,-208}}, color={255,127,0}));
  connect(oveFan, intEqu2.u1) annotation (Line(points={{-160,-150},{-130,-150},{
          -130,-200},{-62,-200}}, color={255,127,0}));
  connect(oveFan, intEqu1.u1)
    annotation (Line(points={{-160,-150},{-62,-150}}, color={255,127,0}));
  connect(intEqu1.y, logSwi.u2)
    annotation (Line(points={{-38,-150},{78,-150}}, color={255,0,255}));
  connect(con.y, logSwi.u1) annotation (Line(points={{22,-120},{60,-120},{60,-142},
          {78,-142}}, color={255,0,255}));
  connect(intEqu2.y, logSwi1.u2)
    annotation (Line(points={{-38,-200},{18,-200}}, color={255,0,255}));
  connect(con1.y, logSwi1.u1) annotation (Line(points={{2,-170},{10,-170},{10,-192},
          {18,-192}}, color={255,0,255}));
  connect(uFan, logSwi1.u3) annotation (Line(points={{-160,-240},{0,-240},{0,-208},
          {18,-208}}, color={255,0,255}));
  connect(logSwi1.y, logSwi.u3) annotation (Line(points={{42,-200},{60,-200},{60,
          -158},{78,-158}}, color={255,0,255}));
  connect(logSwi.y, yFanStaSet)
    annotation (Line(points={{102,-150},{160,-150}}, color={255,0,255}));

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
        lineColor={0,0,255}),
        Text(
          extent={{-98,76},{-40,62}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActSet_flow"),
        Text(
          extent={{-100,98},{-50,84}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="oveFloSet"),
        Text(
          extent={{-100,26},{-60,14}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uDamSet"),
        Text(
          extent={{-98,48},{-48,34}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="oveDamPos"),
        Text(
          extent={{60,36},{100,24}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yDamSet"),
        Text(
          extent={{58,78},{98,66}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VSet_flow"),
        Text(
          extent={{-100,-30},{-60,-42}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uValSet"),
        Text(
          extent={{-100,-12},{-60,-24}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uHeaOff"),
        Text(
          extent={{60,-22},{100,-34}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yValSet"),
        Text(
          extent={{-100,-82},{-74,-96}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uFan"),
        Text(
          extent={{-96,-62},{-62,-76}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="oveFan"),
        Text(
          extent={{56,-64},{96,-76}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yFanStaSet")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-260},{140,260}})),
Documentation(info="<html>
<p>
This block considers the overrides to the setpoints for series fan-powered unit
with variable-volume fan.
The implementation is according to the Section 5.10.7 of ASHRAE Guideline 36,
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
<code>VZonCooMax_flow</code>,
</li>
<li>
when <code>oveFloSet</code> equals to 3, force the zone airflow setpoint
<code>VSet_flow</code> to zone minimum airflow setpoint
<code>VZonMin_flow</code>.
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
<li>
When <code>oveFan</code> equals to 1, force the fan to turn OFF.
</li>
<li>
When <code>oveFan</code> equals to 2, force the fan to turn ON.
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
