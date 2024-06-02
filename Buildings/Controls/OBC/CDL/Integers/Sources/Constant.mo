within Buildings.Controls.OBC.CDL.Integers.Sources;
block Constant
  "Output constant signal of type Integer"
  parameter Integer k
    "Constant output value";
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y
    "Connector of Integer output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y=k;
  annotation (
    defaultComponentName="conInt",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255}),
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={255,127,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,68},{-80,-80}},
          color={192,192,192}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-90,-70},{82,-70}},
          color={192,192,192}),
        Polygon(
          points={{90,-70},{68,-62},{68,-78},{90,-70}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,0},{80,0}}),
        Text(
          extent={{-150,-150},{150,-110}},
          textColor={0,0,0},
          textString="k=%k")}),
    Documentation(
      info="<html>
<p>
Block that outputs a constant signal <code>y = k</code>,
where <code>k</code> is an Integer-valued parameter.
</p>

<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Integers/Sources/Constant.png\"
     alt=\"IntegerConstant.png\" />
</p>
</html>"));
end Constant;
