within Buildings.Controls.OBC.CDL.Integers;
block Multiply "Output product of the two inputs"
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u1
    "Input for multiplication"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u2
    "Input for multiplication"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y
    "Product of the inputs"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y=u1*u2;
  annotation (
    defaultComponentName="mulInt",
    Documentation(
      info="<html>
<p>
Block that outputs <code>y = u1 * u2</code>,
where
<code>u1</code> and <code>u2</code> are Integer inputs.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 27, 2022, by Jianjun Hu:<br/>
Renamed the block name from Product to Multiply.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2865\">issue 2865</a>.
</li>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"),
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={255,127,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-100,60},{-40,60},{-30,40}},
          color={255,127,0}),
        Line(
          points={{-100,-60},{-40,-60},{-30,-40}},
          color={255,127,0}),
        Line(
          points={{50,0},{100,0}},
          color={255,127,0}),
        Line(
          points={{-30,0},{30,0}}),
        Line(
          points={{-15,25.99},{15,-25.99}}),
        Line(
          points={{-15,-25.99},{15,25.99}}),
        Ellipse(
          lineColor={255,127,0},
          extent={{-50,-50},{50,50}}),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}));
end Multiply;
