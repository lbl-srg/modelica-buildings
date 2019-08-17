within Buildings.Controls.OBC.CDL.Logical.Sources;
block Constant "Output constant signal of type Boolean"
  parameter Boolean k "Constant output value";

  Interfaces.BooleanOutput y "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y = k;
  annotation (
    defaultComponentName="con",
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
                                               Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255}),          Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Ellipse(
          extent={{71,7},{85,-7}},
          lineColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-70},{72,-70}}, color={255,0,255}),
        Polygon(
          points={{90,-70},{68,-62},{68,-78},{90,-70}},
          lineColor={255,0,255},
          fillColor={255,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-80,88},{-88,66},{-72,66},{-80,88}},
          lineColor={255,0,255},
          fillColor={255,0,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,66},{-80,-82}}, color={255,0,255}),
                                                   Line(points={{-80,0},{64,0}}),
          Text(
          extent={{-150,-140},{150,-110}},
          lineColor={0,0,0},
          textString="%k")}),
      Documentation(info="<html>
<p>
Block that outputs a constant signal <code>y = k</code>,
where <code>k</code> is a Boolean-valued parameter.
</p>

<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Logical/Constant.png\"
     alt=\"Constant.png\" />
</p>
</html>"));
end Constant;
