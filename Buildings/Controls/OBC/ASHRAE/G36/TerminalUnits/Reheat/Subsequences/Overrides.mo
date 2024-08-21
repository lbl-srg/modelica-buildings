within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences;
block Overrides "Software switches to override setpoints"

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput oveDamPos
    "Index of overriding damper position, 1: set to close; 2: set to open"
    annotation (Placement(transformation(extent={{-180,90},{-140,130}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uDam(
    final min=0,
    final unit="1") "Damper commanded position"
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaOff
    "Override heating valve position, true: close heating valve"
    annotation (Placement(transformation(extent={{-180,-70},{-140,-30}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uVal(
    final min=0,
    final unit="1") "Heating valve commanded position"
    annotation (Placement(transformation(extent={{-180,-110},{-140,-70}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDam(
    final min=0,
    final unit="1") "Damper commanded position, after considering override"
    annotation (Placement(transformation(extent={{140,10},{180,50}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yVal(
    final min=0,
    final unit="1")
    "Heating valve commanded position, after considering override"
    annotation (Placement(transformation(extent={{140,-90},{180,-50}}),
        iconTransformation(extent={{100,-60},{140,-20}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3(
    final k=1)
    "Constant 1"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu3
    "Check if forcing damper to full close"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu4
    "Check if forcing damper to full open"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4(
    final k=2)
    "Constant 2"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cloDam(
    final realTrue=0)
    "Full closed damper position"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal opeDam(
    final realTrue=1)
    "Full open damper position"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Reals.Add add3 "Add up inputs"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Check if the damper setpoint position should be overrided"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1
    "Damper setpoint position after considering override"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply pro
    "Valve position setpoint after considering override"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    final realTrue=0,
    final realFalse=1)
    "Convert boolean true to real 0"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
equation
  connect(conInt3.y, intEqu3.u2) annotation (Line(points={{-98,90},{-90,90},{-90,
          102},{-82,102}}, color={255,127,0}));
  connect(conInt4.y,intEqu4. u2) annotation (Line(points={{-98,30},{-90,30},{-90,
          42},{-82,42}}, color={255,127,0}));
  connect(oveDamPos, intEqu3.u1)
    annotation (Line(points={{-160,110},{-82,110}}, color={255,127,0}));
  connect(oveDamPos, intEqu4.u1) annotation (Line(points={{-160,110},{-130,110},
          {-130,50},{-82,50}},   color={255,127,0}));
  connect(intEqu3.y, cloDam.u)
    annotation (Line(points={{-58,110},{-42,110}}, color={255,0,255}));
  connect(intEqu4.y, opeDam.u)
    annotation (Line(points={{-58,50},{-42,50}},   color={255,0,255}));
  connect(cloDam.y, add3.u1) annotation (Line(points={{-18,110},{0,110},{0,76},{
          18,76}},   color={0,0,127}));
  connect(opeDam.y, add3.u2) annotation (Line(points={{-18,50},{0,50},{0,64},{18,
          64}},  color={0,0,127}));
  connect(intEqu3.y, or2.u1) annotation (Line(points={{-58,110},{-50,110},{-50,30},
          {-2,30}}, color={255,0,255}));
  connect(intEqu4.y, or2.u2) annotation (Line(points={{-58,50},{-50,50},{-50,22},
          {-2,22}}, color={255,0,255}));
  connect(add3.y, swi1.u1) annotation (Line(points={{42,70},{60,70},{60,38},{78,
          38}},     color={0,0,127}));
  connect(or2.y, swi1.u2)
    annotation (Line(points={{22,30},{78,30}}, color={255,0,255}));
  connect(uDam, swi1.u3) annotation (Line(points={{-160,0},{60,0},{60,22},{78,22}},
          color={0,0,127}));
  connect(swi1.y, yDam)
    annotation (Line(points={{102,30},{160,30}}, color={0,0,127}));
  connect(uHeaOff, booToRea.u)
    annotation (Line(points={{-160,-50},{-82,-50}},   color={255,0,255}));
  connect(booToRea.y, pro.u1) annotation (Line(points={{-58,-50},{60,-50},{60,-64},
          {78,-64}},  color={0,0,127}));
  connect(uVal, pro.u2) annotation (Line(points={{-160,-90},{60,-90},{60,-76},{78,
          -76}},  color={0,0,127}));
  connect(pro.y,yVal)
    annotation (Line(points={{102,-70},{160,-70}},   color={0,0,127}));
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
          extent={{-98,46},{-68,34}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uDam"),
        Text(
          extent={{-96,88},{-46,74}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="oveDamPos"),
        Text(
          extent={{58,46},{98,34}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yDam"),
        Text(
          extent={{-98,-62},{-70,-74}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uVal"),
        Text(
          extent={{-98,-34},{-58,-46}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uHeaOff"),
        Text(
          extent={{58,-32},{98,-44}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yVal")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,140}})),
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
when <code>oveDamPos</code> equals to 1, force the damper to full closed by setting
<code>yDam</code> to 0,
</li>
<li>
when <code>oveDamPos</code> equals to 2, force the damper to full open by setting
<code>yDam</code> to 1.
</li>
<li>
when <code>uHeaOff</code> equals to <code>true</code>, force the heating valve to
full closed by setting <code>yVal</code> to 0.
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
