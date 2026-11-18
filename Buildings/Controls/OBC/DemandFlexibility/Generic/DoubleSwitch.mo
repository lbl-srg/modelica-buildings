within Buildings.Controls.OBC.DemandFlexibility.Generic;
block DoubleSwitch "Double switch"
  parameter Real u1
    "Parameter 1";
  parameter Real u2
    "Parameter 2";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u "Boolean input flag"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y1
    "Output variable 1"
    annotation (Placement(transformation(extent={{100,30},{140,70}}),
      iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y2
    "Output variable 2"
    annotation (Placement(transformation(extent={{100,-70},{140,-30}}),
      iconTransformation(extent={{100,-70},{140,-30}})));
protected
  CDL.Conversions.BooleanToReal           booToRea1(realTrue=u2, realFalse=u1)
    "When input variable 2 is true, output the input variable 3, otherwise output the input variable 1"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  CDL.Conversions.BooleanToReal           booToRea(realTrue=u1, realFalse=u2)
    "When input variable 2 is true, output the input variable 1, otherwise output the input variable 3"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
equation
  connect(booToRea.y, y1) annotation (Line(points={{42,30},{80,30},{80,50},{120,
          50}}, color={0,0,127}));
  connect(booToRea1.y, y2) annotation (Line(points={{42,-30},{80,-30},{80,-50},{
          120,-50}}, color={0,0,127}));
  connect(u, booToRea.u) annotation (Line(points={{-120,0},{-40,0},{-40,30},{18,
          30}}, color={255,0,255}));
  connect(u, booToRea1.u) annotation (Line(points={{-120,0},{-40,0},{-40,-30},{18,
          -30}}, color={255,0,255}));
  annotation (defaultComponentName="douSwi",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}},
    grid={2,2}), graphics={Rectangle(
      extent={{-100,100},{100,-100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid), Text(
      extent={{-100,140},{100,100}},
      textColor={0,0,255},
          textString="%name")}), Diagram(
    coordinateSystem(preserveAspectRatio=false,
    grid={2,2})),
    Documentation(revisions="<html>
<ul>
<li>
July 15, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This block routes the two Real parameters <code>u1</code> and <code>u2</code> to the two
Real outputs <code>y1</code> and <code>y2</code> based on the Boolean input
<code>u</code>.
</p>
<p>
If <code>u</code> is <code>true</code>, <code>y1 = u1</code> and
<code>y2 = u2</code>. If <code>u</code> is <code>false</code>, <code>y1 = u2</code>
and <code>y2 = u1</code>.
</p>
</html>"));
end DoubleSwitch;
